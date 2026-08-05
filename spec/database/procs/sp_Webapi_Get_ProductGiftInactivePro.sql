
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ProductGiftInactivePro]
	-- Add the parameters for the stored procedure here
 
	@ProductId nvarchar(max) 
AS
BEGIN
 select p.ProductName, case when  ISNULL(IsActive,0)=1 then 'Active' else 'Inactive' end AtiveStatus, ProductGroupId from tblProduct p with (nolock) where ProductId=@ProductId 
		
END