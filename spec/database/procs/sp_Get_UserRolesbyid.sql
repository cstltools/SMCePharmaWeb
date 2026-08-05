

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_UserRolesbyid]
	-- Add the parameters for the stored procedure here

	@RoleId INT
AS
    BEGIN
    
	SELECT * FROM dbo.tbl_UserRoleInfo
	LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId
	WHERE UserRoleID=@RoleId

	
    END 



