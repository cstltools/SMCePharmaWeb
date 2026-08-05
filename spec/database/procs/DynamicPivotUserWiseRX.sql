CREATE PROCEDURE [dbo].[DynamicPivotUserWiseRX]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max),
	  @ProviderType NVARCHAR(max),
	  @PharmaPlatform NVARCHAR(max)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
     select emp.EmpMasterCode +'' - ''+ emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  EFF.RegionCode,  case when usrRT.RoleTypeId=4   then EFF.GroupCode when usrRT.RoleTypeId=3  then  EFF.RegionCode when usrRT.RoleTypeId=2  then  EFF.AreaCode   else EFF.TerritoryCode end TerritoryCode,   CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((mas.EntryBy),0) ProductQty   from tbl_PrescriptionMaster mas    WITH (NOLOCK) 
	  left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
  inner join View_Webapi_EmployeeFieldForceInfo EFF  WITH (NOLOCK) on emp.EmpInfoId=EFF.EmpInfoId 
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'  and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
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
     select emp.EmpMasterCode +'' - ''+ emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name],  EFF.RegionCode [Region Code],  case when usrRT.RoleTypeId=4   then EFF.GroupCode when usrRT.RoleTypeId=3  then  EFF.RegionCode when usrRT.RoleTypeId=2  then  EFF.AreaCode   else EFF.TerritoryCode end [Territory Code],   CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((mas.EntryBy),0) ProductQty   from tbl_PrescriptionMaster mas    WITH (NOLOCK) 
	  left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
  inner join View_Webapi_EmployeeFieldForceInfo EFF  WITH (NOLOCK) on emp.EmpInfoId=EFF.EmpInfoId 
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'
      and  mas.ApprovalStatus='+@ApprovalStatus+' and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX)   ) StudentResults
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
 