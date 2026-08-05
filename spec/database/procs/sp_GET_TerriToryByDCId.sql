
 create PROCEDURE [dbo].[sp_GET_TerriToryByDCId]
	-- Add the parameters for the stored procedure here
   @DCid NVARCHAR(max)

AS
    BEGIN

	select distinct tr.TerritoryId, tr.TerritoryCode, case when tr.Isactive=0 then  tr.TerritoryCode+' : '+tr.TerritoryName+' ['+'Inactive'+']' else tr.TerritoryCode+' : '+tr.TerritoryName end TerritoryName from       dbo.tblTerritory tr   with (nolock)  
    INNER JOIN dbo.tblSubTerritory subtr   with (nolock) ON tr.TerritoryId = subtr.TerritoryId
       INNER JOIN dbo.tblMarket AS MKT   with (nolock) ON subtr.SubTerritoryId = MKT.SubTerritoryId
    
  
        INNER JOIN dbo.tblArea ar   with (nolock) ON ar.AreaId = tr.AreaId
        INNER JOIN dbo.tblRegion rg    with (nolock)ON rg.RegionId = ar.RegionId
        INNER JOIN dbo.tbl_Group gp   with (nolock) ON gp.GroupId = rg.GroupId
		inner JOIN dbo.tblRouteInformationMarketDetail rDtl   with (nolock) ON rDtl.MarketId = MKT.MarketId
      
        left JOIN dbo.tblRouteInformationMaster RMas   with (nolock) ON RMas.RouteInformationMasterId = rDtl.RouteInformationMasterId

		where RMas.DcId=@DCid
		order by tr.TerritoryCode asc
    END

