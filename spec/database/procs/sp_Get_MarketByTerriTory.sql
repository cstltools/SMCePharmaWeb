-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MarketByTerriTory]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
 

SELECT (T.TerritoryName+'|'+A.AreaName+'|'+ R.RegionName+'|'+ G.GroupName) AS Name , M.MarketName, M.TerritoryId , M.MarketId FROM dbo.tblTerritory  T
LEFT JOIN  dbo.tblMarket M ON M.TerritoryId = T.TerritoryId
LEFT JOIN dbo.tblArea A ON A.AreaId = T.AreaId
LEFT JOIN dbo.tblRegion R ON R.RegionId = A.RegionId
LEFT JOIN dbo.tbl_Group G ON G.GroupId = R.GroupId
WHERE t.IsActive =1 AND M.IsActive =1


END
