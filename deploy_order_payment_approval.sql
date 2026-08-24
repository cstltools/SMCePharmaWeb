/* =====================================================================================
   Order Payment Approval - database deployment script
   Target DB : SalesDisDB_SMC_NEWDB (dev) / SalesDisDB_SMC (prod)
   Rewritten : 2026-08-24  - rebuilt on the existing approval framework

   WHAT THIS IS
   ------------
   A credit-blocked order cannot become an invoice. "Go for Approval" attaches a payment
   commitment (instalment plan) to the order and pushes it through the SAME approval
   framework every other approval page in this system uses:

       tblMainMenuNew.SL = 383        <- this page MenuId
       tblApprovalMapMaster/Detail    <- the chain, configured at
                                         UserPermission/ApprovalStepMap.aspx
       tblRoleType                    <- role ids
       tblOrderPaymentApprovalLog     <- one row per action (mirrors tblCustomerApprovalLog)

   The chain is NOT hardcoded anywhere in this script or in C#. Whatever is configured on
   ApprovalStepMap.aspx for MenuId 383 is the chain. Only MenuId 383 is hardcoded.

   Status vocabulary - the framework values, unchanged:
       Posted    step 1, written by "Go for Approval"
       Verified  an intermediate approver said yes
       Accepted  the last approver in the chain said yes  -> invoice allowed
       Rejected  someone said no                          -> round is closed

   WHERE THE STATE LIVES
   ---------------------
   In the log table, nowhere else. No column is added to tblOrder. "Current state of
   order X" = the log row with the highest (Round, Step) for TableId = X.

   DELIBERATE DIFFERENCES FROM tblCustomerApprovalLog (all documented, all on purpose)
   ---------------------------------------------------------------------------------
   1. Round column. Customer approval treats Rejected as terminal - the record simply
      vanishes from the list and is never resubmitted. An order can be reworked and
      resubmitted, so each submission is a Round with Step restarting at 1. Without this
      the map lookup ([Order] > @Step) walks off the end of the configured chain on the
      second submission.
   2. Server-side authorization. sp_webapi_SaveCustomerAppLog trusts the caller: the
      "is it your turn" test is a HiddenField comparison in the page. Here the acting
      role, the acting employee and the market scope are all resolved from the database
      using the session UserId, and the proc refuses anything that does not line up.
   3. No auto-approve on missing config. The customer proc reads "no next role" as "chain
      finished" and stamps Accepted - so a page with no map rows self-approves on the
      first click. Here a missing map is an error.
   4. Parameterised list proc. sp_Get_CustomerApp concatenates a @param string built in
      the code-behind and EXECs it. This one takes typed parameters.
   5. Lean columns. The customer log carries ToGroupId, ToRegionId, ToAreaId,
      ToTerritoryId, EntryTimeS, ApproveByS, ApproveTimeS, EntryByApp, ApproveByApp and
      more that nothing ever reads. Only the columns this workflow uses are kept.
   ===================================================================================== */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/* -------------------------------------------------------------------------------------
   0. RETIRE THE PREVIOUS (NON-FRAMEWORK) IMPLEMENTATION
   -------------------------------------------------------------------------------------
   The first cut of this feature hardcoded AM -> DZSM -> NSM in fnOrderApproverChain and
   kept its own 0..7 status machine. Everything below replaces it. fnOrderCreditValidation
   is the one piece that survives - it answers "is this order credit-blocked and by how
   much", which has nothing to do with the approval chain.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.trg_tblOrderPaymentApprovalHistory_NoChange', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange
GO
IF OBJECT_ID('dbo.sp_OrderPaymentApproval_Request', 'P')   IS NOT NULL DROP PROCEDURE dbo.sp_OrderPaymentApproval_Request
GO
IF OBJECT_ID('dbo.sp_OrderPaymentApproval_Act', 'P')       IS NOT NULL DROP PROCEDURE dbo.sp_OrderPaymentApproval_Act
GO
IF OBJECT_ID('dbo.sp_OrderPaymentApproval_GetList', 'P')   IS NOT NULL DROP PROCEDURE dbo.sp_OrderPaymentApproval_GetList
GO
IF OBJECT_ID('dbo.sp_OrderPaymentApproval_GetDetail', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_OrderPaymentApproval_GetDetail
GO
IF OBJECT_ID('dbo.tblOrderPaymentApprovalHistory', 'U')    IS NOT NULL DROP TABLE dbo.tblOrderPaymentApprovalHistory
GO
IF OBJECT_ID('dbo.tblOrderPaymentApprovalSchedule', 'U')   IS NOT NULL DROP TABLE dbo.tblOrderPaymentApprovalSchedule
GO
IF OBJECT_ID('dbo.tblOrderPaymentApproval', 'U')           IS NOT NULL DROP TABLE dbo.tblOrderPaymentApproval
GO
IF OBJECT_ID('dbo.fnOrderApproverChain', 'IF')             IS NOT NULL DROP FUNCTION dbo.fnOrderApproverChain
GO


/* -------------------------------------------------------------------------------------
   1. MENU FLAG
   -------------------------------------------------------------------------------------
   sp_GET_MainMenuByType - which feeds the Menu dropdown on ApprovalStepMap.aspx - filters
   on IsApprovalPage = 1. Without this the page cannot be configured at all.
   ------------------------------------------------------------------------------------- */

UPDATE dbo.tblMainMenuNew
   SET IsApprovalPage = 1
 WHERE SL = 383
   AND ISNULL(CONVERT(bit, IsApprovalPage), 0) = 0
GO


/* -------------------------------------------------------------------------------------
   2. TABLES
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.tblOrderPaymentApprovalLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblOrderPaymentApprovalLog
    (
        OrderPaymentApprovalLogId int IDENTITY(1,1) NOT NULL,

        TableId         int            NOT NULL,   -- tblOrder.OrderId; named TableId to match the framework
        Round           int            NOT NULL,   -- one submission; Step restarts at 1 each Round
        Step            int            NOT NULL,   -- matches tblApprovalMapDetail.[Order]

        RoleTypeId      int            NULL,       -- role that performed this step
        ToRoleTypeId    int            NULL,       -- role the request now waits on; NULL = chain finished
        Status          nvarchar(50)   NOT NULL,   -- Posted | Verified | Accepted | Rejected
        Comments        nvarchar(500)  NULL,
        Type            nvarchar(50)   NOT NULL CONSTRAINT DF_tblOPALog_Type   DEFAULT ('OrderPayment'),
        MenuId          int            NOT NULL CONSTRAINT DF_tblOPALog_MenuId DEFAULT (383),

        FromEmpId       int            NULL,       -- tblEmpGeneralInfo.EmpInfoId of the actor
        FromUserId      int            NULL,       -- tblUser.UserId of the actor

        /* the ORDER market position, not the actor - this is what scope checks and list
           filtering are actually about (see header note 5) */
        TerritoryId     int            NULL,
        AreaId          int            NULL,
        RegionId        int            NULL,
        GroupId         int            NULL,
        ComUnitId       int            NULL,

        DueAmount       decimal(18,2)  NOT NULL CONSTRAINT DF_tblOPALog_Due DEFAULT (0),
        EntryDate       datetime       NOT NULL CONSTRAINT DF_tblOPALog_EntryDate DEFAULT (GETDATE()),

        CONSTRAINT PK_tblOrderPaymentApprovalLog PRIMARY KEY CLUSTERED (OrderPaymentApprovalLogId),

        /* Two approvers clicking at the same moment both compute the same Step. One of
           them loses here, in the database, rather than both rows landing. */
        CONSTRAINT UX_tblOPALog_Order_Round_Step UNIQUE (TableId, Round, Step)
    );

    CREATE NONCLUSTERED INDEX IX_tblOPALog_Waiting
        ON dbo.tblOrderPaymentApprovalLog (ToRoleTypeId, Status)
        INCLUDE (TableId, Round, Step, AreaId, RegionId, GroupId, ComUnitId);
END
GO

IF OBJECT_ID('dbo.tblOrderPaymentSchedule', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblOrderPaymentSchedule
    (
        ScheduleId      int IDENTITY(1,1) NOT NULL,
        OrderId         int            NOT NULL,
        PlanVersion     int            NOT NULL,   -- = the log Round this plan was submitted with
        PaymentNo       int            NOT NULL,
        PaymentDate     date           NOT NULL,
        PaymentAmount   decimal(18,2)  NOT NULL,
        EntryBy         int            NULL,
        EntryDate       datetime       NOT NULL CONSTRAINT DF_tblOPS_EntryDate DEFAULT (GETDATE()),

        CONSTRAINT PK_tblOrderPaymentSchedule PRIMARY KEY CLUSTERED (ScheduleId),
        CONSTRAINT CK_tblOPS_Amount CHECK (PaymentAmount > 0),
        CONSTRAINT UX_tblOPS_Order_Version_Date UNIQUE (OrderId, PlanVersion, PaymentDate)
    );

    CREATE NONCLUSTERED INDEX IX_tblOPS_Order
        ON dbo.tblOrderPaymentSchedule (OrderId, PlanVersion)
        INCLUDE (PaymentNo, PaymentDate, PaymentAmount);
END
GO


/* -------------------------------------------------------------------------------------
   3. CREDIT VALIDATION  (unchanged - survives from the previous implementation)
   -------------------------------------------------------------------------------------
   Per-order credit flag and outstanding due. This is the authority for "is this order
   blocked" and for "how much must the instalment plan add up to".

   ponytail: the same rule is also written inline inside sp_LoadOrderListForOrderCreationbyTerri
   and sp_LoadOrderListForOrderRouteDayWise. Deliberate - rewriting those two hot list
   procs to CROSS APPLY this function is a perf-risky change to a live page. If the rule
   changes, change it in all three places. Upgrade path: switch the list procs to
   CROSS APPLY dbo.fnOrderCreditValidation once there is an index on
   tblInvoice(CustomerMasterId) and a load test to back it.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.fnOrderCreditValidation', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fnOrderCreditValidation
GO
CREATE FUNCTION dbo.fnOrderCreditValidation (@OrderId int)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.OrderId,
        o.CustomerMasterId,
        ISNULL(o.GrossValue, 0)                                     AS GrossValue,
        ISNULL(VI.ReceivableTotalAmnt, 0)                           AS DueAmount,
        ISNULL(VI.OutstandingInvoiceCount, 0)                       AS OutstandingInvoiceCount,
        ISNULL(VI.MaxDueDays, 0)                                    AS MaxDueDays,
        ISNULL(NB.AllowedNoOfInvoice, 2)                            AS AllowedNoOfInvoice,
        ISNULL(NB.AllowedCreditLimit, 50000)                        AS AllowedCreditLimit,
        ISNULL(NB.NumberOfDaysInTransit, 45)                        AS NumberOfDaysInTransit,

        CASE WHEN ISNULL(VI.OutstandingInvoiceCount, 0) >= ISNULL(NB.AllowedNoOfInvoice, 2)
             THEN 1 ELSE 0 END                                      AS IsMaxOutstandingExceeded,

        CASE WHEN ISNULL(VI.MaxDueDays, 0)      > ISNULL(NB.NumberOfDaysInTransit, 45)
               OR ISNULL(o.GrossValue, 0)       > ISNULL(NB.AllowedCreditLimit, 50000)
             THEN 1 ELSE 0 END                                      AS IsCreditPeriodExceeded
    FROM dbo.tblOrder o WITH (NOLOCK)

    OUTER APPLY (
        SELECT TOP 1
            NB1.AllowedNoOfInvoice,
            NB1.AllowedCreditLimit,
            NB1.NumberOfDaysInTransit
        FROM dbo.tblInvoiceNotBinding NB1 WITH (NOLOCK)
        WHERE (
                  (NB1.ApplyType = 'Customer'     AND NB1.CustomerId     = o.CustomerMasterId)
               OR (NB1.ApplyType = 'CustomerType' AND NB1.CustomerTypeId = o.CustTypeId)
              )
          AND NB1.IsActive = 1
          AND CONVERT(date, GETDATE()) BETWEEN NB1.ActiveFromDate
                                           AND ISNULL(NB1.ActiveToDate, CONVERT(date, GETDATE()))
        ORDER BY CASE WHEN NB1.ApplyType = 'Customer' THEN 0 ELSE 1 END ASC
    ) NB

    OUTER APPLY (
        SELECT
            COUNT(*) AS OutstandingInvoiceCount,
            MAX(DATEDIFF(DAY, DATEADD(day, -1, CONVERT(date, I.InvoiceDate)), CONVERT(date, GETDATE()))) AS MaxDueDays,
            SUM(ISNULL(CASE WHEN I.SndReturnInvoiceNo IS NOT NULL
                            THEN ISNULL(sndRTN.sndReturnNetAmount, 0)
                            ELSE ISNULL(TD.TotalDelivery, 0) END - ISNULL(P.PP, 0), 0)) AS ReceivableTotalAmnt
        FROM dbo.tblInvoice I WITH (NOLOCK)
        INNER JOIN (
            SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery
            FROM dbo.tblInvoiceDetail WITH (NOLOCK)
            GROUP BY InvoiceId
        ) TD ON I.InvoiceId = TD.InvoiceId
        LEFT JOIN (
            SELECT InvoiceId, SUM(sndReturnNetAmount) AS sndReturnNetAmount
            FROM dbo.tblInvoiceDetailReturn WITH (NOLOCK)
            GROUP BY InvoiceId
        ) sndRTN ON I.InvoiceId = sndRTN.InvoiceId
        LEFT JOIN (
            SELECT InvoiceId, SUM(ISNULL(TPAmount, 0) + ISNULL(VATAmount, 0)) AS PP
            FROM dbo.tblCustPayDetail WITH (NOLOCK)
            GROUP BY InvoiceId
        ) P ON I.InvoiceId = P.InvoiceId
        WHERE I.CustomerMasterId = o.CustomerMasterId
          AND ISNULL(CASE WHEN I.SndReturnInvoiceNo IS NOT NULL
                          THEN ISNULL(sndRTN.sndReturnNetAmount, 0)
                          ELSE ISNULL(TD.TotalDelivery, 0) END - ISNULL(P.PP, 0), 0) > 5
          AND ISNULL(CASE WHEN I.SndReturnInvoiceNo IS NOT NULL
                          THEN ISNULL(sndRTN.sndReturnNetAmount, 0)
                          ELSE ISNULL(TD.TotalDelivery, 0) END, 0) <> ISNULL(P.PP, 0)
          AND I.PaymentInvoiceStatus <> 'Reject'
    ) VI

    WHERE o.OrderId = @OrderId
)
GO


/* -------------------------------------------------------------------------------------
   4. CURRENT STATE OF AN ORDER
   -------------------------------------------------------------------------------------
   Single definition of "where is this order right now", used by the invoice gate, the
   list proc and the action proc so the three can never disagree.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.fnOrderPaymentApprovalState', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fnOrderPaymentApprovalState
GO
CREATE FUNCTION dbo.fnOrderPaymentApprovalState (@OrderId int)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        L.OrderPaymentApprovalLogId,
        L.TableId       AS OrderId,
        L.Round,
        L.Step,
        L.RoleTypeId,
        L.ToRoleTypeId,
        L.Status,
        L.DueAmount,
        L.TerritoryId, L.AreaId, L.RegionId, L.GroupId, L.ComUnitId,
        L.EntryDate,
        /* the role that opened this round - the map lookup key */
        (SELECT TOP 1 P.RoleTypeId
           FROM dbo.tblOrderPaymentApprovalLog P WITH (NOLOCK)
          WHERE P.TableId = L.TableId AND P.Round = L.Round AND P.Step = 1) AS OriginRoleTypeId
    FROM dbo.tblOrderPaymentApprovalLog L WITH (NOLOCK)
    WHERE L.TableId = @OrderId
    ORDER BY L.Round DESC, L.Step DESC
)
GO


/* -------------------------------------------------------------------------------------
   5. sp_Post_OrderPaymentApp   -  "Go for Approval"
   -------------------------------------------------------------------------------------
   Opens a round: validates the instalment plan, writes the plan, writes the Step 1
   "Posted" log row pointing at the first configured approver.

   @ScheduleXml : <Schedule><Row Date="yyyy-MM-dd" Amount="0.00" />...</Schedule>
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_Post_OrderPaymentApp', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Post_OrderPaymentApp
GO
CREATE PROCEDURE dbo.sp_Post_OrderPaymentApp
    @OrderId      int,
    @ActionUserId int,
    @ScheduleXml  xml           = NULL,
    @Comments     nvarchar(500) = NULL,
    @MenuId       int           = 383
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /* --- who is calling: resolved from the database, never from the caller ----------- */
    DECLARE @EmpId int, @RoleTypeId int;

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    IF @RoleTypeId IS NULL
    BEGIN
        RAISERROR('Your user account could not be resolved. Please log in again.', 16, 1);
        RETURN;
    END

    /* --- the order ------------------------------------------------------------------- */
    DECLARE @TerritoryId int, @ComUnitId int, @IsInvoice bit, @OrderCode nvarchar(100);

    SELECT @TerritoryId = o.TerritoryId,
           @ComUnitId   = o.ComUnitId,
           @IsInvoice   = ISNULL(o.IsInvoice, 0),
           @OrderCode   = o.OrderCode
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.OrderId = @OrderId;

    IF @OrderCode IS NULL AND @TerritoryId IS NULL AND @ComUnitId IS NULL
    BEGIN
        RAISERROR('Order not found.', 16, 1);
        RETURN;
    END

    IF @IsInvoice = 1
    BEGIN
        RAISERROR('This order has already been invoiced.', 16, 1);
        RETURN;
    END

    /* --- is it actually blocked, and by how much ------------------------------------- */
    DECLARE @DueAmount decimal(18,2), @Blocked bit;

    SELECT @DueAmount = cv.DueAmount,
           @Blocked   = CASE WHEN cv.IsMaxOutstandingExceeded = 1 OR cv.IsCreditPeriodExceeded = 1
                             THEN 1 ELSE 0 END
    FROM dbo.fnOrderCreditValidation(@OrderId) cv;

    IF ISNULL(@Blocked, 0) = 0
    BEGIN
        RAISERROR('This order is not credit-blocked. No payment approval is required.', 16, 1);
        RETURN;
    END

    /* --- one live round at a time ---------------------------------------------------- */
    DECLARE @CurStatus nvarchar(50), @CurRound int;

    SELECT @CurStatus = st.Status, @CurRound = st.Round
    FROM dbo.fnOrderPaymentApprovalState(@OrderId) st;

    IF @CurStatus IN ('Posted', 'Verified')
    BEGIN
        RAISERROR('This order is already waiting for approval.', 16, 1);
        RETURN;
    END

    IF @CurStatus = 'Accepted'
    BEGIN
        RAISERROR('This order is already approved. You can create the invoice.', 16, 1);
        RETURN;
    END

    /* --- the chain, from configuration ----------------------------------------------- */
    DECLARE @NextRoleTypeId int, @MapExists bit = 0;

    IF EXISTS (SELECT 1 FROM dbo.tblApprovalMapMaster m WITH (NOLOCK)
                JOIN dbo.tblApprovalMapDetail d WITH (NOLOCK)
                  ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
               WHERE m.MenuId = @MenuId AND m.FromRoleId = @RoleTypeId)
        SET @MapExists = 1;

    IF @MapExists = 0
    BEGIN
        RAISERROR('The approval chain for this page is not configured for your role. Please contact MIS (Approval Step Map).', 16, 1);
        RETURN;
    END

    SELECT TOP 1 @NextRoleTypeId = d.ToRoleId
    FROM dbo.tblApprovalMapMaster m WITH (NOLOCK)
    JOIN dbo.tblApprovalMapDetail d WITH (NOLOCK) ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
    WHERE m.MenuId = @MenuId AND m.FromRoleId = @RoleTypeId AND d.[Order] > 1
    ORDER BY d.[Order] ASC;

    /* A one-step chain would mean "posting approves it", which is not an approval at
       all. The customer proc silently accepts this; here it is an error. */
    IF @NextRoleTypeId IS NULL
    BEGIN
        RAISERROR('The approval chain for this page has no approver after your role. Please contact MIS (Approval Step Map).', 16, 1);
        RETURN;
    END

    /* --- the instalment plan --------------------------------------------------------- */
    DECLARE @Plan TABLE (PaymentNo int, PaymentDate date, PaymentAmount decimal(18,2));

    /* PaymentNo is numbered by ROW_NUMBER, not by an IDENTITY on the table variable:
       INSERT ... SELECT ... ORDER BY does not guarantee identity assignment order. */
    INSERT INTO @Plan (PaymentNo, PaymentDate, PaymentAmount)
    SELECT ROW_NUMBER() OVER (ORDER BY x.PaymentDate), x.PaymentDate, x.PaymentAmount
    FROM (
        SELECT r.value('@Date', 'date')             AS PaymentDate,
               r.value('@Amount', 'decimal(18,2)')  AS PaymentAmount
        FROM @ScheduleXml.nodes('/Schedule/Row') AS t(r)
    ) x;

    IF NOT EXISTS (SELECT 1 FROM @Plan)
    BEGIN
        RAISERROR('A payment schedule is required. Add at least one instalment.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM @Plan WHERE PaymentAmount IS NULL OR PaymentAmount <= 0)
    BEGIN
        RAISERROR('Every instalment amount must be greater than zero.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM @Plan WHERE PaymentDate IS NULL OR PaymentDate < CONVERT(date, GETDATE()))
    BEGIN
        RAISERROR('Instalment dates must be today or later.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT PaymentDate FROM @Plan GROUP BY PaymentDate HAVING COUNT(*) > 1)
    BEGIN
        RAISERROR('Instalment dates must be unique.', 16, 1);
        RETURN;
    END

    DECLARE @PlanTotal decimal(18,2) = (SELECT SUM(PaymentAmount) FROM @Plan);

    IF ABS(@PlanTotal - ISNULL(@DueAmount, 0)) > 0.01
    BEGIN
        DECLARE @msg nvarchar(300) =
            'The instalment total (' + CONVERT(nvarchar(30), @PlanTotal) +
            ') must equal the total due (' + CONVERT(nvarchar(30), ISNULL(@DueAmount, 0)) + ').';
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    /* --- write ----------------------------------------------------------------------- */
    DECLARE @AreaId int, @RegionId int, @GroupId int;

    SELECT @AreaId   = t.AreaId,
           @RegionId = a.RegionId,
           @GroupId  = r.GroupId
    FROM dbo.tblTerritory t WITH (NOLOCK)
    LEFT JOIN dbo.tblArea   a WITH (NOLOCK) ON a.AreaId   = t.AreaId
    LEFT JOIN dbo.tblRegion r WITH (NOLOCK) ON r.RegionId = a.RegionId
    WHERE t.TerritoryId = @TerritoryId;

    DECLARE @NewRound int = ISNULL(@CurRound, 0) + 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO dbo.tblOrderPaymentSchedule
            (OrderId, PlanVersion, PaymentNo, PaymentDate, PaymentAmount, EntryBy)
        SELECT @OrderId, @NewRound, PaymentNo, PaymentDate, PaymentAmount, @EmpId
        FROM @Plan;

        INSERT INTO dbo.tblOrderPaymentApprovalLog
            (TableId, Round, Step, RoleTypeId, ToRoleTypeId, Status, Comments, Type, MenuId,
             FromEmpId, FromUserId, TerritoryId, AreaId, RegionId, GroupId, ComUnitId, DueAmount)
        VALUES
            (@OrderId, @NewRound, 1, @RoleTypeId, @NextRoleTypeId, 'Posted', @Comments, 'OrderPayment', @MenuId,
             @EmpId, @ActionUserId, @TerritoryId, @AreaId, @RegionId, @GroupId, @ComUnitId, ISNULL(@DueAmount, 0));

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        /* the unique index is the real duplicate-request guard */
        IF ERROR_NUMBER() IN (2601, 2627)
        BEGIN
            RAISERROR('This order has just been sent for approval by someone else. Please refresh.', 16, 1);
            RETURN;
        END

        DECLARE @err nvarchar(2048) = ERROR_MESSAGE();
        RAISERROR(@err, 16, 1);
        RETURN;
    END CATCH

    SELECT @OrderId AS OrderId, @NewRound AS Round, @NextRoleTypeId AS ToRoleTypeId;
END
GO


/* -------------------------------------------------------------------------------------
   6. sp_Get_OrderPaymentApp   -  approver worklist
   -------------------------------------------------------------------------------------
   Row scope comes from the caller session UserId, resolved server-side. The market
   dropdown values are optional NARROWING filters on top of that - they can never widen
   what the caller is allowed to see.

   Scope rule (the framework rule, from CustomerApproveList.LoadData):
       AM   (2) -> own EmpAreaId          DZSM (3) -> own EmpRegionId
       NSM  (4) -> own EmpGroupId         DIC  (8) -> own company units
       any other role -> no market restriction
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_Get_OrderPaymentApp', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Get_OrderPaymentApp
GO
CREATE PROCEDURE dbo.sp_Get_OrderPaymentApp
    @ActionUserId int,
    @Status       nvarchar(50) = NULL,   -- NULL/'' = live only (Posted + Verified)
    @FromDt       date         = NULL,
    @ToDt         date         = NULL,
    @GroupId      int          = NULL,
    @RegionId     int          = NULL,
    @AreaId       int          = NULL,
    @TerritoryId  int          = NULL,
    @OrderId      int          = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmpId int, @RoleTypeId int;

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    IF @RoleTypeId IS NULL
    BEGIN
        RAISERROR('Your user account could not be resolved. Please log in again.', 16, 1);
        RETURN;
    END

    DECLARE @MyArea int, @MyRegion int, @MyGroup int;

    SELECT TOP 1 @MyArea = ff.EmpAreaId, @MyRegion = ff.EmpRegionId, @MyGroup = ff.EmpGroupId
    FROM dbo.View_Webapi_EmployeeFieldForceInfo ff WITH (NOLOCK)
    WHERE ff.EmpInfoId = @EmpId;

    ;WITH live AS
    (
        /* the current row of every order that has ever been posted */
        SELECT L.*
        FROM dbo.tblOrderPaymentApprovalLog L WITH (NOLOCK)
        WHERE L.OrderPaymentApprovalLogId =
              (SELECT TOP 1 X.OrderPaymentApprovalLogId
                 FROM dbo.tblOrderPaymentApprovalLog X WITH (NOLOCK)
                WHERE X.TableId = L.TableId
                ORDER BY X.Round DESC, X.Step DESC)
    )
    SELECT
        live.TableId                    AS OrderId,
        live.OrderPaymentApprovalLogId  AS LogId,
        live.Round,
        live.Step,
        live.RoleTypeId,
        live.ToRoleTypeId,
        live.Status,
        live.Comments,
        live.DueAmount,
        live.EntryDate                  AS LastActionDate,

        o.OrderCode,
        o.GrossValue                    AS OrderValue,
        o.EntryDate                     AS OrderDate,
        cm.CustomerCode,
        cm.CustomerName,
        terr.TerritoryCode,
        terr.TerritoryName,
        ar.AreaCode,
        rg.RegionCode,

        rtNow.DisplayName               AS WaitingForRole,
        rtDid.DisplayName               AS LastActionRole,
        emp.EmpName                     AS LastActionBy,

        /* the whole plan as one readable cell - the approver sees what they are
           approving without opening anything */
        sch.ScheduleText,
        sch.InstalmentCount,
        sch.FirstPaymentDate,

        /* server-side "may THIS user act on THIS row right now" - the page renders the
           buttons from this, and sp_Save_OrderPaymentAppLog re-checks it anyway */
        CONVERT(bit, CASE WHEN live.Status IN ('Posted', 'Verified')
                           AND live.ToRoleTypeId = @RoleTypeId
                          THEN 1 ELSE 0 END) AS CanAct
    FROM live
    JOIN dbo.tblOrder o WITH (NOLOCK)          ON o.OrderId = live.TableId
    LEFT JOIN dbo.tblCustMaster cm WITH (NOLOCK) ON cm.CustomerMasterId = o.CustomerMasterId
    LEFT JOIN dbo.tblTerritory terr WITH (NOLOCK) ON terr.TerritoryId = live.TerritoryId
    LEFT JOIN dbo.tblArea       ar  WITH (NOLOCK) ON ar.AreaId        = live.AreaId
    LEFT JOIN dbo.tblRegion     rg  WITH (NOLOCK) ON rg.RegionId      = live.RegionId
    LEFT JOIN dbo.tblRoleType   rtNow WITH (NOLOCK) ON rtNow.RoleTypeId = live.ToRoleTypeId
    LEFT JOIN dbo.tblRoleType   rtDid WITH (NOLOCK) ON rtDid.RoleTypeId = live.RoleTypeId
    LEFT JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK) ON emp.EmpInfoId = live.FromEmpId
    OUTER APPLY (
        SELECT
            COUNT(*)              AS InstalmentCount,
            MIN(s.PaymentDate)    AS FirstPaymentDate,
            STUFF((SELECT ' | ' + CONVERT(nvarchar(11), s2.PaymentDate, 106)
                        + '  ' + CONVERT(nvarchar(30), CONVERT(money, s2.PaymentAmount), 1)
                     FROM dbo.tblOrderPaymentSchedule s2 WITH (NOLOCK)
                    WHERE s2.OrderId = live.TableId AND s2.PlanVersion = live.Round
                    ORDER BY s2.PaymentDate
                      FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 3, '') AS ScheduleText
        FROM dbo.tblOrderPaymentSchedule s WITH (NOLOCK)
        WHERE s.OrderId = live.TableId AND s.PlanVersion = live.Round
    ) sch
    WHERE
        /* --- caller scope (mandatory) ------------------------------------------------ */
        (
            @RoleTypeId NOT IN (2, 3, 4, 8)
            OR (@RoleTypeId = 2 AND live.AreaId   = @MyArea)
            OR (@RoleTypeId = 3 AND live.RegionId = @MyRegion)
            OR (@RoleTypeId = 4 AND live.GroupId  = @MyGroup)
            OR (@RoleTypeId = 8 AND live.ComUnitId IN
                    (SELECT uc.CompanyUnitId FROM dbo.tblUserCompanyUnit uc WITH (NOLOCK)
                      WHERE uc.UserId = @ActionUserId))
        )
        /* --- optional narrowing filters ---------------------------------------------- */
    AND (@Status IS NULL OR @Status = '' OR live.Status = @Status)
    AND (NULLIF(@Status, '') IS NOT NULL OR live.Status IN ('Posted', 'Verified'))
    AND (@FromDt      IS NULL OR CONVERT(date, live.EntryDate) >= @FromDt)
    AND (@ToDt        IS NULL OR CONVERT(date, live.EntryDate) <= @ToDt)
    AND (@GroupId     IS NULL OR live.GroupId     = @GroupId)
    AND (@RegionId    IS NULL OR live.RegionId    = @RegionId)
    AND (@AreaId      IS NULL OR live.AreaId      = @AreaId)
    AND (@TerritoryId IS NULL OR live.TerritoryId = @TerritoryId)
    AND (@OrderId     IS NULL OR live.TableId     = @OrderId)
    ORDER BY live.EntryDate DESC;
END
GO


/* -------------------------------------------------------------------------------------
   7. sp_Save_OrderPaymentAppLog   -  Approve / Reject
   -------------------------------------------------------------------------------------
   Shaped after sp_webapi_SaveDoctorAppLog (the clean member of the family), plus the
   three hardenings listed in the header. The caller supplies an action, never a status
   and never a role.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_Save_OrderPaymentAppLog', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Save_OrderPaymentAppLog
GO
CREATE PROCEDURE dbo.sp_Save_OrderPaymentAppLog
    @OrderId      int,
    @ActionUserId int,
    @Action       nvarchar(20),          -- Approve | Reject
    @Comments     nvarchar(500) = NULL,
    @MenuId       int           = 383
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Action NOT IN ('Approve', 'Reject')
    BEGIN
        RAISERROR('Unknown action.', 16, 1);
        RETURN;
    END

    IF @Action = 'Reject' AND LTRIM(RTRIM(ISNULL(@Comments, ''))) = ''
    BEGIN
        RAISERROR('A reason is required when rejecting.', 16, 1);
        RETURN;
    END

    /* --- who is calling -------------------------------------------------------------- */
    DECLARE @EmpId int, @RoleTypeId int;

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    IF @RoleTypeId IS NULL
    BEGIN
        RAISERROR('Your user account could not be resolved. Please log in again.', 16, 1);
        RETURN;
    END

    DECLARE @MyArea int, @MyRegion int, @MyGroup int;

    SELECT TOP 1 @MyArea = ff.EmpAreaId, @MyRegion = ff.EmpRegionId, @MyGroup = ff.EmpGroupId
    FROM dbo.View_Webapi_EmployeeFieldForceInfo ff WITH (NOLOCK)
    WHERE ff.EmpInfoId = @EmpId;

    DECLARE @Round int, @Step int, @Status nvarchar(50), @ToRoleTypeId int,
            @OriginRole int, @DueAmount decimal(18,2),
            @TerritoryId int, @AreaId int, @RegionId int, @GroupId int, @ComUnitId int,
            @NextRoleTypeId int, @NewStatus nvarchar(50);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* Serialise concurrent approvers on this order. The unique index on
           (TableId, Round, Step) is the backstop if two still get through. */
        SELECT TOP 1
            @Round        = L.Round,
            @Step         = L.Step,
            @Status       = L.Status,
            @ToRoleTypeId = L.ToRoleTypeId,
            @DueAmount    = L.DueAmount,
            @TerritoryId  = L.TerritoryId,
            @AreaId       = L.AreaId,
            @RegionId     = L.RegionId,
            @GroupId      = L.GroupId,
            @ComUnitId    = L.ComUnitId
        FROM dbo.tblOrderPaymentApprovalLog L WITH (UPDLOCK, HOLDLOCK)
        WHERE L.TableId = @OrderId
        ORDER BY L.Round DESC, L.Step DESC;

        IF @Round IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('This order has not been sent for approval.', 16, 1);
            RETURN;
        END

        IF @Status NOT IN ('Posted', 'Verified')
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('This request is already closed.', 16, 1);
            RETURN;
        END

        /* --- is it your turn --------------------------------------------------------- */
        IF @ToRoleTypeId IS NULL OR @ToRoleTypeId <> @RoleTypeId
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('You are not the approver for this stage.', 16, 1);
            RETURN;
        END

        /* --- is it your market ------------------------------------------------------- */
        IF (@RoleTypeId = 2 AND ISNULL(@AreaId, -1)   <> ISNULL(@MyArea, -2))
        OR (@RoleTypeId = 3 AND ISNULL(@RegionId, -1) <> ISNULL(@MyRegion, -2))
        OR (@RoleTypeId = 4 AND ISNULL(@GroupId, -1)  <> ISNULL(@MyGroup, -2))
        OR (@RoleTypeId = 8 AND NOT EXISTS (SELECT 1 FROM dbo.tblUserCompanyUnit uc WITH (NOLOCK)
                                             WHERE uc.UserId = @ActionUserId
                                               AND uc.CompanyUnitId = @ComUnitId))
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('This request is outside your market.', 16, 1);
            RETURN;
        END

        SELECT TOP 1 @OriginRole = P.RoleTypeId
        FROM dbo.tblOrderPaymentApprovalLog P WITH (NOLOCK)
        WHERE P.TableId = @OrderId AND P.Round = @Round AND P.Step = 1;

        /* --- next link in the configured chain --------------------------------------- */
        DECLARE @NewStep int = @Step + 1;

        IF NOT EXISTS (SELECT 1 FROM dbo.tblApprovalMapMaster m WITH (NOLOCK)
                        JOIN dbo.tblApprovalMapDetail d WITH (NOLOCK)
                          ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
                       WHERE m.MenuId = @MenuId AND m.FromRoleId = @OriginRole)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('The approval chain for this page is no longer configured. Please contact MIS (Approval Step Map).', 16, 1);
            RETURN;
        END

        SELECT TOP 1 @NextRoleTypeId = d.ToRoleId
        FROM dbo.tblApprovalMapMaster m WITH (NOLOCK)
        JOIN dbo.tblApprovalMapDetail d WITH (NOLOCK) ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
        WHERE m.MenuId = @MenuId AND m.FromRoleId = @OriginRole AND d.[Order] > @NewStep
        ORDER BY d.[Order] ASC;

        IF @Action = 'Reject'
        BEGIN
            SET @NewStatus      = 'Rejected';
            SET @NextRoleTypeId = NULL;
        END
        ELSE IF @NextRoleTypeId IS NULL
            SET @NewStatus = 'Accepted';     -- chain finished
        ELSE
            SET @NewStatus = 'Verified';

        INSERT INTO dbo.tblOrderPaymentApprovalLog
            (TableId, Round, Step, RoleTypeId, ToRoleTypeId, Status, Comments, Type, MenuId,
             FromEmpId, FromUserId, TerritoryId, AreaId, RegionId, GroupId, ComUnitId, DueAmount)
        VALUES
            (@OrderId, @Round, @NewStep, @RoleTypeId, @NextRoleTypeId, @NewStatus, @Comments,
             'OrderPayment', @MenuId, @EmpId, @ActionUserId,
             @TerritoryId, @AreaId, @RegionId, @GroupId, @ComUnitId, @DueAmount);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        IF ERROR_NUMBER() IN (2601, 2627)
        BEGIN
            RAISERROR('Someone else has just acted on this request. Please refresh.', 16, 1);
            RETURN;
        END

        DECLARE @err nvarchar(2048) = ERROR_MESSAGE();
        RAISERROR(@err, 16, 1);
        RETURN;
    END CATCH

    SELECT @NewStatus AS Status, @NextRoleTypeId AS ToRoleTypeId;
END
GO


/* -------------------------------------------------------------------------------------
   8. sp_OrderPaymentApproval_CanCreateInvoice   -  the invoice gate
   -------------------------------------------------------------------------------------
   The authority for "may this order become an invoice right now". Called before every
   navigation into invoice creation; a grid button state is a hint, not a control.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_CanCreateInvoice', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_CanCreateInvoice
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_CanCreateInvoice
    @OrderId int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Blocked bit, @MaxOut bit, @CreditExc bit;

    SELECT @MaxOut    = cv.IsMaxOutstandingExceeded,
           @CreditExc = cv.IsCreditPeriodExceeded
    FROM dbo.fnOrderCreditValidation(@OrderId) cv;

    SET @Blocked = CASE WHEN ISNULL(@MaxOut, 0) = 1 OR ISNULL(@CreditExc, 0) = 1 THEN 1 ELSE 0 END;

    IF @Blocked = 0
    BEGIN
        SELECT CONVERT(bit, 1) AS CanCreate, CONVERT(nvarchar(200), NULL) AS Reason,
               CONVERT(nvarchar(50), NULL) AS Status;
        RETURN;
    END

    DECLARE @Status nvarchar(50), @WaitingRole nvarchar(100);

    SELECT @Status = st.Status,
           @WaitingRole = rt.DisplayName
    FROM dbo.fnOrderPaymentApprovalState(@OrderId) st
    LEFT JOIN dbo.tblRoleType rt WITH (NOLOCK) ON rt.RoleTypeId = st.ToRoleTypeId;

    IF @Status = 'Accepted'
    BEGIN
        SELECT CONVERT(bit, 1) AS CanCreate, CONVERT(nvarchar(200), NULL) AS Reason,
               @Status AS Status;
        RETURN;
    END

    DECLARE @Reason nvarchar(200) =
        CASE
            WHEN @Status IS NULL     THEN CASE WHEN ISNULL(@MaxOut, 0) = 1
                                               THEN 'Customer already has the maximum allowed outstanding invoices.'
                                               ELSE 'Credit period exceeded.' END
            WHEN @Status = 'Rejected' THEN 'The payment approval for this order was rejected.'
            ELSE 'Waiting for ' + ISNULL(@WaitingRole, 'approval') + '.'
        END;

    SELECT CONVERT(bit, 0) AS CanCreate, @Reason AS Reason, @Status AS Status;
END
GO


/* -------------------------------------------------------------------------------------
   9. sp_Get_OrderPaymentSchedule   -  the plan attached to an order
   -------------------------------------------------------------------------------------
   Used by the invoice-creation modal to pre-fill a rejected round for rework, and by
   anything that wants the instalments as rows rather than as the one-line summary the
   list proc renders.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_Get_OrderPaymentSchedule', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Get_OrderPaymentSchedule
GO
CREATE PROCEDURE dbo.sp_Get_OrderPaymentSchedule
    @OrderId     int,
    @PlanVersion int = NULL      -- NULL = the latest plan
AS
BEGIN
    SET NOCOUNT ON;

    IF @PlanVersion IS NULL
        SELECT @PlanVersion = MAX(PlanVersion)
        FROM dbo.tblOrderPaymentSchedule WITH (NOLOCK)
        WHERE OrderId = @OrderId;

    SELECT s.ScheduleId, s.OrderId, s.PlanVersion, s.PaymentNo, s.PaymentDate, s.PaymentAmount
    FROM dbo.tblOrderPaymentSchedule s WITH (NOLOCK)
    WHERE s.OrderId = @OrderId AND s.PlanVersion = @PlanVersion
    ORDER BY s.PaymentDate;
END
GO


/* -------------------------------------------------------------------------------------
   10. sp_Get_OrderPaymentAppHistory   -  full trail for one order
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_Get_OrderPaymentAppHistory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Get_OrderPaymentAppHistory
GO
CREATE PROCEDURE dbo.sp_Get_OrderPaymentAppHistory
    @OrderId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.OrderPaymentApprovalLogId AS LogId,
        L.Round, L.Step, L.Status, L.Comments, L.EntryDate,
        rtDid.DisplayName AS ActionRole,
        rtNow.DisplayName AS WaitingForRole,
        emp.EmpName       AS ActionBy
    FROM dbo.tblOrderPaymentApprovalLog L WITH (NOLOCK)
    LEFT JOIN dbo.tblRoleType rtDid WITH (NOLOCK) ON rtDid.RoleTypeId = L.RoleTypeId
    LEFT JOIN dbo.tblRoleType rtNow WITH (NOLOCK) ON rtNow.RoleTypeId = L.ToRoleTypeId
    LEFT JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK) ON emp.EmpInfoId = L.FromEmpId
    WHERE L.TableId = @OrderId
    ORDER BY L.Round, L.Step;
END
GO


PRINT 'Order Payment Approval objects deployed.';
PRINT 'NEXT STEP: open UserPermission/ApprovalStepMap.aspx, pick menu "Order Payment Approval",';
PRINT 'pick the From Role that raises the request, and configure the chain.';
PRINT 'NOTE: the dropdown shows tblRoleType.DisplayName - "NSM" there is RoleTypeId 14,';
PRINT 'and RoleTypeId 4 is shown as "Regional Head".';
GO
