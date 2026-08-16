-- Registers SInventory_UI/StockOutReport.aspx in the sidebar, as a sibling of
-- RptBussinessSummary_DayWise.aspx (SL=2036) under the "MIS Reports" parent (SL=2027).
--
-- Same convention as spec/database/menu/RptBussinessSummary_DayWise_menu.sql: no
-- sp_Save_MenuNew/sp_Insert_MainMenuNew exists, so new rows are added by direct INSERT. SL is a
-- plain int, not IDENTITY, so it must be chosen manually - 2037 is the first unused value in the
-- gap after "MIS Reports"'s existing children (2028-2036 taken, 2037-2044 free).

INSERT INTO dbo.tblMainMenuNew (SL, ManuName, URL, ParantId, TypeId, Class, Icon)
VALUES (2037, 'Stock Out Report', '../SInventory_UI/StockOutReport.aspx', '2027', 1, NULL, 'bx bx-right-arrow-alt')

-- Role grants copied verbatim from SL=2036 (Day Wise Net Sales Report, this page's design
-- reference and nearest sibling) so the same roles that can see that report can see this one.
INSERT INTO dbo.tblMenuRole (SL, RoleId, [Add], [View], [Delete], [Edit], Permission)
SELECT 2037, RoleId, [Add], [View], [Delete], [Edit], Permission
FROM dbo.tblMenuRole
WHERE SL = 2036
