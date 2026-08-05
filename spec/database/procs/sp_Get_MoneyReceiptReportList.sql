CREATE PROCEDURE [dbo].[sp_Get_MoneyReceiptReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
   
    DECLARE @Q NVARCHAR(MAX)='SELECT distinct ord.OrderSenderCode +'' : ''+ord.OrderSenderName OrderBy, INV.UpdateDate, com.ComUnitCode+'' : ''+com.ComUnitName  ComUnitName, com.Address,  INV.InvoiceId,INV.OrderNo,CSTMR.CustomerCode,CSTMR.CustomerName,INV.InvoiceNo,CONVERT(VARCHAR,INV.InvoiceDate,103) InvoiceDate,DelivaryInvoiceNo AS PaymentNo,
    CONVERT(VARCHAR,INV.UpdateDate,103) AS PaymentDate,PMT.PaymentAmount,''M-''+RIGHT(DelivaryInvoiceNo,10) AS ReceiptNo FROM tblInvoice AS INV 
	LEFT JOIN tblCustMaster AS CSTMR ON INV.CustomerMasterId = CSTMR.CustomerMasterId
	inner JOIN (SELECT InvoiceId,SUM(DeliveryNetAmount) AS PaymentAmount FROM tblInvoiceDetail AS INVD WHERE INVD.DeliveryStatus IS NOT NULL GROUP BY InvoiceId) AS PMT ON INV.InvoiceId = PMT.InvoiceId
inner join tblOrder ord on ord.OrderId=INV.OrderId

inner join tblCompanyUnit com on ord.ComUnitId=com.ComUnitId
	WHERE INV.DeliveryInvoiceStatus IS NOT NULL AND INV.DeliveryInvoiceStatus != ''Reject'' ' + @Parm  + 'ORDER BY INV.UpdateDate DESC'   	

	EXEC sp_executesql @Q

END
              