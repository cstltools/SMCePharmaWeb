CREATE PROCEDURE [dbo].[sp_GET_ProductBrand_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblProductBrand where ProductBrandId = @id
      
    END