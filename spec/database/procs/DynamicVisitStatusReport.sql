CREATE PROCEDURE [dbo].[DynamicVisitStatusReport]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max),
	  @ProviderType NVARCHAR(max),
	  @PharmaPlatform NVARCHAR(max),
	@ZoneSelect  nvarchar(Max),
	@AreaSelect  nvarchar(Max),
	@TeritorySelect  nvarchar(Max),
	@EmpID  nvarchar(Max),
	@DoctorTypeSelect  nvarchar(Max),
	@Brand  nvarchar(Max)

AS
BEGIN
 --STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS Degree,ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''')  as [Speciality], pt.ProgramTypeName [Provider Type],dt.DoctorTypeName [Doctor Type], gr.GroupCode [Group Code],  gr.GroupName [Group Name],rg.RegionCode [Zone Code],rg.RegionName  [Zone Name],Ar.AreaCode [Area Code],Ar.AreaName [Area Name],Tr.TerritoryCode [Territory Code],Tr.TerritoryName [Territory Name],subTr.SubTerritoryCode [Sub-Territory Code],subTr.SubTerritoryName [Sub-Territory Name],mr.MarketCode [Market Code],mr.MarketName [Market Name]
  DECLARE @SqlStatement NVARCHAR(MAX)
   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
 select  distinct     doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name], mas.TerritoryCode_DCR  [Territory] , emp.EmpMasterCode +'' (''+ emp.EmpName +'')'' [User Code], pro.ProductCode [Product Code], pro.ProductName [Product Name],    CONVERT(date,mas.DcrDate)  DcrDate,    isnull((  dcrDtl.ProductId),0) ProductQty   from tbl_DCRInfo mas   WITH (NOLOCK) 
 inner join  tbl_DcrDetails dcrDtl WITH (NOLOCK)    on mas.DcrId=dcrDtl.DcrId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId
 left join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 left join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 left join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 left join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 

  where  pro.ProductGroupId = 1 and convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')   and mas.SMCType_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_DCR )   and pt.ProgramTypeName= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,pt.ProgramTypeName )    and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   and emp.EmpInfoId= COALESCE( NULLIF('''+@EmpID+''' , '''') ,emp.EmpInfoId)   and pro.ProductBrandId= COALESCE( NULLIF('''+@Brand+''' , '''') ,pro.ProductBrandId)     and mas.DoctorTypeID_DCR= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorTypeID_DCR )
    ) StudentResults
    PIVOT (
          count(ProductQty)
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
  select  distinct     doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name], mas.TerritoryCode_DCR  [Territory] , emp.EmpMasterCode +'' (''+ emp.EmpName +'')'' [User Code], pro.ProductCode [Product Code], pro.ProductName [Product Name],    CONVERT(date,mas.DcrDate)  DcrDate,    isnull((  dcrDtl.ProductId),0) ProductQty   from tbl_DCRInfo mas   WITH (NOLOCK) 
 inner join  tbl_DcrDetails dcrDtl WITH (NOLOCK)    on mas.DcrId=dcrDtl.DcrId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId
 left join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 left join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 left join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 left join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
 
  where    pro.ProductGroupId = 1 and convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')   and mas.SMCType_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_DCR )   and pt.ProgramTypeName= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,pt.ProgramTypeName )    and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   and emp.EmpInfoId= COALESCE( NULLIF('''+@EmpID+''' , '''') ,emp.EmpInfoId)   and pro.ProductBrandId= COALESCE( NULLIF('''+@Brand+''' , '''') ,pro.ProductBrandId)     and mas.DoctorTypeID_DCR= COALESCE( NULLIF('''+ @DoctorTypeSelect+''' , '''') ,mas.DoctorTypeID_DCR )  and mas.ApprovalStatus='+@ApprovalStatus+'  ) StudentResults
    PIVOT (
          count(ProductQty)
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 

end
  EXEC(@SqlStatement)
 
END
 