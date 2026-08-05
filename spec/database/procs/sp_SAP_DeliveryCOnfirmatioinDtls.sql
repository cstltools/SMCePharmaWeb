CREATE PROCEDURE [dbo].[sp_SAP_DeliveryCOnfirmatioinDtls] ---SAP Invoice Details
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
''                           as Batch,

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


 from SAP_API_Data.. tbl_DeliveryConfirmation_Sales iv with(nolock)
  
 where     CustomerCode=@MIOCode and Territory=@Territory
 and FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 FORMAT(DATEADD(DAY, -3,GETDATE()),'dd.MM.yyyy')  
 

--{"Orders":[{"order":[{"CustomerCode":"500011","Territory":"401","Zone":"000001","Area":"3000","SalesDocDate":"06.11.2025","OrderType":"ZSPH","item":[{"Plant":"2038","Batch":"021/25","ProductCode":"141050","Quantity":"152.0","UoM":"PK","UnitPrice":"157.50","VAT":"4166.32","DiscountAmount":"0.00","FOCFlag":""}]}]}]}

END
 
