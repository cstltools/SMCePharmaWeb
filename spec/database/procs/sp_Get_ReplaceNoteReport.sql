CREATE PROCEDURE [dbo].[sp_Get_ReplaceNoteReport] 
	-- Add the parameters for the stored procedure here
   
    
  @Parm nvarchar(max)
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='select  ID.DiscountAmount, I.ReturnInvoiceNo, format(I.ReturnInvoiceDate,''dd-MMM-yyyy'') ReturnInvoiceDate,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, ID.ProductCode,ID.ProductName, ps.PackSizeName  PackSize,ID.BatchNo, 
(ID.Quantity)ReturnQuantity,(ID.NetAmount)Amount,
(ID.TotalPriceVatAmount)VatAmount, ''Return from market for date expired'' ReplacementReason
  from tblReturnInvoice  I with (nolock)
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
 INNER JOIN  [tblReturnInvoiceDetail]  ID  with (nolock)  on ID.ReturnInvoiceId=I.ReturnInvoiceId
 left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
  left JOIN dbo.tblProduct pro ON pro.ProductCode = ID.ProductCode
 LEFT JOIN dbo.tblPackSize ps with (nolock) ON pro.PackSizeId=ps.PackSizeId
left JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId  where I.ReturnInvoiceId is not null ' + @Parm 
 
EXEC sp_executesql @Q

END
              