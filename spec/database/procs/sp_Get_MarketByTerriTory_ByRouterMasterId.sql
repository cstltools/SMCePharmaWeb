-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_MarketByTerriTory_ByRouterMasterId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN


SELECT (T.TerritoryName+'|'+A.AreaName+'|'+ R.RegionName+'|'+ G.GroupName) AS Name , M.MarketName, T.TerritoryId , T.IsActive, M.MarketId,
CASE WHEN M.IsActive = 0 Then '(InActive)'
WHEN M.IsActive = 1 THEN '(Active)'
End IactiveInactive ,
CASE WHEN M.IsActive = 0 Then 'disabled'
WHEN M.IsActive = 1 THEN ''''
End disabled  FROM dbo.RouterDetails  RD
LEFT JOIN  dbo.tblTerritory T ON T.TerritoryId = RD.TerritoryId
LEFT JOIN  dbo.tblMarket M ON M.MarketId = RD.MarketId
LEFT JOIN dbo.tblArea A ON A.AreaId = T.AreaId
LEFT JOIN dbo.tblRegion R ON R.RegionId = A.RegionId
LEFT JOIN dbo.tbl_Group G ON G.GroupId = R.GroupId
WHERE RD.RouterMasterId = @id

END


