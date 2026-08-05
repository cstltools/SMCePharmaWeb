CREATE PROCEDURE [dbo].[sp_Get_MoneyReceiptReportAfterPaymentList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN

 exec sp_Update_Zero_PaymentInfo
   SET NOCOUNT ON;
    DECLARE @Q NVARCHAR(MAX)='SELECT distinct custPay.DANameId, custPay.CustPayDetailId,    case when custPay.DANameId =112 then ''MIO Name  & EID : ''+  ord.OrderSenderName + '' (''+ord.OrderSenderCode+'')''    else ''SA Name  & EID : ''+   custPayDa.Name  + '' (''+custPayDa.DACode+'')''    end  OrderBy, INV.UpdateDate, com.ComUnitCode+'' : ''+com.ComUnitName  ComUnitName, com.Address,  INV.InvoiceId,INV.OrderNo,CSTMR.CustomerCode,CSTMR.CustomerName,INV.InvoiceNo,CONVERT(VARCHAR,INV.InvoiceDate,103) InvoiceDate,DelivaryInvoiceNo AS DelivaryInvoiceNo,
    CONVERT(VARCHAR,INV.UpdateDate,103) AS DelivaryInvoiceDate, INV.PaymentInvoiceNo AS PaymentNo,
    CONVERT(VARCHAR,custPay.custPaymentDate,103) AS PaymentDate,isnull(custPay.TPAmount,0) + isnull(custPay.VatAmount,0) PaymentAmount,  isnull(custPay.TPAmount,0) TPAmount, isnull(custPay.VatAmount,0) VatAmount,FinalPaymentNo +''-''+cast(custPay.CustPayId as nvarchar(max)) AS ReceiptNo FROM tblInvoice AS INV 
	LEFT JOIN tblCustMaster AS CSTMR ON INV.CustomerMasterId = CSTMR.CustomerMasterId
	--inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS PaymentAmount FROM tblInvoiceDetail AS INVD WHERE INVD.DeliveryStatus IS NOT NULL GROUP BY InvoiceId) AS PMT ON INV.InvoiceId = PMT.InvoiceId
inner join tblOrder ord on ord.OrderId=INV.OrderId
inner join tblCustPayDetail custPay on custPay.InvoiceId=INV.InvoiceId
left join tblDAInfo custPayDa on custPayDa.DAId=custPay.DANameId


inner join tblCompanyUnit com on ord.ComUnitId=com.ComUnitId
	WHERE custPay.CustPayDetailId IS NOT NULL  ' + @Parm  + 'ORDER BY  FinalPaymentNo +''-''+cast(custPay.CustPayId as nvarchar(max)), CONVERT(VARCHAR,custPay.custPaymentDate,103) DESC'   	

	EXEC sp_executesql @Q

END
       