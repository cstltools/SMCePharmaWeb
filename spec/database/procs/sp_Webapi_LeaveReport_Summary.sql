 CREATE PROCEDURE [dbo].[sp_Webapi_LeaveReport_Summary]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2  nvarchar(max) ,
	@Year nvarchar(max) 
AS
BEGIN 
DECLARE @Q NVARCHAR(MAX)=''
  set   @Q  ='select distinct * from (Select  PM.EmpMasterCode, PM.EmpName,   dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode, format(PM.JoiningDate,''dd-MMM-yyyy'') Dateofjoin, DATEDIFF(MONTH, CONVERT(Date,PM.JoiningDate), CONVERT(Date,GETDATE())) MonthCount, isnull(tblPre.PreviousLeave, 0) PreviousLeave, ISNULL(tblCasualAcc.CasualAcc,0) Casual, ISNULL(tblSickAcc.SickAcc,0) Sick, ISNULL(tblAnnualBl.AnnualBal,0) Annual,
   
    isnull(tblPre.PreviousLeave, 0)+ ISNULL(tblAnnual.Annual,0) Eligible, 
	
	 case when  CAST((DATEDIFF(year, PM.JoiningDate, GETDATE())  - (CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 1 ELSE 0 END)) AS NVARCHAR(max))>0 then   CAST((DATEDIFF(year, PM.JoiningDate, GETDATE())  - (CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 1 ELSE 0 END)) AS NVARCHAR(max))+'' Y, '' else  ''''end +
 case when  CAST( MONTH(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) - 1 AS NVARCHAR(max))>0 then CAST( MONTH(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) - 1 AS NVARCHAR(max)) + '' M, '' else '''' end +
CAST(DAY(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) -(CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 0 ELSE 3 END)  AS NVARCHAR(max)) +'' D''  Los, 

isnull(tblPre.PreviousLeave, 0)+ ISNULL(tblAnnual.Annual,0) +isnull(tblAccMu.AccumulateLeave,0) Balance,
 
   case when  PM.Jobleftdate is null then  case when  year(GETDATE())> '+CAST(@Year as nvarchar(max))+'  then    case when  DATEDIFF(month,PM.JoiningDate, getdate())+1>=36 then (12/12)* 9 when DATEDIFF(month,PM.JoiningDate, getdate())+1<36 and DATEDIFF(month,PM.JoiningDate, getdate())+1>=12 then (10/12)* 9  else 0  end else 0  end  else 0 end  LeaveEncash, isnull(tblAccMu.AccumulateLeave,0) AccumulatedLeave from tblEmpGeneralInfo PM with (nolock)
   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
 
   left join tblDesignation dgs   WITH (NOLOCK) on PM.DesignationId=dgs.DesignationId
    left   JOIN
                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
                 WHERE (N.IsActive = 1) ) AS NSM ON NSM.EmployeeId = PM.EmpInfoId


   LEFT OUTER JOIN
                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   RM.IsBase=1) AS RSM ON RSM.EmployeeId = PM.EmpInfoId
				 
				  LEFT OUTER JOIN
                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  AM.IsBaseAM=1) AS ASM ON ASM.EmployeeId = PM.EmpInfoId
				 
				  LEFT OUTER JOIN
                 (SELECT    M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where M.isactive=1
                 ) AS MIO ON MIO.EmployeeId = PM.EmpInfoId 

   left join (select SUM(mas.YearlyLeaveQty) Casual, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas
 
 
  where mas.LeaveTypeId=3    '+@Parm2+' group by  mas.EmployeeInfoId)tblCasual on  PM.EmpInfoId=tblCasual.EmployeeInfoId

    left join (select SUM(mas.YearlyLeaveQty) Sick, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=2     '+@Parm2+' group by   mas.EmployeeInfoId)tblSick on  PM.EmpInfoId=tblSick.EmployeeInfoId

  left join (select SUM(mas.YearlyLeaveQty) Annual, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 
  where mas.LeaveTypeId=1    '+@Parm2+' group by  mas.EmployeeInfoId)tblAnnual on  PM.EmpInfoId=tblAnnual.EmployeeInfoId


  left join (select SUM(mas.YearlyLeaveBalance) PreviousLeave, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas

 where LeaveTypeId=3 and 
    FiscalYear='+cast((cast(@Year as int)-1) as nvarchar(max))+'  group by  mas.EmployeeInfoId) tblPre on  PM.EmpInfoId=tblPre.EmployeeInfoId


   

   left join (select [EmpId], SUM( [AccumulateLeave]) AccumulateLeave  from  [dbo].[tblLeaveEncashBlnc] where YearVal='+cast((cast(@Year as int)-1) as nvarchar(max))+'   group by [EmpId] )tblAccMu on  tblAccMu.EmpId=PM.EmpInfoId


     left join (select SUM(mas.Days) AnnualBal, mas.EmployeeId  EmployeeInfoId from Employee_LeaveApplications mas

inner join Employee_YearlyLeaveBalance  dtl on mas.LeaveBalanceId=dtl.LeaveBalanceId
  where dtl.LeaveTypeId=1   and mas.ApprovalStatus=''2''  '+@Parm2+' group by  mas.EmployeeId)tblAnnualBl on  PM.EmpInfoId=tblAnnualBl.EmployeeInfoId



   left join (select SUM(YearlyLeaveQty-YearlyLeaveBalance) CasualAcc, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas
	 
  where mas.LeaveTypeId=3     '+@Parm2+' group by  mas.EmployeeInfoId)tblCasualAcc on  PM.EmpInfoId=tblCasualAcc.EmployeeInfoId

    left join (select SUM(YearlyLeaveQty-YearlyLeaveBalance) SickAcc, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas
	 
  where mas.LeaveTypeId=2    '+@Parm2+' group by  mas.EmployeeInfoId)tblSickAcc on  PM.EmpInfoId=tblSickAcc.EmployeeInfoId

  left join (select SUM(YearlyLeaveQty-YearlyLeaveBalance) AnnualAcc, mas.EmployeeInfoId  EmployeeInfoId from Employee_YearlyLeaveBalance mas
	 
  where mas.LeaveTypeId=1    '+@Parm2+' group by  mas.EmployeeInfoId)tblAnnualAcc on  PM.EmpInfoId=tblAnnualAcc.EmployeeInfoId



	   where PM.EmpInfoId is not null ' +@Parm+') tbl order by   MarketCode asc'

	  					
EXEC sp_executesql @Q

END


--  select distinct * from (Select  PM.EmpMasterCode, PM.EmpName,   dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode, format(PM.JoiningDate,''dd-MMM-yyyy'') Dateofjoin, DATEDIFF(MONTH, CONVERT(Date,PM.JoiningDate), CONVERT(Date,GETDATE())) MonthCount, '''' PreviousLeave, ISNULL(tblCasual.Casual,0) Casual, ISNULL(tblSick.Sick,0) Sick, ISNULL(tblAnnual.Annual,0) Annual, case when  CAST((DATEDIFF(year, PM.JoiningDate, GETDATE())  - (CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 1 ELSE 0 END)) AS NVARCHAR(max))>0 then   CAST((DATEDIFF(year, PM.JoiningDate, GETDATE())  - (CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 1 ELSE 0 END)) AS NVARCHAR(max))+'' Years, '' else  ''''end +

-- case when  CAST( MONTH(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) - 1 AS NVARCHAR(max))>0 then CAST( MONTH(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) - 1 AS NVARCHAR(max)) + '' Months, '' else '''' end +

--CAST(DAY(GETDATE() - DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate)) -(CASE WHEN DATEADD(year, DATEDIFF(year, PM.JoiningDate, GETDATE()), PM.JoiningDate) > GETDATE() THEN 0 ELSE 3 END)  AS NVARCHAR(max)) +'' Days''  Los, '''' Eligible, '''' Balance, '''' LeaveEncash, '''' AccumulatedLeave from tblEmpGeneralInfo PM with (nolock)
--   left join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
 
--   left join tblDesignation dgs   WITH (NOLOCK) on PM.DesignationId=dgs.DesignationId
--    left   JOIN
--                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
--                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
--                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
--                 WHERE (N.IsActive = 1) ) AS NSM ON NSM.EmployeeId = PM.EmpInfoId


--   LEFT OUTER JOIN
--                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
--                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
--                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
--                 WHERE   RM.IsBase=1) AS RSM ON RSM.EmployeeId = PM.EmpInfoId
				 
--				  LEFT OUTER JOIN
--                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
--                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
--                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
--                 WHERE  AM.IsBaseAM=1) AS ASM ON ASM.EmployeeId = PM.EmpInfoId
				 
--				  LEFT OUTER JOIN
--                 (SELECT    M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
--                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
--                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where M.isactive=1
--                 ) AS MIO ON MIO.EmployeeId = PM.EmpInfoId 

--   left join (select SUM(mas.Days) Casual, mas.EmployeeId  EmployeeInfoId from Employee_LeaveApplications mas

--inner join Employee_YearlyLeaveBalance  dtl on mas.LeaveBalanceId=dtl.LeaveBalanceId
--  where dtl.LeaveTypeId=2  and mas.ApprovalStatus=''2''   '+@Parm2+' group by  mas.EmployeeId)tblCasual on  PM.EmpInfoId=tblCasual.EmployeeInfoId

--    left join (select SUM(mas.Days) Sick, mas.EmployeeId  EmployeeInfoId from Employee_LeaveApplications mas

--inner join Employee_YearlyLeaveBalance  dtl on mas.LeaveBalanceId=dtl.LeaveBalanceId
--  where dtl.LeaveTypeId=1  and mas.ApprovalStatus=''2''   '+@Parm2+' group by  mas.EmployeeId)tblSick on  PM.EmpInfoId=tblSick.EmployeeInfoId

--  left join (select SUM(mas.Days) Annual, mas.EmployeeId  EmployeeInfoId from Employee_LeaveApplications mas

--inner join Employee_YearlyLeaveBalance  dtl on mas.LeaveBalanceId=dtl.LeaveBalanceId
--  where dtl.LeaveTypeId=3   and mas.ApprovalStatus=''2''  '+@Parm2+' group by  mas.EmployeeId)tblAnnual on  PM.EmpInfoId=tblAnnual.EmployeeInfoId

--	   where PM.EmpInfoId is not null ' +@Parm+') tbl order by   MarketCode asc