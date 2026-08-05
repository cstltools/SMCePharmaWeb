

CREATE PROCEDURE [dbo].[sp_SAP_DeliveryCOnfirmatioinDtls_New] ---SAP Invoice Details
   @MIOCode nvarchar(max)  ,
   @Territory nvarchar(max)  ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
 select Plant MasterId,  
Plant                      as MIOCode,	
'401'                             as Territory,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
--'31-oct-2025'	      as InvoiceDt

--,O.OrderType OrderType 
,OrderType OrderType,
Plant                    as MIOCode,	
--O.TerritoryCode                                as Territory,
Batch                         as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
 tblCompanyUnit.SAP_Code                                       as Depot, 
ProductCode                             as	ProductCode, 
 (CAST(SUM(Quantity) as decimal(18,1)))        as Quantity,
UoM as UnitofMeasure,
--CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
--sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
CAST( (UnitPrice) as decimal(18,2)) 	        as UnitPrice,
(CAST(SUM(VAT) as decimal(18,2)))            as	VAT,


 (CAST(SUM(DiscountAmount) as decimal(18,2)))   as DiscountAmount, FOCFlag  as FOCType


 from SAP_API_Data.. tbl_DeliveryConfirmation_Sales iv with(nolock) 
     left join tblCompanyUnit on tblCompanyUnit.Customer_Code = iv.Plant

  where  
 
  CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE) and Plant=@MIOCode 

  -- IS_SAP_MigrationDone=1    and Plant=@MIOCode 
   
  -- CAST(SalesDocDate AS DATE) =  '09-may-2026' and Plant=@MIOCode

  group by Plant  ,   tblCompanyUnit.SAP_Code, 
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 



,OrderType  ,
 
--O.TerritoryCode                                as Territory,
Batch                          ,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
 
ProductCode           ,UoM   ,UnitPrice           ,FOCFlag    






END


 
 
-- CAST(SalesDocDate AS DATE) =  '22-Mar-2026' and Plant=@MIOCode 


 --CAST(SalesDocDate AS DATE) = '03-Feb-2026'  and Plant=@MIOCode   and IS_SAP_MigrationDone=1 

  