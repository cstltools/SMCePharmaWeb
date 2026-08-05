CREATE PROCEDURE [dbo].[sp_check_Unitprice]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @ProductName   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblUnitPrice WHERE ProductName=@ProductName AND  UnitPriceId NOT IN ( @id)

END