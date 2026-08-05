CREATE PROCEDURE [dbo].[DynamicPivotUserWiseDCR]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max),
	  @ProviderType NVARCHAR(max),
	  @PharmaPlatform NVARCHAR(max),
	@ZoneSelect  nvarchar(Max),
	@AreaSelect  nvarchar(Max),
	@TeritorySelect  nvarchar(Max)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)

   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
     select emp.EmpMasterCode  +'' - ''+  emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  mas.RegionCode_Dcr [Region],   mas.TerritoryCode_DCR   [Territory],   CONVERT(date,mas.DcrDate)  DcrDate,  isnull((mas.EntryBy),0) ProductQty   from tbl_DCRInfo mas    WITH (NOLOCK) 
 inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 -- inner join View_Webapi_EmployeeFieldForceInfo EFF  WITH (NOLOCK) on emp.EmpInfoId=EFF.EmpInfoId 
  where  convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
         and mas.DoctorProgramypeId= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,mas.DoctorProgramypeId )   and mas.SmcTypeId_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SmcTypeId_DCR)  and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)  
    ) StudentResults
    PIVOT (
      count([ProductQty])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 

 end 
 else

 begin
  SET @SqlStatement = N'
    SELECT * FROM (
     select emp.EmpMasterCode  +'' - ''+  emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  mas.RegionCode_Dcr [Region],   mas.TerritoryCode_DCR   [Territory],    CONVERT(date,mas.DcrDate)  DcrDate,  isnull((mas.EntryBy),0) ProductQty   from tbl_DCRInfo mas    WITH (NOLOCK) 
 inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
  
  where  convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
       
     and  mas.ApprovalStatus='+@ApprovalStatus+'    and mas.DoctorProgramypeId= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,mas.DoctorProgramypeId )   and mas.SmcTypeId_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SmcTypeId_DCR)  and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   ) StudentResults
    PIVOT (
      count([ProductQty])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 
 end
  EXEC(@SqlStatement)
 
END
 