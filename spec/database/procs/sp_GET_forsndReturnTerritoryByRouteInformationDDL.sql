

 create PROCEDURE [dbo].[sp_GET_forsndReturnTerritoryByRouteInformationDDL]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN
    SET NOCOUNT ON;
	 
--    select distinct ord.TerritoryId TerritoryId ,ord.TerritoryCode+ ' : '+ord.TerritoryName_Ord AS TerritoryName     

--from tblOrder ord   WITH (NOLOCK) where ord.DistributionRouteId=@id
    select distinct  terry.TerritoryId AS TerritoryId, terry.TerritoryCode+ ' : '+terry.TerritoryName AS TerritoryName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
  INNER JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = ord.TerritoryId
  
   
where       ord.DistributionRoute_Ord is not null    and  PaymentInvoiceNo  is  not null and     SndReturnInvoiceNo  is  null 
 --and  RouteInformationMasterId not in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )     
   -- and Inv.ComUnitId=1  AND ord.DistributionRouteId=52 AND ord.TerritoryId='45'  and   ord.ComUnitId='1'
   AND ord.DistributionRouteId=@id
      
    END


