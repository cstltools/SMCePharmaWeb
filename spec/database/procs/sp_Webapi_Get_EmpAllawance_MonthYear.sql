CREATE

 PROCEDURE [dbo].[sp_Webapi_Get_EmpAllawance_MonthYear]
	-- Add the parameters for the stored procedure here

	@EmpInfoId nvarchar(max) ,
	@Month nvarchar(max),
	@Year nvarchar(max)  
AS
BEGIN 

select EmpMasterCode,  EmpInfoId,    MonthlyAllowance   MonthlyAllowance,   MonthlyAllowanceName  from (
select emp.EmpMasterCode, al.EmpInfoId,  case when ((case when  month(emp.JoiningDate)=@Month and year(emp.JoiningDate)=@Year then  (isnull(mas.MonthlyAllowance,0)/DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,emp.JoiningDate),0))))*((DATEDIFF(d, CONVERT(Date,emp.JoiningDate),CONVERT(Date, EOMONTH(emp.JoiningDate))))+1)  when  month(emp.JobleftDate)=@Month and year(emp.JobleftDate)=@Year then  nullif(cast( isnull(mas.MonthlyAllowance,0)/ DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,emp.JobleftDate),0)))  as decimal(18,2))*   CAST((DATEDIFF(DAY, (SELECT DATEADD(m, DATEDIFF(m, 0, emp.JobleftDate), 0)) , emp.JobleftDate))+1  as decimal(18,2)) ,0)   else isnull (mas.MonthlyAllowance,0) end))>= isnull (mas.MonthlyAllowance,0) then  isnull (mas.MonthlyAllowance,0) else  ((case when  month(emp.JoiningDate)=@Month and year(emp.JoiningDate)=@Year then  (isnull(mas.MonthlyAllowance,0)/DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,emp.JoiningDate),0))))*((DATEDIFF(d, CONVERT(Date,emp.JoiningDate),CONVERT(Date, EOMONTH(emp.JoiningDate))))+1)  when  month(emp.JobleftDate)=@Month and year(emp.JobleftDate)=@Year then  nullif(cast( isnull(mas.MonthlyAllowance,0)/ DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,emp.JobleftDate),0)))  as decimal(18,2))*   CAST((DATEDIFF(DAY, (SELECT DATEADD(m, DATEDIFF(m, 0, emp.JobleftDate), 0)) , emp.JobleftDate))+1  as decimal(18,2)) ,0)   else isnull (mas.MonthlyAllowance,0) end)) end MonthlyAllowance, mas.MonthlyAllowanceName from tbl_MonthlyAllowance mas 
inner join tbl_MonthlyAllowanceDetail al on mas.MonthlyAllowanceId=al.MonthlyAllowanceId
inner join tblEmpGeneralInfo emp on al.EmpInfoId=emp.EmpInfoId
WHERE al.EmpInfoId in( select * from fnSplit(@EmpInfoId,',')) and mas.IsActive=1)tbl

END



