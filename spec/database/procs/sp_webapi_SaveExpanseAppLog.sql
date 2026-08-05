

CREATE PROCEDURE [dbo].[sp_webapi_SaveExpanseAppLog]  --[dbo].[sp_webapi_SaveOrderMaster] 'shaon20','20245','11/25/2020 5:04:16 PM'
    @ExpanseApprovalId INT ,
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


	DECLARE @ExDate DATETIME
	DECLARE @Todate DATETIME=CONVERT(DATE,GETDATE())
	SELECT @ExDate= CONVERT(DATE,EntryDate)  FROM dbo.tbl_ExpenseClaim WHERE ExpenseClaimID=@TableId

	DECLARE @day INT=0

	if(@FromEmpId<>330)
		BEGIN
	SELECT @day=DATEDIFF(DAY,@ExDate,@Todate)
	end
	IF(@day<=7)
	BEGIN




	DECLARE @Countdata INT=0
		if(@FromEmpId<>330)
		BEGIN
	SELECT @Countdata=COUNT(*) FROM dbo.tblExpanseApprovalLog WHERE FromEmpId=@FromEmpId AND TableId=@TableId
		end

	IF(@Countdata <1)
	BEGIN

	DECLARE @FinalStep INT
	SELECT @FinalStep=Steps FROM dbo.tblApprovalStepMaster WHERE SL=@MenuId

	DECLARE @StepTemp INT=0
	SET @StepTemp=@Step

	DECLARE @MapRoleTypeId INT
	SELECT @MapRoleTypeId=RoleTypeId FROM dbo.tbl_ExpenseClaim
	LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tbl_ExpenseClaim.EmpInfoId
	LEFT JOIN dbo.tblUser ON tblUser.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
	LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	WHERE dbo.tbl_ExpenseClaim.ExpenseClaimID=@TableId

	DECLARE @CurrentRoleTypeId INT=@MapRoleTypeId
	DECLARE @CurrentStep INT=1
	SELECT TOP 1 @CurrentRoleTypeId=ToRoleTypeId FROM dbo.tblExpanseApprovalLog WHERE TableId=@TableId ORDER BY ExpanseApprovalId DESC
	IF(@CurrentRoleTypeId IS NULL)
	BEGIN
	    SET @CurrentRoleTypeId=@MapRoleTypeId
	END

	


	DECLARE @NextRoleTypeId INT=NULL
	SELECT TOP 1 @NextRoleTypeId=ToRoleId FROM dbo.tblApprovalMapMaster
	LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId
	WHERE MenuId=@MenuId AND FromRoleId=@MapRoleTypeId  AND [Order]>@Step
	ORDER BY [Order] ASC

    
		
	IF(@NextRoleTypeId IS NULL AND @Status<>'Rejected')
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



	SELECT @GroupId=EmpGroupId,@RegionId=EmpRegionId,@AreaId=EmpAreaId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@FromEmpId

	IF(@Status='Accepted')
	BEGIN
	    UPDATE dbo.tbl_ExpenseClaim SET ApprovalStatus='2' WHERE ExpenseClaimID=@TableId
	END
	IF(@Status='Verified')
	BEGIN
	    UPDATE dbo.tbl_ExpenseClaim SET ApprovalStatus='1' WHERE ExpenseClaimID=@TableId
	END
	IF(@Status='Rejected')
	BEGIN
	    UPDATE dbo.tbl_ExpenseClaim SET ApprovalStatus='3' WHERE ExpenseClaimID=@TableId
	END
	--DECLARE @RoleTypeIds INT=0

	--SELECT TOP 1 @RoleTypeIds=ToRoleTypeId FROM dbo.tblExpanseApprovalLog WHERE TableId=@TableId ORDER BY Step DESC
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



    INSERT INTO dbo.tblExpanseApprovalLog
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
        getdate(),
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

		SELECT @ExpanseApprovalId=SCOPE_IDENTITY()
		SELECT @ExpanseApprovalId
    END

	 END 

	END