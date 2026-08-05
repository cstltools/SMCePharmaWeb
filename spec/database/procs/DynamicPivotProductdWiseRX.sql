CREATE PROCEDURE [dbo].[DynamicPivotProductdWiseRX]
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
     select pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'    and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
    ) StudentResults
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
    SELECT * FROM (
     select pro.ProductCode [Product Code], pro.ProductName [Product Name],     CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((dcrDtl.ProductId),0) ProductQty   from tbl_PrescriptionProductDetail dcrDtl    WITH (NOLOCK) 
 inner join  tbl_PrescriptionMaster mas WITH (NOLOCK)    on mas.PrescriptionId=dcrDtl.PrescriptionId
 inner join tblProduct pro  WITH (NOLOCK)    on pro.ProductId=dcrDtl.ProductId
   left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
  where Month(mas.PrescriptionDate)='+@Month+' and Year(mas.PrescriptionDate)='+@Year+'    and pt.ProgramTypeName= COALESCE( NULLIF('''+ @ProviderType+''' , '''') ,pt.ProgramTypeName )   and mas.SMCType_RX= COALESCE( NULLIF('''+@PharmaPlatform+''' , '''') ,mas.SMCType_RX) 
    and  mas.ApprovalStatus='+@ApprovalStatus+'  ) StudentResults
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
 