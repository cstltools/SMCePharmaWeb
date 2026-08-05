-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DcrProduct]
	-- Add the parameters for the stored procedure here
@productId INT,
@pk INT,
@type NVARCHAR(50),
@qty DECIMAL(18,0),
@empid INT
AS
BEGIN

DECLARE @Mainqty DECIMAL(18,2)
DECLARE @StockQty DECIMAL(18,2)		
DECLARE @GWPromoQtyId INT



SET @Mainqty=@qty

WHILE(@Mainqty>0)
BEGIN

SELECT @GWPromoQtyId=GWPromoQtyId,@StockQty=TransactionQTY FROM dbo.tblGroupWisePromoQty WHERE EmpInfoId=@empid AND ProductId=@productId
AND TransactionQTY>0

IF(@StockQty>=@Mainqty)
BEGIN
UPDATE dbo.tblGroupWisePromoQty SET TransactionQTY=TransactionQTY-@Mainqty WHERE GWPromoQtyId=@GWPromoQtyId
INSERT INTO tblPromoTransaction
(TransDate,GWPromoQtyId,TransQty)
VALUES
(GETDATE(),@GWPromoQtyId,-@qty)

		INSERT INTO dbo.tbl_DcrDetails
		        ( DcrId, ProductId, Type ,ProductQty,EmpInfoId,GWPromoQtyId)
		VALUES  (
				@pk,@productId,@type,@qty,@empid,@GWPromoQtyId
		          )
    
	SET @Mainqty=0

END
ELSE
BEGIN
    
	SET @Mainqty=@Mainqty-@StockQty
	UPDATE dbo.tblGroupWisePromoQty SET TransactionQTY=0  WHERE GWPromoQtyId=@GWPromoQtyId
INSERT INTO tblPromoTransaction
(TransDate,GWPromoQtyId,TransQty)
VALUES
(GETDATE(),@GWPromoQtyId,-@StockQty)

		INSERT INTO dbo.tbl_DcrDetails
		        ( DcrId, ProductId, Type ,ProductQty,EmpInfoId,GWPromoQtyId)
		VALUES  (
				@pk,@productId,@type,@StockQty,@empid,@GWPromoQtyId
		          )


END    





END











END

