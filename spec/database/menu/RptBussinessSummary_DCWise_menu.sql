-- Registers SInventory_UI/RptBussinessSummary_DCWise.aspx in the sidebar, directly beside
-- "Day Wise Net Sales Report" (RptBussinessSummary_DayWise.aspx, SL=2036 - this page's design
-- reference) under the "MIS Reports" parent (SL=2027).
--
-- Same convention as spec/database/menu/RptBussinessSummary_DayWise_menu.sql: no sp_Save_MenuNew /
-- sp_Insert_MainMenuNew exists, so new rows are added by direct INSERT. SL is a plain int, not
-- IDENTITY, so it must be chosen manually - 2038 is the first free value after the group's
-- existing children (2028-2037 taken, 2038-2044 free).

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon)
VALUES (2038, 'DC Wise Net Sales Report', '../SInventory_UI/RptBussinessSummary_DCWise.aspx', '2027', 1, NULL, 'bx bx-right-arrow-alt')

-- Role grants copied verbatim from SL=2036 (Day Wise Net Sales Report): same report, aggregated
-- per DC instead of per day, so exactly the same roles should see it.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 2038, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 2036
