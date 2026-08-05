CREATE PROCEDURE [dbo].[sp_SAP_DeliveryConfirmationSales_ProcessNew] --- exec sp_SAP_DeliveryConfirmationSales_ProcessNew
   

AS
BEGIN

--delete from SAP_API_Data..tbl_DeliveryConfirmation_Sales where SalesDocDate between '6-july-2025' and '7-july-2025'


insert into SAP_API_Data..tbl_DeliveryConfirmation_Sales (CustomerCode,Territory,SalesDocDate,OrderType,Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag,Zone,Area,Batch,isDemo)

select  
tblEmpGeneralInfo.SAPEmpCode                       as MIOCode,	
tblTerritory.SAP_Code                                              as Territory,
--o.OrderSenderCode,
cONVERT(DATE,iv.updateDate)	                                             as InvoiceDt ,
'ZSPH'                                                   as OrderType,

--ivD.BatchNo                                              as Batch,
U.Customer_Code                                               as Plant, 
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
end                                                      as FOCType,

tblRegion.SAP_Code                                              as Zone,
tblArea.SAP_Code                                              as Area,
tblDCStore.BatchNo                                              as Batch,
1

from tblInvoice  iv with(nolock)
left join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpMasterCode=o.OrderSenderCode
left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
--left join tblArea on o.AreaId=tblArea.AreaId
--left join tblRegion on o.RegionId =tblRegion.RegionId
left join tblDCStore on tblDCStore.DCStoreId =ivD.DCStoreId
left join tblMIOInfo on tblMIOInfo.EmployeeId = tblEmpGeneralInfo.EmpInfoId and tblMIOInfo.IsActive=1
left join tblTerritory on tblTerritory.TerritoryId = tblMIOInfo.TerritoryId and tblTerritory.IsActive=1
left join tblArea on tblArea.AreaId = tblTerritory.AreaId and tblArea.IsActive=1
left join tblRegion on tblRegion.RegionId = tblArea.RegionId and tblRegion.IsActive=1


where  

ivD.DeliveryStatus in ('Partial','Full') 

and iv.updateDate = 
CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)  --- exec sp_SAP_DeliveryConfirmationSales_ProcessNew
--'03-Oct-2025' 


Group by tblEmpGeneralInfo.SAPEmpCode   ,tblTerritory.SAP_Code      ,iv.updateDate,ProductGroupId ,ivD.ISGiftProduct,  U.Customer_Code , P.SAP_Code  ,  tblStockUOM.UOMSAPCode  
 ,CAST(ivD.UnitPrice as decimal(18,2)) ,
tblRegion.SAP_Code   ,
tblArea.SAP_Code  ,
tblDCStore.BatchNo  
--,o.OrderSenderCode                                          


order by tblEmpGeneralInfo.SAPEmpCode,tblTerritory.SAP_Code   



UPDATE SAP_API_Data..tbl_DeliveryConfirmation_Sales
SET FOCFlag='C',Batch=' '
FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales SAP
INNER JOIN tblProduct ON SAP.ProductCode = tblProduct.SAP_Code
WHERE SalesDocDate = 
CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
--'03-Oct-2025'   
  AND isDemo = 1
  AND ProductGroupId = 3;


 exec SAP_API_Data..sp_UP_UpdateVatandPrice
DECLARE @DateParam DATE;
SET @DateParam = 
--'03-Oct-2025' 
DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

EXEC sp_SAP_UpdateEmpTerritory @DateParam;

 --'12-sep-2024' 

END


--Check gift item e C asche kina

--select SAP.* from  SAP_API_Data..tbl_DeliveryConfirmation_Sales  SAP
--inner join tblProduct on SAP.ProductCode=tblProduct.SAP_Code
---- where SalesDocDate='17-july-2024' and isDemo=1  and ProductGroupId=3


 --select sum(Quantity)Qty,sum(DiscountAmount)Discount,sum(Quantity*UnitPrice)TP,sum(VAT)VAT from  SAP_API_Data..tbl_DeliveryConfirmation_Sales 
 --where SalesDocDate between '21-Sep-2025' and '21-Sep-2025' and isDemo=1 and FOCFlag is null 


 -- select * from  SAP_API_Data..tbl_DeliveryConfirmation_Sales 
 --where SalesDocDate='12-Sep-2025' and isDemo=1 

 --delete from  SAP_API_Data..tbl_DeliveryConfirmation_Sales  where  SalesDocDate between '15-Sep-2025' and '19-Sep-2025'



-- update SAP_API_Data..tbl_DeliveryConfirmation_Sales set zone= 'MN100', Area=3042, Territory=643 where (SalesDocDate between '21-aug-2024' and '21-aug-2024') and CustomerCode='EE00052302'



--select top 1 tblTerritory.SAP_Code,tblArea.SAP_Code,tblRegion.SAP_Code
--from tblTerritory 
--inner join tblArea on tblArea.AreaId=tblTerritory.AreaId
--inner join tblRegion on tblRegion.RegionId=tblArea.RegionId
--where AreaCode='MN-140' and  tblTerritory.IsActive=1 and tblArea.IsActive=1