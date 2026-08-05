CREATE VIEW dbo.View_ZoneName
AS
SELECT RegionCode AS ZoneCode, RegionName AS ZoneName
FROM     dbo.tblRegion
