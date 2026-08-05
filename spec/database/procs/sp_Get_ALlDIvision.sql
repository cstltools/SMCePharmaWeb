CREATE PROCEDURE [dbo].[sp_Get_ALlDIvision]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	--SELECT * FROM dbo.tbl_Division nolock
	-- WHERE IsActive = 1



	 SELECT  A.DivisionId , 0 AS IsDisable , A.DivisionName
FROM    dbo.tbl_Division A
        --LEFT JOIN dbo.tbl_ZoneDivisionRelation B ON B.DivisionId = A.DivisionId
        --LEFT JOIN dbo.tblRegion C ON C.RegionId = B.ZoneId
WHERE   A.IsActive = 1 order by A.DivisionName asc

END

