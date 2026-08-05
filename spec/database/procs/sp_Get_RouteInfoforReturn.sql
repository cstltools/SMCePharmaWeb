CREATE PROCEDURE [dbo].[sp_Get_RouteInfoforReturn]
	-- Add the parameters for the stored procedure here
  @id INT

AS
    BEGIN

--	  select distinct ord.DistributionRouteId ,Rote.RouteName DistributionRouteName

--from tblInvoice Inv
--inner join tblOrder ord on ord.OrderId=Inv.OrderId
--inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
    
--where        PaymentInvoiceNo  is  null    and Inv.ComUnitId=@id   and  RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )   order by Rote.RouteName


 select distinct ord.DistributionRouteId ,ord.DistributionRoute_Ord   DistributionRouteName 

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
--inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
   
where      PaymentInvoiceNo  is  null
 --and  RouteInformationMasterId not in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )     
    and Inv.ComUnitId=@id  
  order by DistributionRouteName
 END