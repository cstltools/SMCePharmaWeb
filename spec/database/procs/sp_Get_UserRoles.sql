

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_UserRoles]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
    
	SELECT * FROM dbo.tbl_UserRoleInfo
	LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId

	
    END 



