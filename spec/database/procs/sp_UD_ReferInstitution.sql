
Create PROCEDURE [dbo].[sp_UD_ReferInstitution]
	-- Add the parameters for the stored procedure here
    @id INT,
    @InstitutionName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT

AS
    BEGIN


		UPDATE tblReferInstitution 
		SET InstitutionName = @InstitutionName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE InstitutionId =  @id
       

    END
