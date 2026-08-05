
CREATE   PROCEDURE [dbo].[sp_da_SalesAPI_doLogin]
    @username NVARCHAR(50),
    @password NVARCHAR(50),
    @Imei NVARCHAR(MAX),
    @DeviceInfo NVARCHAR(MAX),
    @OS NVARCHAR(MAX),
    @OS_Version NVARCHAR(MAX),
    @AppVersion NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @islogin BIT = 0;
    DECLARE @UserId INT = 0;
    DECLARE @FirstIMEI NVARCHAR(MAX) = NULL;
    DECLARE @SecIMEI NVARCHAR(MAX) = NULL;
    DECLARE @LoginMessage NVARCHAR(500) = N'';

    SELECT @UserId = ISNULL(UserId, 0),
           @FirstIMEI = IMEI_One,
           @SecIMEI = IMEI_Two
    FROM dbo.tblUser
    WHERE LoginName = @username
      AND Password = @password
      AND UserStatus = 'Active'
      AND IsAppsUser = 1
      AND UserRoleID = 32;

    IF (@UserId = 0)
    BEGIN
        SET @LoginMessage = N'Invalid username or password. Please check and try again.';
        SET @islogin = 0;
    END
    ELSE
    BEGIN
        IF (@FirstIMEI IS NULL AND @SecIMEI IS NULL)
        BEGIN
            UPDATE dbo.tblUser
            SET LastAccessTime_1 = GETDATE(),
                AppVer_1 = @AppVersion,
                OS_Version_1 = @OS_Version,
                OS_1 = @OS,
                DeviceInfo_1 = @DeviceInfo,
                IMEI_One = @Imei
            WHERE UserId = @UserId
              AND UserRoleID = 32;

            SET @islogin = 1;
            SET @LoginMessage = N'Login successful. Device registered.';
        END
        ELSE IF (@FirstIMEI IS NOT NULL AND @SecIMEI IS NOT NULL)
        BEGIN
            IF (@FirstIMEI = @Imei OR @SecIMEI = @Imei)
            BEGIN
                SET @islogin = 1;
                SET @LoginMessage = N'Login successful.';
            END
            ELSE
            BEGIN
                SET @islogin = 0;
                SET @LoginMessage = N'This device is not allowed. IMEI does not match your registered devices. Please contact with admin.';
            END
        END
        ELSE IF (@FirstIMEI IS NULL AND @SecIMEI IS NOT NULL)
        BEGIN
            IF (@SecIMEI = @Imei)
            BEGIN
                SET @islogin = 1;
                SET @LoginMessage = N'Login successful.';
            END
            ELSE
            BEGIN
                UPDATE dbo.tblUser
                SET LastAccessTime_1 = GETDATE(),
                    AppVer_1 = @AppVersion,
                    OS_Version_1 = @OS_Version,
                    OS_1 = @OS,
                    DeviceInfo_1 = @DeviceInfo,
                    IMEI_One = @Imei
                WHERE UserId = @UserId;

                SET @islogin = 1;
                SET @LoginMessage = N'Login successful. New device registered.';
            END
        END
        ELSE IF (@FirstIMEI IS NOT NULL AND @SecIMEI IS NULL)
        BEGIN
            IF (@FirstIMEI = @Imei)
            BEGIN
                SET @islogin = 1;
                SET @LoginMessage = N'Login successful.';
            END
            ELSE
            BEGIN
                UPDATE dbo.tblUser
                SET LastAccessTime_2 = GETDATE(),
                    AppVer_2 = @AppVersion,
                    OS_Version_2 = @OS_Version,
                    OS_2 = @OS,
                    DeviceInfo_2 = @DeviceInfo,
                    IMEI_Two = @Imei
                WHERE UserId = @UserId;

                SET @islogin = 1;
                SET @LoginMessage = N'Login successful. Second device registered.';
            END
        END
    END

    IF (@islogin = 0)
    BEGIN
        SET @UserId = 0;
    END

    IF (@islogin = 1 AND (NULLIF(LTRIM(RTRIM(@LoginMessage)), N'') IS NULL))
        SET @LoginMessage = N'Login successful.';

    IF (@islogin = 0 AND (NULLIF(LTRIM(RTRIM(@LoginMessage)), N'') IS NULL))
        SET @LoginMessage = N'Login failed.';

    /* 1st result: message for client apps */
    SELECT @LoginMessage AS Message,
           CAST(@islogin AS BIT) AS IsSuccess,
           @UserId AS EffectiveUserId;

    /* 2nd result: user profile (empty when login failed) */
    SELECT 'Sales ASSISTANCE' AS DesigName,
           B.DACode,
           A.UserId,
           B.Name AS UserName,
           RoleType AS EmpRole,
           A.UserType,
           A.UserCode,
           A.LoginName,
           A.Email,
           A.ContactNo,
           A.CentralWareHouse,
           B.DAId EmpInfoId,
           A.Password,
           A.Password AS UserCo,
           ISNULL(
               (SELECT COUNT(*) FROM dbo.tblUser WHERE IMEI_One = @Imei OR IMEI_Two = @Imei),
               0
           ) AS IsImeiMatched,
           (SELECT TOP 1 VersionName FROM dbo.tbl_AppVersion WHERE IsActive = 1 ORDER BY [Version] DESC) AS VersionName,
           '' AS ShiftStartTime,
           '' AS ShiftEndTime,
           1 AS TrackEnable,
           tblRoleType.RoleTypeId,
           RoleType,
           IsApprove,
           IsForward
    FROM tblUser A
        INNER JOIN dbo.tblDAInfo B
            ON B.DAId = A.daInfoId
        LEFT JOIN dbo.tbl_UserRoleInfo
            ON tbl_UserRoleInfo.UserRoleID = A.UserRoleID
        LEFT JOIN dbo.tblRoleType
            ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId
    WHERE A.UserId = @UserId;
END
