ALTER PROCEDURE [dbo].[sp_Save_UserMaster_New]
	@UserId INT,
    @UserName nvarchar (max)=NULL,
    @UserType nvarchar (max)=NULL,
    @LoginName nvarchar (max)=NULL,
    @Password nvarchar (max)=NULL,
    @IMEI_One nvarchar (max)=NULL,
    @IMEI_Two nvarchar (max)=NULL,
    @EmpInfoId int=NULL,
    @DaInfoId int=NULL,
    @UserRoleID int=NULL,
    @UserTypeId int=NULL,
	@IsAppsUser bit=NULL,
    @ActiveInActiveDate datetime=NULL,
	@EntryBy nvarchar(50)=NULL,
	@UserStatus nvarchar (max)=NULL,
	@IsMainDashboard bit=NULL,
	@IsDepotDashboard bit=NULL
AS
BEGIN
    DECLARE  @CampaignCode NVARCHAR(max)
    SELECT @CampaignCode='U_'+ CAST(ISNULL(MAX(ISNULL(UserId,0)),0)+1001 AS NVARCHAR(max)) FROM dbo.[tblUser]
    
    INSERT INTO [dbo].[tblUser] (
		[UserName],[UserType],[UserCode],[LoginName],[Password],
		[EmpInfoId],[DaInfoId],[IsAppsUser],[IMEI_One],[IMEI_Two],[UserRoleID],
		[ActiveInActiveDate],[UserTypeId],EntryBy,EntryDate, UserStatus,IsMainDashboard,IsDepotDashboard
	)
    VALUES (
		@UserName,@UserType,@CampaignCode,@LoginName,@Password,
		@EmpInfoId,@DaInfoId,@IsAppsUser,@IMEI_One,@IMEI_Two,@UserRoleID,
		@ActiveInActiveDate,@UserTypeId,@EntryBy,GETDATE(),@UserStatus,@IsMainDashboard,@IsDepotDashboard 
	)
	SELECT SCOPE_IDENTITY()
END
GO
