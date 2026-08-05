



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_LeaveReport]
	-- Add the parameters for the stored procedure here
	  @Year INT,@EmpInfoId INT
AS
BEGIN
		 
	SELECT EmployeeInfoId,EmpMasterCode,EmpName,YearlyLeaveQty,YearlyLeaveBalance,(YearlyLeaveQty-YearlyLeaveBalance)AS LeaveBalance,c.LeaveConType LeaveTypeName FROM dbo.Employee_YearlyLeaveBalance
	LEFT JOIN dbo.tblEmpGeneralInfo ON dbo.tblEmpGeneralInfo.EmpInfoId=dbo.Employee_YearlyLeaveBalance.EmployeeInfoId
	--LEFT JOIN dbo.Employe_LeaveTypeInfos ON Employe_LeaveTypeInfos.LeaveTypeId = Employee_YearlyLeaveBalance.LeaveTypeId
	   LEFT JOIN dbo.tblLeaveConType C  (NOLOCK) ON C.LeaveConTypeId = Employee_YearlyLeaveBalance.LeaveTypeId
	 WHERE FiscalYear=@Year AND EmployeeInfoId=@EmpInfoId

END





