



CREATE PROCEDURE [dbo].[sp_webapi_SaveOrderAppLog]  --[dbo].[sp_webapi_SaveOrderMaster] 'shaon20','20245','11/25/2020 5:04:16 PM'
    @OrderApprovalId INT ,
	--comuitid IS actually comanyId
    @Date DATETIME NULL,
        @FromEmpId INT NULL,
        @ToEmpId INT NULL,
        @TableId INT NULL,
        @Status NVARCHAR(MAX) NULL,
        @Comments NVARCHAR(MAX) NULL,
        @Type NVARCHAR(MAX) NULL,
        @Step INT NULL,
        @GroupId INT NULL,
        @RegionId INT NULL,
        @AreaId INT NULL,
        @TerritoryId INT NULL,
        @ToGroupId INT NULL,
        @ToRegionId INT NULL,
        @ToAreaId INT NULL,
        @ToTerritoryId INT NULL,
        @EntryByS NVARCHAR(MAX) NULL,
       @EntryDateS DATETIME NULL,
        @EntryTimeS TIME(7) NULL
		,
        @ApproveByS NVARCHAR(MAX) NULL,
        @ApproveDateS DATETIME NULL,
        @ApproveTimeS TIME(7) NULL,
        @EntryByApp NVARCHAR(MAX) NULL,
       @EntryDateApp DATETIME NULL,
       @EntryTimeApp TIME(7) NULL,
        @ApproveByApp NVARCHAR(MAX) NULL,
        @ApproveDateApp DATETIME NULL,
        @ApproveTimeApp TIME(7) NULL,@MenuId INT NULL
AS
    BEGIN
	DECLARE @Countdata INT=0
	SELECT @Countdata=COUNT(*) FROM dbo.tblOrderApprovalLog WHERE FromEmpId=@FromEmpId AND TableId=@TableId
	

	IF(@Countdata <1)
	BEGIN
	DECLARE @FinalStep INT
	SELECT @FinalStep=Steps FROM dbo.tblApprovalStepMaster WHERE SL=@MenuId

	DECLARE @StepTemp INT=0
	SET @StepTemp=@Step

	DECLARE @MapRoleTypeId INT
	SELECT @MapRoleTypeId=RoleTypeId FROM dbo.tblOrder
	--LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblOrder.EmpInfoId
	LEFT JOIN dbo.tblUser ON tblUser.UserId = dbo.tblOrder.EntryBy
	LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	WHERE dbo.tblOrder.OrderId=@TableId

	DECLARE @CurrentRoleTypeId INT=@MapRoleTypeId
	DECLARE @CurrentStep INT=1
	SELECT TOP 1 @CurrentRoleTypeId=ToRoleTypeId FROM dbo.tblOrderApprovalLog WHERE TableId=@TableId ORDER BY OrderApprovalId DESC
	IF(@CurrentRoleTypeId IS NULL)
	BEGIN
	    SET @CurrentRoleTypeId=@MapRoleTypeId
	END

	


	DECLARE @NextRoleTypeId INT=NULL
	SELECT TOP 1 @NextRoleTypeId=ToRoleId FROM dbo.tblApprovalMapMaster
	LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId
	WHERE MenuId=@MenuId AND FromRoleId=@MapRoleTypeId  AND [Order]>@Step
	ORDER BY [Order] ASC

    
	
	IF((@NextRoleTypeId IS NULL OR @Status='Accepted') AND @Status<>'Rejected')
	BEGIN
	    SET @Status='Accepted'
	END
	

	--IF(NOT EXISTS(SELECT * FROM dbo.tblASMInfo WHERE AreaId=@AreaId AND EmployeeId<>1))
	--BEGIN
	--    SET @StepTemp=@StepTemp+1
	--END
	--IF(NOT EXISTS(SELECT * FROM dbo.tblRSMInfo WHERE RegionId=@RegionId AND EmployeeId<>1))
	--BEGIN
	--    SET @StepTemp=@StepTemp+1
	--END
	--IF(NOT EXISTS(SELECT * FROM dbo.tblNSMInfo WHERE GroupId=@GroupId AND EmployeeId<>1))
	--BEGIN
	--    SET @StepTemp=@StepTemp+1
	--END
	

	--DECLARE @RoleTypeId INT
	--SELECT @RoleTypeId=RoleTypeId FROM dbo.tblEmpGeneralInfo
	--LEFT JOIN dbo.tblUser ON tblUser.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
	--LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	--WHERE tblEmpGeneralInfo.EmpInfoId=@FromEmpId


	--DECLARE @ToRoleTypeId INT 
	--SELECT TOP 1 @ToRoleTypeId=CONVERT(INT,RoleName) FROM dbo.tblApprovalStepMaster
	--LEFT JOIN dbo.tblApprovalStepsNew ON dbo.tblApprovalStepMaster.AppMasterId=dbo.tblApprovalStepsNew.ApprovalStepMasterId
	--WHERE tblApprovalStepMaster.SL=@MenuId AND StepOrder>@RoleTypeId ORDER BY StepOrder ASC

	--SELECT * FROM dbo.tblApprovalMapMaster
	--LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId

	SET @EntryDateS=GETDATE()
	SET @EntryTimeS=CONVERT(TIME(7),GETDATE())

	SELECT @GroupId=EmpGroupId,@RegionId=EmpRegionId,@AreaId=EmpAreaId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@FromEmpId

	DECLARE @MainStatus NVARCHAR(MAX)=NULL


	IF(@Status='Accepted')
	BEGIN
	
	    UPDATE dbo.tblOrder SET  ActionStatus='2' WHERE OrderId=@TableId

	--	declare @OrderCode nvarchar(max)
	--select @OrderCode=MAX(ISNULL(OrderCode,1000))+1 from tblOrder where  ActionStatus='2'

	--UPDATE dbo.tblOrder SET OrderCode=@OrderCode  WHERE OrderId=@TableId
	END
	IF(@Status='Verified')
	BEGIN
	    UPDATE dbo.tblOrder SET ActionStatus='1' WHERE OrderId=@TableId
	END
	IF(@Status='Posted')
	BEGIN
	    UPDATE dbo.tblOrder SET ActionStatus='0' WHERE OrderId=@TableId
	END
	IF(@Status='Rejected')
	BEGIN
	    UPDATE dbo.tblOrder SET ActionStatus='3' WHERE OrderId=@TableId
	END

	--DECLARE @RoleTypeIds INT=0

	--SELECT TOP 1 @RoleTypeIds=ToRoleTypeId FROM dbo.tblOrderApprovalLog WHERE TableId=@TableId ORDER BY Step DESC
	--IF(@RoleTypeIds IS NOT NULL)
	--BEGIN
	--	IF(@RoleTypeIds<>@RoleTypeId)
	--	BEGIN
	--		SET @StepTemp=@StepTemp+1
	--	END    
	--END
	
	
	--IF(@StepTemp=@FinalStep)
	--BEGIN
	--    SET @Status='Accepted'
	--END



    INSERT INTO dbo.tblOrderApprovalLog
    (
        
        Date,
        FromEmpId,
        ToEmpId,
        TableId,
        Status,
        Comments,
        Type,
        Step,
        GroupId,
        RegionId,
        AreaId,
        TerritoryId,
        ToGroupId,
        ToRegionId,
        ToAreaId,
        ToTerritoryId,
        EntryByS,
        EntryDateS,
        EntryTimeS,
        ApproveByS,
        ApproveDateS,
        ApproveTimeS,
        EntryByApp,
        EntryDateApp,
        EntryTimeApp,
        ApproveByApp,
        ApproveDateApp,
        ApproveTimeApp,RoleTypeId,ToRoleTypeId
    )
    VALUES
    (   
        @Date,
        @FromEmpId,
        @ToEmpId,
        @TableId,
        @Status,
        @Comments,
        @Type,
        @StepTemp,
        @GroupId,
        @RegionId,
        @AreaId,
        @TerritoryId,
        @ToGroupId,
        @ToRegionId,
        @ToAreaId,
        @ToTerritoryId,
        @EntryByS,
       @EntryDateS,
        @EntryTimeS,
        @ApproveByS,
        @ApproveDateS,
        @ApproveTimeS,
        @EntryByApp,
       @EntryDateApp,
       @EntryTimeApp,
        @ApproveByApp,
        @ApproveDateApp,
        @ApproveTimeApp,@CurrentRoleTypeId,@NextRoleTypeId
        )

		SELECT @OrderApprovalId=SCOPE_IDENTITY()

    END
	END
    


