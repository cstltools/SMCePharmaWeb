CREATE PROCEDURE [dbo].[sp_EmpGeneralInfoByEmployeeId]
	-- Add the parameters for the stored procedure here
    @EmployeeId  INT  


AS
    BEGIN


	select usRT.RoleTypeId, usRT.RoleType, usR.RoleName from   tblEmpGeneralInfo PM with (nolock)
   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
   left join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   left join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId where pm.EmpInfoId=@EmployeeId and us.UserStatus='Active' and pm.EmployeeStatus='Active'
    
end