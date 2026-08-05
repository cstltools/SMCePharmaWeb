CREATE PROCEDURE [dbo].[sp_DefigitRecovery] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

    select DISTINCT CustomerCode MasterId,  
CustomerCode                      as MIOCode,	
Territory                             as Territory, Zone [Zone],  Area [Area] ,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
--,O.OrderType OrderType 
,OrderType OrderType

from 
  SAP_API_Data..tbl_AllDefigitRecovery_2 iv with(nolock)
 where CustomerCode= 'EE00051161'
 
 -- CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)
  --FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 --FORMAT(DATEADD(DAY, -1,GETDATE()),'16.10.2024')   EE00050821


END



























 




