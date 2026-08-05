CREATE PROCEDURE [dbo].[sp_Get_RoleTypeByEmpId]
	-- Add the parameters for the stored procedure here

	@EmpId INT

AS
BEGIN
	
SELECT usr.RoleTypeId,u.UserId FROM tblUser u
inner join tbl_UserRoleInfo usr ON usr.UserRoleID=u.UserRoleID
where EmpInfoId=@EmpId
	 
END


