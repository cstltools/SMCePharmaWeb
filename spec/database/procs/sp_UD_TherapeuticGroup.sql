CREATE PROCEDURE [dbo].[sp_UD_TherapeuticGroup]
	-- Add the parameters for the stored procedure here
    @id INT,
    @TherapeuticGroupName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN


		UPDATE tblTherapeuticGroup
		SET TherapeuticGroupName = @TherapeuticGroupName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy=@InactiveBy, InactiveDate = @InactiveDate
		WHERE TherapeuticGroupId =  @id
       

    END
