CREATE VIEW dbo.View_DepotName
AS
SELECT ComUnitCode AS DepotCode, ComUnitName AS DepotName
FROM     dbo.tblCompanyUnit
