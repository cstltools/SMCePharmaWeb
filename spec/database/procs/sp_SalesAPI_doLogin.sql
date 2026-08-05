CREATE PROCEDURE [dbo].[sp_SalesAPI_doLogin]
    @username NVARCHAR(50) ,
    @password NVARCHAR(50),
	@Imei NVARCHAR(max)
AS
    BEGIN

	DECLARE @islogin BIT=0

	DECLARE @UserId INT=0
	DECLARE @FirstIMEI NVARCHAR(MAX)=NULL
	DECLARE @SecIMEI NVARCHAR(MAX)=NULL
	SELECT @UserId=ISNULL(UserId,0),@FirstIMEI=IMEI_One,@SecIMEI=IMEI_Two FROM dbo.tblUser WHERE LoginName=@username AND Password=@password AND UserStatus = 'Active'

	IF(@FirstIMEI IS NULL AND @SecIMEI IS NULL)
	BEGIN
	    
		UPDATE dbo.tblUser SET IMEI_One=@Imei WHERE UserId=@UserId
		SET @islogin=1
	END
	ELSE IF(@FirstIMEI IS NOT NULL AND @SecIMEI IS NOT NULL)
	BEGIN
	    IF(@FirstIMEI=@Imei OR @SecIMEI=@Imei)
		BEGIN
		    SET @islogin=1
		END
		ELSE
        BEGIN
            SET @islogin=0
        END

	END
	ELSE IF(@FirstIMEI IS NULL AND  @SecIMEI IS NOT NULL)
	BEGIN
	    IF(@SecIMEI=@Imei)
		BEGIN
		    SET @islogin=1
		END
		ELSE
        BEGIN
            UPDATE dbo.tblUser SET IMEI_One=@Imei WHERE UserId=@UserId
			SET @islogin=1
        END
	END
	ELSE IF(@FirstIMEI IS NOT NULL AND  @SecIMEI IS NULL)
	BEGIN
	    IF(@FirstIMEI=@Imei)
		BEGIN
		    SET @islogin=1
		END
		ELSE
        BEGIN
            UPDATE dbo.tblUser SET IMEI_Two=@Imei WHERE UserId=@UserId
			SET @islogin=1
        END
	END
	
	IF(@islogin=0)
	BEGIN
	    SET @UserId=0
	END

  	        SELECT dgs.DesigName, B.EmpMasterCode, A.UserId ,
                B.EmpName AS UserName ,
				RoleType as EmpRole,
                A.UserType ,
                A.UserCode ,
                A.LoginName ,
                A.Email ,
                A.ContactNo ,
                A.CentralWareHouse ,
                A.EmpInfoId , A.Password,
                A.Password AS UserCo,
				ISNULL((SELECT COUNT(*) AS Dsas FROM dbo.tblUser WHERE IMEI_One = @Imei OR IMEI_Two = @Imei),0)AS IsImeiMatched,
				(SELECT TOP 1 VersionName FROM dbo.tbl_AppVersion WHERE IsActive = 1 ORDER BY Version DESC) AS VersionName,
				shft.ShiftInTime AS ShiftStartTime,
				shft.ShiftOutTime AS ShiftEndTime,
				1 AS TrackEnable,tblRoleType.RoleTypeId,RoleType,IsApprove,IsForward



        FROM    tblUser A
                INNER JOIN dbo.tblEmpGeneralInfo B ON B.EmpInfoId = A.EmpInfoId
				LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = A.UserRoleID
				LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tbl_UserRoleInfo.RoleTypeId
                INNER JOIN dbo.tbl_Shift shft ON B.ShiftId = shft.ShiftId
               left JOIN dbo.tblDesignation dgs ON B.DesignationId = dgs.DesignationId

        --WHERE   A.LoginName = @username
        --        AND A.Password = @password
        --        AND A.UserStatus = 'Active'

		WHERE
        A.UserId=@UserId
	

    END