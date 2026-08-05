CREATE PROCEDURE [dbo].[sp_SAP_StoNoforChallanConfirm] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

    select distinct  challan_code StoNo , format(D.StockRcvDate,'dd.MM.yyyy HH:mm:ss') PostingDate , format(D.StockRcvDate,'dd.MM.yyyy') DocDate, convert(date,D.StockRcvDate) StockRcvDate

from
  SAP_API_Data..tblSAP_StockMovementMaster iv with(nolock)
  inner join SalesDisDB_SMC_NEWDB..tblDCStore D on D.ChalanNo=iv.challan_code
  where   ISNULL(isConfirmDone,0)<>1  and convert(date,D.StockRcvDate) >= convert(date,'08-jan-2024')
 
 order by convert(date,D.StockRcvDate) asc

END



























 




