

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Department]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @DepartmentName    NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblDepartment WHERE DeptName=@DepartmentName AND    DeptId NOT IN ( @id)

END



