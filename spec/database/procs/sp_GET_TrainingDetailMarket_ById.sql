

 create PROCEDURE [dbo].[sp_GET_TrainingDetailMarket_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  dtl.*, gr.GroupName GroupName,rg.RegionName  RegionName, ar.AreaName AreaName,tr.TerritoryName TerritoryName, subtr.SubTerritoryName SubTerritoryName,mar.MarketName MarketName  from [dbo].tbl_TrainingMarketDetail dtl with (nolock)
	left join tbl_Group gr  with (nolock) on gr.GroupId=dtl.GroupId
	left join tblRegion rg  with (nolock) on rg.RegionId=dtl.RegionId
	left join tblArea ar  with (nolock) on ar.AreaId =dtl.AreaId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =dtl.TerritoryId
	left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =dtl.SubTerritoryId
	left join tblMarket mar  with (nolock) on mar.MarketId =dtl.MarketId
	 
	 where TrainningId= @id
      
    END


