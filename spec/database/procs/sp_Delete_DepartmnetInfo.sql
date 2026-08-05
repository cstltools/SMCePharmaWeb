
CREATE PROCEDURE [dbo].[sp_Delete_DepartmnetInfo]
	-- Add the parameters for the stored procedure here
    @DeptId INT 

AS
    BEGIN

       DELETE FROM tblDepartment WHERE DeptId = @DeptId
    END


