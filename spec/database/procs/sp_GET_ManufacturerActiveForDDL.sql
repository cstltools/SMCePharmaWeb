CREATE PROCEDURE [dbo].[sp_GET_ManufacturerActiveForDDL] 


AS
BEGIN
	

	 Select ManufacId, ManufacName from tblManufacturer where IsActive = 1

END
