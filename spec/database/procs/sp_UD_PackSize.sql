CREATE PROCEDURE [dbo].[sp_UD_PackSize]
	-- Add the parameters for the stored procedure here
    @id INT,
    @PackSizeName  NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll

AS
    BEGIN

		UPDATE tblPackSize 
		SET PackSizeName =  @PackSizeName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy= @InactiveBy, ActiveInactiveDate=@ActiveInactiveDate
		WHERE PackSizeId =  @id
       
    END