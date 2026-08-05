CREATE PROCEDURE [dbo].[sp_Process_YearlyLeaveBalance] 

	@ProcessBy INT

AS
BEGIN
	
		DECLARE @Count INT
		DECLARE @EmpInfoId INT
		DECLARE @JoiningDate DATETIME

		DECLARE @ServiceLenthInMonth INT = 0
		DECLARE @RemainingMonth INT = 0
		DECLARE @PresentMonth INT = 0
		DECLARE @PerMonth INT = 0

		
		
		DECLARE @StartDate DATETIME 
		DECLARE @EndDate DATETIME 
        
		--------------------------------------------------------
		DECLARE @MyCursor CURSOR
		SET @MyCursor = CURSOR FAST_FORWARD
		FOR
		---------------

		SELECT EmpInfoId,JoiningDate FROM tblEmpGeneralInfo
		WHERE EmployeeStatus = 'Active' 
		   --and CONVERT(date, JoiningDate)>= CONVERT(date,'2023-04-02 00:00:00.000')
		--AND EmpInfoId NOT IN (SELECT DISTINCT EmployeeInfoId FROM Employee_YearlyLeaveBalance WHERE FiscalYear = YEAR(GETDATE()))
	
		----------

		OPEN @MyCursor
		FETCH NEXT FROM @MyCursor
		INTO @EmpInfoId,@JoiningDate

		WHILE @@FETCH_STATUS = 0
		BEGIN
		SELECT @StartDate =  DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		 SELECT @EndDate = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)
		 --SELECT @ServiceLenthInMonth = DATEDIFF(month,@JoiningDate, GETDATE());
		 SELECT @ServiceLenthInMonth = DATEDIFF(month,@JoiningDate, @EndDate)+1;
		 


		-- Second Cursor

		DECLARE @LeaveTypeId INT
		DECLARE @LeaveConfigId INT
		DECLARE @LeaveTypeName NVARCHAR(500)
		DECLARE @LeaveDays DECIMAL(18,2)
		DECLARE @TotalYears INT = 0
		DECLARE @LeaveBalanceId INT = 0
		        
		--------------------------------------------------------
		DECLARE @MyCursor2 CURSOR
		SET @MyCursor2 = CURSOR FAST_FORWARD
		FOR
		---------------[dbo].[Employe_LeaveTypeInfos]
		
		--SELECT LeaveTypeId,LeaveTypeName,LeaveDays FROM Employe_LeaveTypeInfos WHERE IsActive = 1


		SELECT  LeaveConfigId, LeaveTypeId, LeaveName   LeaveTypeName, 0 LeaveDays FROM tblLeaveConfig WHERE IsActive = 1
			--[dbo].[tblLeaveConfigCountDtl]
		----------
		OPEN @MyCursor2
		FETCH NEXT FROM @MyCursor2
		INTO  @LeaveConfigId,@LeaveTypeId,@LeaveTypeName,@LeaveDays
		
		WHILE @@FETCH_STATUS = 0
		BEGIN

		


		DECLARE @LeaveRatio DECIMAL(18,2)=CONVERT(DECIMAL(18,2),@ServiceLenthInMonth)
	declare @cc int=0
		select  @cc=ISNULL(COUNT(*),0)   from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=4 and LeaveConfigId=@LeaveConfigId

		if(@cc>0)
		begin
		select  @LeaveDays=ISNULL(DaysPerMonthly,0)   from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=4 and LeaveConfigId=@LeaveConfigId
		SET @LeaveRatio=12
		end
		
		else 
		begin

		IF(@ServiceLenthInMonth>=36)
		BEGIN
		select  @LeaveDays=ISNULL(DaysPerMonthly,0)   from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=1 and LeaveConfigId=@LeaveConfigId
		SET @LeaveRatio=12

		END 

		ELSE IF(@ServiceLenthInMonth<=36 and @ServiceLenthInMonth>=12)
		BEGIN
		select @LeaveDays=ISNULL(DaysPerMonthly,0)    from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=2 and LeaveConfigId=@LeaveConfigId
		SET @LeaveRatio=12

		END 

		--ELSE IF(@ServiceLenthInMonth<12 )
		--BEGIN

		--IF(DAY(@JoiningDate)>15)
		--	BEGIN
		--select ISNULL(DaysPerMonthly,0) DaysPerMonthly  from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=2 and LeaveConfigId=@LeaveConfigId
		--SET @LeaveRatio=12

		--END 
		--END 

		ELSE
        BEGIN
            IF(DAY(@JoiningDate)>=15)
			BEGIN
			select @LeaveDays=ISNULL(DaysPerMonthly,0)    from  [dbo].[tblLeaveConfigCountDtl]  where JoiningDateCountId=3 and LeaveConfigId=@LeaveConfigId
			    SET @LeaveRatio=@LeaveRatio-1
			END
        END
		end
		--DECLARE @LeavePerMonth DECIMAL(18,2)
		--SET @LeavePerMonth=CONVERT(DECIMAL(18,2),@LeaveDays)/12

		SET @LeaveDays=CONVERT(DECIMAL(18,2),(@LeaveRatio*@LeaveDays))

		--SET @TotalYears = 0
		--SET @TotalYears = @ServiceLenthInMonth/12;

		--IF(@LeaveDays < 12)
		--	BEGIN
		--		SET @PerMonth = 12/@LeaveDays;
		--	END
		--ELSE
		--	BEGIN
		--		SET @PerMonth = @LeaveDays/12;
		--	END


		--SELECT @PresentMonth =  MONTH(GETDATE());
		--SET @RemainingMonth = 12 - @PresentMonth;

		--IF(@RemainingMonth < 12 AND @RemainingMonth > 1)
		--BEGIN
		--	SET @LeaveDays = ROUND((@RemainingMonth * @PerMonth), 2)
		--END


		DECLARE @IsSave BIT=1
		DECLARE @IsProbation BIT
        SELECT @IsProbation=IsProbition FROM dbo.tblEmpGeneralInfo WHERE EmpInfoId=@EmpInfoId
		IF(@LeaveTypeId='4' )
		BEGIN
		IF(@IsProbation='1')
		BEGIN
		    SET @IsSave=0
		END
		END

		DECLARE @IsExist BIT=0
		DECLARE @CountData INT
		SELECT @CountData=COUNT(*) FROM dbo.Employee_YearlyLeaveBalance WHERE FiscalYear=YEAR(GETDATE()) AND EmployeeInfoId=@EmpInfoId
		AND LeaveTypeId=@LeaveTypeId

		DECLARE @annualQty INT=0
		SELECT @annualQty=ISNULL(YearlyLeaveBalance,0) FROM dbo.Employee_YearlyLeaveBalance WHERE FiscalYear=YEAR(GETDATE())-1 AND EmployeeInfoId=@EmpInfoId AND LeaveTypeId='3'
		SET @annualQty=ISNULL(@annualQty,0)
		SET @LeaveDays=@LeaveDays+@annualQty
		--T RUNCATE TABLE Employee_YearlyLeaveBalance
		IF(@IsSave=1 AND @CountData=0)
		begin
		INSERT INTO Employee_YearlyLeaveBalance
           (FiscalYear
           ,EmployeeInfoId
           ,LeaveTypeId
           ,YearlyLeaveBalance,YearlyLeaveQty
           ,Remarks
           ,EntryBy
           ,EntryDate,
		   IsActive)
		VALUES
           (YEAR(GETDATE()),
		   @EmpInfoId,
		   @LeaveTypeId,
		   @LeaveDays,@LeaveDays,
		   @ProcessBy,
		   1
           ,GETDATE()
		   ,1)

		   SET @Count = @Count + 1

		   SELECT @LeaveBalanceId = SCOPE_IDENTITY()

		   -- Insert Into transcation Table

		   INSERT INTO Employee_YearlyLeaveTranscations
           (TranscationDate
           ,LeaveDays
		   ,LeaveBalanceId)
		VALUES
           (GETDATE()
           ,@LeaveDays
		   ,@LeaveBalanceId)
		
		END
		
		FETCH NEXT FROM @MyCursor2
		INTO @LeaveConfigId, @LeaveTypeId,@LeaveTypeName,@LeaveDays
		
		END
		CLOSE @MyCursor2
		DEALLOCATE @MyCursor2

	

		FETCH NEXT FROM @MyCursor
		INTO @EmpInfoId,@JoiningDate

		END
		CLOSE @MyCursor
		DEALLOCATE @MyCursor

END



--SELECT LEFT(DATENAME(WEEKDAY,'2020-09-1 00:00:00.000'),3) 

