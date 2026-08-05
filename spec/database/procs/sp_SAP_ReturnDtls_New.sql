CREATE PROCEDURE [dbo].[sp_SAP_ReturnDtls_New] ---SAP Invoice Details
   @MIOCode nvarchar(max)  ,
   @Territory nvarchar(max)  ,
     @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
 select Plant  MasterId,  
        Plant                       as MIOCode,	
       '401'                              as Territory,
       FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
--,O.OrderType OrderType 
,OrderType OrderType,
''                    as MIOCode,	
--O.TerritoryCode                                as Territory,
Batch                         as Batch,

--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt, 
 tblCompanyUnit.SAP_Code                                       as Depot, 
ProductCode                             as	ProductCode, 
 (CAST(SUM(Quantity) as decimal(18,1)))        as Quantity,
UoM                                as UnitofMeasure,
--CAST(ivD.UnitPrice as decimal(18,2)) 	        as UnitPrice,
--sum(CAST(ivD.UnitVatAmount as decimal(18,3)))            as	VAT,
CAST(UnitPrice as decimal(18,2)) 	        as UnitPrice,
(CAST(SUM(VAT) as decimal(18,2)))            as	VAT,


 (CAST(SUM(DiscountAmount) as decimal(18,2)))   as DiscountAmount, FOCFlag  as FOCType


 from SAP_API_Data.. tbl_Return iv with(nolock)
     left join tblCompanyUnit on tblCompanyUnit.Customer_Code = iv.Plant

 where   
  Plant=@MIOCode  and CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)
  --CAST(GETDATE() - 1 AS DATE)


  --Plant=@MIOCode  and CAST(SalesDocDate AS DATE) =  '02-feb-2026'  and IS_SAP_MigrationDone=1
 
 
 --and SPReturn=1

 group by Plant  ,   
FORMAT(iv.SalesDocDate,'dd.MM.yyyy'),OrderType ,Batch ,tblCompanyUnit.SAP_Code ,
 
ProductCode       , UoM   ,UnitPrice           ,FOCFlag    


 
END
 