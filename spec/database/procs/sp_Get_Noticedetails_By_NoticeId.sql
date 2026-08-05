-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_Noticedetails_By_NoticeId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	      
   SELECT G.GroupId, G.GroupName, R.RegionId, R.RegionName, A.AreaId, A.AreaName , T.TerritoryId, T.TerritoryName, M.MarketId, M.MarketName FROM dbo.tbl_Notice_MarketDetails NM
   LEFT JOIN dbo.tbl_Group G ON G.GroupId = NM.GroupId
   LEFT JOIN dbo.tblRegion R ON R.RegionId = NM.RegionId
   LEFT JOIN dbo.tblArea A ON A.AreaId = NM.AreaId
   LEFT JOIN dbo.tblTerritory T ON T.TerritoryId = nm.TerritoryId
   LEFT JOIN dbo.tblMarket M ON M.MarketId = NM.MarketId 
   WHERE NM.NoticeDetailsId IS NOT NULL AND NM.NoticeId = @id 
  
   END

