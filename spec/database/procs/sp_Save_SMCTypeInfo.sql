
create PROCEDURE [dbo].[sp_Save_SMCTypeInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @SMCType  NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT ,
    @IsCustomer BIT ,
    @IsDoctor BIT ,
    @IsDefault BIT 

AS
    BEGIN
	


		if not exists (select SMCType from tblSMCType where SMCType=@SMCType)
begin 
        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'BN - ' + ( CONVERT(NVARCHAR(MAX), ( COUNT(SMCTypeId) + 10001 )) ) FROM  tblSMCType


        INSERT INTO tblSMCType
           (
			SMCTypeCode
           ,SMCType
           ,EntryBy
           ,EntryDate
           ,IsActive,forCustomer,forDotor,IsDefault
           )
     VALUES
           (
		   @DepartmentCode,
		   @SMCType,
		   @EntryBy,
		   GETDATE(),
		   @IsActive ,@IsCustomer,@IsDoctor,@IsDefault
		   )

		SELECT SCOPE_IDENTITY()
		End
else  Return 0
    END
