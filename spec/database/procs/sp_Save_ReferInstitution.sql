
Create PROCEDURE [dbo].[sp_Save_ReferInstitution]
	-- Add the parameters for the stored procedure here
    @id INT,
    @InstitutionName  NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT

AS
    BEGIN
	
	if not exists (select InstitutionName from tblReferInstitution where InstitutionName=@InstitutionName)
    begin 

        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'INST-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(InstitutionId) + 10001 )) ) FROM  tblReferInstitution

        INSERT INTO tblReferInstitution
           (
			InstitutionName
			,InstitutionCode			
           ,IsActive
           ,EntryBy
           ,EntryDate        
           )
     VALUES
           (
		    @InstitutionName,
			@DepartmentCode,
			@IsActive,
		    @EntryBy,
		    GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
