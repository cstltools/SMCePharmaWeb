-- =============================================
CREATE PROCEDURE [dbo].[sp_check_ShippingCarton]
	-- Add the parameters for the stored procedure here
	@id  INT ,
    @ShippingCartonSizeName    NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblShippingCartonSize WHERE ShippingCartonSizeName=@ShippingCartonSizeName AND ShippingCartonSizeId NOT IN ( @id)

END
