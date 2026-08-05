

 CREATE PROCEDURE [dbo].[sp_GET_RouteInformationMarketDetail_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  dtl.*, gr.GroupCode+' : '+ gr.GroupName GroupName, rg.RegionCode+' : '+ rg.RegionName  RegionName,ar.AreaCode+' : '+ ar.AreaName AreaName,tr.TerritoryCode +' : '+tr.TerritoryName TerritoryName, subtr.SubTerritoryCode+' : '+ subtr.SubTerritoryName SubTerritoryName, mar.MarketCode+' : '+ mar.MarketName MarketName  from [dbo].tblRouteInformationMarketDetail dtl with (nolock)
		inner join tblMarket mar  with (nolock) on mar.MarketId =dtl.MarketId
	left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =mar.SubTerritoryId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =subtr.TerritoryId
	left join tblArea ar  with (nolock) on ar.AreaId =tr.AreaId
	left join tblRegion rg  with (nolock) on rg.RegionId=ar.RegionId

	left join tbl_Group gr  with (nolock) on gr.GroupId=rg.GroupId

	 
	 where RouteInformationMasterId= @id
      
    END


