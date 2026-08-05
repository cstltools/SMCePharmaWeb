
CREATE PROCEDURE [dbo].[sp_GET_ProductRelatedValue_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select PS.PackSizeName as PackSize,* from tblProduct P
	 LEFT JOIN tblPackSize PS ON PS.PackSizeId = P.PackSizeId
	  where P.ProductId = @id
      
    END
