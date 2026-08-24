-- Registers Approval_UI/OrderPaymentApprovalList.aspx in the sidebar as a sibling of
-- OrderApproveList.aspx (SL=381) under the "Approval Operation" parent (SL=347).
--
-- Same convention as spec/database/menu/StockOutReport_menu.sql: no sp_Save_MenuNew /
-- sp_Insert_MainMenuNew exists in this codebase, so new rows are added by direct INSERT.
-- SL is a plain int, not IDENTITY, so it must be chosen manually - 383 is the first unused
-- value after the "Approval Operation" group's existing children (302/303/356/371/372/376/
-- 377/379/381/382 taken; 383-400 free, verified live).
--
-- Before running on a new database, confirm 383 is still free:
--     SELECT * FROM tblMainMenuNew WHERE SL = 383
--
-- IsApprovalPage = 1 is what puts this page into the Menu dropdown on
-- UserPermission/ApprovalStepMap.aspx (sp_GET_MainMenuByType filters on it). Without it
-- the approval chain for this page cannot be configured at all.
--
-- Role grants: copied from SL=381 (Order Approval List) so the same oversight roles keep
-- visibility, PLUS the AM role (UserRoleID 3), which is a first-class approver in this
-- workflow but is not on the Order Approval List's grant set. Which roles actually ACT is
-- decided by the chain configured on ApprovalStepMap.aspx, not here - this only controls
-- who can open the page.

IF NOT EXISTS (SELECT 1 FROM dbo.tblMainMenuNew WHERE SL = 383)
    INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon, IsApprovalPage)
    VALUES (383, 'Order Payment Approval', '../Approval_UI/OrderPaymentApprovalList.aspx', '347', 1, NULL, 'bx bx-right-arrow-alt', 1)
GO

UPDATE dbo.tblMainMenuNew
   SET IsApprovalPage = 1
 WHERE SL = 383
   AND ISNULL(CONVERT(bit, IsApprovalPage), 0) = 0
GO

INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 383, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 381
  AND NOT EXISTS (SELECT 1 FROM dbo.tblMenuRole mr WHERE mr.SL = 383 AND mr.RoleId = tblMenuRole.RoleId)
GO

-- AM (UserRoleID 3, RoleTypeId 2) is normally the first approval level and must be able to
-- open the page.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 383, 3, 1, 1, 0, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM dbo.tblMenuRole WHERE SL = 383 AND RoleId = 3)
GO
