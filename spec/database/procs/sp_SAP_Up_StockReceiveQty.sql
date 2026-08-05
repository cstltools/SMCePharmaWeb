create PROCEDURE [dbo].[sp_SAP_Up_StockReceiveQty] 

	@StockMovementDetailId int,
	@quantity INT
	
AS
BEGIN

 UPDATE SAP_API_Data..[tblSAP_StockMovementDetail]
   SET  [quantity] = @quantity 
       
 WHERE StockMovementDetailId=@StockMovementDetailId

END



