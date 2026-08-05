
CREATE PROCEDURE [dbo].[sp_UD_DesignationInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
    @DesigName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT

AS
    BEGIN

		UPDATE tblDesignation 
		SET DesigName = @DesigName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE DesignationId =  @id
       
    END
