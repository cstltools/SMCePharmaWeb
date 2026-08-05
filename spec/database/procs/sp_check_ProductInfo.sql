CREATE PROCEDURE [dbo].[sp_check_ProductInfo]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @ProductName   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblProduct WHERE ProductName=@ProductName AND  ProductId NOT IN ( @id)

END