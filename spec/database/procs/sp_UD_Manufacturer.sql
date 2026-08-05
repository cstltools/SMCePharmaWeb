CREATE PROCEDURE [dbo].[sp_UD_Manufacturer]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ManufacName   NVARCHAR(MAX) ,
	@ManufacAddress  NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT,
	@ActiveInactiveDate datetime

AS
    BEGIN


		UPDATE tblManufacturer 
		SET ManufacName = @ManufacName,ManufacAddress=@ManufacAddress,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy=@InactiveBy, ActiveInactiveDate=@ActiveInactiveDate
		WHERE ManufacId =  @id
       

    END