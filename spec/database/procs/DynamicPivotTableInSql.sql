CREATE PROCEDURE dbo.DynamicPivotTableInSql
  @ColumnToPivot  NVARCHAR(255),
  @ListToPivot    NVARCHAR(255)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'
    SELECT * FROM (
     select  proBrnd.ProductSQName,     CONVERT(date,mas.DcrDate)  DcrDate,  (ProductQty) ProductQty   from tbl_DcrDetails dcrDtl    WITH (NOLOCK) 
 inner join  tbl_DCRInfo mas WITH (NOLOCK)    on mas.DcrId=dcrDtl.DcrId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
 inner join tblProductSQ proBrnd  WITH (NOLOCK)    on pro.ProductBrandId=proBrnd.ProductBrandId
    ) StudentResults
    PIVOT (
      SUM([ProductQty])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 
  EXEC(@SqlStatement)
 
END