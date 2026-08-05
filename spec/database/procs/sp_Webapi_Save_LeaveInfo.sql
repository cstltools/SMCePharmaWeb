-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_LeaveInfo]
	-- Add the parameters for the stored procedure here
    @leaveAppId INT = 0 ,
    @typeId INT = NULL ,
    @startDate DATETIME = NULL ,
    @endDate DATETIME = NULL ,
    @reason NVARCHAR(MAX) = NULL ,
    @empId INT = NULL,
    @DateOfReturnsToDuty DATETIME = NULL ,
    @LeaveAddress NVARCHAR(MAX) = NULL ,
    @EmergencyContactNo NVARCHAR(MAX) = NULL ,
    @Comments NVARCHAR(MAX) = NULL  

AS
    BEGIN



	DECLARE @mioId INT,@shiftId int,@UserRoleID int

SELECT @mioId = MIOId FROM dbo.tblMIOInfo WHERE EmployeeId = @empId

DECLARE @Role NVARCHAR(MAX)
SELECT @Role=usR.RoleName ,@UserRoleID= us.UserRoleID 
FROM dbo.tblEmpGeneralInfo  emp
left join  tblUser us on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo usR on usR.UserRoleID=us.UserRoleID
 
 WHERE emp.EmpInfoId=@empId



        DECLARE @totalDays INT ,
            @userId INT ,
            @appStatus NVARCHAR(50)

        SELECT  @appStatus = ActionText
        FROM    dbo.tblAction
        WHERE   ActionId = 1

        SELECT  @userId = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId
        SELECT  @totalDays = ( DATEDIFF(DAY, @startDate, @endDate) + 1 )



		DECLARE @HolidayCount INT

		SELECT @HolidayCount=COUNT(*) FROM dbo.Employee_GovtHolidays WHERE HolidayDate BETWEEN @startDate AND @endDate

		DECLARE @LeaveTypeId INT
		--DECLARE @IsHoliday BIT
        
		SELECT @LeaveTypeId=LeaveTypeId  FROM dbo.Employee_YearlyLeaveBalance WHERE LeaveBalanceId=@typeId

		IF(@LeaveTypeId=1)
		BEGIN


		    SET @totalDays=@totalDays-@HolidayCount
		END

		declare @dd decimal(18,2)
		select  @dd= cast( SUM(A.YearlyLeaveBalance) as decimal(18,2)) 
FROM    dbo.Employee_YearlyLeaveBalance A  WHERE A.EmployeeInfoId = @empId AND A.FiscalYear = year(getdate()) and  LeaveTypeId=@LeaveTypeId 

IF(@LeaveTypeId=1)
		BEGIN
Select

		@dd= cast(  case when isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) +isnull(tblAccMu.AccumulateLeave,0) >=90 then 90 else isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) end as int)    from  tblEmpGeneralInfo PM with (nolock)
		 --+isnull(tblAccMu.AccumulateLeave,0)
		  left join (select SUM(mas.YearlyLeaveBalance) PreviousLeave, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 where LeaveTypeId=3 and 
    FiscalYear=  ( cast( year(getdate()) as int)-1)     group by  mas.EmployeeInfoId) tblPre on  PM.EmpInfoId=tblPre.EmployeeInfoId

	 

	 left join (select SUM(mas.YearlyLeaveQty) Annual, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=1    group by  mas.EmployeeInfoId)tblAnnual on  PM.EmpInfoId=tblAnnual.EmployeeInfoId

	    left join (select [EmpId], SUM( [AccumulateLeave]) AccumulateLeave  from  [dbo].[tblLeaveEncashBlnc] where YearVal= year(getdate())  group by [EmpId] )tblAccMu on  tblAccMu.EmpId=PM.EmpInfoId
 
 
  where    PM.EmpInfoId=@empId  and isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) +isnull(tblAccMu.AccumulateLeave,0)>0

  end

-- select  @dd= cast( SUM(A.LeaveDays) as decimal(18,2)) 
--FROM   Employee_YearlyLeaveTranscations A 
--	LEFT JOIN Employee_YearlyLeaveBalance AS LVB ON A.LeaveBalanceId = LVB.LeaveBalanceId
--	LEFT JOIN tblLeaveConType AS LVTYP ON LVB.LeaveTypeId = LVTYP.LeaveConTypeId
-- WHERE LVB.EmployeeInfoId = @empId AND YEAR(A.TranscationDate) = year(getdate()) and  LeaveTypeId=@LeaveTypeId   
      --  IF ( @leaveAppId > 0 )
      --      BEGIN
			
      --          UPDATE  dbo.Employee_LeaveApplications
      --          SET     LeaveBalanceId = @typeId ,
      --                  LeaveFromDate = @startDate ,
      --                  LeaveToDate = @endDate ,
      --                  Days = @totalDays ,
      --                  UpdateBy = @userId ,
      --                  UpdateDate = GETDATE(),
						--Reason = @reason,DateOfReturnsToDuty=@DateOfReturnsToDuty,LeaveAddress=@LeaveAddress,  EmergencyContactNo=@EmergencyContactNo, Comments=@Comments
      --          WHERE   LeaveApplicationId = @leaveAppId



      --      END
      --  ELSE
            --BEGIN

			 if(  @dd>=@totalDays)
			begin
			DECLARE @CountLeavePending INT
			SELECT @CountLeavePending=COUNT(*) FROM dbo.Employee_LeaveApplications WHERE EmployeeId=@empId AND LeaveBalanceId=@typeId AND (ApprovalStatus IN ('0','1','Pending'))
			IF(@CountLeavePending<1)
			BEGIN
                INSERT  INTO dbo.Employee_LeaveApplications
                        ( EmployeeId ,
                          LeaveBalanceId ,
                          LeaveFromDate ,
                          LeaveToDate ,
                          Days ,
                          EntryBy ,
                          EntryDate ,
                          Reason ,
                          ApprovalStatus,DateOfReturnsToDuty,LeaveAddress,EmergencyContactNo,Remarks
		                )
                VALUES  ( @empId ,
                          @typeId ,
                          @startDate ,
                          @endDate ,
                          @totalDays ,
                          @userId ,
                          GETDATE() ,
                          @reason ,
                          0,@DateOfReturnsToDuty,@LeaveAddress,@EmergencyContactNo,@Comments
		                )

						select @leaveAppId=SCOPE_IDENTITY()
            DECLARE @ToEmpId INT
DECLARE @GroupId INT
DECLARE @RegionId INT
DECLARE @AreaId INT
DECLARE @TerrId INT
DECLARE @MarketId INT

DECLARE @EntryTime TIME(7)=cast(GETDATE() as time)
--SELECT * FROM dbo.View_webapi_FieldForce
--LEFT JOIN dbo.tblMIOInfo ON 

IF(@Role='MIO')
BEGIN
    SELECT @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE MIOEmpId=@empId
END
IF(@Role='ASM')
BEGIN
SELECT   @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE ASMEMPId=@empId
END
IF(@Role='RSM')
BEGIN
    SELECT  @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE RSMEMPId=@empId
END
IF(@Role='NSM')
BEGIN
    SELECT  @GroupId=GroupId,@AreaId=AreaId,@TerrId=TerritoryId,@RegionId=RegionId FROM dbo.View_webapi_FieldForce WHERE NSMEMPId=@empId
END

 

declare @datess datetime
set @datess=GETDATE()
EXECUTE dbo.sp_webapi_SaveLeaveAppLog @LeaveApprovalId = 0,                         -- int
                                 @Date =@datess,           -- datetime
                                 @FromEmpId = @empId,                          -- int
                                 @ToEmpId = 0,                            -- int
                                 @TableId = @leaveAppId,                            -- int
                                 @Status = N'Posted',                           -- nvarchar(max)
                                 @Comments = N'',                         -- nvarchar(max)
                                 @Type = N'Leave',                             -- nvarchar(max)
                                 @Step = 1,                               -- int
                                 @GroupId = @GroupId,                            -- int
                                 @RegionId = @RegionId,                           -- int
                                 @AreaId = @AreaId,                             -- int
                                 @TerritoryId = @TerrId,                        -- int
                                 @ToGroupId = 0,                          -- int
                                 @ToRegionId = 0,                         -- int
                                 @ToAreaId = 0,                           -- int
                                 @ToTerritoryId = 0,                      -- int
                                 @EntryByS = @empId,                         -- nvarchar(max)
                                 @EntryDateS = @datess,     -- datetime
                                 @EntryTimeS = @EntryTime,                -- time(7)
                                 @ApproveByS = NULL,                       -- nvarchar(max)
                                 @ApproveDateS = NULL,   -- datetime
                                 @ApproveTimeS = NULL,              -- time(7)
                                 @EntryByApp = @empId,                       -- nvarchar(max)
                                 @EntryDateApp = @datess,   -- datetime
                                 @EntryTimeApp = @datess,              -- time(7)
                                 @ApproveByApp = NULL,                     -- nvarchar(max)
                                 @ApproveDateApp = NULL, -- datetime
                                 @ApproveTimeApp = NULL,            -- time(7)
                                 @MenuId = 1378                              -- int

							


		
		select @leaveAppId

    END
	END
	END

