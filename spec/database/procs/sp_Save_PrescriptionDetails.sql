-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Save_PrescriptionDetails]
	-- Add the parameters for the stored procedure here
	@PresDetailId INT,
    @PrescriptionId INT ,
	@ProductId INT	    
AS
    BEGIN
	
        INSERT  INTO [dbo].[tbl_PrescriptionProductDetail]
                ( PrescriptionId ,                
                  ProductId                 
	            )
        VALUES  ( @PrescriptionId ,              
                  @ProductId                       	
	            )

SELECT SCOPE_IDENTITY()

END

