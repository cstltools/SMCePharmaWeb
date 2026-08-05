
 CREATE PROCEDURE [dbo].[sp_GET_DepartmentInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblDepartment where DeptId = @id
      
    END

