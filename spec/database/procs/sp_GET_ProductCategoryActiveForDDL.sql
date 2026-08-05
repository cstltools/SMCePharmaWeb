
CREATE PROCEDURE [dbo].[sp_GET_ProductCategoryActiveForDDL] 


AS
BEGIN
	

	 Select ProductCategoryId, ProductCategory from tblProductCategory where IsActive = 1

END