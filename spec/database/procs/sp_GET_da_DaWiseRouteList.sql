

 CREATE   PROCEDURE [dbo].[sp_GET_da_DaWiseRouteList]
	-- Add the parameters for the stored procedure here
   @daid int=0

AS
    BEGIN

	 Select  rtMas.DCId ComUnitId, rtMas.RouteInformationMasterId RouteId,rtMas.RouteName RouteName      from tblRouteInformationDADetail dtl with (nolock)
	 
	 inner join tblRouteInformationMaster rtMas  with (nolock) on rtMas.RouteInformationMasterId=dtl.RouteInformationMasterId
	 inner join tblCompanyUnit cUnit  with (nolock) on cUnit.ComUnitId=rtMas.DCId
	  where dtl.DAId = @daid  and rtMas.RouteInformationMasterId is not null  and rtMas.RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )
      
    END
