CREATE PROCEDURE [dbo].[sp_GET_VacentTerritory]
	
	-- Add the parameters for the stored procedure here
	@AreaId INT

AS
BEGIN


		SELECT distinct TR.TerritoryId, TR.TerritoryCode + ' : ' + TR.TerritoryName AS TerritoryName FROM tblTerritory AS TR 
        INNER JOIN tblArea AS AR ON TR.AreaId = AR.AreaId
        INNER JOIN tblRegion AS RGN ON AR.RegionId = RGN.RegionId
        LEFT JOIN tblMioInfo AS MIO ON TR.TerritoryId = MIO.TerritoryId
        WHERE TR.AreaId = @AreaId AND TR.IsActive = 'True' AND TR.TerritoryId not in (SELECT TerritoryId FROM tblMIOInfo WHERE IsActive = 'True')


		
END


--TRUNCATE TABLE tblMIOInfo



