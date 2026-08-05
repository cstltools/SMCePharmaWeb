CREATE PROCEDURE [dbo].[sp_SAP_DeliveryCOnfirmatioinMaster] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

 select DISTINCT  CustomerCode MasterId,  
CustomerCode                      as MIOCode,	
Territory                             as Territory,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
--,O.OrderType OrderType 
,OrderType OrderType

from
  SAP_API_Data..tbl_DeliveryConfirmation_Sales iv with(nolock)
 where     FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 FORMAT(DATEADD(DAY, -3,GETDATE()),'dd.MM.yyyy')


END



























 




