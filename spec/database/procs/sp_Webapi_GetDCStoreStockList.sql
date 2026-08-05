
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE    [dbo].[sp_Webapi_GetDCStoreStockList]

@CustomerMasterId nvarchar(max)
AS
BEGIN
	
	 
	   
select cast (convert (int, floor(ISNULL(SUM(dcStore.StockQty),0))) as nvarchar(max)) StockQty,tblProduct.ProductCode, tblProduct.ProductName 
from tblCustMaster  cus  with (nolock)
inner join tblMarket mr  with (nolock) on mr.MarketId=cus.MarketId
 
inner join tblRouteInformationMarketDetail dcDtl  with (nolock) on dcDtl.MarketId=cus.MarketId
inner join tblRouteInformationMaster dcMas  with (nolock) on dcDtl.RouteInformationMasterId=dcMas.RouteInformationMasterId
inner join tblDCStore dcStore  with (nolock) on dcStore.ComUnitId=dcMas.DCId
left  join tblProduct  with (nolock) on tblProduct.ProductCode = dcStore.ProductCode 
where cus.CustomerMasterId=@CustomerMasterId  and tblProduct.ProductGroupId=1 
group by tblProduct.ProductCode, tblProduct.ProductName

having ISNULL(SUM(dcStore.StockQty),0)>0
order by tblProduct.ProductName asc
END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 



