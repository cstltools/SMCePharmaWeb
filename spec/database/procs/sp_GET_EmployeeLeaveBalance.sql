
CREATE PROCEDURE [dbo].[sp_GET_EmployeeLeaveBalance]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN


	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT EYLVB.LeaveBalanceId,EGI.EmpInfoId,EGI.EmpMasterCode,EGI.EmpName,EYLVB.FiscalYear,C.LeaveConType LeaveTypeName,EYLVB.YearlyLeaveBalance,
		SUM(ELVB.LeaveDays) AS LeaveBalance FROM Employee_YearlyLeaveTranscations ELVB
		LEFT JOIN Employee_YearlyLeaveBalance AS EYLVB ON ELVB.LeaveBalanceId = EYLVB.LeaveBalanceId
		LEFT JOIN tblEmpGeneralInfo AS EGI ON EYLVB.EmployeeInfoId = EGI.EmpInfoId
		  INNER JOIN dbo.tblLeaveConType C ( NOLOCK ) ON C.LeaveConTypeId = EYLVB.LeaveTypeId
              
		WHERE LeaveTranscationId IS NOT NULL' + @Parameter + '   and EYLVB.FiscalYear= format(getdate(),''yyyy'') 
		GROUP BY EYLVB.LeaveBalanceId,EGI.EmpInfoId,EGI.EmpMasterCode,EGI.EmpName,EYLVB.FiscalYear,C.LeaveConType,EYLVB.YearlyLeaveBalance'


       EXEC(@Query)


    END


	--SELECT * FROM tblEmpGeneralInfo
