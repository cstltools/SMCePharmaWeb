CREATE PROCEDURE [dbo].[sp_Webapi_Get_Userrole]
	-- Add the parameters for the stored procedure here

AS
BEGIN

SELECT * FROM dbo.tbl_UserRoleInfo  with (nolock)
WHERE   UserRoleID in (1,3,5,7)
union all SELECT * FROM dbo.tbl_UserRoleInfo   with (nolock)
WHERE UserRoleID IN ('17')


--select * from tblRoleType

END