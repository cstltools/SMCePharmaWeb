-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_View_EmployeeLeaveBalance]
	-- Add the parameters for the stored procedure here

	@EmpMasterCode NVARCHAR(MAX) 

AS
BEGIN
	
	 

	SELECT EGI.EmpInfoId,EGI.EmpMasterCode,EGI.EmpName,LVTYP.LeaveTypeName,LVB.YearlyLeaveBalance
	,SUM(LVT.LeaveDays) AS LeaveBalance FROM Employee_YearlyLeaveTranscations AS LVT
	LEFT JOIN Employee_YearlyLeaveBalance AS LVB ON LVT.LeaveBalanceId = LVB.LeaveBalanceId
	LEFT JOIN Employe_LeaveTypeInfos AS LVTYP ON LVB.LeaveTypeId = LVTYP.LeaveTypeId
	LEFT JOIN tblEmpGeneralInfo AS EGI ON LVB.EmployeeInfoId = EGI.EmpInfoId
    WHERE EGI.EmpMasterCode = @EmpMasterCode
    GROUP BY EGI.EmpInfoId,EGI.EmpMasterCode,EGI.EmpName,LVTYP.LeaveTypeName,LVB.YearlyLeaveBalance
           

END

