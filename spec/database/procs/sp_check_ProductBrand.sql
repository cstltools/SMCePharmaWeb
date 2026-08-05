CREATE PROCEDURE [dbo].[sp_check_ProductBrand]
	-- Add the parameters for the stored procedure here
	@id  INT ,
    @ProductBrandName   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblProductBrand WHERE ProductBrandName = @ProductBrandName  AND ProductBrandId NOT IN ( @id)

END
