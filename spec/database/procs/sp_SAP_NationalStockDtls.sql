CREATE PROCEDURE [dbo].[sp_SAP_NationalStockDtls] ---SAP Invoice Details
   @MasterId nvarchar(max)
    ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
--Select * from 
--(select  
--isnull(O.MIOCode,'Blank')                        as MIOCode,	
----O.TerritoryCode                                as Territory,
--ivD.BatchNo                                as Batch,

----FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
--U.SAP_Code                                      as Depot, 
--P.SAP_Code                              as	ProductCode, 
--sum(CAST(ivD.Quantity as decimal(18,1)))        as Quantity,
--tblStockUOM.UOMSAPCode                                as UnitofMeasure,
----CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
----sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
--CAST(tblUnitPrice.UnitPrice as decimal(18,2)) 	        as UnitPrice,
-- (CAST(tblUnitPrice.VATPercentage as decimal(18,3)))            as	VAT,


--sum(CAST(ivD.DiscountAmount as decimal(18,2)))   as DiscountAmount, 
--case when  ivD.UnitPrice =0 and ProductGroupId=3   then 'C'     when  ivD.UnitPrice =0 and ProductGroupId in (1,2) then 'B'    end                                     as FOCType


-- from tblInvoice  iv with(nolock)
-- inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
-- inner join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
-- inner join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
-- inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
-- inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
--  inner join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
-- where InvoiceDate between @FrmDate and @ToDate and P.SAP_Code is not null

--Group by isnull(O.MIOCode,'Blank') ,InvoiceDate,ProductGroupId,ivD.BatchNo  	,  U.SAP_Code , P.SAP_Code  ,  tblStockUOM.UOMSAPCode ,tblUnitPrice.UnitPrice,tblUnitPrice.VATPercentage  ,CAST(ivD.UnitPrice as decimal(18,2)) )tblx
--where  isnull(MIOCode,'Blank') =@MasterId



 select  
''                       as MIOCode,	
--O.TerritoryCode                                as Territory,
iv.Batch                                as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
iv.Plant                                      as Depot, 
iv.ProductCode                              as	ProductCode, 
 (CAST(iv.ActualQuantity as decimal(18,1)))        as Quantity,
iv.UoM                                as UnitofMeasure,
--CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
--sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
CAST(0 as decimal(18,2)) 	        as UnitPrice,
 (CAST(0 as decimal(18,3)))            as	VAT,


 (CAST(0 as decimal(18,2)))   as DiscountAmount,  (CAST(BookedforDelivery as decimal(18,2)))   as  BookedforDelivery,
''                as FOCType

  from SAP_API_Data..tbl_Stock  iv with(nolock)
 where FORMAT(SalesDocDate ,'dd.MM.yyyy')=FORMAT(DATEADD(DAY, -1,GETDATE()),'dd.MM.yyyy')  
order by FORMAT(iv.SalesDocDate,'dd.MM.yyyy')   


END
 

  --"Depot": "BD31",
  --                          "ProductCode": "MNS03",
  --                          "Quantity": "72.0",
  --                          "UnitofMeasure": "Pack",
  --                          "UnitPrice": "405.00",
  --                          "VAT": "70.470",
  --                          "DiscountAmount": "0.00",
  --                          "FOCType": ""


