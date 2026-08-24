-- =====================================================================================
--  Order Payment Approval - SAMPLE approval chain for MenuId 383
--
--  YOU DO NOT NEED THIS FILE IN PRODUCTION.
--  The chain is meant to be configured on UserPermission/ApprovalStepMap.aspx:
--      Menu = "Order Payment Approval", pick the From Role, add the steps, Save.
--  This script only exists so a dev/staging database can be seeded without clicking
--  through the page, and so the intended default is written down somewhere.
--
--  It calls the exact same procedures the page calls, so what it writes is
--  indistinguishable from what the page would write.
--
--  THE NAMING TRAP - read before configuring anything by hand:
--      ApprovalStepMap.aspx shows tblRoleType.DisplayName, while the approval pages
--      match on tblRoleType.RoleType. They disagree for two rows:
--          RoleTypeId  4 : RoleType 'NSM'         DisplayName 'Regional Head'
--          RoleTypeId 14 : RoleType 'Head of NSM' DisplayName 'NSM'
--      So picking "NSM" in the dropdown gives you RoleTypeId 14, not 4.
--
--  Default written below - who raises the request decides where the chain starts:
--      From DIC (8)  : DIC -> AM -> DZSM -> NSM        (Invoice Creation is a DIC page)
--      From AM  (2)  : AM  -> DZSM -> NSM
--      From DZSM(3)  : DZSM -> NSM
--
--  Order 1 is always the raising role itself. That is the framework's convention
--  (see every other MenuId in tblApprovalMapMaster) and sp_Post_OrderPaymentApp
--  depends on it: the first approver is the row at [Order] = 2.
-- =====================================================================================

SET NOCOUNT ON;

DECLARE @MenuId int = 383;
DECLARE @MenuName nvarchar(200) = 'Order Payment Approval';
DECLARE @MasterId int;

/* ---- raised by DIC (RoleTypeId 8) ------------------------------------------------- */
EXEC dbo.sp_Save_ApprovalMapMaster @MenuId = @MenuId, @MenuName = @MenuName, @FromRoleId = 8;
SELECT @MasterId = ApprovalMapMasterId FROM dbo.tblApprovalMapMaster WHERE MenuId = @MenuId AND FromRoleId = 8;

EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 8, @Order = 1;  -- DIC (raiser)
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 2, @Order = 2;  -- AM
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 3, @Order = 3;  -- DZSM
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 4, @Order = 4;  -- NSM

/* ---- raised by AM (RoleTypeId 2) -------------------------------------------------- */
EXEC dbo.sp_Save_ApprovalMapMaster @MenuId = @MenuId, @MenuName = @MenuName, @FromRoleId = 2;
SELECT @MasterId = ApprovalMapMasterId FROM dbo.tblApprovalMapMaster WHERE MenuId = @MenuId AND FromRoleId = 2;

EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 2, @Order = 1;  -- AM (raiser)
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 3, @Order = 2;  -- DZSM
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 4, @Order = 3;  -- NSM

/* ---- raised by DZSM (RoleTypeId 3) ------------------------------------------------ */
EXEC dbo.sp_Save_ApprovalMapMaster @MenuId = @MenuId, @MenuName = @MenuName, @FromRoleId = 3;
SELECT @MasterId = ApprovalMapMasterId FROM dbo.tblApprovalMapMaster WHERE MenuId = @MenuId AND FromRoleId = 3;

EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 3, @Order = 1;  -- DZSM (raiser)
EXEC dbo.sp_Save_ApprovalMapDetail @ApprovalMapMasterId = @MasterId, @ToRoleId = 4, @Order = 2;  -- NSM

/* ---- what got written ------------------------------------------------------------- */
SELECT m.FromRoleId, fr.RoleType AS RaisedBy, d.[Order], d.ToRoleId,
       tr.RoleType AS ApproverRoleType, tr.DisplayName AS ShownOnConfigPage
FROM dbo.tblApprovalMapMaster m
JOIN dbo.tblApprovalMapDetail d ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
LEFT JOIN dbo.tblRoleType fr ON fr.RoleTypeId = m.FromRoleId
LEFT JOIN dbo.tblRoleType tr ON tr.RoleTypeId = d.ToRoleId
WHERE m.MenuId = @MenuId
ORDER BY m.FromRoleId, d.[Order];
