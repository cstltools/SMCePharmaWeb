CREATE PROCEDURE [dbo].[DynamicPivotUserWiseDCP]
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
     select emp.EmpMasterCode  +'' - ''+  emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  doc.RegionCode_DV [Region],   doc.TerritoryCode_DV   [Territory],   CONVERT(date,doc.TourPlanDate)  DcrDate,  isnull((mas.EmpInfoId),0) ProductQty   from tbl_DoctorTourPlanMaster mas    WITH (NOLOCK) 
  inner join tbl_DoctorTourPlanDetail doc  WITH (NOLOCK)    on mas.DocTPMaster=DOC.DocTPMaster
  inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on mas.EmpInfoId=emp.EmpInfoId
 inner join  tblUser usr WITH (NOLOCK)    on mas.EmpInfoId=usr.EmpInfoId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
  where   convert(date,doc.TourPlanDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
        and doc.DoctorProgramypeId_DV= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,doc.DoctorProgramypeId_DV )   and doc.SMCTypeId_DV= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,doc.SMCTypeId_DV)  and doc.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,doc.RegionId)   and doc.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,doc.AreaId) and doc.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,doc.TerritoryId)  
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
       select emp.EmpMasterCode  +'' - ''+  emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  doc.RegionCode_DV [Region],   doc.TerritoryCode_DV   [Territory],   CONVERT(date,doc.TourPlanDate)  DcrDate,  isnull((mas.EmpInfoId),0) ProductQty   from tbl_DoctorTourPlanMaster mas    WITH (NOLOCK) 
  inner join tbl_DoctorTourPlanDetail doc  WITH (NOLOCK)    on mas.DocTPMaster=DOC.DocTPMaster
  inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on mas.EmpInfoId=emp.EmpInfoId
 inner join  tblUser usr WITH (NOLOCK)    on mas.EmpInfoId=usr.EmpInfoId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
  where   convert(date, doc.TourPlanDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
        and  case when mas.ApprovalStatus=''Pending''   then ''0'' else mas.ApprovalStatus end='+@ApprovalStatus+'    and doc.DoctorProgramypeId_DV= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,doc.DoctorProgramypeId_DV )   and doc.SMCTypeId_DV= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,doc.SMCTypeId_DV)  and doc.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,doc.RegionId)   and doc.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,doc.AreaId) and doc.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,doc.TerritoryId)   ) StudentResults
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
 