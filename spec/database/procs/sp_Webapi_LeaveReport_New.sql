



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_LeaveReport_New]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='
	SELECT EmployeeInfoId,EmpMasterCode,EmpName,YearlyLeaveQty,YearlyLeaveBalance,(YearlyLeaveQty-YearlyLeaveBalance)AS LeaveBalance,LeaveTypeName FROM dbo.Employee_YearlyLeaveBalance
	LEFT JOIN dbo.tblEmpGeneralInfo ON dbo.tblEmpGeneralInfo.EmpInfoId=dbo.Employee_YearlyLeaveBalance.EmployeeInfoId
	LEFT JOIN dbo.Employe_LeaveTypeInfos ON Employe_LeaveTypeInfos.LeaveTypeId = Employee_YearlyLeaveBalance.LeaveTypeId
 WHERE  Employee_YearlyLeaveBalance.LeaveBalanceId is not null 
	 ' +@Parm

						
EXEC sp_executesql @Q

END




