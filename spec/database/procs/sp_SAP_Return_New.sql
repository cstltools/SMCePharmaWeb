CREATE PROCEDURE [dbo].[sp_SAP_Return_New] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

    select DISTINCT  Plant                             MasterId,  
                     Plant                             as MIOCode,	
                    '401'                              as Territory, 
					'000001'                              [Zone],  
					'3000'                                [Area] ,
                   FORMAT(iv.SalesDocDate,'dd.MM.yyyy') as InvoiceDt 

                   ,OrderType                           OrderType

from 
  SAP_API_Data..tbl_Return iv with(nolock)
 where  
 
  CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)
  --CAST(GETDATE() - 1 AS DATE)

  --CAST(SalesDocDate AS DATE) = '02-Feb-2026'
  
  
  --and IS_SAP_MigrationDone=1




  --CAST(SalesDocDate AS DATE) = '30-jan-2026' 
 
 --and SPReturn=1
 -- -- and SPReturn=1
  --

END



























 




