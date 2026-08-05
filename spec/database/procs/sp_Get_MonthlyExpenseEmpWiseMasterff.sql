

create

 PROCEDURE [dbo].[sp_Get_MonthlyExpenseEmpWiseMasterff]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
SELECT     EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode,vv.RegionCode ZoneCode, TadaDateMonthYear MonthYear, CAST(tblDA.TadaDate as nvarchar(max))+ ', '+tblDA.DayNameVal DAdate,  tblDA.MarketName,tblDA.TourType, floor( ISNULL(tblDA.DAAmount,0)) daAmount , ISNULL(tblMilag.AllowedMileageInKM,0) AllowedMileageInKM, ISNULL(tblMilag.MilageExpense,0) mileageAmount, floor( ISNULL(tblExpense.ExpenseAmount,0)) expenseAmount, ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0) totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId
LEFT JOIN (SELECT mr.MarketName,st.StationTypeName  TourType, Month(DAMas.TadaDate) TadaDateMonth,Year(DAMas.TadaDate) TadaDateYear, format(DAMas.TadaDate,'MMMM, yyyy') TadaDateMonthYear , DAY(DAMas.TadaDate) TadaDate,   DATENAME(DW,DAMas.TadaDate) DayNameVal , DAMas.EmpInfoId, SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
   
   inner join tblMarket mr  WITH (NOLOCK) on   DAMas.MarketId=mr.MarketId
   left join tblStationType st  WITH (NOLOCK) on   DAMas.TourTypeId=st.StationTypeId
 where DAMas.TadaID is not null  and  DAMas.ApprovalStatus='2' GROUP BY  DAMas.EmpInfoId, DAY(DAMas.TadaDate), DATENAME(DW,DAMas.TadaDate), mr.MarketName, st.StationTypeName, Month(DAMas.TadaDate) ,Year(DAMas.TadaDate),format(DAMas.TadaDate,'MMMM, yyyy')  )tblDA    ON  tblDA.EmpInfoId= EmpMas.EmpInfoId 

 
LEFT JOIN (SELECT Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate, DAY(milMas.MileageDate) TadaDate, milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.AllowedMileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'   GROUP BY   milMas.EmpInfoId,DAY(milMas.MileageDate),Month(milMas.MileageDate),Year(milMas.MileageDate))tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId   and MonthMileageDate=TadaDateMonth and YearMileageDate=TadaDateYear and tblDA.TadaDate=tblMilag.TadaDate

LEFT JOIN (SELECT  DAY(EMas.ExpenseDate) TadaDate,EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount, Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 inner join View_Webapi_EmployeeFieldForceInfo   on EMas.EmpInfoId=View_Webapi_EmployeeFieldForceInfo.EmpInfoId
 where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2'   GROUP BY  EMas.EmpInfoId,DAY(EMas.ExpenseDate),Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId  and ExpenseDateMont=TadaDateMonth and ExpenseDateYear=TadaDateYear and tblExpense.TadaDate=tblDA.TadaDate

 
 LEFT JOIN (SELECT  DAY(EMas.ExpenseDate) TadaDate,EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount, Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 inner join View_Webapi_EmployeeFieldForceInfo   on EMas.EmpInfoId=View_Webapi_EmployeeFieldForceInfo.EmpInfoId
 where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2'   GROUP BY  EMas.EmpInfoId,DAY(EMas.ExpenseDate),Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense2    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId  and tblExpense2.ExpenseDateMont=TadaDateMonth and tblExpense2.ExpenseDateYear=TadaDateYear and tblExpense2.TadaDate!=tblDA.TadaDate


 left   JOIN
                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.EmployeeId = EmpMas.EmpInfoId


   LEFT OUTER JOIN
                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE (RM.IsActive = 1)) AS RSM ON EmpMas.EmpInfoId = RSM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE (AM.IsActive = 1)) AS ASM ON EmpMas.EmpInfoId = ASM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId
                 WHERE (M.IsActive = 1)) AS MIO ON EmpMas.EmpInfoId = MIO.EmployeeId 


				 inner join View_Webapi_EmployeeFieldForceInfo vv on vv.EmpInfoId=EmpMas.EmpInfoId
WHERE EmpMas.EmpInfoId is not null  and  ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0)>0   and tblDA.TadaDateMonth=@Month and tblDA.TadaDateYear=@Year
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))



END