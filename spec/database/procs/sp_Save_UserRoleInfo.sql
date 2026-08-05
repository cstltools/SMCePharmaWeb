
CREATE PROCEDURE [dbo].[sp_Save_UserRoleInfo]
	
	-- Add the parameters for the stored procedure here

	@UserRoleID INT,
    @RoleName NVARCHAR(500),
    @entryBy INT,
    @RoleTypeId INT,
	@isActive BIT,
	@acInAcDate DATETIME

 AS
    BEGIN
	
	IF NOT EXISTS (select UserRoleID from tbl_UserRoleInfo where   RoleName = @RoleName )
    BEGIN 
        INSERT INTO tbl_UserRoleInfo
           (RoleName
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate,RoleTypeId)
     VALUES
           (@RoleName,
			@isActive,
			@acInAcDate,
			@entryBy,
			GETDATE(),@RoleTypeId)

		SELECT SCOPE_IDENTITY()

			END
		ELSE  	
		Return 0
    END
