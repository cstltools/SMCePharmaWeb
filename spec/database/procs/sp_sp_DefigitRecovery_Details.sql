CREATE PROCEDURE [dbo].[sp_sp_DefigitRecovery_Details] ---SAP Invoice Details
   @MIOCode nvarchar(max)  ,
   @Territory nvarchar(max)  ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
 select CustomerCode MasterId,  
CustomerCode                      as MIOCode,	
Territory                             as Territory,
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


 from SAP_API_Data.. tbl_AllDefigitRecovery_2 iv with(nolock)
    

 where    CustomerCode= 'EE00051161'

--and CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)


 --FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 --FORMAT(DATEADD(DAY, -1,GETDATE()),'16.10.2024')   
 
END
 




--  select CustomerCode MasterId,  
--CustomerCode                      as MIOCode,	
--Territory                             as Territory,
--FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
----,O.OrderType OrderType 
--,OrderType OrderType,
--CustomerCode                    as MIOCode,	
----O.TerritoryCode                                as Territory,
--Batch                         as Batch,

----FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
--Plant                                      as Depot, 
--ProductCode                             as	ProductCode, 
-- (CAST(Quantity as decimal(18,1)))        as Quantity,
--UoM                                as UnitofMeasure,
----CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
----sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
--CAST(UnitPrice as decimal(18,2)) 	        as UnitPrice,
--(CAST(VAT as decimal(18,2)))            as	VAT,


-- (CAST(DiscountAmount as decimal(18,2)))   as DiscountAmount, FOCFlag  as FOCType


-- from SAP_API_Data.. tbl_Return iv with(nolock)
    

-- where     CustomerCode in ('EE00051380','EE00052416') and Territory in ('893','444') and 

--  CAST(SalesDocDate AS DATE) between '01-nov-2022' and '01-nov-2024'

