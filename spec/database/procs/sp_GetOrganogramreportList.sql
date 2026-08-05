CREATE PROCEDURE [dbo].[sp_GetOrganogramreportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   select distinct  ff.GroupCode +' : '+ ff.GroupName GroupName, ff.NSMCode +' : '+ ff.NSMName NSMName, ff.RegionCode +' : '+ ff.RegionName RegionName, ff.RSMCode +' : '+ ff.RSMName RSMName, ff.AreaCode +' : '+ ff.AreaName AreaName, ff.ASM +' : '+ ff.ASMName ASMName, ff.TerritoryCode +' : '+ ff.TerritoryName TerritoryName, ff.MIOCode +' : '+ ff.MIOName MIOName,   ff.SubTerritoryCode +' : '+ ff.SubTerritoryName SubTerritoryName,  ff.MarketId, ff.MarketCode+' : '+ff.MarketName MarketName, ISNULL(tblCust.CustCount,0) CustCount ,ISNULL(tblDoc.DocCount,0) DocCount  ,ISNULL(tblRoute.RouteCount,0) RouteCount from [dbo].[View_webapi_FieldForce] ff with (nolock)
left join (select marketid, count(*) CustCount from tblCustMaster  with (nolock) where IsActive=1 group by marketid) tblCust on ff.MarketId=tblCust.MarketId

left join (select marketid, count(*) DocCount from tblDoctorMaster  with (nolock) where IsActive=1 group by marketid) tblDoc on ff.MarketId=tblDoc.MarketId


left join (select marketid, count(*) RouteCount from tblRouteInformationMarketDetail  with (nolock)  group by marketid) tblRoute on ff.MarketId=tblDoc.MarketId

order by  ff.MarketCode+' : '+ff.MarketName  asc
END