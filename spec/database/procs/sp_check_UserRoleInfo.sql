

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_UserRoleInfo]
	-- Add the parameters for the stored procedure here
	  @UserRoleID  INT ,
	  @RoleName  nvarchar(max)  
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_UserRoleInfo WHERE RoleName=@RoleName AND  UserRoleID NOT IN ( @UserRoleID)

END



