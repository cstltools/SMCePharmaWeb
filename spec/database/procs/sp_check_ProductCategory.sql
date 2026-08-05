CREATE PROCEDURE [dbo].[sp_check_ProductCategory]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @ProductCategory     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblProductCategory WHERE ProductCategory=@ProductCategory AND  ProductCategoryId NOT IN ( @id)

END