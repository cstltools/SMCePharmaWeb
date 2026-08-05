CREATE PROCEDURE [dbo].[sp_SAP_DeliveryConfirmationSales_Process] --- exec sp_SAP_DeliveryConfirmationSales_Process
   


   --TRUNCATE TABLE SAP_API_Data..tbl_DeliveryConfirmation_Sales
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


insert into SAP_API_Data..tbl_DeliveryConfirmation_Sales (CustomerCode,Territory,SalesDocDate,OrderType,Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag)


select  
tblEmpGeneralInfo.SAPEmpCode                       as MIOCode,	
o.SAPTerritoryCode_Ord                                              as Territory,
cONVERT(DATE,iv.updateDate)	                                             as InvoiceDt ,
'ZSPH'                                                   as OrderType,

--ivD.BatchNo                                              as Batch,
U.SAP_Code                                               as Plant, 
LTRIM(RTRIM( P.SAP_Code))                                       as ProductCode, 
sum(CAST(ivD.DeliveryQuantity as decimal(18,1)))                 as Quantity,
tblStockUOM.UOMSAPCode                                   as UoM, 
CAST(ivD.UnitPrice as decimal(18,2)) 	         as UnitPrice,
sum(CAST(ivD.DeliveryTotalPriceVatAmount as decimal(18,2)))  	  as	VAT,
--(CAST(tblUnitPrice.VATPercentage as decimal(18,3))) 

sum(CAST(ivD.DeliveryDiscountAmount as decimal(18,2)))           as DiscountAmount, 


case when  ivD.ISGiftProduct =1  and ProductGroupId=3   
then 'C'     when  ivD.ISGiftProduct =1 
and ProductGroupId in (1,2) then 'B'    
end                                                      as FOCType


from tblInvoice  iv with(nolock)
inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpMasterCode=o.OrderSenderCode
left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode

--inner join tblMioInfo mio with(nolock) on mio.EmployeeId=  o.MIOId  and mio.IsActive=1

--inner join tblTerritory tr  with(nolock)  on  tr.TerritoryId=O.TerritoryId
--inner join tblMioInfo mio with(nolock) on mio.TerritoryId=  tr.TerritoryId  and mio.IsActive=1


where  
--p.productgroupid=1 and 

ivD.DeliveryStatus in ('Partial','Full') 

and iv.updateDate=CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)

--and P.SAP_Code is not null  
--and P.SAP_Code<> '141032'

Group by tblEmpGeneralInfo.SAPEmpCode   ,o.SAPTerritoryCode_Ord   ,iv.updateDate,ProductGroupId ,ivD.ISGiftProduct,  U.SAP_Code , P.SAP_Code  ,  tblStockUOM.UOMSAPCode  
 ,CAST(ivD.UnitPrice as decimal(18,2)) 
order by tblEmpGeneralInfo.SAPEmpCode 




END


