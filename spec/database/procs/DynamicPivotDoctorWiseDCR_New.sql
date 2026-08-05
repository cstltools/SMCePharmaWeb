CREATE PROCEDURE [dbo].[DynamicPivotDoctorWiseDCR_New]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max),
	@ApprovalStatus  nvarchar(Max)
AS
BEGIN
 --STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS Degree,ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''')  as [Speciality], pt.ProgramTypeName [Provider Type],dt.DoctorTypeName [Doctor Type], gr.GroupCode [Group Code],  gr.GroupName [Group Name],rg.RegionCode [Zone Code],rg.RegionName  [Zone Name],Ar.AreaCode [Area Code],Ar.AreaName [Area Name],Tr.TerritoryCode [Territory Code],Tr.TerritoryName [Territory Name],subTr.SubTerritoryCode [Sub-Territory Code],subTr.SubTerritoryName [Sub-Territory Name],mr.MarketCode [Market Code],mr.MarketName [Market Name]
  DECLARE @SqlStatement NVARCHAR(MAX)
   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
 select DoctorId,DcrDate ,[Doctor Code],  [Doctor Name], [Doctor Speciality],[Provider Type], [Pharma Platform], [Doctor Type],[Group],[Region],[Area],[Territory],[Market] from   View_DCR mas with (nolock)
  
  
 

  where Month(mas.DcrDate)='+@Month+' and Year(mas.DcrDate)='+@Year+'
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
  select DoctorId,DcrDate ,[Doctor Code],  [Doctor Name], [Doctor Speciality],[Provider Type], [Pharma Platform], [Doctor Type],[Group],[Region],[Area],[Territory],[Market] from   View_DCR mas with (nolock)
  
  
 
  where Month(mas.DcrDate)='+@Month+' and Year(mas.DcrDate)='+@Year+'
      and  mas.ApprovalStatus='+@ApprovalStatus+'  ) StudentResults
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
 