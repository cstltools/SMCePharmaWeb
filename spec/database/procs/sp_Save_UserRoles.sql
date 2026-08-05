

CREATE PROCEDURE [dbo].[sp_Save_UserRoles]
	-- Add the parameters for the stored procedure here
	
    @RoleName NVARCHAR(MAX) NULL,
		    @IsActive BIT NULL
			,
		    @ActiveDate DATETIME NULL,
		    @EntryBy NVARCHAR(MAX) NULL,
		    @EntryDate DATETIME NULL,
		    @RoleTypeId INT
 AS
    BEGIN
	


		INSERT INTO dbo.tbl_UserRoleInfo
		(
		    RoleName,
		    IsActive,
		    ActiveDate,
		    EntryBy,
		    EntryDate,
		    RoleTypeId
		)
		VALUES
		(   @RoleName,
		    @IsActive,
		    @ActiveDate,
		    @EntryBy,
		    @EntryDate,
		    @RoleTypeId
		    )

		SELECT SCOPE_IDENTITY()

    END

