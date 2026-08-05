

CREATE

 PROCEDURE [dbo].[sp_Get_MonthlyExpenseEmpWiseMaster]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
select distinct * from (

SELECT   MainDate_,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode,vv.RegionCode ZoneCode, TadaDateMonthYear MonthYear, CAST(tblDA.TadaDate as nvarchar(max))+ ', '+tblDA.DayNameVal DAdate,  tblDA.MarketName,tblDA.TourType, floor( ISNULL(tblDA.DAAmount,0)) daAmount , ISNULL(tblMilag.AllowedMileageInKM,0) AllowedMileageInKM, ISNULL(tblMilag.MilageExpense,0) mileageAmount, floor( ISNULL(tblExpense.ExpenseAmount,0)) expenseAmount, ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0) totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId

  --da date join 
LEFT JOIN (SELECT convert(Date,DAMas.TadaDate) MainDate_, mr.MarketName,st.StationTypeName  TourType, Month(DAMas.TadaDate) TadaDateMonth,Year(DAMas.TadaDate) TadaDateYear, format(DAMas.TadaDate,'MMMM, yyyy') TadaDateMonthYear , DAY(DAMas.TadaDate) TadaDate,   DATENAME(DW,DAMas.TadaDate) DayNameVal , DAMas.EmpInfoId, SUM(ISNULL(ISNULL(DAMas.DAAmount,0),0)) DAAmount  FROM dbo.tbl_TadaClaimMaster DAMas WITH (NOLOCK)
 
   
   left join tblMarket mr  WITH (NOLOCK) on   DAMas.MarketId=mr.MarketId
   left join tblStationType st  WITH (NOLOCK) on   DAMas.TourTypeId=st.StationTypeId
where DAMas.TadaID is not null  and  DAMas.ApprovalStatus='2' GROUP BY  convert(Date,DAMas.TadaDate),DAMas.EmpInfoId, DAY(DAMas.TadaDate), DATENAME(DW,DAMas.TadaDate), mr.MarketName, st.StationTypeName, Month(DAMas.TadaDate) ,Year(DAMas.TadaDate),format(DAMas.TadaDate,'MMMM, yyyy')  )tblDA    ON  tblDA.EmpInfoId= EmpMas.EmpInfoId 
 

LEFT JOIN (SELECT Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate, DAY(milMas.MileageDate) TadaDate, milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.MileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'   GROUP BY   milMas.EmpInfoId,DAY(milMas.MileageDate),Month(milMas.MileageDate),Year(milMas.MileageDate))tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId   and MonthMileageDate=TadaDateMonth and YearMileageDate=TadaDateYear and tblDA.TadaDate=tblMilag.TadaDate


LEFT JOIN (SELECT  DAY(EMas.ExpenseDate) TadaDate,EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount, Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
  where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2'   GROUP BY  EMas.EmpInfoId,DAY(EMas.ExpenseDate),Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId  and ExpenseDateMont=TadaDateMonth and ExpenseDateYear=TadaDateYear and tblExpense.TadaDate=tblDA.TadaDate

 --da date join end

 left   JOIN
                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
                 WHERE (N.IsActive = 1) ) AS NSM ON NSM.EmployeeId = EmpMas.EmpInfoId


   LEFT OUTER JOIN
                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   RM.IsBase=1) AS RSM ON EmpMas.EmpInfoId = RSM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  AM.IsBaseAM=1) AS ASM ON EmpMas.EmpInfoId = ASM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT    M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where --M.isactive=1  and
							   tr.isactive=1
                 ) AS MIO ON EmpMas.EmpInfoId = MIO.EmployeeId 


				 inner join View_Webapi_EmployeeFieldForceInfo_Top1 vv on vv.EmpInfoId=EmpMas.EmpInfoId
WHERE EmpMas.EmpInfoId is not null  and  ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0)>0   and tblDA.TadaDateMonth=@Month and tblDA.TadaDateYear=@Year
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))

union all
SELECT   distinct ExpenseDate_ MainDate_, EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode,vv.RegionCode ZoneCode, FORMAT(ExpenseDate_,'MMMM, yyyy') MonthYear, CAST( tblExpense.TadaDate as nvarchar(max))+ ', '+tblExpense.ExpenseMonthVal DAdate,   '' MarketName,'' TourType, 0 daAmount , 0 AllowedMileageInKM, 0 mileageAmount, floor( ISNULL(tblExpense.ExpenseAmount,0)) expenseAmount, ISNULL(0,0)  + 0 +ISNULL(tblExpense.ExpenseAmount,0) totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId


  LEFT JOIN (SELECT convert(Date,EMas.ExpenseDate) ExpenseDate_, DATENAME(DW,EMas.ExpenseDate) ExpenseMonthVal,  DAY(EMas.ExpenseDate) TadaDate,EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount, Month(EMas.ExpenseDate) ExpenseDateMont  ,Year(EMas.ExpenseDate)  ExpenseDateYear  FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK) where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2'   and CONVERT(Date,EMas.ExpenseDate) not in (select * from  (select  convert(Date,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1))) mainDate  
from    (
         select top 31 ROW_NUMBER() over (order by a.object_id) as n
         from   sys.all_objects a
      ) a
	  
	  
	   where   DATEPART(mm,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1)))=@Month   ) tblx where convert(date,tblx.mainDate)  in 
	   (select distinct convert(date,TadaDate)   from tbl_TadaClaimMaster  where tbl_TadaClaimMaster.ApprovalStatus='2'  and MONTH(TadaDate)=@Month  and EmpInfoId in( select * from fnSplit(@EmpId,','))  ))    GROUP BY convert(Date,EMas.ExpenseDate), DATENAME(DW,EMas.ExpenseDate), EMas.EmpInfoId,DAY(EMas.ExpenseDate),Month(EMas.ExpenseDate)    ,Year(EMas.ExpenseDate))tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId  and ExpenseDateMont=@Month and ExpenseDateYear=@Year 
  --da date join 
  
 
  




 --da date join end

 left   JOIN
                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.EmployeeId = EmpMas.EmpInfoId


   LEFT OUTER JOIN
                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   RM.IsBase=1) AS RSM ON EmpMas.EmpInfoId = RSM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  AM.IsBaseAM=1) AS ASM ON EmpMas.EmpInfoId = ASM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT    M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId where    Tr.isactive=1 --and  m.isactive=1 
                ) AS MIO ON EmpMas.EmpInfoId = MIO.EmployeeId 

				 
				 inner join View_Webapi_EmployeeFieldForceInfo_Top1 vv on vv.EmpInfoId=EmpMas.EmpInfoId
WHERE EmpMas.EmpInfoId is not null       and ISNULL(tblExpense.ExpenseAmount,0)>0   
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))


union all

SELECT   distinct  MileageDate_ MainDate_,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when NSM.GroupName is not null then NSM.GroupName when RSM.RegionName is not null then  RSM.RegionName when ASM.AreaName is not null then  ASM.AreaName  else MIO.TerritoryName end  BaseHQ , case when NSM.GroupCode is not null then NSM.GroupCode when RSM.RegionCode is not null then  RSM.RegionCode when ASM.AreaCode is not null then  ASM.AreaCode   else MIO.TerritoryCode end MarketCode,vv.RegionCode ZoneCode, FORMAT(MileageDate_,'MMMM, yyyy') MonthYear, CAST( tblMilag.MonthMileageDate as nvarchar(max))+', '+tblMilag.MileageMonthVal DAdate,   '' MarketName,'' TourType, 0 daAmount , tblMilag.AllowedMileageInKM AllowedMileageInKM, 0 mileageAmount, 0 expenseAmount, ISNULL(0,0)  + 0 +ISNULL(tblMilag.MilageExpense,0) totalAmount FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId


  LEFT JOIN (SELECT convert(Date,milMas.MileageDate) MileageDate_, DATENAME(DW,milMas.MileageDate) MileageMonthVal,  Month(milMas.MileageDate) MonthMileageDate ,Year(milMas.MileageDate) YearMileageDate, DAY(milMas.MileageDate) TadaDate, milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.MileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null  and CONVERT(Date,milMas.MileageDate) not in ((select * from  (select  convert(Date,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1))) mainDate  
from    (
         select top 31 ROW_NUMBER() over (order by a.object_id) as n
         from   sys.all_objects a
      ) a
	  
	  
	   where   DATEPART(mm,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1)))=@Month   ) tblx where convert(date,tblx.mainDate)  in 
	   (select distinct convert(date,TadaDate)   from tbl_TadaClaimMaster  where tbl_TadaClaimMaster.ApprovalStatus='2'  and MONTH(TadaDate)=@Month  and EmpInfoId in( select * from fnSplit(@EmpId,','))  )) )   and  milMas.ApprovalStatus='2'   GROUP BY   convert(Date,milMas.MileageDate), DATENAME(DW,milMas.MileageDate),  milMas.EmpInfoId,DAY(milMas.MileageDate),Month(milMas.MileageDate),Year(milMas.MileageDate))tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId   and MonthMileageDate=@Month and YearMileageDate=@Year  

	    

 --da date join end

 left   JOIN
                 (SELECT N.EmployeeId, grp.GroupName, grp.GroupCode 
                 FROM    dbo.tblNSMInfo AS N LEFT OUTER JOIN
                              dbo.tbl_Group AS grp ON N.GroupId = grp.GroupId
                 WHERE (N.IsActive = 1)) AS NSM ON NSM.EmployeeId = EmpMas.EmpInfoId


   LEFT OUTER JOIN
                 (SELECT RM.EmployeeId, rg.RegionName, rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE  RM.IsBase=1) AS RSM ON EmpMas.EmpInfoId = RSM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT AM.EmployeeId, Ar.AreaName, Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  AM.IsBaseAM=1) AS ASM ON EmpMas.EmpInfoId = ASM.EmployeeId
				 
				  LEFT OUTER JOIN
                 (SELECT   M.EmployeeId, Tr.TerritoryName, Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId where Tr.isactive=1  -- and m.IsActive=1  
                 ) AS MIO ON EmpMas.EmpInfoId = MIO.EmployeeId 

				 
				 inner join View_Webapi_EmployeeFieldForceInfo_Top1 vv on vv.EmpInfoId=EmpMas.EmpInfoId
WHERE EmpMas.EmpInfoId is not null    and ISNULL(tblMilag.MilageExpense,0)>0       
and EmpMas.EmpInfoId in( select * from fnSplit(@EmpId,','))

)tbll
order by  EmpMasterCode, MainDate_  ASC

END