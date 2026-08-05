

CREATE

 PROCEDURE [dbo].[sp_Get_MonthlyExpenseEmpWiseTotal]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
SELECT    EmpMas.EmpMasterCode,       ISNULL(SUM(tblDA.DAAmount),0)+ ISNULL(sum(tblMilag.MilageExpense),0)  +ISNULL(sum(tblExpense.ExpenseAmount),0)  + case when sum((case when  month(EmpMas.JoiningDate)=@Month and year(EmpMas.JoiningDate)=@Year then  (isnull(tblall.MonthlyAllowance,0)/DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,EmpMas.JoiningDate),0))))*((DATEDIFF(d, CONVERT(Date,EmpMas.JoiningDate),CONVERT(Date, EOMONTH(EmpMas.JoiningDate))))+1)   when  month(EmpMas.JobleftDate)=@Month and year(EmpMas.JobleftDate)=@Year then  (nullif(cast( isnull(tblall.MonthlyAllowance,0)/ DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,EmpMas.JobleftDate),0)))  as decimal(18,2))*   CAST((DATEDIFF(DAY, (  DATEADD(m, DATEDIFF(m, 0, EmpMas.JobleftDate), 0)) , EmpMas.JobleftDate))+1  as decimal(18,2)) ,0))   else isnull (tblall.MonthlyAllowance,0) end))>= sum(isnull (tblall.MonthlyAllowance,0)) then sum(isnull (tblall.MonthlyAllowance,0)) else  sum((case when  month(EmpMas.JoiningDate)=@Month and year(EmpMas.JoiningDate)=@Year then  (isnull(tblall.MonthlyAllowance,0)/DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,EmpMas.JoiningDate),0))))*((DATEDIFF(d, CONVERT(Date,EmpMas.JoiningDate),CONVERT(Date, EOMONTH(EmpMas.JoiningDate))))+1)   when  month(EmpMas.JobleftDate)=@Month and year(EmpMas.JobleftDate)=@Year then  (nullif(cast( isnull(tblall.MonthlyAllowance,0)/ DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,EmpMas.JobleftDate),0)))  as decimal(18,2))*   CAST((DATEDIFF(DAY, (  DATEADD(m, DATEDIFF(m, 0, EmpMas.JobleftDate), 0)) , EmpMas.JobleftDate))+1  as decimal(18,2)) ,0))   else isnull (tblall.MonthlyAllowance,0) end)) end    totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  
LEFT JOIN (SELECT  emp.EmpMasterCode, Month(DAMas.TadaDate) TadaDateMonth,Year(DAMas.TadaDate) TadaDateYear,    SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
    inner join tblEmpGeneralInfo emp on emp.EmpInfoId=DAMas.EmpInfoId
 where DAMas.TadaID is not null and  DAMas.ApprovalStatus='2'  GROUP BY    Month(DAMas.TadaDate) ,Year(DAMas.TadaDate),emp.EmpMasterCode )tblDA    ON  tblDA.EmpMasterCode= EmpMas.EmpMasterCode   and   TadaDateMonth=@Month and TadaDateYear=@Year

 
LEFT JOIN (SELECT  Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate,  emp.EmpMasterCode, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) 
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=milMas.EmpInfoId
where milMas.MileageClaimId is not null    and  milMas.ApprovalStatus='2'   GROUP BY  emp.EmpMasterCode,Month(milMas.MileageDate)   ,Year(milMas.MileageDate)   )tblMilag     ON  tblMilag.EmpMasterCode= EmpMas.EmpMasterCode  and MonthMileageDate=@Month and YearMileageDate=@Year

LEFT JOIN (SELECT   emp.EmpMasterCode, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount,  Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear   FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=EMas.EmpInfoId

 where  EMas.ExpenseClaimID is not null and  EMas.ApprovalStatus='2'    GROUP BY   emp.EmpMasterCode,Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate)    )tblExpense     ON  tblExpense.EmpMasterCode= EmpMas.EmpMasterCode  and ExpenseDateMont=@Month and ExpenseDateYear=@Year

  left join (select EmpMasterCode, ISNULL(sum(mas.MonthlyAllowance),0) MonthlyAllowance from tbl_MonthlyAllowanceDetail dtl
 inner join tbl_MonthlyAllowance mas on dtl.MonthlyAllowanceId=mas.MonthlyAllowanceId
 inner join tblEmpGeneralInfo emp on emp.EmpInfoId=dtl.EmpInfoId
 where mas.IsActive=1
   group by  EmpMasterCode
 )tblall on EmpMas.EmpMasterCode=tblall.EmpMasterCode

WHERE EmpMas.EmpInfoId is not null      --and tblDA.TadaDateMonth=@Month and tblDA.TadaDateYear=@Year
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))

group by EmpMas.EmpMasterCode, EmpMas.JoiningDate, EmpMas.JobleftDate

END