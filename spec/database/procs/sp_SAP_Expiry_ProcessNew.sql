CREATE PROCEDURE [dbo].[sp_SAP_Expiry_ProcessNew] --- exec sp_SAP_Expiry_ProcessNew ** always invoice update date dea tante hobe 
   

AS
BEGIN

--delete from SAP_API_Data..tbl_ExpiryReturn  where  Plant='2037' and SalesDocDate='2026-02-28'

--select * from SAP_API_Data..tbl_ExpiryReturn where  Plant='2037' and SalesDocDate='2026-02-28'

insert into SAP_API_Data..tbl_ExpiryReturn (CustomerCode,Territory,SalesDocDate,OrderType,Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag,Zone,Area,Batch)


select  
tblEmpGeneralInfo.SAPEmpCode                       as MIOCode,	


tblTerritory.SAP_Code                                              as Territory,

cONVERT(DATE,iv.InvoiceAdjustmentDate)	                                             as InvoiceDt ,
'ZEXP'                                                   as OrderType,

--ivD.BatchNo                                              as Batch,
tblCompanyUnit.SAP_Code                                               as Plant, 
LTRIM(RTRIM( P.SAP_Code))                                       as ProductCode, 



sum(CAST(ivD.Quantity as decimal(18,1)))                 as Quantity,
tblStockUOM.UOMSAPCode                                   as UoM, 
CAST(ivD.UnitPrice as decimal(18,2)) 	         as UnitPrice,
sum(CAST(ivD.TotalPriceVatAmount as decimal(18,2))) 	  as	VAT,
--(CAST(tblUnitPrice.VATPercentage as decimal(18,3))) 

sum(CAST(ivD.DiscountAmount as decimal(18,2)))           as DiscountAmount, 


' '                                                   as FOCType,

tblRegion.SAP_Code                                              as Zone,
tblArea.SAP_Code                                              as Area,
'1'                                             as Batch

from tblReturnInvoice  iv with(nolock)
inner join tblReturnInvoiceDetail ivD with(nolock) on iv.ReturnInvoiceId=ivD.ReturnInvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
--left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
--left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
left join tblArea on iv.AreaId_Rtn=tblArea.AreaId
left join tblRegion on iv.RegionId_Rtn =tblRegion.RegionId
left join tblTerritory on iv.Terri_Id_new =tblTerritory.TerritoryId
left join tblCompanyUnit on tblCompanyUnit.ComUnitId =iv.ComUnitId


left join tblMIOInfo on tblMIOInfo.MIOId =iv.MIOId_new
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpInfoId=tblMIOInfo.EmployeeId


where  

--iv.ReturnInvoiceId in (
--507,
--606,
--607,
--704


--)
iv.InvoiceAdjustmentDate between '30-june-2026' and  '30-june-2026' 


Group by tblEmpGeneralInfo.SAPEmpCode   ,tblTerritory.SAP_Code  ,iv.updateDate,ProductGroupId ,  tblCompanyUnit.SAP_Code   , P.SAP_Code  ,  tblStockUOM.UOMSAPCode  
 ,CAST(ivD.UnitPrice as decimal(18,2)) ,
tblRegion.SAP_Code   ,
tblArea.SAP_Code  ,
ivD.BatchNo    ,
P.ProductCode  ,

cONVERT(DATE,iv.InvoiceAdjustmentDate)	,
tblEmpGeneralInfo.EmpMasterCode                                   


order by tblEmpGeneralInfo.SAPEmpCode 


--select * from tblProduct where ProductCode='OAD01'
--select * from tblProduct where ProductCode='ANA01'
--select * from tblProduct where ProductCode='ARD01'

END


--Check gift item e C asche kina

--select SAP.* from  SAP_API_Data..tbl_DeliveryConfirmation_Sales  SAP
--inner join tblProduct on SAP.ProductCode=tblProduct.SAP_Code
-- where SalesDocDate='27-jan-2024' and isDemo=1  and ProductGroupId=3


-- select sum(Quantity)qty,sum(DiscountAmount)discount,sum(Quantity*UnitPrice)unitprice,sum(VAT)vat from  SAP_API_Data..tbl_DeliveryConfirmation_Sales 
-- where SalesDocDate='27-jan-2024' and isDemo=1 


--  select * from  SAP_API_Data..tbl_DeliveryConfirmation_Sales 
-- where SalesDocDate='22-jan-2024' and isDemo=1 


