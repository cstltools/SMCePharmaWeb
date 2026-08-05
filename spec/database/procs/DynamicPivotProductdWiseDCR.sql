CREATE PROCEDURE [dbo].[DynamicPivotProductdWiseDCR]
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
     select pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.DcrDate)  DcrDate,  isnull((ProductQty),0) ProductQty   from tbl_DcrDetails dcrDtl    WITH (NOLOCK) 
 inner join  tbl_DCRInfo mas WITH (NOLOCK)    on mas.DcrId=dcrDtl.DcrId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
  where  convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
         and mas.DoctorProgramypeId= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,mas.DoctorProgramypeId )   and mas.SmcTypeId_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SmcTypeId_DCR)  and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)  
    ) StudentResults
    PIVOT (
      SUM([ProductQty])
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
     select pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.DcrDate)  DcrDate,  isnull((ProductQty),0) ProductQty   from tbl_DcrDetails dcrDtl    WITH (NOLOCK) 
 inner join  tbl_DCRInfo mas WITH (NOLOCK)    on mas.DcrId=dcrDtl.DcrId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
  where  convert(date, mas.DcrDate)  between convert(date,'''+@Month+''') and convert(date,'''+@Year+''')  
       
   and  mas.ApprovalStatus='+@ApprovalStatus+'   and mas.DoctorProgramypeId= COALESCE( NULLIF('''+@ProviderType+''' , '''') ,mas.DoctorProgramypeId )   and mas.SmcTypeId_DCR= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SmcTypeId_DCR)  and mas.RegionId= COALESCE( NULLIF('''+@ZoneSelect+''' , '''') ,mas.RegionId)   and mas.AreaId= COALESCE( NULLIF('''+@AreaSelect+''' , '''') ,mas.AreaId) and mas.TerritoryId= COALESCE( NULLIF('''+@TeritorySelect+''' , '''') ,mas.TerritoryId)   ) StudentResults
    PIVOT (
      SUM([ProductQty])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 end
  EXEC(@SqlStatement)
 
END
 