	CREATE PROCEDURE [dbo].[DynamicPivotDWSP]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'SELECT * FROM (
  
 select   Eff.EmpMasterCode+'' : ''+Emp.EmpName [EMP. ID & Name], Eff.TerritoryCode [Territory Code],  dgs.DesigName [Designation], ur.RoleName [Role], CONVERT(date,dtl.DWSPDate) DWSPDate,  ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0) TotalAmount from tbl_DWSPMaster mas  with (nolock)
inner join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
inner join View_Webapi_EmployeeFieldForceInfo Eff   with (nolock)  on Eff.TerritoryId=mas.TerritoryId
inner join tblEmpGeneralInfo Emp   with (nolock)  on Emp.EmpInfoId=Eff.EmpInfoId
inner join tblDesignation dgs   with (nolock)  on Emp.DesignationId=dgs.DesignationId
inner join tblUser us   with (nolock)  on Emp.EmpInfoId=us.EmpInfoId

inner join tbl_UserRoleInfo ur   with (nolock)  on ur.UserRoleID=us.UserRoleID

where Month(dtl.DWSPDate)='+@Month+' and Year(dtl.DWSPDate)='+@Year+'


 

union all

 select  distinct  Eff.EmpMasterCode+'' : ''+Emp.EmpName [EMP. ID & Name], Eff.TerritoryCode [Territory Code],  dgs.DesigName [Designation], ur.RoleName [Role], CONVERT(date, ''01''+''-''+ (mas.Month)+''-''+  (mas.Year))
 DWSPDate,  mas.TargetAmount TotalAmount from tblTerritoryWiseTargetSetup mas  with (nolock) 
inner join View_Webapi_EmployeeFieldForceInfo Eff   with (nolock)  on Eff.TerritoryId=mas.TerritoryId
inner join tblUser us   with (nolock)  on mas.EntryBy=us.UserId

inner join tblEmpGeneralInfo Emp   with (nolock)  on Emp.EmpInfoId=us.EmpInfoId
inner join tblDesignation dgs   with (nolock)  on Emp.DesignationId=dgs.DesignationId

inner join tbl_UserRoleInfo ur   with (nolock)  on ur.UserRoleID=us.UserRoleID
where  (mas.Month)=''July'' and  (mas.Year)=2022

) StudentResults
PIVOT ( SUM(TotalAmount)
  FOR ['+@ColumnToPivot+']
  IN (
    '+@ListToPivot+'
  )
) AS PivotTable  Order BY PivotTable.[Territory Code]';
 
  EXEC(@SqlStatement)
 
END




--Order BY PivotTable.[Territory Code]