

CREATE PROCEDURE [dbo].[sp_Webapi_Get_EmployyeMonthlyExpenseSum]
	-- Add the parameters for the stored procedure here
	@empId int = null,
 
 
@Role  nvarchar(max)=null,
 
@Month  int=null,
@Year   int=null



AS
BEGIN
   
SELECT         ISNULL(SUM(tblDA.DAAmount),0)+ ISNULL(sum(tblMilag.MilageExpense),0)  +ISNULL(sum(tblExpense.ExpenseAmount),0)  + ISNULL(sum(MonthlyAllowance),0)     GrandTotal FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  
LEFT JOIN (SELECT  emp.EmpMasterCode, Month(DAMas.TadaDate) TadaDateMonth,Year(DAMas.TadaDate) TadaDateYear,    SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
    inner join tblEmpGeneralInfo emp on emp.EmpInfoId=DAMas.EmpInfoId
 where DAMas.TadaID is not null and  DAMas.ApprovalStatus='2'  GROUP BY    Month(DAMas.TadaDate) ,Year(DAMas.TadaDate),emp.EmpMasterCode )tblDA    ON  tblDA.EmpMasterCode= EmpMas.EmpMasterCode  

 
LEFT JOIN (SELECT  Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate,  emp.EmpMasterCode, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) 
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=milMas.EmpInfoId
where milMas.MileageClaimId is not null    and  milMas.ApprovalStatus='2'   GROUP BY  emp.EmpMasterCode,Month(milMas.MileageDate)   ,Year(milMas.MileageDate)   )tblMilag     ON  tblMilag.EmpMasterCode= EmpMas.EmpMasterCode  and MonthMileageDate=TadaDateMonth and YearMileageDate=TadaDateYear

LEFT JOIN (SELECT   emp.EmpMasterCode, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount,  Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear   FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=EMas.EmpInfoId

 where  EMas.ExpenseClaimID is not null and  EMas.ApprovalStatus='2'    GROUP BY   emp.EmpMasterCode,Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate)    )tblExpense     ON  tblExpense.EmpMasterCode= EmpMas.EmpMasterCode  and ExpenseDateMont=TadaDateMonth and ExpenseDateYear=TadaDateYear

  left join (select EmpMasterCode, ISNULL(sum(mas.MonthlyAllowance),0) MonthlyAllowance from tbl_MonthlyAllowanceDetail dtl
 inner join tbl_MonthlyAllowance mas on dtl.MonthlyAllowanceId=mas.MonthlyAllowanceId
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=dtl.EmpInfoId
 where mas.IsActive=1
   group by  EmpMasterCode
 )tblall on EmpMas.EmpMasterCode=tblall.EmpMasterCode

WHERE EmpMas.EmpInfoId is not null      and tblDA.TadaDateMonth=@Month and tblDA.TadaDateYear=@Year
and  EmpMas.EmpInfoId=@empid 



END