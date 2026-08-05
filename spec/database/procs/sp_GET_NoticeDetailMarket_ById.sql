

 CREATE PROCEDURE [dbo].[sp_GET_NoticeDetailMarket_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  dtl.*, gr.GroupName GroupName,rg.RegionName  RegionName, ar.AreaName AreaName,tr.TerritoryName TerritoryName, subtr.SubTerritoryName SubTerritoryName,mar.MarketName MarketName  from [dbo].tbl_Notice_MarketDetails dtl with (nolock)
	left join tblMarket mar  with (nolock) on mar.MarketId =dtl.MarketId
	left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =dtl.SubTerritoryId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =dtl.TerritoryId
	left join tblArea ar  with (nolock) on ar.AreaId =dtl.AreaId
	left join tblRegion rg  with (nolock) on rg.RegionId=dtl.RegionId

	left join tbl_Group gr  with (nolock) on gr.GroupId=dtl.GroupId
	 
	 where NoticeId= @id
      
    END


