CREATE PROCEDURE [dbo].[sp_SAP_SalesReturnDtls] ---SAP Invoice Details
   @MasterId nvarchar(max)
    ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
Select * from 
(select  
isnull(O.MIOCode,'Blank')                        as MIOCode,	
--O.TerritoryCode                                as Territory,
ivD.BatchNo                                as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
U.SAP_Code                                      as Depot, 
P.SAP_Code                              as	ProductCode, 
sum(CAST(ivD.Quantity as decimal(18,1)))        as Quantity,
tblStockUOM.UOMSAPCode                                as UnitofMeasure,
CAST(tblUnitPrice.UnitPrice as decimal(18,2)) 	        as UnitPrice,
(CAST(tblUnitPrice.VATPercentage as decimal(18,3)))            as	VAT,
sum(CAST(ivD.DiscountAmount as decimal(18,2)))   as DiscountAmount, 
case when  ivD.UnitPrice =0 and ProductGroupId=3   then 'C'     when  ivD.UnitPrice =0 and ProductGroupId in (1,2) then 'B'    end                                     as FOCType


 from tblInvoice  iv with(nolock)
 inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
 inner join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
 inner join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
 inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
 inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
 inner join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode

 where   ivD.DeliveryStatus in ('Partial','Full') and iv.updateDate between @FrmDate and @ToDate  and ivD.UnitPrice >0 and P.SAP_Code is not null

Group by isnull(O.MIOCode,'Blank') ,iv.updateDate,ProductGroupId,ivD.BatchNo  	,  U.SAP_Code , P.SAP_Code  ,  tblStockUOM.UOMSAPCode ,tblUnitPrice.UnitPrice,tblUnitPrice.VATPercentage  ,CAST(ivD.UnitPrice as decimal(18,2)) )tblx
where  isnull(MIOCode,'Blank') =@MasterId 


END
 

  --"Depot": "BD31",
  --                          "ProductCode": "MNS03",
  --                          "Quantity": "72.0",
  --                          "UnitofMeasure": "Pack",
  --                          "UnitPrice": "405.00",
  --                          "VAT": "70.470",
  --                          "DiscountAmount": "0.00",
  --                          "FOCType": ""


