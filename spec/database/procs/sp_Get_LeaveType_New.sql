-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_LeaveType_New]
 
AS
    BEGIN


        --SELECT  A.LeaveTypeName ,
        --        B.LeaveBalanceId ,
        --        B.YearlyLeaveBalance
        --FROM    dbo.Employe_LeaveTypeInfos A
        --        INNER JOIN dbo.Employee_YearlyLeaveBalance B ON B.LeaveTypeId = A.LeaveTypeId
        --WHERE   A.IsActive = 1
        --        AND B.EmployeeInfoId = @empId
        --        AND B.FiscalYear = @year


		SELECT distinct B.[LeaveConType] LeaveTypeName ,
     A.LeaveTypeId as    LeaveBalanceId  
       
FROM    dbo.Employee_YearlyLeaveBalance A
        INNER JOIN tblLeaveConType B ON B.LeaveConTypeId = A.LeaveTypeId
        INNER JOIN dbo.Employee_YearlyLeaveTranscations C ON C.LeaveBalanceId = A.LeaveBalanceId
		 
		GROUP BY  B.LeaveConType ,
        A.LeaveBalanceId,     A.LeaveTypeId 




--		SELECT  B.LeaveTypeName ,
--        A.LeaveBalanceId ,
--		t2.leavdays
--FROM    dbo.Employee_YearlyLeaveBalance A
--        INNER JOIN dbo.Employe_LeaveTypeInfos B ON B.LeaveTypeId = A.LeaveTypeId
--        LEFT JOIN (
		
--        SELECT  LeaveBalanceId ,
--                SUM(LeaveDays)AS leavdays
--        FROM    Employee_YearlyLeaveTranscations
--        GROUP BY LeaveBalanceId
--		)AS t2 ON t2.LeaveBalanceId = A.LeaveBalanceId
--		WHERE A.EmployeeInfoId = 1


    END

