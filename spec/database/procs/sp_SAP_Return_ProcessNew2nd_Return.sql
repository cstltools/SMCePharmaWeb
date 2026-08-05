Create PROCEDURE [dbo].[sp_SAP_Return_ProcessNew2nd_Return] --- exec sp_SAP_Return_ProcessNew
   

AS
BEGIN
--select * from SAP_API_Data..tbl_Return where SalesDocDate='18-april-2024'

--select * from SAP_API_Data..tbl_Return

insert into SAP_API_Data..tbl_Return (CustomerCode,Territory,SalesDocDate,OrderType,Plant,ProductCode,Quantity,UoM,UnitPrice,VAT,DiscountAmount,FOCFlag,Zone,Area,Batch,SPReturn)

select  
tblEmpGeneralInfo.SAPEmpCode                       as MIOCode,	
o.SAPTerritoryCode_Ord                                              as Territory,

cONVERT(DATE,iv.SndReturnPaymentDate)	                                             as InvoiceDt ,
'ZRET'                                                   as OrderType,

--ivD.BatchNo                                              as Batch,
U.Customer_Code                                               as Plant, 
LTRIM(RTRIM( P.SAP_Code))                                       as ProductCode, 
sum(CAST(tblInvoiceDetailReturn.PreviousQuantity as decimal(18,1)))  - sum(CAST(tblInvoiceDetailReturn.sndReturnQuantity as decimal(18,1)))                   as Quantity,
tblStockUOM.UOMSAPCode                                   as UoM, 
CAST(ivD.UnitPrice as decimal(18,2)) 	         as UnitPrice,
(sum(CAST(tblInvoiceDetailReturn.PreviousQuantity as decimal(18,1)))  - sum(CAST(tblInvoiceDetailReturn.sndReturnQuantity as decimal(18,1)))   )*(ivD.UnitVatAmount)	  as	VAT,
--(CAST(tblUnitPrice.VATPercentage as decimal(18,3))) 

sum(ISNULL(ivD.PaymentDiscountAmount- tblInvoiceDetailReturn.sndReturnDiscountAmount,0))     as DiscountAmount, 


case when  ivD.ISGiftProduct =1  and ProductGroupId=3   
then 'C'     when  ivD.ISGiftProduct =1 
and ProductGroupId in (1,2) then 'B'    
end                                                      as FOCType,

tblRegion.SAP_Code                                              as Zone,
tblArea.SAP_Code                                              as Area,
tblDCStore.BatchNo                                              as Batch,1

from tblInvoice  iv with(nolock)
inner join tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
left join tblProduct P with(nolock) on P.ProductCode = ivD.ProductCode
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
left join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
left join tblEmpGeneralInfo on tblEmpGeneralInfo.EmpMasterCode=o.OrderSenderCode
left join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
left join tblUnitPrice on tblUnitPrice.ProductCode=P.ProductCode
left join tblArea on o.AreaId=tblArea.AreaId
left join tblRegion on o.RegionId =tblRegion.RegionId
left join tblDCStore on tblDCStore.DCStoreId =ivD.DCStoreId
inner join tblInvoiceDetailReturn on tblInvoiceDetailReturn.InvoiceDetailId=ivD.InvoiceDetailId

where  

tblInvoiceDetailReturn.PreviousQuantity<>tblInvoiceDetailReturn.sndReturnQuantity
and iv.SndReturnPaymentDate=
CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)

--and tblInvoiceDetailReturn.PreviousQuantity <>0
--CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
--and PaymentInvoiceNo is not null


Group by tblEmpGeneralInfo.SAPEmpCode   ,o.SAPTerritoryCode_Ord   ,iv.SndReturnPaymentDate,ProductGroupId ,ivD.ISGiftProduct,  U.Customer_Code , P.SAP_Code  ,  tblStockUOM.UOMSAPCode  
 ,CAST(ivD.UnitPrice as decimal(18,2)) ,
tblRegion.SAP_Code   ,
tblArea.SAP_Code  ,
tblDCStore.BatchNo    ,ivD.UnitVatAmount                                        


order by tblEmpGeneralInfo.SAPEmpCode 




exec SAP_API_Data..sp_UP_UpdateVatandPrice_Return


END


--select sum(Quantity)qty,sum(DiscountAmount)discount,(sum(Quantity*UnitPrice)+sum(VAT))-sum(DiscountAmount) from  SAP_API_Data..tbl_Return 
--where SalesDocDate between '21-sep-2025' and '27-sep-2025' 


--and FOCFlag is null



--delete from SAP_API_Data..tbl_Return  where SalesDocDate between '14-sep-2025' and '14-sep-2025'

 --delete from   SAP_API_Data..tbl_Return where SalesDocDate='22-may-2024'
 --select * from  SAP_API_Data..tbl_Return 
 --where SalesDocDate='21-may-2024' and FOCFlag is null


 --select * from tblCompanyUnit