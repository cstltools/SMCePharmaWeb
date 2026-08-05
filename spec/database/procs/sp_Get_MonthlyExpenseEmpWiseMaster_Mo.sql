 
 CREATE

 PROCEDURE [dbo].[sp_Get_MonthlyExpenseEmpWiseMaster_Mo]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 

DECLARE @startDate DATE, @endDate DATE
Set @startDate = '2022-04-01'
set @endDate = '2022-04-30'

;WITH Calender AS (
    SELECT @startDate AS YourDate
    UNION ALL
    SELECT DATEADD(day,1,YourDate) FROM Calender
    WHERE DATEADD(day,1,YourDate) <= @endDate
)

select distinct * from Calender cal
inner join (SELECT  distinct  tblDA.daDate  daDate_,tblMilag.MilDate,tblExpense.ExpDate,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode,vv.RegionCode ZoneCode, TadaDateMonthYear MonthYear, '' DAdate,  tblDA.MarketName,tblDA.TourType, floor( ISNULL(tblDA.DAAmount,0)) daAmount , ISNULL(tblMilag.AllowedMileageInKM,0) AllowedMileageInKM, ISNULL(tblMilag.MilageExpense,0) mileageAmount, floor( ISNULL(tblExpense.ExpenseAmount,0)) expenseAmount, ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0) totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId

LEFT JOIN (SELECT convert(Date,DAMas.TadaDate) daDate, mr.MarketName,st.StationTypeName  TourType,  format(DAMas.TadaDate,'MMMM, yyyy') TadaDateMonthYear ,  DATENAME(DW,DAMas.TadaDate) DayNameVal , DAMas.EmpInfoId, SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
    
   inner join tblMarket mr  WITH (NOLOCK) on   DAMas.MarketId=mr.MarketId
   left join tblStationType st  WITH (NOLOCK) on   DAMas.TourTypeId=st.StationTypeId
 where DAMas.TadaID is not null  and  DAMas.ApprovalStatus='2'  and  MONTH(DAMas.TadaDate)=4 and  Year(DAMas.TadaDate)=2022  GROUP BY  convert(Date,DAMas.TadaDate), DAMas.EmpInfoId, DATENAME(DW,DAMas.TadaDate), mr.MarketName, st.StationTypeName, format(DAMas.TadaDate,'MMMM, yyyy')  )tblDA    ON  tblDA.EmpInfoId= EmpMas.EmpInfoId 

 
LEFT JOIN (SELECT convert(Date,milMas.MileageDate) MilDate,   milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.AllowedMileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'  and  MONTH(milMas.MileageDate)=4 and  Year(milMas.MileageDate)=2022   GROUP BY convert(Date,milMas.MileageDate),  milMas.EmpInfoId )tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId  

LEFT JOIN (SELECT  convert(Date,EMas.ExpenseDate) ExpDate, EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
 inner join View_Webapi_EmployeeFieldForceInfo   on EMas.EmpInfoId=View_Webapi_EmployeeFieldForceInfo.EmpInfoId
 where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2' and  MONTH(EMas.ExpenseDate)=4 and  Year(EMas.ExpenseDate)=2022  GROUP BY  convert(Date,EMas.ExpenseDate),EMas.EmpInfoId,DAY(EMas.ExpenseDate),Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId 



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
WHERE EmpMas.EmpInfoId is not null   
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))) as  tblt on (tblt.daDate_=CONVERT(Date,cal.YourDate) )


  
 
option (maxrecursion 0)

 end