-- Added 2026-08-15: registers SInventory_UI/RptBussinessSummary_DayWise.aspx in the sidebar,
-- as a sibling of RptBussinessSummary_Loading.aspx (SL=2028, "Business Summary" - this page's
-- design reference) under the "MIS Reports" parent (SL=2027).
--
-- Same convention as spec/database/menu/MonthlyInventoryReportBatchWise_menu.sql: no
-- sp_Save_MenuNew/sp_Insert_MainMenuNew exists, so new rows are added by direct INSERT. SL is a
-- plain int, not IDENTITY, so it must be chosen manually - 2036 was the first unused value in the
-- gap after the "MIS Reports" group's existing children (2028-2035 taken, 2036-2044 free).
--
-- The dbo.MainMenu2(@UserId, @UserRoleID) function (spec/database/functions/MainMenu2.sql) reads
-- tblMainMenuNew + tblMenuRole to build the rendered <ul> sidebar HTML for menu levels 1-3 (this
-- page's level). Verified live: dbo.MainMenu2(1, 1) includes
-- '<li> <a href="../SInventory_UI/RptBussinessSummary_DayWise.aspx">' after this INSERT, and a
-- real browser session (Admin user) could expand MIS Reports and click through to the page from
-- the sidebar.

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon)
VALUES (2036, 'Day Wise Net Sales Report', '../SInventory_UI/RptBussinessSummary_DayWise.aspx', '2027', 1, NULL, 'bx bx-right-arrow-alt')

-- Role grants copied verbatim from SL=2028 (Business Summary, this page's design reference) so the
-- same 18 roles that can see that report can see this one.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 2036, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 2028
