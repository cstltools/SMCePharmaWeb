-- Added 2026-08-20: registers Approval_UI/OrderPaymentApprovalList.aspx in the sidebar as a
-- sibling of OrderApproveList.aspx (SL=381, this page's design reference) under the
-- "Approval Operation" parent (SL=347).
--
-- Same convention as spec/database/menu/StockOutReport_menu.sql: no sp_Save_MenuNew /
-- sp_Insert_MainMenuNew exists in this codebase, so new rows are added by direct INSERT.
-- SL is a plain int, not IDENTITY, so it must be chosen manually - 383 is the first unused
-- value after the "Approval Operation" group's existing children (302/303/356/371/372/376/
-- 377/379/381/382 taken; 383-400 free, verified live).
--
-- Role grants: copied from SL=381 (Order Approval List) so the same oversight roles keep
-- visibility, PLUS the AM role (UserRoleID 3), which is a first-class approver in this
-- workflow but is not on the Order Approval List's grant set.

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon)
VALUES (383, 'Order Payment Approval', '../Approval_UI/OrderPaymentApprovalList.aspx', '347', 1, NULL, 'bx bx-right-arrow-alt')

INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 383, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 381

-- AM (UserRoleID 3, RoleTypeId 2) is the first approval level and must be able to open the page.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 383, 3, 1, 1, 0, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM dbo.tblMenuRole WHERE SL = 383 AND RoleId = 3)
