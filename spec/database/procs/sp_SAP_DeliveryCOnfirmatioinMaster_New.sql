CREATE PROCEDURE [dbo].[sp_SAP_DeliveryCOnfirmatioinMaster_New] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

    select DISTINCT   Plant                   as MasterId,  
                      Plant                   as MIOCode,	
                      '401'                   as Territory,
                      '000001'                as [Zone],  
                      '3000'                  as [Area] ,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	      as InvoiceDt, 
--'31-oct-2025'	      as InvoiceDt, 


OrderType                                    as OrderType
  
  from
  SAP_API_Data..tbl_DeliveryConfirmation_Sales iv with(nolock)

   where  
   
  -- Plant='500009' and CAST(SalesDocDate AS DATE) =  '09-may-2026'

   CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)
  

   --IS_SAP_MigrationDone=1 


   --CAST(SalesDocDate AS DATE) =  '22-Mar-2026'


   --CAST(SalesDocDate AS DATE) = '03-Feb-2026' and 
   
      
 
   --select * from tblCompanyUnit where Customer_Code='500005'

END









--ALTER PROCEDURE [dbo].[sp_SAP_DeliveryCOnfirmatioinMaster_New] ---SAP Invoice
--   @FrmDate nvarchar(max),
--   @ToDate nvarchar(max)

--AS
--BEGIN

   
--    select DISTINCT   Plant                   as MasterId,  
--                      Plant                   as MIOCode,	
--                      '401'                   as Territory,
--                      '000001'                as [Zone],  
--                      '3000'                  as [Area] ,
--FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	      as InvoiceDt 
--,OrderType                                    as OrderType
  
--  from
--  SAP_API_Data..tbl_DeliveryConfirmation_Sales iv with(nolock)
--  where    
--  CAST(SalesDocDate AS DATE) = CAST('15-jul-2025' AS DATE) and Plant='500006'





--END





























 




