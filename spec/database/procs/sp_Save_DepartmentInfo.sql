
CREATE PROCEDURE [dbo].[sp_Save_DepartmentInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
    @DepartmentName NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT

AS
    BEGIN
	
	if not exists (select DeptName from tblDepartment where DeptName=@DepartmentName)
    begin 

        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'ROTE-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(DeptId) + 10001 )) ) FROM  tblDepartment

        INSERT INTO tblDepartment
           (
			DeptName
			,DeptCode			
           ,IsActive
           ,EntryBy
           ,EntryDate        
           )
     VALUES
           (
		    @DepartmentName,
			@DepartmentCode,
			@IsActive,
		    @EntryBy,
		    GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
