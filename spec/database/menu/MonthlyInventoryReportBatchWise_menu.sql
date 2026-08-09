-- Added 2026-08-09: registers SInventory_UI/MonthlyInventoryReportBatchWise.aspx in the sidebar,
-- as a sibling of DepositSlipReport.aspx (SL=2045) under the "Reports" parent (SL=348).
--
-- Menu items are NOT inserted via a stored procedure in this codebase - no sp_Save_MenuNew/
-- sp_Insert_MainMenuNew exists (checked spec/database/procs/ and live sys.procedures). New rows are
-- added by direct INSERT, consistent with this repo's general DB-first convention. SL is a plain
-- int, not IDENTITY, so it must be chosen manually - 2048 was the first unused value adjacent to
-- the existing "Reports" group's SL range (2045/2046/2047 taken).
--
-- The dbo.MainMenu2(@UserId, @UserRoleID) function (spec/database/functions/MainMenu2.sql) reads
-- tblMainMenuNew + tblMenuRole to build the rendered <ul> sidebar HTML for menu levels 1-3 (this
-- page's level). tblMainMenu/tblMenuDistribution (the per-user system behind CommonUI/
-- UserPermission.aspx) is a separate, older mechanism that only matters for 4th-level nesting -
-- not relevant here.

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, Icon, TypeId)
VALUES (2048, 'Monthly Inventory Report (Batch Wise)', '../SInventory_UI/MonthlyInventoryReportBatchWise.aspx', '348', 'bx bx-right-arrow-alt', 1)

-- Role grants copied verbatim from SL=2045 (DepositSlipReport.aspx, this page's design reference)
-- so the same roles that can see that report can see this one.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], Edit, Permission)
SELECT 2048, RoleId, [Add], [View], [Delete], Edit, Permission
FROM dbo.tblMenuRole
WHERE SL = 2045
