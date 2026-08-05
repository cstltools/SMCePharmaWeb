create PROCEDURE [dbo].[sp_SAP_STOListAfterSave_prm]
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN
 
 select FORMAT(OBDDate, 'dd.MM.yyyy') OBDDate, * from tblSAPSTOMaster_SAP  with (nolock)

 where  CONVERT(date, OBDDate) between @FrmDate and @ToDate

 
END


--  select * from tblStockInTransfar
 

