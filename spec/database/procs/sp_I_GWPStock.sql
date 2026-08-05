
-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_GWPStock] 
	(
		 @PromoId INT
         
	)
AS
BEGIN
	 
	DECLARE @Qty INT
--DECLARE @PromoId INT
DECLARE @StockId INT
DECLARE @ProductId INT

SELECT @Qty=ISNULL(Qty,0),@ProductId=ProductId FROM dbo.tblGroupWisePromoQty WHERE GWPromoQtyId=@PromoId

DECLARE @MainQty INT=0
			DECLARE @DCStoresId INT=0

			SET @MainQty=@Qty

			WHILE (@MainQty>0)
			BEGIN
				
			    
				DECLARE @StockQ INT=0

				SELECT TOP 1 @StockQ=ISNULL(Quantity,0),@StockId=ReceiveId FROM dbo.tblCentralStore WHERE ProductId=@ProductId AND Quantity>0


				IF(@StockQ>=@MainQty)
				BEGIN
				   --SET @MainQty=0
				   
				   UPDATE dbo.tblCentralStore SET Quantity=Quantity-@MainQty WHERE ReceiveId=@StockId

				   			INSERT INTO tblGWPStock
							(ReceiveId,ProductId,Qty,GWPromoQtyId)
							VALUES 
							(@StockId,@ProductId,@MainQty,@PromoId)




				    SET @MainQty=0
				END
				ELSE
                BEGIN
                    SET @MainQty=@MainQty-@StockQ
					UPDATE dbo.tblCentralStore SET Quantity=Quantity-@MainQty WHERE ReceiveId=@StockId

				   			INSERT INTO tblGWPStock
							(ReceiveId,ProductId,Qty,GWPromoQtyId)
							VALUES 
							(@StockId,@ProductId,@MainQty,@PromoId)

								

                END


			END
	  
         

END


