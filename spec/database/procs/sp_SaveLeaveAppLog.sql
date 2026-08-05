
CREATE PROCEDURE [dbo].[sp_SaveLeaveAppLog]  --[dbo].[sp_webapi_SaveOrderMaster] 'shaon20','20245','11/25/2020 5:04:16 PM'
    @LeaveApprovalId INT ,
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



	 

	BEGIN


	DECLARE @FinalStep INT
	SELECT @FinalStep=Steps FROM dbo.tblApprovalStepMaster WHERE SL=@MenuId

	DECLARE @StepTemp INT=0
	SET @StepTemp=@Step

	DECLARE @MapRoleTypeId INT
	SELECT @MapRoleTypeId=RoleTypeId FROM dbo.Employee_LeaveApplications
	LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = Employee_LeaveApplications.EmployeeId
	LEFT JOIN dbo.tblUser ON tblUser.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
	LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
	WHERE dbo.Employee_LeaveApplications.LeaveApplicationId=@TableId

	DECLARE @CurrentRoleTypeId INT=@MapRoleTypeId
	DECLARE @CurrentStep INT=1
	SELECT TOP 1 @CurrentRoleTypeId=ToRoleTypeId FROM dbo.tblLeaveApprovalLog WHERE TableId=@TableId ORDER BY LeaveApprovalId DESC
	IF(@CurrentRoleTypeId IS NULL)
	BEGIN
	    SET @CurrentRoleTypeId=@MapRoleTypeId
	END

	
	


	DECLARE @NextRoleTypeId INT=NULL
	SELECT TOP 1 @NextRoleTypeId=ToRoleId FROM dbo.tblApprovalMapMaster
	LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId
	WHERE MenuId=@MenuId AND FromRoleId=@MapRoleTypeId  AND [Order]>@Step
	ORDER BY [Order] ASC
	DECLARE @Countdata INT=0
	SELECT @Countdata=COUNT(*) FROM dbo.tblLeaveApprovalLog WHERE FromEmpId=@FromEmpId AND TableId=@TableId and ToRoleTypeId=@NextRoleTypeId
   



	IF(@NextRoleTypeId IS NULL AND @Status<>'Rejected')
	BEGIN
	    SET @Status='Accepted'
		SET @NextRoleTypeId=0
	END


		DECLARE @DADate DATETIME
	DECLARE @Todate DATETIME=CONVERT(DATE,GETDATE())
	SELECT @DADate =CONVERT(DATE,EntryDate) FROM dbo.Employee_LeaveApplications WHERE LeaveApplicationId=@TableId

	DECLARE @day INT
	SELECT @day=DATEDIFF(DAY,@DADate,@Todate)
	 
	-- IF(@day<=7)
	--BEGIN


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
		DECLARE @BalanceId INT
		DECLARE @Qty INT
		DECLARE @EmpInfoIdL INT 


	SELECT @GroupId=EmpGroupId,@RegionId=EmpRegionId,@AreaId=EmpAreaId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@FromEmpId


	--DECLARE @RoleTypeIds INT=0

	--SELECT TOP 1 @RoleTypeIds=ToRoleTypeId FROM dbo.tblLeaveApprovalLog WHERE TableId=@TableId ORDER BY Step DESC
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
	IF(@Status='Accepted')
	BEGIN
	--DECLARE @appCount INT=0
	--select @appCount=ISNULL(count(*),0) from Employee_LeaveApplications WHERE LeaveApplicationId=@TableId and ApprovalStatus='2'
	--if(@appCount=0)
	--begin
	    UPDATE dbo.Employee_LeaveApplications SET ApprovalStatus='2' WHERE LeaveApplicationId=@TableId

	

		SELECT @BalanceId=LeaveBalanceId,@Qty=Days,@EmpInfoIdL=EmployeeId FROM dbo.Employee_LeaveApplications
		
		 WHERE LeaveApplicationId=@TableId

		 UPDATE dbo.Employee_YearlyLeaveBalance SET YearlyLeaveBalance=YearlyLeaveBalance-@Qty WHERE LeaveTypeId=@BalanceId AND EmployeeInfoId=@EmpInfoIdL AND FiscalYear=YEAR(GETDATE())


		 INSERT INTO [dbo].[tblLeaveOperation]
           ([EmpId]
           ,[LeaveTypeId]
           ,[DayValue]
           ,[MonthVal]
           ,[YearVal])
     VALUES
           (@EmpInfoIdL 
           ,@BalanceId
           ,   -@Qty   
           ,MONTH(GETDATE())
           ,YEAR(GETDATE()))


	--END
	END
	IF(@Status='Verified')
	BEGIN
	    UPDATE dbo.Employee_LeaveApplications SET ApprovalStatus='1' WHERE LeaveApplicationId=@TableId
	END

	IF(@Status='Rejected')
	BEGIN

	DECLARE @ReCount INT=0
	select @ReCount=ISNULL(count(*),0) from Employee_LeaveApplications WHERE LeaveApplicationId=@TableId and ApprovalStatus='2'
	if(@ReCount>0)
	begin
	    UPDATE dbo.Employee_LeaveApplications SET ApprovalStatus='3' WHERE LeaveApplicationId=@TableId


		 

		SELECT @BalanceId=LeaveBalanceId,@Qty=Days,@EmpInfoIdL=EmployeeId FROM dbo.Employee_LeaveApplications
		
		 WHERE LeaveApplicationId=@TableId

		 UPDATE dbo.Employee_YearlyLeaveBalance SET YearlyLeaveBalance=YearlyLeaveBalance+@Qty WHERE LeaveTypeId=@BalanceId AND EmployeeInfoId=@EmpInfoIdL AND FiscalYear=YEAR(GETDATE())


	END
	else
	begin
	 UPDATE dbo.Employee_LeaveApplications SET ApprovalStatus='3' WHERE LeaveApplicationId=@TableId

	end
	END
    INSERT INTO dbo.tblLeaveApprovalLog
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

	 
		 set @LeaveApprovalId=SCOPE_IDENTITY()
		  SELECT @LeaveApprovalId

    --END

	 
	END
	END
