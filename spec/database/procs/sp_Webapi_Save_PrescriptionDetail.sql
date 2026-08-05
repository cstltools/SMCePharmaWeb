CREATE PROCEDURE [dbo].[sp_Webapi_Save_PrescriptionDetail]
	-- Add the parameters for the stored procedure here
	@productId INT = NULL,
	@pk int

AS
BEGIN
		
		INSERT INTO dbo.tbl_PrescriptionProductDetail
		        ( 
		          PrescriptionId ,
		          ProductId
		        )
		VALUES  (
		@pk,@productId

		        )


END

