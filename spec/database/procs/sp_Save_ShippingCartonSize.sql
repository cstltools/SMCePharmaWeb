
CREATE PROCEDURE [dbo].[sp_Save_ShippingCartonSize]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ShippingCartonSizeName  NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll

	

AS
    BEGIN
	
	if not exists (select ShippingCartonSizeName from tblShippingCartonSize where ShippingCartonSizeName=@ShippingCartonSizeName)
    begin 

        DECLARE @ShippingCartonCode	 NVARCHAR(MAX)

        SELECT  @ShippingCartonCode	 = 'SHIP-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ShippingCartonSizeId) + 10001 )) ) FROM  tblShippingCartonSize

        INSERT INTO tblShippingCartonSize
           (
			ShippingCartonSizeName
			,ShippingCartonCode	
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,ActiveInactiveDate     
           )
     VALUES
           (
		    @ShippingCartonSizeName,
			@ShippingCartonCode,
			@IsActive,
		    @EntryBy,
		    GETDATE(),
			@InactiveBy,
			@ActiveInactiveDate
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END