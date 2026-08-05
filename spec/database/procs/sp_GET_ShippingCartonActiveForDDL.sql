CREATE PROCEDURE [dbo].[sp_GET_ShippingCartonActiveForDDL] 


AS
BEGIN
	

	 Select  ShippingCartonSizeId, ShippingCartonSizeName from tblShippingCartonSize where IsActive = 1

END
