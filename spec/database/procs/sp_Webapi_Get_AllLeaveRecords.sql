-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_AllLeaveRecords]
	-- Add the parameters for the stored procedure here
    @empCode NVARCHAR(50) = NULL ,
    @leaveTypeId INT = NULL
AS
    BEGIN
	

        SELECT  A.LeaveApplicationId ,
                C.LeaveTypeName ,
                CONVERT(NVARCHAR(50), A.LeaveFromDate, 106) AS LeaveFromDate ,
                CONVERT(NVARCHAR(50), A.LeaveToDate, 106) AS LeaveToDate ,
                A.Days ,
                A.Reason ,
             case when A.ApprovalStatus='0' then 'Pending'  when A.ApprovalStatus='1' then 'Verified' when A.ApprovalStatus='2' then 'Approved' when A.ApprovalStatus='3' then 'Rejected'  else A.ApprovalStatus end     ApprovalStatus ,
                ( emp.EmpMasterCode + ':' + emp.EmpName ) AS EmpName ,
                SUM(yt.LeaveDays) AS YearlyLeaveBalance
        FROM    dbo.Employee_LeaveApplications A ( NOLOCK )
                INNER JOIN dbo.Employee_YearlyLeaveBalance B ( NOLOCK ) ON B.LeaveBalanceId = A.LeaveBalanceId
                INNER JOIN dbo.Employe_LeaveTypeInfos C ( NOLOCK ) ON C.LeaveTypeId = B.LeaveTypeId
                INNER JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = A.EmployeeId
                LEFT JOIN dbo.Employee_YearlyLeaveTranscations yt ON yt.LeaveBalanceId = A.LeaveBalanceId
       WHERE   emp.EmpMasterCode = COALESCE(@empCode, emp.EmpMasterCode) AND 
		B.LeaveTypeId = COALESCE(@leaveTypeId, B.LeaveTypeId)
        GROUP BY A.LeaveApplicationId ,
                C.LeaveTypeName ,
                A.LeaveFromDate ,
                A.LeaveToDate ,
                A.Days ,
                A.Reason ,
                ApprovalStatus ,
                emp.EmpMasterCode + ':' + emp.EmpName
        ORDER BY A.LeaveApplicationId DESC



    END

