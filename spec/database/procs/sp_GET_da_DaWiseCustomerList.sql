

 CREATE   PROCEDURE [dbo].[sp_GET_da_DaWiseCustomerList]
	-- Add the parameters for the stored procedure here
   @daid int=0

AS
    BEGIN

	select rtMas.RouteInformationMasterId RouteId,rtMas.DCId ComUnitId, Latitude,Longitude, cus.CustomerMasterId, cus.CustomerCode, cus.CustomerName, cus.CellNo, cus.Address, mr.MarketCode, mr.MarketName from tblCustMaster cus
	inner join tblRouteInformationMarketDetail rtdtl  with (nolock) on rtdtl.MarketId=cus.MarketId
	inner join tblRouteInformationMaster rtMas  with (nolock) on rtMas.RouteInformationMasterId=rtdtl.RouteInformationMasterId
	 
	 inner join tblRouteInformationDADetail rtDA  with (nolock) on rtDA.RouteInformationMasterId=rtMas.RouteInformationMasterId

	  
	 inner join tblMarket mr  with (nolock) on mr.MarketId=cus.MarketId
	
	
	where cus.IsActive=1   and rtDA.DAId = @daid  and rtMas.RouteInformationMasterId is not null  and rtMas.RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )
      
    END
