CREATE PROCEDURE [dbo].[DynamicPivotDoctorWiseDCPCustomerWise]
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
 --STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS Degree,ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''')  as [Speciality], pt.ProgramTypeName [Provider Type],dt.DoctorTypeName [Doctor Type], gr.GroupCode [Group Code],  gr.GroupName [Group Name],rg.RegionCode [Zone Code],rg.RegionName  [Zone Name],Ar.AreaCode [Area Code],Ar.AreaName [Area Name],Tr.TerritoryCode [Territory Code],Tr.TerritoryName [Territory Name],subTr.SubTerritoryCode [Sub-Territory Code],subTr.SubTerritoryName [Sub-Territory Name],mr.MarketCode [Market Code],mr.MarketName [Market Name]
  DECLARE @SqlStatement NVARCHAR(MAX)
   if(@ApprovalStatus='Select')
	begin
  SET @SqlStatement = N'
    SELECT * FROM (
 select  DoctorId,DcrDate ,[Doctor Code] [Customer Code],  [Doctor Name] [Customer Name], [Group],[Region],[Area],[Territory],[Market] from   View_CustomerDCP mas with (nolock)
  
  
 

  where  convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
            and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)  
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
  select DoctorId,DcrDate ,[Doctor Code] [Customer Code],  [Doctor Name] [Customer Name],  [Group],[Region],[Area],[Territory],[Market] from   View_CustomerDCP mas with (nolock)
  
  
 
  where   convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
      and  mas.ApprovalStatus='+@ApprovalStatus+'     and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   ) StudentResults
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
 