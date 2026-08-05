CREATE PROCEDURE [dbo].[sp_SAP_Invoice_Process] --- exec sp_SAP_DeliveryConfirmationSales_Process
   


   --TRUNCATE TABLE SAP_API_Data..tbl_Stock
   --SELECT * FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales

--   select sum(Quantity) from  SAP_API_Data..tbl_DeliveryConfirmation_Sales where SalesDocDate='3-oct-2023'
--and FOCFlag='C'  

----76+32

--select sum(DeliveryQuantity) from tblInvoice
--inner join tblInvoiceDetail on tblInvoice.InvoiceId= tblInvoiceDetail.InvoiceId
--where UpdateDate='3-oct-2023' and ISGiftProduct=1



--Duplicate count
--SELECT CustomerCode, Territory, SalesDocDate,OrderType, Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag,    COUNT(*) as duplicate_count
--FROM tbl_DeliveryConfirmation_Sales
--GROUP BY CustomerCode, Territory, SalesDocDate,OrderType, Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag
--HAVING COUNT(*) > 1;

--UPDATE tblProduct
--SET SAP_Code = LTRIM(RTRIM(SAP_Code))
--WHERE SAP_Code IS NOT NULL;

-- exec SAP_API_Data..sp_UP_UpdateVatandPrice
AS
BEGIN


insert into SAP_API_Data..tbl_Stock ([SalesDocDate],[Plant],[ProductCode],[UoM],[Batch],[ActualQuantity],[BookedforDelivery])


select  
CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)                    as SalesDocDate,	
C.SAP_Code                                                   as Plant,
P.SAP_Code                                                   as ProductCode ,
tblStockUOM.UOMSAPCode                                       as UoM ,
D.BatchNo                                                    as BatchNo ,
Sum(D.StockQty)                                               as ActualQuantity,
isnull(sum(tblX.Quantity   ) ,0)                                                as BookedforDelivery

from tblDCStore D with(nolock)
inner join tblCompanyUnit C with(nolock) on D.ComUnitId=C.CompanyId
left join tblProduct P with(nolock) on P.ProductCode = D.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join (Select (tblInvoiceDetail.Quantity)Quantity,DCStoreId from tblInvoice 
           inner join tblInvoiceDetail on    tblInvoice.InvoiceId= tblInvoiceDetail.InvoiceId    
		   where DelivaryInvoiceNo is null)tblX on tblX.DCStoreId = D.DCStoreId


where   P.SAP_Code is not null 

Group by C.SAP_Code    ,P.SAP_Code  ,tblStockUOM.UOMSAPCode   ,D.BatchNo 
having  Sum(D.StockQty)  >0
order by C.SAP_Code   ,P.SAP_Code



END


