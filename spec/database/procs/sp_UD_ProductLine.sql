create PROCEDURE [dbo].[sp_UD_ProductLine]
	-- Add the parameters for the stored procedure here
    @id INT,
    @LineName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN


		UPDATE tblProductLine
		SET LineName = @LineName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy=@InactiveBy, InactiveDate = @InactiveDate
		WHERE ProductLineID =  @id
       

    END
