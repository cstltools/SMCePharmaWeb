CREATE PROCEDURE [dbo].[sp_UD_ShippingCarton]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ShippingCartonSizeName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll

AS
    BEGIN

		UPDATE tblShippingCartonSize
		SET ShippingCartonSizeName =@ShippingCartonSizeName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy= @InactiveBy, ActiveInactiveDate=@ActiveInactiveDate
		WHERE ShippingCartonSizeId =  @id
       
    END