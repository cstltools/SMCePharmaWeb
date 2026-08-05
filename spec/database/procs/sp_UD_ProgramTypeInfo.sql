

CREATE PROCEDURE [dbo].[sp_UD_ProgramTypeInfo]
	-- Add the parameters for the stored procedure here
     @id INT = 0 ,
    @ProgramTypeName  NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT ,
    @IsCustomer BIT ,
    @IsDoctor BIT ,
    @IsDefault BIT 


AS
    BEGIN


		UPDATE tblProgramType 
		SET IsCustomer=@IsCustomer,IsDoctor=@IsDoctor,IsDefault=@IsDefault, ProgramTypeName = @ProgramTypeName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE ProgramTypeId =  @id
       

    END

