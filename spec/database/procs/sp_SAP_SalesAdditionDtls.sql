create PROCEDURE [dbo].[sp_SAP_SalesAdditionDtls]
   @MasterId nvarchar(max) 

AS
BEGIN
select  
isnull(O.MIOCode,'Blank')                        as MIOCode,	
O.TerritoryCode                                as Territory,
FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
U.ComUnitCode                                      as Depot, 
ivD.ProductCode                              as	ProductCode, 
sum(CAST(ivD.Quantity as decimal(18,1)))        as Quantity,
tblStockUOM.StockUOMName                                as UnitofMeasure,
CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
sum(CAST(ivD.DiscountAmount as decimal(18,2)))   as DiscountAmount, 
case when  ivD.UnitPrice =0 and ProductGroupId=3   then 'C'     when  ivD.UnitPrice =0 and ProductGroupId in (1,2) then 'B'    end                                     as FOCType


 from tblInvoice  iv with(nolock)
 inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
 inner join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
 inner join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
 inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
 where iv.InvoiceId=@MasterId

Group by ProductGroupId,O.MIOCode ,	O.TerritoryCode ,FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	,  U.ComUnitCode , ivD.ProductCode ,  tblStockUOM.StockUOMName  ,CAST(ivD.UnitPrice as decimal(18,2)) 

END
 




