CREATE PROCEDURE [dbo].[sp_SAP_STOListDetails_prm]
   @SAPSTOMasterId nvarchar(max) 

AS
BEGIN
 
 select FORMAT(ExpDate, 'dd.MM.yyyy') ExpDate, ObdItemNo ObdItemNo,  * from tblSAPSTODetail_SAP  with (nolock)

 where SAPSTOMasterId=@SAPSTOMasterId

 
END


--  select * from tblStockInTransfar
 

