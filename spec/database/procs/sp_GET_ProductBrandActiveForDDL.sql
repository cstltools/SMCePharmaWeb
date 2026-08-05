
CREATE PROCEDURE [dbo].[sp_GET_ProductBrandActiveForDDL] 


AS
BEGIN
	

	 Select ProductBrandId, ProductBrandName from tblProductBrand where IsActive = 1

END