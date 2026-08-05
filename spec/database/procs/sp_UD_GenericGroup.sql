CREATE PROCEDURE [dbo].[sp_UD_GenericGroup]
	-- Add the parameters for the stored procedure here
    @id INT,
    @GenericGroupName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN


		UPDATE tblGenericGroup
		SET GenericGroupName = @GenericGroupName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy=@InactiveBy, InactiveDate = @InactiveDate
		WHERE GenericGroupId =  @id
       

    END
