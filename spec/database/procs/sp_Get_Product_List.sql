CREATE PROCEDURE [dbo].[sp_Get_Product_List]
 
AS
BEGIN
	
	SELECT j.ProductId, j.ProductCode+' : '+ j.ProductName  ProductName		  FROM dbo.tblProduct j with (nolock)  order by j.ProductName asc  

END