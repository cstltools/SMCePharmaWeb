
CREATE

 PROCEDURE [dbo].[sp_Get_MonthlyExpenseEmpWiseMaster_Final]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max) ,
	@EmpId nvarchar(max) 


AS
BEGIN 
DECLARE @tblDADateTemp TABLE (DaDate Date)
INSERT @tblDADateTemp(DaDate)
select  CONVERT(Date,tblDA.TadaDate)  from  tbl_TadaClaimMaster tblDA 
inner join  [dbo].[DateRange_To_TableByMonthYear](@Month, @Year) tblDatte on CONVERT(Date,tblDA.TadaDate)= CONVERT(Date, tblDatte.DateString) 

where tblDA.EmpInfoId=@EmpId and tblDA.ApprovalStatus='2'

declare @marCo nvarchar(max)
declare @RoleType nvarchar(max)

select @RoleType=rt.RoleType from   tblUser  us  
  inner join  tbl_UserRoleInfo  usrl on us.UserRoleID=usrl.UserRoleID
inner join  tblRoleType  rt on usrl.RoleTypeId=rt.RoleTypeId  where us.EmpInfoId=@EmpId


if(@RoleType='MIO')
begin
select @marCo=Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId and M.IsActive=1
							   order by M.MIOId desc

							   
							   if(@marCo is null)
begin 
select @marCo=Tr.TerritoryCode 
                 FROM    dbo.tblMIOInfo AS M LEFT OUTER JOIN
                              dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId  
							   order by M.MIOId desc
end


							   end


							   if(@RoleType='AM')
begin
select @marCo=Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  Ar.isactive=1  and AM.EmployeeId=@EmpId and AM.IsActive=1
							   order by AM.ASMId desc

							   if(@marCo is null)
begin 
select @marCo=Ar.AreaCode 
                 FROM    dbo.tblASMInfo AS AM LEFT OUTER JOIN
                              dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
                 WHERE  Ar.isactive=1  and AM.EmployeeId=@EmpId  
							   order by AM.ASMId desc
end
							   end

 


 		   if(@RoleType='DZSM')
begin
select @marCo=rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   rg.IsActive=1  and RM.EmployeeId=@EmpId and RM.IsActive=1
							   order by RM.RSMId desc

							     if(@marCo is null)
begin 
select @marCo=rg.RegionCode 
                 FROM    dbo.tblRSMInfo AS RM LEFT OUTER JOIN
                              dbo.tblRegion AS rg ON RM.RegionId = rg.RegionId
                 WHERE   rg.IsActive=1  and RM.EmployeeId=@EmpId  
							   order by RM.RSMId desc
end


							   end

							 
if(@RoleType='NSM')
begin
select @marCo=Tr.GroupCode 
                 FROM    dbo.tblNSMInfo AS M LEFT OUTER JOIN
                              dbo.tbl_Group AS Tr ON M.GroupId = Tr.GroupId  where  
							   tr.isactive=1  and M.EmployeeId=@EmpId
							   order by M.NSMId desc
							   end

  

select * from (select   * from (
 select  CONVERT(Date,tblDA.TadaDate) MainDate_,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when rt.RoleType='NSM' then  tblDA.GroupName  when rt.RoleType='DZSM' then tblDA.RegionName when rt.RoleType='AM'   then  tblDA.AreaName when rt.RoleType='MIO'   then tblDA.TerritoryName else ''  end  BaseHQ ,  @marCo MarketCode,tblDA.RegionCode_DA ZoneCode, FORMAT(tblDA.TadaDate, 'MMMM, yyyy')   MonthYear, FORMAT(tblDA.TadaDate, 'dd, ddd')  DAdate,  tblDA.MarketName,st.StationTypeName TourType, floor( ISNULL(tblDA.DAAmount,0)) daAmount , ISNULL(tblMilag.AllowedMileageInKM,0) AllowedMileageInKM, ISNULL(tblMilag.MilageExpense,0) mileageAmount, floor( ISNULL(tblExpense.ExpenseAmount,0)) expenseAmount, ISNULL(tblDA.DAAmount,0)  + ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExpense.ExpenseAmount,0) totalAmount  FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId
  inner join  tblUser  us on us.EmpInfoId=EmpMas.EmpInfoId
  inner join  tbl_UserRoleInfo  usrl on us.UserRoleID=usrl.UserRoleID
inner join  tblRoleType  rt on usrl.RoleTypeId=rt.RoleTypeId
inner join  tbl_TadaClaimMaster  tblDA on EmpMas.EmpInfoId=tblDA.EmpInfoId and tblDA.ApprovalStatus='2'
   left join tblStationType st  WITH (NOLOCK) on   tblDA.TourTypeId=st.StationTypeId
inner join  [dbo].[DateRange_To_TableByMonthYear](@Month, @Year) tblDatte on CONVERT(Date,tblDA.TadaDate)= CONVERT(Date, tblDatte.DateString) 



LEFT JOIN (SELECT  convert(Date,milMas.MileageDate)  MileageDate ,  milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.MileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'   GROUP BY  convert(Date,milMas.MileageDate),  milMas.EmpInfoId )tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId     and CONVERT(Date, tblDatte.DateString) =tblMilag.MileageDate


LEFT JOIN (SELECT  convert(Date,EMas.ExpenseDate) ExpenseDate,EMas.EmpInfoId, SUM(ISNULL(EMas.Amount,0)  )   ExpenseAmount    FROM dbo.tbl_ExpenseClaim EMas  WITH (NOLOCK)
  where  EMas.ExpenseClaimID is not null    and  EMas.ApprovalStatus='2'   GROUP BY  convert(Date,EMas.ExpenseDate), EMas.EmpInfoId )tblExpense    ON  tblExpense.EmpInfoId= EmpMas.EmpInfoId    and tblExpense.ExpenseDate=CONVERT(Date, tblDatte.DateString) 


where MONTH(tblDA.TadaDate)=@Month and year(tblDA.TadaDate)=@Year and EmpMas.EmpInfoId=@EmpId) tbl_DA


union all

select * from (
 select  CONVERT(Date,tblExp.ExpenseDate) MainDate_,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, ''  BaseHQ ,  @marCo MarketCode,'' ZoneCode, FORMAT(tblExp.ExpenseDate, 'MMMM, yyyy')   MonthYear, FORMAT(tblExp.ExpenseDate, 'dd, ddd')  DAdate,  '' MarketName,'' TourType, 0 daAmount , ISNULL(tblMilag.AllowedMileageInKM,0) AllowedMileageInKM, ISNULL(tblMilag.MilageExpense,0) mileageAmount, floor( ISNULL(tblExp.Amount,0)) expenseAmount,   ISNULL(tblMilag.MilageExpense,0) +ISNULL(tblExp.Amount,0) totalAmount  FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId
  inner join  tblUser  us on us.EmpInfoId=EmpMas.EmpInfoId
  inner join  tbl_UserRoleInfo  usrl on us.UserRoleID=usrl.UserRoleID
inner join  tblRoleType  rt on usrl.RoleTypeId=rt.RoleTypeId
inner join  tbl_ExpenseClaim  tblExp on EmpMas.EmpInfoId=tblExp.EmpInfoId and tblExp.ApprovalStatus='2'
  
inner join  [dbo].[DateRange_To_TableByMonthYear](@Month, @Year) tblDatte on CONVERT(Date,tblExp.ExpenseDate)= CONVERT(Date, tblDatte.DateString) 



LEFT JOIN (SELECT  convert(Date,milMas.MileageDate)  MileageDate ,  milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.MileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'   GROUP BY  convert(Date,milMas.MileageDate),  milMas.EmpInfoId )tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId     and CONVERT(Date,tblExp.ExpenseDate) =tblMilag.MileageDate

 


where MONTH(tblExp.ExpenseDate)=@Month and year(tblExp.ExpenseDate)=@Year and EmpMas.EmpInfoId=@EmpId) tbl_Exp  where tbl_Exp.MainDate_  not in (select * FROM @tblDADateTemp)


union all

select * from (
 select  CONVERT(Date,tblMilag.MileageDate) MainDate_,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when rt.RoleType='NSM' then  tblMilag.GroupName   when rt.RoleType='DZSM' then tblMilag.RegionName when rt.RoleType='AM'   then  tblMilag.AreaName when rt.RoleType='MIO'   then tblMilag.TerritoryName else ''  end  BaseHQ ,  @marCo MarketCode,tblMilag.RegionCode_Mil ZoneCode, FORMAT(tblMilag.MileageDate, 'MMMM, yyyy')   MonthYear, FORMAT(tblMilag.MileageDate, 'dd, ddd')  DAdate, tblMilag.MarketName MarketName,'' TourType, 0 daAmount , SUM(ISNULL(tblMilag.MileageInKM,0))  AllowedMileageInKM, CONVERT(DECIMAL(10,2),SUM(ISNULL(tblMilag.MileageInKM,0)  * ISNULL(tblMilag.AllowedMileageInKM,0)) ) mileageAmount, 0 expenseAmount,    CONVERT(DECIMAL(10,2),SUM(ISNULL(tblMilag.MileageInKM,0)  * ISNULL(tblMilag.AllowedMileageInKM,0)) ) totalAmount  FROM dbo.tblEmpGeneralInfo EmpMas  WITH (NOLOCK)
  left join tblDesignation dgs   WITH (NOLOCK) on EmpMas.DesignationId=dgs.DesignationId
  inner join  tblUser  us on us.EmpInfoId=EmpMas.EmpInfoId
  inner join  tbl_UserRoleInfo  usrl on us.UserRoleID=usrl.UserRoleID
inner join  tblRoleType  rt on usrl.RoleTypeId=rt.RoleTypeId
inner join  tbl_MileageClaim  tblMilag on EmpMas.EmpInfoId=tblMilag.EmpInfoId and tblMilag.ApprovalStatus='2'
  
inner join  [dbo].[DateRange_To_TableByMonthYear](@Month, @Year) tblDatte on CONVERT(Date,tblMilag.MileageDate)= CONVERT(Date, tblDatte.DateString) 



--LEFT JOIN (SELECT  convert(Date,milMas.MileageDate)  MileageDate ,  milMas.EmpInfoId, CONVERT(DECIMAL(10,2),SUM(ISNULL(milMas.MileageInKM,0)  * ISNULL(milMas.AllowedMileageInKM,0)) ) MilageExpense, SUM(ISNULL(milMas.MileageInKM,0)) AllowedMileageInKM FROM dbo.tbl_MileageClaim milMas  WITH (NOLOCK) where milMas.MileageClaimId is not null   and  milMas.ApprovalStatus='2'   GROUP BY  convert(Date,milMas.MileageDate),  milMas.EmpInfoId )tblMilag    ON  tblMilag.EmpInfoId= EmpMas.EmpInfoId     and CONVERT(Date,tblExp.ExpenseDate) =tblMilag.MileageDate

 


where MONTH(tblMilag.MileageDate)=@Month and year(tblMilag.MileageDate)=@Year and EmpMas.EmpInfoId=@EmpId   

group by CONVERT(Date,tblMilag.MileageDate)  ,  EmpMas.EmpInfoId, EmpMas.EmpMasterCode, EmpMas.EmpName, dgs.DesigName, case when rt.RoleType='NSM' then  tblMilag.GroupName   when rt.RoleType='DZSM' then tblMilag.RegionName when rt.RoleType='AM'   then  tblMilag.AreaName when rt.RoleType='MIO'   then tblMilag.TerritoryName else ''  end    ,  case when rt.RoleType='NSM' then  tblMilag.GroupCode_Mil  when rt.RoleType='DZSM' then tblMilag.RegionCode_Mil when rt.RoleType='AM'   then  tblMilag.AreaCode_Mil when rt.RoleType='MIO'   then tblMilag.TerritoryCode_Mil else ''  end  ,tblMilag.RegionCode_Mil  , FORMAT(tblMilag.MileageDate, 'MMMM, yyyy')    , FORMAT(tblMilag.MileageDate, 'dd, ddd')   , tblMilag.MarketName  
) tbl_Mil  where tbl_Mil.MainDate_  not in (select * FROM @tblDADateTemp)

)tblMy order by tblMy.MainDate_ asc

 end