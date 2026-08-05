
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_EmployeeInformationListActive]
	-- Add the parameters for the stored procedure here
		@Parm nvarchar(max) 
AS
BEGIN
   
    DECLARE @Q NVARCHAR(MAX)='
   Select us.UserRoleId, usRT.RoleType, usR.RoleName, PM.EmpInfoId,CONVERT(NVARCHAR(50),PM.DateOfBirth,106)AS EmpDateOfBirth, case when  PM.EmployeeStatus=''Active'' then EmpName else EmpName+   '' (''+PM.EmployeeStatus+'')''   end EmpName, PM.* from tblEmpGeneralInfo PM with (nolock)
   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
   left join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   left join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId
    where  PM.EmpInfoId not in (1)

   ' +@Parm

						
EXEC sp_executesql @Q


END

