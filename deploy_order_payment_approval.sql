/* =====================================================================================
   Order Payment Approval System - database deployment script
   Target DB : SalesDisDB_SMC_NEWDB (dev) / SalesDisDB_SMC (prod)
   Added     : 2026-08-20
   Spec      : spec/requirements.md (FR-OPA-*, BR-OPA-*, VR-OPA-*, SEC-OPA-*, AUD-OPA-*)
   Plan      : docs/implementation/order-payment-approval-plan.md

   Idempotent: safe to re-run. Objects are CREATE-if-missing / ALTER.
   Rollback  : docs/implementation/order-payment-approval-plan.md section 13.

   Flow implemented
   ----------------
     Order -> credit validation -> can create invoice?
        YES -> invoice creation (existing behaviour, untouched)
        NO  -> Go for Approval -> AM (+ payment schedule) -> DZSM -> NSM -> invoice allowed

   Status codes (spec/requirements.md Phase 14)
     0 = Pending AM Approval      1 = AM Approved
     2 = Pending DZSM Approval    3 = DZSM Approved
     4 = Pending NSM Approval     5 = Fully Approved
     6 = Rejected                 7 = Cancelled
   Statuses 1 and 3 are audit-only: an approver's single action writes both the
   "<role> Approved" history row and the "Pending <next role>" history row inside one
   transaction, so the persisted header status moves 0 -> 2 -> 4 -> 5.
   ===================================================================================== */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/* -------------------------------------------------------------------------------------
   1. TABLES
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.tblOrderPaymentApproval', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblOrderPaymentApproval
    (
        OrderPaymentApprovalId  int IDENTITY(1,1)   NOT NULL,
        OrderId                 int                 NOT NULL,
        OrderCode               nvarchar(100)       NULL,
        CustomerMasterId        int                 NULL,
        CustomerCode            nvarchar(100)       NULL,
        CustomerName            nvarchar(250)       NULL,
        ComUnitId               int                 NULL,
        TerritoryId             int                 NULL,
        AreaId                  int                 NULL,
        RegionId                int                 NULL,
        GroupId                 int                 NULL,

        OrderGrossValue         decimal(18,2)       NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Gross  DEFAULT (0),
        TotalDueAmount          decimal(18,2)       NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Due    DEFAULT (0),
        BlockReason             nvarchar(200)       NULL,

        ApprovalStatus          int                 NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Status DEFAULT (0),

        /* approver chain snapshotted at request time so a later org-structure change
           cannot strand an in-flight request */
        AMEmpId                 int                 NULL,
        DZSMEmpId               int                 NULL,
        NSMEmpId                int                 NULL,

        AMActionBy              int                 NULL,
        AMActionDate            datetime            NULL,
        AMRemarks               nvarchar(500)       NULL,
        DZSMActionBy            int                 NULL,
        DZSMActionDate          datetime            NULL,
        DZSMRemarks             nvarchar(500)       NULL,
        NSMActionBy             int                 NULL,
        NSMActionDate           datetime            NULL,
        NSMRemarks              nvarchar(500)       NULL,

        RejectedBy              int                 NULL,
        RejectedDate            datetime            NULL,
        RejectReason            nvarchar(500)       NULL,

        PaymentPlanVersion      int                 NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Ver    DEFAULT (0),
        IsScheduleLocked        bit                 NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Lock   DEFAULT (0),

        IsActive                bit                 NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_Active DEFAULT (1),
        RequestedByUserId       int                 NULL,
        RequestedByEmpId        int                 NULL,
        RequestedDate           datetime            NOT NULL CONSTRAINT DF_tblOrderPaymentApproval_ReqDt  DEFAULT (GETDATE()),

        CONSTRAINT PK_tblOrderPaymentApproval PRIMARY KEY CLUSTERED (OrderPaymentApprovalId),
        CONSTRAINT CK_tblOrderPaymentApproval_Status CHECK (ApprovalStatus BETWEEN 0 AND 7)
    );

    /* VR-OPA-07: at most one live request per order - enforced by the database, not by
       an application-side "check then insert" race. */
    CREATE UNIQUE NONCLUSTERED INDEX UX_tblOrderPaymentApproval_ActiveOrder
        ON dbo.tblOrderPaymentApproval (OrderId)
        WHERE IsActive = 1;

    CREATE NONCLUSTERED INDEX IX_tblOrderPaymentApproval_Status
        ON dbo.tblOrderPaymentApproval (ApprovalStatus, IsActive)
        INCLUDE (OrderId, AMEmpId, DZSMEmpId, NSMEmpId);
END
GO

IF OBJECT_ID('dbo.tblOrderPaymentApprovalSchedule', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblOrderPaymentApprovalSchedule
    (
        ScheduleId              int IDENTITY(1,1)   NOT NULL,
        OrderPaymentApprovalId  int                 NOT NULL,
        PaymentPlanVersion      int                 NOT NULL,
        PaymentNo               int                 NOT NULL,
        PaymentDate             date                NOT NULL,
        PaymentAmount           decimal(18,2)       NOT NULL,
        EntryBy                 int                 NULL,
        EntryDate               datetime            NOT NULL CONSTRAINT DF_tblOPASchedule_EntryDate DEFAULT (GETDATE()),
        IsActive                bit                 NOT NULL CONSTRAINT DF_tblOPASchedule_IsActive  DEFAULT (1),

        CONSTRAINT PK_tblOrderPaymentApprovalSchedule PRIMARY KEY CLUSTERED (ScheduleId),
        CONSTRAINT FK_tblOPASchedule_Approval FOREIGN KEY (OrderPaymentApprovalId)
            REFERENCES dbo.tblOrderPaymentApproval (OrderPaymentApprovalId),
        CONSTRAINT CK_tblOPASchedule_Amount CHECK (PaymentAmount > 0)
    );

    /* VR-OPA-13: duplicate payment date inside one plan version is impossible. */
    CREATE UNIQUE NONCLUSTERED INDEX UX_tblOPASchedule_Date
        ON dbo.tblOrderPaymentApprovalSchedule (OrderPaymentApprovalId, PaymentPlanVersion, PaymentDate);
END
GO

IF OBJECT_ID('dbo.tblOrderPaymentApprovalHistory', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblOrderPaymentApprovalHistory
    (
        HistoryId               int IDENTITY(1,1)   NOT NULL,
        OrderPaymentApprovalId  int                 NOT NULL,
        OrderId                 int                 NULL,
        ActionUserId            int                 NULL,
        ActionEmpId             int                 NULL,
        RoleTypeId              int                 NULL,
        RoleName                nvarchar(50)        NULL,
        ActionName              nvarchar(50)        NOT NULL,
        FromStatus              int                 NULL,
        ToStatus                int                 NULL,
        Remarks                 nvarchar(500)       NULL,
        PaymentPlanVersion      int                 NULL,
        OldValue                nvarchar(MAX)       NULL,
        NewValue                nvarchar(MAX)       NULL,
        ActionDate              datetime            NOT NULL CONSTRAINT DF_tblOPAHistory_Date DEFAULT (GETDATE()),

        CONSTRAINT PK_tblOrderPaymentApprovalHistory PRIMARY KEY CLUSTERED (HistoryId)
    );

    CREATE NONCLUSTERED INDEX IX_tblOPAHistory_Approval
        ON dbo.tblOrderPaymentApprovalHistory (OrderPaymentApprovalId, HistoryId);
END
GO

/* AUD-OPA-04: audit rows are append-only. Any UPDATE/DELETE - including one issued by
   a future developer or by a compromised app account - fails loudly instead of silently
   rewriting approval history. */
IF OBJECT_ID('dbo.trg_tblOrderPaymentApprovalHistory_NoChange', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange
GO
CREATE TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange
ON dbo.tblOrderPaymentApprovalHistory
INSTEAD OF UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR('tblOrderPaymentApprovalHistory is append-only; UPDATE/DELETE is not permitted.', 16, 1);
END
GO

/* -------------------------------------------------------------------------------------
   2. CREDIT VALIDATION - single source of truth for the NEW code paths
   -------------------------------------------------------------------------------------
   The same rule set already lives inline inside sp_LoadOrderListForOrderCreationbyTerri
   and sp_LoadOrderListForOrderRouteDayWise (they compute it for a whole territory/route
   in one aggregate pass). This function re-expresses it for a single order so the
   request proc and the invoice-creation guard have a server-side authority that does not
   depend on anything the browser sent.

   ponytail: rule logic is duplicated between this function and those two list procs.
   Deliberate - rewriting the two hot list procs to CROSS APPLY this function is a
   perf-risky change to an existing production page and is out of this requirement's
   scope. If the rule changes, change it in all three places. Upgrade path: switch the
   list procs to CROSS APPLY dbo.fnOrderCreditValidation once there is an index on
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
   3. APPROVER CHAIN RESOLUTION
   -------------------------------------------------------------------------------------
   Reuses the existing org-structure tables. No new hierarchy is introduced.
     Territory -> tblTerritory.AreaId  -> tblASMInfo  (AM   / RoleTypeId 2)
     Area      -> tblArea.RegionId     -> tblRSMInfo  (DZSM / RoleTypeId 3)
     Region    -> tblRegion.GroupId    -> tblNSMInfo  (NSM  / RoleTypeId 4)
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.fnOrderApproverChain', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fnOrderApproverChain
GO
CREATE FUNCTION dbo.fnOrderApproverChain (@TerritoryId int)
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.TerritoryId,
        t.AreaId,
        a.RegionId,
        r.GroupId,
        am.EmployeeId AS AMEmpId,
        dz.EmployeeId AS DZSMEmpId,
        ns.EmployeeId AS NSMEmpId
    FROM dbo.tblTerritory t WITH (NOLOCK)
    LEFT JOIN dbo.tblArea   a WITH (NOLOCK) ON a.AreaId   = t.AreaId
    LEFT JOIN dbo.tblRegion r WITH (NOLOCK) ON r.RegionId = a.RegionId
    OUTER APPLY (SELECT TOP 1 EmployeeId FROM dbo.tblASMInfo WITH (NOLOCK)
                 WHERE AreaId   = t.AreaId   AND IsActive = 1 ORDER BY ASMId DESC) am
    OUTER APPLY (SELECT TOP 1 EmployeeId FROM dbo.tblRSMInfo WITH (NOLOCK)
                 WHERE RegionId = a.RegionId AND IsActive = 1 ORDER BY RSMId DESC) dz
    OUTER APPLY (SELECT TOP 1 EmployeeId FROM dbo.tblNSMInfo WITH (NOLOCK)
                 WHERE GroupId  = r.GroupId  AND IsActive = 1 ORDER BY NSMId DESC) ns
    WHERE t.TerritoryId = @TerritoryId
)
GO

/* -------------------------------------------------------------------------------------
   4. sp_OrderPaymentApproval_Request  -  "Go for Approval"
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_Request', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_Request
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_Request
    @OrderId        int,
    @ActionUserId   int,
    @Remarks        nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EmpId int, @RoleTypeId int, @RoleName nvarchar(50);

    /* SEC-OPA-01: identity and role are resolved from the database using the session's
       UserId only. Nothing role-shaped is accepted from the caller. */
    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId, @RoleName = ur.RoleName
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    IF @RoleTypeId IS NULL
    BEGIN
        RAISERROR('Your user account could not be resolved. Please log in again.', 16, 1);
        RETURN;
    END

    DECLARE @CustomerMasterId int, @ComUnitId int, @TerritoryId int, @OrderCode nvarchar(100),
            @CustomerCode nvarchar(100), @CustomerName nvarchar(250), @GrossValue decimal(18,2),
            @IsInvoice bit;

    SELECT @OrderCode        = o.OrderCode,
           @CustomerMasterId = o.CustomerMasterId,
           @CustomerCode     = o.CustomerCode,
           @CustomerName     = o.CustomerName,
           @ComUnitId        = o.ComUnitId,
           @TerritoryId      = o.TerritoryId,
           @GrossValue       = ISNULL(o.GrossValue, 0),
           @IsInvoice        = o.IsInvoice
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.OrderId = @OrderId;

    IF @OrderCode IS NULL
    BEGIN
        RAISERROR('Order not found.', 16, 1);
        RETURN;
    END

    IF @IsInvoice = 1
    BEGIN
        RAISERROR('This order is already invoiced. Approval is not applicable.', 16, 1);
        RETURN;
    END

    /* BR-OPA-01: an approval request only exists because credit validation failed.
       Recomputed here server-side - the browser's opinion is not consulted. */
    DECLARE @IsMaxExceeded bit, @IsCreditExceeded bit, @DueAmount decimal(18,2);

    SELECT @IsMaxExceeded    = cv.IsMaxOutstandingExceeded,
           @IsCreditExceeded = cv.IsCreditPeriodExceeded,
           @DueAmount        = cv.DueAmount
    FROM dbo.fnOrderCreditValidation(@OrderId) cv;

    IF ISNULL(@IsMaxExceeded, 0) = 0 AND ISNULL(@IsCreditExceeded, 0) = 0
    BEGIN
        RAISERROR('This order is not credit blocked. Please use Go To Invoice.', 16, 1);
        RETURN;
    END

    DECLARE @BlockReason nvarchar(200) =
        CASE WHEN @IsMaxExceeded = 1 THEN N'Customer already has maximum outstanding invoices.'
             ELSE N'Credit period / credit limit exceeded.' END;

    DECLARE @AreaId int, @RegionId int, @GroupId int, @AMEmpId int, @DZSMEmpId int, @NSMEmpId int;

    SELECT @AreaId    = ch.AreaId,   @RegionId  = ch.RegionId, @GroupId  = ch.GroupId,
           @AMEmpId   = ch.AMEmpId,  @DZSMEmpId = ch.DZSMEmpId, @NSMEmpId = ch.NSMEmpId
    FROM dbo.fnOrderApproverChain(@TerritoryId) ch;

    /* BR-OPA-03: an incomplete chain would create a request nobody can act on. */
    IF @AMEmpId IS NULL OR @DZSMEmpId IS NULL OR @NSMEmpId IS NULL
    BEGIN
        RAISERROR('Approver chain is incomplete for this territory (AM / DZSM / NSM not set up). Please contact MIS.', 16, 1);
        RETURN;
    END

    DECLARE @NewId int;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO dbo.tblOrderPaymentApproval
            (OrderId, OrderCode, CustomerMasterId, CustomerCode, CustomerName, ComUnitId,
             TerritoryId, AreaId, RegionId, GroupId, OrderGrossValue, TotalDueAmount, BlockReason,
             ApprovalStatus, AMEmpId, DZSMEmpId, NSMEmpId, PaymentPlanVersion, IsScheduleLocked,
             IsActive, RequestedByUserId, RequestedByEmpId, RequestedDate)
        VALUES
            (@OrderId, @OrderCode, @CustomerMasterId, @CustomerCode, @CustomerName, @ComUnitId,
             @TerritoryId, @AreaId, @RegionId, @GroupId, @GrossValue, ISNULL(@DueAmount, 0), @BlockReason,
             0, @AMEmpId, @DZSMEmpId, @NSMEmpId, 0, 0,
             1, @ActionUserId, @EmpId, GETDATE());

        SET @NewId = SCOPE_IDENTITY();

        INSERT INTO dbo.tblOrderPaymentApprovalHistory
            (OrderPaymentApprovalId, OrderId, ActionUserId, ActionEmpId, RoleTypeId, RoleName,
             ActionName, FromStatus, ToStatus, Remarks, PaymentPlanVersion, OldValue, NewValue)
        VALUES
            (@NewId, @OrderId, @ActionUserId, @EmpId, @RoleTypeId, @RoleName,
             N'Requested', NULL, 0, @Remarks, 0, NULL,
             N'Due=' + CONVERT(nvarchar(30), ISNULL(@DueAmount, 0)) + N'; ' + @BlockReason);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        /* 2601/2627 = the UX_..._ActiveOrder filtered unique index fired: a concurrent
           duplicate "Go for Approval". Report it as the business rule it is. */
        IF ERROR_NUMBER() IN (2601, 2627)
        BEGIN
            RAISERROR('An approval request for this order already exists.', 16, 1);
            RETURN;
        END

        DECLARE @msg nvarchar(2048) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
        RETURN;
    END CATCH

    SELECT @NewId AS OrderPaymentApprovalId, 0 AS ApprovalStatus;
END
GO

/* -------------------------------------------------------------------------------------
   5. sp_OrderPaymentApproval_Act  -  approve / reject / cancel
   -------------------------------------------------------------------------------------
   @Action     : 'Approve' | 'Reject' | 'Cancel'
   @ScheduleXml: required on the AM Approve step only.
                 <Schedule><Row Date="2026-09-01" Amount="1500.00"/>...</Schedule>
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_Act', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_Act
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_Act
    @OrderPaymentApprovalId int,
    @ActionUserId           int,
    @Action                 nvarchar(20),
    @Remarks                nvarchar(500) = NULL,
    @ScheduleXml            xml           = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EmpId int, @RoleTypeId int, @RoleName nvarchar(50);

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId, @RoleName = ur.RoleName
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    IF @RoleTypeId IS NULL
    BEGIN
        RAISERROR('Your user account could not be resolved. Please log in again.', 16, 1);
        RETURN;
    END

    IF @Action NOT IN (N'Approve', N'Reject', N'Cancel')
    BEGIN
        RAISERROR('Unknown action.', 16, 1);
        RETURN;
    END

    DECLARE @Status int, @OrderId int, @AMEmpId int, @DZSMEmpId int, @NSMEmpId int,
            @TotalDue decimal(18,2), @Version int, @Locked bit, @RequestedByUserId int, @IsActive bit;

    SELECT @Status            = ApprovalStatus,
           @OrderId           = OrderId,
           @AMEmpId           = AMEmpId,
           @DZSMEmpId         = DZSMEmpId,
           @NSMEmpId          = NSMEmpId,
           @TotalDue          = TotalDueAmount,
           @Version           = PaymentPlanVersion,
           @Locked            = IsScheduleLocked,
           @RequestedByUserId = RequestedByUserId,
           @IsActive          = IsActive
    FROM dbo.tblOrderPaymentApproval WITH (NOLOCK)
    WHERE OrderPaymentApprovalId = @OrderPaymentApprovalId;

    IF @OrderId IS NULL
    BEGIN
        RAISERROR('Approval request not found.', 16, 1);
        RETURN;
    END

    IF @IsActive = 0
    BEGIN
        RAISERROR('This approval request is no longer active.', 16, 1);
        RETURN;
    END

    IF @Status IN (5, 6, 7)
    BEGIN
        RAISERROR('This request is already closed and cannot be actioned again.', 16, 1);
        RETURN;
    END

    /* ---------------------------------------------------------------------------------
       SEC-OPA-02 / SEC-OPA-03: level authorization.
       The acting user must hold the role type that owns the CURRENT status AND be the
       employee this specific request was routed to. No role may act on another role's
       step, and no role may skip a step - the status itself is the gate.
       --------------------------------------------------------------------------------- */
    DECLARE @ExpectedRoleTypeId int, @ExpectedEmpId int, @LevelName nvarchar(20);

    SELECT @ExpectedRoleTypeId = CASE @Status WHEN 0 THEN 2 WHEN 2 THEN 3 WHEN 4 THEN 4 END,
           @ExpectedEmpId      = CASE @Status WHEN 0 THEN @AMEmpId WHEN 2 THEN @DZSMEmpId WHEN 4 THEN @NSMEmpId END,
           @LevelName          = CASE @Status WHEN 0 THEN N'AM' WHEN 2 THEN N'DZSM' WHEN 4 THEN N'NSM' END;

    IF @Action = N'Cancel'
    BEGIN
        /* Only the requester may withdraw their own request, and only before it is closed. */
        IF @RequestedByUserId <> @ActionUserId
        BEGIN
            RAISERROR('Only the user who raised this request can cancel it.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        IF @ExpectedRoleTypeId IS NULL
        BEGIN
            RAISERROR('This request is not in an actionable state.', 16, 1);
            RETURN;
        END

        IF @RoleTypeId <> @ExpectedRoleTypeId
        BEGIN
            RAISERROR('You are not authorized for this approval level.', 16, 1);
            RETURN;
        END

        IF @ExpectedEmpId IS NULL OR @EmpId <> @ExpectedEmpId
        BEGIN
            RAISERROR('This request is not assigned to you.', 16, 1);
            RETURN;
        END
    END

    /* ---------------------------------------------------------------------------------
       Payment schedule - AM approve step only (VR-OPA-10..15). All validation is here,
       server-side; the browser's copy of these rules is a convenience, not the gate.
       --------------------------------------------------------------------------------- */
    DECLARE @NewVersion int = @Version;
    DECLARE @Sched TABLE (PaymentNo int, PaymentDate date, PaymentAmount decimal(18,2));

    IF @Action = N'Approve' AND @Status = 0
    BEGIN
        IF @ScheduleXml IS NULL
        BEGIN
            RAISERROR('Payment schedule is required before AM approval.', 16, 1);
            RETURN;
        END

        INSERT INTO @Sched (PaymentNo, PaymentDate, PaymentAmount)
        SELECT ROW_NUMBER() OVER (ORDER BY d, a),
               d,
               a
        FROM (
            SELECT r.value('@Date',   'date')          AS d,
                   r.value('@Amount', 'decimal(18,2)') AS a
            FROM @ScheduleXml.nodes('/Schedule/Row') AS x(r)
        ) src;

        IF NOT EXISTS (SELECT 1 FROM @Sched)
        BEGIN
            RAISERROR('Payment schedule must contain at least one instalment.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM @Sched WHERE PaymentDate IS NULL OR PaymentAmount IS NULL)
        BEGIN
            RAISERROR('Payment date and amount are required on every instalment.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM @Sched WHERE PaymentAmount <= 0)
        BEGIN
            RAISERROR('Payment amount must be greater than 0.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM @Sched WHERE PaymentDate < CONVERT(date, GETDATE()))
        BEGIN
            RAISERROR('Payment date cannot be earlier than today.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT PaymentDate FROM @Sched GROUP BY PaymentDate HAVING COUNT(*) > 1)
        BEGIN
            RAISERROR('Duplicate payment date is not allowed.', 16, 1);
            RETURN;
        END

        IF ABS(ISNULL((SELECT SUM(PaymentAmount) FROM @Sched), 0) - ISNULL(@TotalDue, 0)) > 0.005
        BEGIN
            DECLARE @sumMsg nvarchar(300) =
                N'Total scheduled amount (' + CONVERT(nvarchar(30), ISNULL((SELECT SUM(PaymentAmount) FROM @Sched), 0)) +
                N') must equal total due amount (' + CONVERT(nvarchar(30), ISNULL(@TotalDue, 0)) + N').';
            RAISERROR(@sumMsg, 16, 1);
            RETURN;
        END

        SET @NewVersion = @Version + 1;
    END

    IF @Action = N'Approve' AND @Status <> 0 AND @ScheduleXml IS NOT NULL
    BEGIN
        /* VR-OPA-16: only the AM step authors the plan. DZSM/NSM approve or reject it. */
        RAISERROR('Only the AM step can set the payment schedule.', 16, 1);
        RETURN;
    END

    /* ---------------------------------------------------------------------------------
       State transition
       --------------------------------------------------------------------------------- */
    DECLARE @ToStatus int =
        CASE WHEN @Action = N'Cancel' THEN 7
             WHEN @Action = N'Reject' THEN 6
             ELSE CASE @Status WHEN 0 THEN 2 WHEN 2 THEN 4 WHEN 4 THEN 5 END
        END;

    IF @ToStatus IS NULL
    BEGIN
        RAISERROR('Invalid status transition.', 16, 1);
        RETURN;
    END

    IF @Action = N'Reject' AND (@Remarks IS NULL OR LTRIM(RTRIM(@Remarks)) = N'')
    BEGIN
        RAISERROR('Rejection reason is required.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        /* Optimistic concurrency: the WHERE clause pins the status we validated against.
           A second approver who loaded the same row a moment earlier updates 0 rows and
           is told so, instead of double-approving. */
        UPDATE dbo.tblOrderPaymentApproval
        SET ApprovalStatus     = @ToStatus,
            PaymentPlanVersion = @NewVersion,
            IsScheduleLocked   = CASE WHEN @ToStatus = 5 THEN 1 ELSE IsScheduleLocked END,

            AMActionBy         = CASE WHEN @Status = 0 THEN @EmpId    ELSE AMActionBy    END,
            AMActionDate       = CASE WHEN @Status = 0 THEN GETDATE() ELSE AMActionDate  END,
            AMRemarks          = CASE WHEN @Status = 0 THEN @Remarks  ELSE AMRemarks     END,

            DZSMActionBy       = CASE WHEN @Status = 2 THEN @EmpId    ELSE DZSMActionBy   END,
            DZSMActionDate     = CASE WHEN @Status = 2 THEN GETDATE() ELSE DZSMActionDate END,
            DZSMRemarks        = CASE WHEN @Status = 2 THEN @Remarks  ELSE DZSMRemarks    END,

            NSMActionBy        = CASE WHEN @Status = 4 THEN @EmpId    ELSE NSMActionBy    END,
            NSMActionDate      = CASE WHEN @Status = 4 THEN GETDATE() ELSE NSMActionDate  END,
            NSMRemarks         = CASE WHEN @Status = 4 THEN @Remarks  ELSE NSMRemarks     END,

            RejectedBy         = CASE WHEN @ToStatus = 6 THEN @EmpId    ELSE RejectedBy   END,
            RejectedDate       = CASE WHEN @ToStatus = 6 THEN GETDATE() ELSE RejectedDate END,
            RejectReason       = CASE WHEN @ToStatus = 6 THEN @Remarks  ELSE RejectReason END,

            /* A rejected or cancelled request stops being the live one, so the requester
               may raise a fresh request (re-submission) without tripping the unique index. */
            IsActive           = CASE WHEN @ToStatus IN (6, 7) THEN 0 ELSE IsActive END
        WHERE OrderPaymentApprovalId = @OrderPaymentApprovalId
          AND ApprovalStatus         = @Status
          AND IsActive               = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('This request was changed by another user. Please reload the list.', 16, 1);
            RETURN;
        END

        IF @Action = N'Approve' AND @Status = 0
        BEGIN
            UPDATE dbo.tblOrderPaymentApprovalSchedule
            SET IsActive = 0
            WHERE OrderPaymentApprovalId = @OrderPaymentApprovalId;

            INSERT INTO dbo.tblOrderPaymentApprovalSchedule
                (OrderPaymentApprovalId, PaymentPlanVersion, PaymentNo, PaymentDate, PaymentAmount, EntryBy)
            SELECT @OrderPaymentApprovalId, @NewVersion, PaymentNo, PaymentDate, PaymentAmount, @EmpId
            FROM @Sched;
        END

        /* AUD-OPA-01..03 - one row per logical state change, never overwritten. */
        IF @Action = N'Approve'
        BEGIN
            DECLARE @midStatus int = CASE @Status WHEN 0 THEN 1 WHEN 2 THEN 3 ELSE NULL END;

            IF @midStatus IS NOT NULL
            BEGIN
                INSERT INTO dbo.tblOrderPaymentApprovalHistory
                    (OrderPaymentApprovalId, OrderId, ActionUserId, ActionEmpId, RoleTypeId, RoleName,
                     ActionName, FromStatus, ToStatus, Remarks, PaymentPlanVersion, OldValue, NewValue)
                VALUES
                    (@OrderPaymentApprovalId, @OrderId, @ActionUserId, @EmpId, @RoleTypeId, @RoleName,
                     @LevelName + N' Approved', @Status, @midStatus, @Remarks, @NewVersion,
                     NULL,
                     CASE WHEN @Status = 0
                          THEN N'Schedule v' + CONVERT(nvarchar(10), @NewVersion) + N': ' +
                               ISNULL(STUFF((SELECT N', ' + CONVERT(nvarchar(10), PaymentDate, 120) + N'=' +
                                                    CONVERT(nvarchar(30), PaymentAmount)
                                             FROM @Sched ORDER BY PaymentNo
                                             FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 2, N''), N'')
                          ELSE NULL END);

                INSERT INTO dbo.tblOrderPaymentApprovalHistory
                    (OrderPaymentApprovalId, OrderId, ActionUserId, ActionEmpId, RoleTypeId, RoleName,
                     ActionName, FromStatus, ToStatus, Remarks, PaymentPlanVersion)
                VALUES
                    (@OrderPaymentApprovalId, @OrderId, @ActionUserId, @EmpId, @RoleTypeId, @RoleName,
                     CASE @ToStatus WHEN 2 THEN N'Pending DZSM Approval' ELSE N'Pending NSM Approval' END,
                     @midStatus, @ToStatus, NULL, @NewVersion);
            END
            ELSE
            BEGIN
                INSERT INTO dbo.tblOrderPaymentApprovalHistory
                    (OrderPaymentApprovalId, OrderId, ActionUserId, ActionEmpId, RoleTypeId, RoleName,
                     ActionName, FromStatus, ToStatus, Remarks, PaymentPlanVersion, NewValue)
                VALUES
                    (@OrderPaymentApprovalId, @OrderId, @ActionUserId, @EmpId, @RoleTypeId, @RoleName,
                     N'NSM Approved - Fully Approved', @Status, @ToStatus, @Remarks, @NewVersion,
                     N'Payment schedule locked');
            END
        END
        ELSE
        BEGIN
            INSERT INTO dbo.tblOrderPaymentApprovalHistory
                (OrderPaymentApprovalId, OrderId, ActionUserId, ActionEmpId, RoleTypeId, RoleName,
                 ActionName, FromStatus, ToStatus, Remarks, PaymentPlanVersion)
            VALUES
                (@OrderPaymentApprovalId, @OrderId, @ActionUserId, @EmpId, @RoleTypeId, @RoleName,
                 CASE WHEN @Action = N'Cancel' THEN N'Cancelled'
                      ELSE ISNULL(@LevelName, N'') + N' Rejected' END,
                 @Status, @ToStatus, @Remarks, @NewVersion);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        DECLARE @m nvarchar(2048) = ERROR_MESSAGE();
        RAISERROR(@m, 16, 1);
        RETURN;
    END CATCH

    SELECT @OrderPaymentApprovalId AS OrderPaymentApprovalId, @ToStatus AS ApprovalStatus;
END
GO

/* -------------------------------------------------------------------------------------
   6. sp_OrderPaymentApproval_GetList  -  approver worklist
   -------------------------------------------------------------------------------------
   Row-level scope is derived from the caller's own role and employee id. A user only
   ever sees the requests routed to their own level - there is no client-supplied filter
   that can widen it (SEC-OPA-04, guards against IDOR by enumeration).
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_GetList', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_GetList
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_GetList
    @ActionUserId int,
    @StatusFilter int  = -1,      /* -1 = all statuses visible to this user */
    @FromDate     date = NULL,
    @ToDate       date = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmpId int, @RoleTypeId int;

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    SELECT
        pa.OrderPaymentApprovalId,
        pa.OrderId,
        pa.OrderCode,
        pa.CustomerCode,
        pa.CustomerName,
        pa.TerritoryId,
        t.TerritoryName,
        pa.OrderGrossValue,
        pa.TotalDueAmount,
        pa.BlockReason,
        pa.ApprovalStatus,
        CASE pa.ApprovalStatus
             WHEN 0 THEN N'Pending AM Approval'
             WHEN 1 THEN N'AM Approved'
             WHEN 2 THEN N'Pending DZSM Approval'
             WHEN 3 THEN N'DZSM Approved'
             WHEN 4 THEN N'Pending NSM Approval'
             WHEN 5 THEN N'Fully Approved'
             WHEN 6 THEN N'Rejected'
             WHEN 7 THEN N'Cancelled'
             ELSE N'Unknown' END                       AS ApprovalStatusName,
        pa.PaymentPlanVersion,
        pa.IsScheduleLocked,
        pa.RequestedDate,
        /* Not every account maps to a tblEmpGeneralInfo row (Admin has EmpInfoId 0), and a
           blank name in an approval trail is useless - fall back to the login name. */
        COALESCE(reqEmp.EmpName, reqUsr.LoginName, N'')  AS RequestedByName,
        ISNULL(sch.ScheduledAmount, 0)                 AS ScheduledAmount,
        pa.TotalDueAmount - ISNULL(sch.ScheduledAmount, 0) AS RemainingAmount,

        /* The single authority the UI renders its buttons from - never recomputed
           client-side, and always re-verified by sp_OrderPaymentApproval_Act. */
        CASE WHEN pa.IsActive = 1
              AND (   (pa.ApprovalStatus = 0 AND @RoleTypeId = 2 AND pa.AMEmpId   = @EmpId)
                   OR (pa.ApprovalStatus = 2 AND @RoleTypeId = 3 AND pa.DZSMEmpId = @EmpId)
                   OR (pa.ApprovalStatus = 4 AND @RoleTypeId = 4 AND pa.NSMEmpId  = @EmpId))
             THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS CanAct
    FROM dbo.tblOrderPaymentApproval pa WITH (NOLOCK)
    LEFT JOIN dbo.tblTerritory t WITH (NOLOCK) ON t.TerritoryId = pa.TerritoryId
    LEFT JOIN dbo.tblEmpGeneralInfo reqEmp WITH (NOLOCK) ON reqEmp.EmpInfoId = pa.RequestedByEmpId
    LEFT JOIN dbo.tblUser           reqUsr WITH (NOLOCK) ON reqUsr.UserId    = pa.RequestedByUserId
    OUTER APPLY (
        SELECT SUM(s.PaymentAmount) AS ScheduledAmount
        FROM dbo.tblOrderPaymentApprovalSchedule s WITH (NOLOCK)
        WHERE s.OrderPaymentApprovalId = pa.OrderPaymentApprovalId
          AND s.PaymentPlanVersion     = pa.PaymentPlanVersion
          AND s.IsActive               = 1
    ) sch
    WHERE (
              (@RoleTypeId = 2 AND pa.AMEmpId   = @EmpId)
           OR (@RoleTypeId = 3 AND pa.DZSMEmpId = @EmpId)
           OR (@RoleTypeId = 4 AND pa.NSMEmpId  = @EmpId)
           OR (@RoleTypeId = 5)                              /* Admin: read-only oversight */
           OR (pa.RequestedByUserId = @ActionUserId)          /* own requests */
          )
      AND (@StatusFilter = -1 OR pa.ApprovalStatus = @StatusFilter)
      AND (@FromDate IS NULL OR CONVERT(date, pa.RequestedDate) >= @FromDate)
      AND (@ToDate   IS NULL OR CONVERT(date, pa.RequestedDate) <= @ToDate)
    ORDER BY pa.ApprovalStatus ASC, pa.RequestedDate DESC;
END
GO

/* -------------------------------------------------------------------------------------
   7. sp_OrderPaymentApproval_GetDetail  -  header + schedule + history for one request
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_GetDetail', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_GetDetail
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_GetDetail
    @OrderPaymentApprovalId int,
    @ActionUserId           int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmpId int, @RoleTypeId int;

    SELECT @EmpId = u.EmpInfoId, @RoleTypeId = ur.RoleTypeId
    FROM dbo.tblUser u WITH (NOLOCK)
    LEFT JOIN dbo.tbl_UserRoleInfo ur WITH (NOLOCK) ON ur.UserRoleID = u.UserRoleID
    WHERE u.UserId = @ActionUserId;

    /* SEC-OPA-05 (IDOR): a request id the caller has no relationship with returns nothing,
       not somebody else's customer and due figures. */
    IF NOT EXISTS (
        SELECT 1 FROM dbo.tblOrderPaymentApproval pa WITH (NOLOCK)
        WHERE pa.OrderPaymentApprovalId = @OrderPaymentApprovalId
          AND (   (@RoleTypeId = 2 AND pa.AMEmpId   = @EmpId)
               OR (@RoleTypeId = 3 AND pa.DZSMEmpId = @EmpId)
               OR (@RoleTypeId = 4 AND pa.NSMEmpId  = @EmpId)
               OR (@RoleTypeId = 5)
               OR  pa.RequestedByUserId = @ActionUserId)
    )
    BEGIN
        RAISERROR('You are not authorized to view this approval request.', 16, 1);
        RETURN;
    END

    SELECT
        pa.*,
        CASE pa.ApprovalStatus
             WHEN 0 THEN N'Pending AM Approval'   WHEN 1 THEN N'AM Approved'
             WHEN 2 THEN N'Pending DZSM Approval' WHEN 3 THEN N'DZSM Approved'
             WHEN 4 THEN N'Pending NSM Approval'  WHEN 5 THEN N'Fully Approved'
             WHEN 6 THEN N'Rejected'              WHEN 7 THEN N'Cancelled'
             ELSE N'Unknown' END AS ApprovalStatusName,
        CASE WHEN pa.IsActive = 1
              AND (   (pa.ApprovalStatus = 0 AND @RoleTypeId = 2 AND pa.AMEmpId   = @EmpId)
                   OR (pa.ApprovalStatus = 2 AND @RoleTypeId = 3 AND pa.DZSMEmpId = @EmpId)
                   OR (pa.ApprovalStatus = 4 AND @RoleTypeId = 4 AND pa.NSMEmpId  = @EmpId))
             THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS CanAct
    FROM dbo.tblOrderPaymentApproval pa WITH (NOLOCK)
    WHERE pa.OrderPaymentApprovalId = @OrderPaymentApprovalId;

    SELECT s.ScheduleId, s.PaymentNo, s.PaymentDate, s.PaymentAmount, s.PaymentPlanVersion
    FROM dbo.tblOrderPaymentApprovalSchedule s WITH (NOLOCK)
    INNER JOIN dbo.tblOrderPaymentApproval pa WITH (NOLOCK)
        ON pa.OrderPaymentApprovalId = s.OrderPaymentApprovalId
       AND pa.PaymentPlanVersion     = s.PaymentPlanVersion
    WHERE s.OrderPaymentApprovalId = @OrderPaymentApprovalId
      AND s.IsActive = 1
    ORDER BY s.PaymentNo;

    SELECT h.HistoryId, h.ActionName, h.FromStatus, h.ToStatus, h.Remarks, h.RoleName,
           h.PaymentPlanVersion, h.OldValue, h.NewValue, h.ActionDate,
           COALESCE(e.EmpName, u.LoginName, N'') AS ActionByName
    FROM dbo.tblOrderPaymentApprovalHistory h WITH (NOLOCK)
    LEFT JOIN dbo.tblEmpGeneralInfo e WITH (NOLOCK) ON e.EmpInfoId = h.ActionEmpId
    LEFT JOIN dbo.tblUser           u WITH (NOLOCK) ON u.UserId    = h.ActionUserId
    WHERE h.OrderPaymentApprovalId = @OrderPaymentApprovalId
    ORDER BY h.HistoryId;
END
GO

/* -------------------------------------------------------------------------------------
   8. sp_OrderPaymentApproval_CanCreateInvoice  -  the invoice-creation gate
   -------------------------------------------------------------------------------------
   Returns CanCreate (bit) + Reason (nvarchar) + ApprovalStatus (int, -1 = no request).
   This is the authority behind both the button state and the server-side re-check that
   runs when the button is actually clicked, so a forged/replayed postback gains nothing.
   ------------------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.sp_OrderPaymentApproval_CanCreateInvoice', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_OrderPaymentApproval_CanCreateInvoice
GO
CREATE PROCEDURE dbo.sp_OrderPaymentApproval_CanCreateInvoice
    @OrderId int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IsMax bit, @IsCredit bit;
    SELECT @IsMax = cv.IsMaxOutstandingExceeded, @IsCredit = cv.IsCreditPeriodExceeded
    FROM dbo.fnOrderCreditValidation(@OrderId) cv;

    DECLARE @Status int = -1;
    SELECT @Status = ApprovalStatus
    FROM dbo.tblOrderPaymentApproval WITH (NOLOCK)
    WHERE OrderId = @OrderId AND IsActive = 1;

    IF ISNULL(@IsMax, 0) = 0 AND ISNULL(@IsCredit, 0) = 0
    BEGIN
        SELECT CAST(1 AS bit) AS CanCreate, N'' AS Reason, ISNULL(@Status, -1) AS ApprovalStatus;
        RETURN;
    END

    IF @Status = 5
    BEGIN
        SELECT CAST(1 AS bit) AS CanCreate, N'' AS Reason, @Status AS ApprovalStatus;
        RETURN;
    END

    DECLARE @Reason nvarchar(200) =
        CASE @Status
             WHEN 0 THEN N'Approval pending with AM.'
             WHEN 1 THEN N'Approval pending with AM.'
             WHEN 2 THEN N'Approval pending with DZSM.'
             WHEN 3 THEN N'Approval pending with DZSM.'
             WHEN 4 THEN N'Approval pending with NSM.'
             WHEN 6 THEN N'Payment approval was rejected.'
             WHEN 7 THEN N'Payment approval request was cancelled.'
             ELSE CASE WHEN ISNULL(@IsMax, 0) = 1
                       THEN N'Customer already has maximum outstanding invoices.'
                       ELSE N'Credit period exceeded.' END
        END;

    SELECT CAST(0 AS bit) AS CanCreate, @Reason AS Reason, ISNULL(@Status, -1) AS ApprovalStatus;
END
GO

/* -------------------------------------------------------------------------------------
   9. EXISTING PROCS - surface the approval status on the Invoice Creation grid
   -------------------------------------------------------------------------------------
   Minimal change: one LEFT JOIN + two output columns on each of the two procs that feed
   SInventory_UI/InvoiceCreationByOrder_daaw.aspx. No existing column, filter, join or
   row-set changes, so every other consumer keeps its current behaviour.
   Applied by ALTER below (see section 9a/9b) - run this script on a database that
   already has the current version of both procs.
   ------------------------------------------------------------------------------------- */
PRINT 'Sections 9a/9b (ALTER of sp_LoadOrderListForOrderCreationbyTerri and';
PRINT 'sp_LoadOrderListForOrderRouteDayWise) are in alter_orderlist_payment_approval.sql';
PRINT 'so this script stays re-runnable independently of those two procs'' current text.';
GO

PRINT 'Order Payment Approval - schema, functions and procedures deployed.';
GO
