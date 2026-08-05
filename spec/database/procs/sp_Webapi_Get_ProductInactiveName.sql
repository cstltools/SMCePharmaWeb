
create PROCEDURE [dbo].[sp_Webapi_Get_ProductInactiveName]
	-- Add the parameters for the stored procedure here
 
	@ProductId nvarchar(max) 
AS
BEGIN
 select p.ProductName from tblProduct p with (nolock) where ProductId=@ProductId
		
END