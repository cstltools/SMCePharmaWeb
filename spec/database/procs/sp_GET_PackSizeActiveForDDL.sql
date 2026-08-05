CREATE PROCEDURE [dbo].[sp_GET_PackSizeActiveForDDL] 


AS
BEGIN
	

	 Select PackSizeId, PackSizeName from tblPackSize where IsActive = 1

END
