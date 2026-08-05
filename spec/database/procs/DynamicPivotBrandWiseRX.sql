CREATE PROCEDURE [dbo].[DynamicPivotBrandWiseRX]
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
     select  proBrnd.ProductSQName [Brand Name], pro.ProductCode+'' : ''+pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
  left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
 inner join tblProductSQ proBrnd  WITH (NOLOCK)    on pro.ProductBrandId=proBrnd.ProductBrandId
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'   and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
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
     select  proBrnd.ProductSQName [Brand Name], pro.ProductCode+'' : ''+pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
  left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
 inner join tblProductSQ proBrnd  WITH (NOLOCK)    on pro.ProductBrandId=proBrnd.ProductBrandId
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'  and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
  and  mas.ApprovalStatus='+@ApprovalStatus+'  ) StudentResults
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
 