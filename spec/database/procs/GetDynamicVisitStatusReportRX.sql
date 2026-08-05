CREATE PROCEDURE [dbo].[GetDynamicVisitStatusReportRX]
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
	@TeritorySelect  nvarchar(Max),
	@EmpID  nvarchar(Max),
	@Brand   nvarchar(Max)

AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)

  if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT distinct * FROM (
      select  doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name], mas.TerritoryCode_RX  [Territory] , emp.EmpMasterCode +'' (''+ emp.EmpName +'')'' [User Code], pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,    isnull((  dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId

   left join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 left join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 left join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 left join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 
     where   pro.ProductGroupId=1 and  convert(date, mas.PrescriptionDate) between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')          and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )  and mas.DoctorType_RX= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorType_RX )   and dcrDtl.ProductId= COALESCE( NULLIF('''+ @ProID+''' , '''') ,dcrDtl.ProductId )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
          and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   and emp.EmpInfoId= COALESCE( NULLIF('''+@EmpID+''' , '''') ,emp.EmpInfoId) and pro.ProductBrandId= COALESCE( NULLIF('''+@Brand+''' , '''') ,pro.ProductBrandId)     ) StudentResults
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
      select  doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name], mas.TerritoryCode_RX  [Territory] , emp.EmpMasterCode +'' (''+ emp.EmpName +'')'' [User Code], pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,    isnull((  dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId

   left join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 left join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 left join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 left join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 
  where   pro.ProductGroupId=1 and  convert(date, mas.PrescriptionDate) between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')          and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )  and mas.DoctorType_RX= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorType_RX )   and dcrDtl.ProductId= COALESCE( NULLIF('''+ @ProID+''' , '''') ,dcrDtl.ProductId )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
          and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   and emp.EmpInfoId= COALESCE( NULLIF('''+@EmpID+''' , '''') ,emp.EmpInfoId)   and pro.ProductBrandId= COALESCE( NULLIF('''+@Brand+''' , '''') ,pro.ProductBrandId) 
    and  mas.ApprovalStatus='+@ApprovalStatus+'        ) StudentResults
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
 