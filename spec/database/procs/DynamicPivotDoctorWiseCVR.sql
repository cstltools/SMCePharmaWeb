create PROCEDURE [dbo].[DynamicPivotDoctorWiseCVR]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'
    SELECT * FROM (
    select    mas.DoctorId,   doc.CustomerName  [Customer Name],doc.CustomerCode [Customer Code],  doc.OwnerName [Owner Name], gr.GroupCode [Group Code],  gr.GroupName [Group Name],rg.RegionCode [Zone Code],rg.RegionName  [Zone Name],Ar.AreaCode [Area Code],Ar.AreaName [Area Name],Tr.TerritoryCode [Territory Code],Tr.TerritoryName [Territory Name],subTr.SubTerritoryCode [Sub-Territory Code],subTr.SubTerritoryName [Sub-Territory Name],mr.MarketCode [Market Code],mr.MarketName [Market Name], CONVERT(date,mas.DcrDate)  DcrDate from tbl_DCRInfo mas   WITH (NOLOCK) 
 inner join tblCustMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.CustomerMasterId
 
  left join  tblMarket mr  WITH (NOLOCK)    on mas.MarketId=mr.MarketId
	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mas.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on Tr.TerritoryId=mas.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=mas.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on mas.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=mas.GroupId

	 where mas.TypeDcr=''CVR'' and Month(mas.DcrDate)='+@Month+' and Year(mas.DcrDate)='+@Year+'
    ) StudentResults
    PIVOT (
          count(DoctorId)
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 
  EXEC(@SqlStatement)
 
END
 