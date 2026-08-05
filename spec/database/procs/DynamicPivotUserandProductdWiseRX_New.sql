CREATE PROCEDURE [dbo].[DynamicPivotUserandProductdWiseRX_New]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max),
	  @ProviderType NVARCHAR(max),
	  @PharmaPlatform NVARCHAR(max),
	  @DoctorTypeSelect  NVARCHAR(max),
	  @ProID  NVARCHAR(max),
	@ZoneSelect  nvarchar(Max),
	@AreaSelect  nvarchar(Max),
	@TeritorySelect  nvarchar(Max)

AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)

  if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT distinct * FROM (
     select emp.EmpMasterCode [Employee ID], emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name], pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId

   inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 
  where convert(date, mas.PrescriptionDate) between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')          and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )  and mas.DoctorType_RX= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorType_RX )   and dcrDtl.ProductId= COALESCE( NULLIF('''+ @ProID+''' , '''') ,dcrDtl.ProductId )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
          and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)     ) StudentResults
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
     SELECT distinct * FROM (
     select emp.EmpMasterCode [Employee ID], emp.EmpName+'' (''+usrRT.RoleType+'')'' [Employee Name], pro.ProductCode [Product Code], pro.ProductName [Product Name],      CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId

   inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 
  where convert(date, mas.PrescriptionDate) between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')          and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and dcrDtl.ProductId= COALESCE( NULLIF('''+ @ProID+''' , '''') ,dcrDtl.ProductId )  and mas.DoctorType_RX= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorType_RX )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
    and  mas.ApprovalStatus='+@ApprovalStatus+'      and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)     ) StudentResults
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
 