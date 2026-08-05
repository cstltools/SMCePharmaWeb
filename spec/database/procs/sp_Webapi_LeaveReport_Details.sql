
 CREATE PROCEDURE [dbo].[sp_Webapi_LeaveReport_Details]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2  nvarchar(max)  ,
	@Year nvarchar(max) 
AS
BEGIN 
   DECLARE @Q NVARCHAR(MAX)=''
   set @Q='
SELECT   emp.EmpMasterCode ,  emp.EmpName   AS EmpName , usr.RoleName,format(  A.LeaveFromDate, ''dd-MMM-yyyy'') AS LeaveFromDate ,
               format(  A.LeaveToDate, ''dd-MMM-yyyy'') AS LeaveToDate ,
                A.Days  
                ,
             case when A.ApprovalStatus=''0'' then ''Pending''  when A.ApprovalStatus=''1'' then ''Verified'' when A.ApprovalStatus=''2'' then ''Approved'' when A.ApprovalStatus=''3'' then ''Rejected''  else A.ApprovalStatus end     ApprovalStatus ,C.LeaveConType LeaveTypeName , tblCasual.ElliCasual,  ISNULL(CAST((tblCasual.ElliCasual / 12) * MONTH(GETDATE()) AS DECIMAL(10,2)),0) abCasual  , tblCasual.TKCasual TKCasual,  ISNULL( ISNULL(CAST((tblCasual.ElliCasual / 12) * MONTH(GETDATE()) AS DECIMAL(10,2)),0) - tblCasual.TKCasual,0) CasualBlnc,

 tblSick.ElliSick,  ISNULL(CAST((tblSick.ElliSick / 12) * MONTH(GETDATE()) AS DECIMAL(10,2)),0)  abSick,  tblSick.TKSick,  isnull( ISNULL(CAST((tblSick.ElliSick / 12) * MONTH(GETDATE()) AS DECIMAL(10,2)),0)  -  tblSick.TKSick,0) SickBlnc,

 
 tblAnnual.ElliAnnual,  ISNULL(CAST(( isnull(tblAnnual.ElliAnnual,0) / 12) * MONTH(GETDATE()) AS DECIMAL(10,2)),0)  abAnnual,tblAnnual.TKAnnual,     isnull(tblAccMu.AccumulateLeave,tblAnnual.ElliAnnual) PreviousAL, ISNULL(isnull(tblAccMu.AccumulateLeave,tblAnnual.ElliAnnual) -tblAnnual.TKAnnual,0) AnnualBlnc
        FROM    dbo.Employee_LeaveApplications A ( NOLOCK )
               
                 INNER JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = A.EmployeeId
				    left JOIN dbo.tblUser us ON us.EmpInfoId = A.EmployeeId
					   INNER JOIN dbo.tblLeaveConType C ( NOLOCK ) ON C.LeaveConTypeId = A.LeaveBalanceId
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = us.UserRoleID

left join (select SUM(mas.YearlyLeaveQty) ElliCasual, SUM(YearlyLeaveQty-YearlyLeaveBalance) TKCasual, sum(YearlyLeaveBalance) abCasual,  mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas 
  where mas.LeaveTypeId=3  '+@Parm2+'    group by  mas.EmployeeInfoId)tblCasual on  emp.EmpInfoId=tblCasual.EmployeeInfoId

    left join (select SUM(mas.YearlyLeaveQty) ElliSick,  SUM(YearlyLeaveQty-YearlyLeaveBalance) TKSick, sum(YearlyLeaveBalance) abSick, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=2      '+@Parm2+'    group by   mas.EmployeeInfoId)tblSick on  emp.EmpInfoId=tblSick.EmployeeInfoId

  left join (select SUM(mas.YearlyLeaveQty) ElliAnnual,  SUM(YearlyLeaveQty-YearlyLeaveBalance) abAnnual,  SUM(YearlyLeaveQty-YearlyLeaveBalance) TKAnnual,  mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=1   '+@Parm2+'  group by  mas.EmployeeInfoId)tblAnnual on  emp.EmpInfoId=tblAnnual.EmployeeInfoId


 -- left join (select SUM(mas.YearlyLeaveBalance) PreviousLeave, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 --where LeaveTypeId=3 and 
 --   FiscalYear= cast((cast(2023 as int)-1) as nvarchar(max))   group by  mas.EmployeeInfoId) tblPre on   A.EmployeeId=tblPre.EmployeeInfoId

	  left join (select [EmpId], SUM( [AccumulateLeave]) AccumulateLeave  from  [dbo].[tblLeaveEncashBlnc] where YearVal='+cast((cast(@Year as int)-1) as nvarchar(max))+'   group by [EmpId] )tblAccMu on  tblAccMu.EmpId=A.EmployeeId

                where A.LeaveApplicationId is not null  ' +@Parm

	  					
EXEC sp_executesql @Q

END



--and emp.EmpMasterCode='50750'  and  2023 between year(A.LeaveFromDate) and year(A.LeaveToDate)