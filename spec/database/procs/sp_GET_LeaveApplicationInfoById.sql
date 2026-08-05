-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_LeaveApplicationInfoById]
	-- Add the parameters for the stored procedure here

	@Parameter NVARCHAR(MAX) 

AS
BEGIN
	
	
	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT FORMAT(LeaveFromDate,''dd-MMM-yyyy'') LeaveFromDate, LVAP.LeaveBalanceId,EGI.EmpInfoId,EGI.EmpMasterCode,EGI.EmpName,LVTYP.LeaveTypeName,LVAP.LeaveApplicationId,
	LVAP.LeaveApplicationId,LVAP.LeaveFromDate,LVAP.LeaveToDate,LVAP.Reason,LVAP.ApprovalStatus,LVAP.Days,
	ENTR.EmpName AS EntryBy,LVAP.EntryDate,UPDT.EmpName AS UpdateBy, LVAP.UpdateDate,APRV.EmpName AS ApproveBy,LVAP.ApproveDate 
	FROM Employee_LeaveApplications AS LVAP
	LEFT JOIN Employee_YearlyLeaveBalance AS LVB ON LVAP.LeaveBalanceId = LVB.LeaveBalanceId
	LEFT JOIN Employe_LeaveTypeInfos AS LVTYP ON LVB.LeaveTypeId = LVTYP.LeaveTypeId
	LEFT JOIN tblEmpGeneralInfo AS EGI ON LVB.EmployeeInfoId = EGI.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = LVAP.EntryBy
	LEFT JOIN tblEmpGeneralInfo AS UPDT ON UPDT.EmpInfoId = LVAP.UpdateBy
	LEFT JOIN tblEmpGeneralInfo AS APRV ON APRV.EmpInfoId = LVAP.UpdateDate
	WHERE LVAP.LeaveApplicationId IS NOT NULL ' + @Parameter

	EXEC(@Query)


	SELECT * FROM Employee_LeaveApplications
           

END



