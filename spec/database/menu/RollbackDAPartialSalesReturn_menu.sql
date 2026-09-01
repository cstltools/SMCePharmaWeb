-- Registers SInventory_UI/RollbackDAPartialSalesReturn.aspx in the sidebar, directly beside
-- "Sales Return" (DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx, SL=7000099) under the
-- "Sales Assistant Approval Process" parent (SL=7000091) - the rollback page undoes what that
-- page's Partial submit did, so it belongs in the same group.
--
-- Same convention as spec/database/menu/StockOutReport_menu.sql: no sp_Save_MenuNew /
-- sp_Insert_MainMenuNew exists, so new rows are added by direct INSERT. SL is a plain int, not
-- IDENTITY, so it must be chosen manually - 7000100 is the first free value after 7000099.

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon)
VALUES (7000100, 'Sales Return Rollback', '../SInventory_UI/RollbackDAPartialSalesReturn.aspx', '7000091', 1, NULL, 'bx bx-right-arrow-alt')

-- Role grants copied verbatim from SL=7000099 (Sales Return): the page reverses that page's
-- submit, so exactly the roles that can approve a return can undo one.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 7000100, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 7000099
