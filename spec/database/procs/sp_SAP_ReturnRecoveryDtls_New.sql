CREATE PROCEDURE [dbo].[sp_SAP_ReturnRecoveryDtls_New] ---SAP Invoice Details
   @MIOCode nvarchar(max)  ,
   @Territory nvarchar(max)  ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN


 select 
 CustomerCode MasterId,  
CustomerCode                      as MIOCode,	
Territory                             as Territory,
 '30.11.2024'	 	       as InvoiceDt 
--,O.OrderType OrderType 
,'ZSPH' OrderType,
CustomerCode                    as MIOCode,	
--O.TerritoryCode                                as Territory,
Batch                         as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
Plant                                      as Depot, 
ProductCode                             as	ProductCode, 
sum( (CAST(Quantity as decimal(18,1))) )       as Quantity,
UoM                                as UnitofMeasure,
--CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
--sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
CAST(UnitPrice as decimal(18,2)) 	        as UnitPrice,
sum((CAST(VAT as decimal(18,2)))  )         as	VAT,
sum((CAST(DiscountAmount as decimal(18,2))))   as DiscountAmount, FOCFlag  as FOCType
from SAP_API_Data.. tbl_SAPRecoverySales iv with(nolock)
where CustomerCode in ('EE00051410') 

group by 
CustomerCode , Territory    ,FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	     ,OrderType ,Batch     ,Plant         , ProductCode        , UoM       ,CAST(UnitPrice as decimal(18,2)) 	,FOCFlag
 order by CustomerCode,ProductCode asc

END
 


 --update SAP_API_Data..tbl_SAPRecoverySales set SalesDocDate = '2024-11-30',OrderType='ZSPH'