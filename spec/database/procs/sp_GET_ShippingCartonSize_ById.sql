 CREATE PROCEDURE [dbo].[sp_GET_ShippingCartonSize_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblShippingCartonSize where ShippingCartonSizeId = @id
      
    END
