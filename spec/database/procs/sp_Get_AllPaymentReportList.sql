create PROCEDURE [dbo].[sp_Get_AllPaymentReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='
SELECT O.CustomerType as NCOD,tblInvoice.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblInvoice.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus,dbo.tblCustomerPay.PaymentDate
,tblInvoice.MarketCode,tblInvoice.MarketName,tblInvoice.AreaCode,tblInvoice.MiaCode,tblInvoice.DisCode as DistrictCode , tblInvoice.RegionCode,tblInvoice.MIAName,tblInvoice.Types as Type
FROM dbo.tblInvoice WITH (nolock) 
 INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblInvoice.ComUnitId
inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
left JOIN dbo.tblCustPayDetail ON dbo.tblInvoice.InvoiceId = dbo.tblCustPayDetail.InvoiceId
left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId
inner JOIN tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
inner JOIN tblOrder O ON dbo.tblInvoice.OrderId=O.OrderId


WHERE  (DeliveryInvoiceStatus=''Full'' or DeliveryInvoiceStatus= ''Partial'') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblInvoice.PaymentAmount,0)+ISNULL(tblInvoice.AdjustAmount,0) and '+@Parm+
                       ' Union all  SELECT O.CustomerType as NCOD,tblSubInvoiceMaster.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblSubInvoiceMaster.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus,dbo.tblCustomerPay.PaymentDate ,tblSubInvoiceMaster.MarketCode,tblSubInvoiceMaster.MarketName,tblSubInvoiceMaster.AreaCode,tblSubInvoiceMaster.MiaCode,tblSubInvoiceMaster.DisCode as DistrictCode , tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.MIAName,Type FROM dbo.tblSubInvoiceMaster WITH (nolock)   INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblSubInvoiceMaster.ComUnitId inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId left JOIN dbo.tblCustPayDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblCustPayDetail.SubDeportInvoiceId left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId inner JOIN tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId  inner JOIN tblOrder O ON dbo.tblSubInvoiceMaster.OrderId=O.OrderId WHERE  (DeliveryInvoiceStatus=''Full'' or DeliveryInvoiceStatus= ''Partial'') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblSubInvoiceMaster.PaymentAmount,0) and  ' +@Parm

						
EXEC sp_executesql @Q

END
             