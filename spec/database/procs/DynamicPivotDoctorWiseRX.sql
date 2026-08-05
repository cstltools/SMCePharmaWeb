CREATE PROCEDURE [dbo].[DynamicPivotDoctorWiseRX]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max),
	  @ProviderType NVARCHAR(max),
	  @PharmaPlatform NVARCHAR(max)
AS
BEGIN
 --STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS Degree,ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''')  as [Speciality], pt.ProgramTypeName [Provider Type],dt.DoctorTypeName [Doctor Type], gr.GroupCode [Group Code],  gr.GroupName [Group Name],rg.RegionCode [Zone Code],rg.RegionName  [Zone Name],Ar.AreaCode [Area Code],Ar.AreaName [Area Name],Tr.TerritoryCode [Territory Code],Tr.TerritoryName [Territory Name],subTr.SubTerritoryCode [Sub-Territory Code],subTr.SubTerritoryName [Sub-Territory Name],mr.MarketCode [Market Code],mr.MarketName [Market Name]
  DECLARE @SqlStatement NVARCHAR(MAX)
   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
 select      mas.DoctorId, CONVERT(date,mas.PrescriptionDate)  DcrDate,  doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name],STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS [Degree Name],ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''') as [Doctor Speciality], pt.ProgramTypeName [Provider Type] ,mas.SMCType_RX [Pharma Platform],dt.DoctorTypeName [Doctor Type] ,  mas.GroupCode_RX [Group], mas.RegionCode_RX   [Region],mas.AreaCode_RX  [Area],mas.TerritoryCode_RX  [Territory] ,mas.MarketCode_RX   [Market] from tbl_PrescriptionMaster mas   WITH (NOLOCK) 
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId
  
  
 

  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'    and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX)
    ) StudentResults
    PIVOT (
          count(DoctorId)
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
 select      mas.DoctorId, CONVERT(date,mas.PrescriptionDate)  DcrDate,  doc.DoctorCode [Doctor Code],    doc.DoctorName [Doctor Name],STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS [Degree Name],ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''') as [Doctor Speciality], pt.ProgramTypeName [Provider Type] ,mas.SMCType_RX [Pharma Platform],dt.DoctorTypeName [Doctor Type] ,  mas.GroupCode_RX [Group], mas.RegionCode_RX   [Region],mas.AreaCode_RX  [Area],mas.TerritoryCode_RX  [Territory] ,mas.MarketCode_RX   [Market] from tbl_PrescriptionMaster mas   WITH (NOLOCK) 
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId
  
  
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'
      and  mas.ApprovalStatus='+@ApprovalStatus+'   and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) ) StudentResults
    PIVOT (
          count(DoctorId)
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 

end
  EXEC(@SqlStatement)
 
END
 