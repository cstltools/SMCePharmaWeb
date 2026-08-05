CREATE PROCEDURE [dbo].[sp_GET_ProductTypeActiveForDDL] 


AS
BEGIN
	

	 Select ProductTypeId, ProductTypeName from tblProductType where IsActive = 1

END

