CREATE PROCEDURE [dbo].[sp_CS_RoleTypeFSS]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT DisplayName RoleType , * FROM dbo.tblRoleType  with (nolock) where RoleTypeId in (1,
2,
3,4,15)
END
