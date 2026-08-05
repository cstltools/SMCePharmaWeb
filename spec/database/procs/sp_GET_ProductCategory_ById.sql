CREATE PROCEDURE [dbo].[sp_GET_ProductCategory_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblProductCategory where ProductCategoryId = @id
      
    END