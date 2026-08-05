

CREATE PROCEDURE [dbo].[sp_UD_SMCTypeInfo]
	-- Add the parameters for the stored procedure here
     @id INT = 0 ,
    @SMCType  NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT ,
    @IsCustomer BIT ,
    @IsDoctor BIT ,
    @IsDefault BIT 


AS
    BEGIN


		UPDATE tblSMCType 
		SET forCustomer=@IsCustomer,forDotor=@IsDoctor,IsDefault=@IsDefault, SMCType = @SMCType,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE SMCTypeId =  @id
       

    END

