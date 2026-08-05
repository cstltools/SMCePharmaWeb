-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_LeaveType]
	-- Add the parameters for the stored procedure here
	@empId INT,
	@year int
AS
    BEGIN

	set @year= year(GETDATE())
        --SELECT  A.LeaveTypeName ,
        --        B.LeaveBalanceId ,
        --        B.YearlyLeaveBalance
        --FROM    dbo.Employe_LeaveTypeInfos A
        --        INNER JOIN dbo.Employee_YearlyLeaveBalance B ON B.LeaveTypeId = A.LeaveTypeId
        --WHERE   A.IsActive = 1
        --        AND B.EmployeeInfoId = @empId
        --        AND B.FiscalYear = @year


		Select

		'Annual'  LeaveTypeName, 1 LeaveBalanceId, cast(  case when isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) +isnull(tblAccMu.AccumulateLeave,0) >=90 then 90 else isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) end as int)  YearlyLeaveBalance from  tblEmpGeneralInfo PM with (nolock)
		 --+isnull(tblAccMu.AccumulateLeave,0)
		  left join (select SUM(mas.YearlyLeaveBalance) PreviousLeave, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 where LeaveTypeId=3 and 
    FiscalYear=  ( cast(@year as int)-1)     group by  mas.EmployeeInfoId) tblPre on  PM.EmpInfoId=tblPre.EmployeeInfoId

	 

	 left join (select SUM(mas.YearlyLeaveQty) Annual, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=1    group by  mas.EmployeeInfoId)tblAnnual on  PM.EmpInfoId=tblAnnual.EmployeeInfoId

	    left join (select [EmpId], SUM( [AccumulateLeave]) AccumulateLeave  from  [dbo].[tblLeaveEncashBlnc] where YearVal=( cast(@year as int)-1)  group by [EmpId] )tblAccMu on  tblAccMu.EmpId=PM.EmpInfoId
 
 
  where    PM.EmpInfoId=@empId  and isnull(tblPre.PreviousLeave, 0) + ISNULL(tblAnnual.Annual,0) +isnull(tblAccMu.AccumulateLeave,0)>0

  union all

		SELECT distinct B.[LeaveConType] LeaveTypeName ,
     A.LeaveTypeId as    LeaveBalanceId ,
        cast( SUM(A.YearlyLeaveBalance) as int) AS YearlyLeaveBalance
FROM    dbo.Employee_YearlyLeaveBalance A
        INNER JOIN tblLeaveConType B ON B.LeaveConTypeId = A.LeaveTypeId
        INNER JOIN dbo.Employee_YearlyLeaveTranscations C ON C.LeaveBalanceId = A.LeaveBalanceId
		WHERE A.EmployeeInfoId = @empId AND A.FiscalYear = @year and A.LeaveTypeId not in (1)
		GROUP BY  B.LeaveConType , 
        A.LeaveBalanceId,     A.LeaveTypeId   having   SUM(A.YearlyLeaveBalance)>0




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

