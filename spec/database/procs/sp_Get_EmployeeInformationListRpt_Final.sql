
create PROCEDURE [dbo].[sp_Get_EmployeeInformationListRpt_Final]
	-- Add the parameters for the stored procedure here
		@Parm nvarchar(max) ,
		@Month nvarchar(max) 

AS
BEGIN
 DECLARE @Q NVARCHAR(MAX)
 

  set @Q  =' select Distinct * from (
  Select distinct ''''  TerritoryCode , PM.EmpName,  PM.EmpInfoId,PM.EmpMasterCode,   usRT.RoleType, usR.RoleName,  CONVERT(NVARCHAR(50),PM.DateOfBirth,106)AS EmpDateOfBirth,ISNULL(tblDA.DAAmount ,0) DAAmount,ISNULL(tblMilag.MilageExpense ,0) MilageExpense,ISNULL(tblExpense.ExpenseAmount ,0) ExpenseAmount, ISNULL(tblall.MonthlyAllowance,0) MonthlyAllowance, ISNULL(tblDA.DAAmount ,0) +ISNULL(tblMilag.MilageExpense ,0) +ISNULL(tblExpense.ExpenseAmount ,0) + ISNULL(tblall.MonthlyAllowance,0) TotalExp from tblEmpGeneralInfo PM with (nolock)
   inner join tblUser us  with (nolock) on PM.EmpInfoId=us.EmpInfoId
   inner join tbl_UserRoleInfo usR  with (nolock) on usR.UserRoleId=us.UserRoleId
   inner join tblRoleType usRT  with (nolock) on usR.RoleTypeId=usRT.RoleTypeId

 


  


				  LEFT JOIN (SELECT Month(DAMas.TadaDate) TadaDateMonth,Year(DAMas.TadaDate) TadaDateYear  , DAMas.EmpInfoId, SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
   
  
 where DAMas.TadaID is not null  and  DAMas.ApprovalStatus=''2'' GROUP BY  DAMas.EmpInfoId,  Month(DAMas.TadaDate) ,Year(DAMas.TadaDate)  )tblDA    ON  tblDA.EmpInfoId= PM.EmpInfoId 

 
LEFT JOIN (SELECT Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate, milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus=''2''   GROUP BY   milMas.EmpInfoId,Month(milMas.MileageDate),Year(milMas.MileageDate))tblMilag    ON  tblMilag.EmpInfoId= PM.EmpInfoId   and MonthMileageDate=TadaDateMonth and YearMileageDate=TadaDateYear 

LEFT JOIN (SELECT  EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount, Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 
 where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus=''2''   GROUP BY  EMas.EmpInfoId,Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense    ON  tblExpense.EmpInfoId= PM.EmpInfoId  and ExpenseDateMont=TadaDateMonth and ExpenseDateYear=TadaDateYear

  left join (select dtl.EmpInfoId, ISNULL(sum(mas.MonthlyAllowance),0) MonthlyAllowance from tbl_MonthlyAllowanceDetail dtl
 inner join tbl_MonthlyAllowance mas on dtl.MonthlyAllowanceId=mas.MonthlyAllowanceId
 
 where mas.IsActive=1
   group by  EmpInfoId
 )tblall on PM.EmpInfoId=tblall.EmpInfoId
 where PM.EmpInfoId is not null 

   ' +@Parm +' 	) tblll order by   TerritoryCode asc '
 
  

						
EXEC sp_executesql @Q


END
