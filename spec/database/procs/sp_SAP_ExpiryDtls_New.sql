CREATE PROCEDURE [dbo].[sp_SAP_ExpiryDtls_New] ---SAP Invoice Details
   @MIOCode nvarchar(max)  ,
   @Territory nvarchar(max)  ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
 select CustomerCode MasterId,  
Plant                      as MIOCode,	
'401'                               as Territory,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
--,O.OrderType OrderType 
,OrderType OrderType,
CustomerCode                    as MIOCode,	
--O.TerritoryCode                                as Territory,
Batch                         as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
Plant                                      as Depot, 
ProductCode                             as	ProductCode, 
 (CAST(Quantity as decimal(18,1)))        as Quantity,
UoM                                as UnitofMeasure,
--CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
--sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
CAST(UnitPrice as decimal(18,2)) 	        as UnitPrice,
(CAST(VAT as decimal(18,2)))            as	VAT,


 (CAST(DiscountAmount as decimal(18,2)))   as DiscountAmount, FOCFlag  as FOCType


 from SAP_API_Data.. tbl_ExpiryReturn iv with(nolock)
  
 where    Plant='2040'  and
  FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 FORMAT(DATEADD(DAY, -1,GETDATE()),'30.06.2026')  order by ProductCode asc
 
 
END
 
 -- select * from tblCompanyUnit