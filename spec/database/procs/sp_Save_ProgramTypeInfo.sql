
CREATE PROCEDURE [dbo].[sp_Save_ProgramTypeInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @ProgramTypeName  NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT ,
    @IsCustomer BIT ,
    @IsDoctor BIT ,
    @IsDefault BIT 

AS
    BEGIN
	


		if not exists (select ProgramTypeName from tblProgramType where ProgramTypeName=@ProgramTypeName)
begin 
        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'PRO - ' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ProgramTypeId) + 10001 )) ) FROM  tblProgramType


        INSERT INTO tblProgramType
           (
			PrgmTypeCode
           ,ProgramTypeName
           ,EntryBy
           ,EntryDate
           ,IsActive,IsCustomer,IsDoctor,IsDefault
           )
     VALUES
           (
		   @DepartmentCode,
		   @ProgramTypeName,
		   @EntryBy,
		   GETDATE(),
		   @IsActive ,@IsCustomer,@IsDoctor,@IsDefault
		   )

		SELECT SCOPE_IDENTITY()
		End
else  Return 0
    END
