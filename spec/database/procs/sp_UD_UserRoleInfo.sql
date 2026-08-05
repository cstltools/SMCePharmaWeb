
create PROCEDURE [dbo].[sp_UD_UserRoleInfo]
	-- Add the parameters for the stored procedure here
@UserRoleID INT,
    @RoleName NVARCHAR(500),
    @entryBy INT,
    @RoleTypeId INT,
	@isActive BIT,
	@acInAcDate DATETIME

AS
    BEGIN

	UPDATE tbl_UserRoleInfo
	SET RoleName=@RoleName
           ,IsActive=@IsActive
           ,ActiveInActiveDate=@acInAcDate
           ,UpdateBy=@entryBy
           ,UpdateDate=GETDATE(),RoleTypeId=@RoleTypeId
     
	WHERE UserRoleID = @UserRoleID

 END
