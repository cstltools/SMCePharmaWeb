CREATE PROCEDURE [dbo].[sp_GET_PaymentInvSPTPVATAmt]
	-- Add the parameters for the stored procedure here
	@InvoiceId int,
	@PayAmount decimal(18,2)
AS
BEGIN
 

SELECT   (ISNULL(TotalDelivery,0)-isnull(tblinvDetls.PaymentTotalPriceVatAmount,0)) - (isnull(TPAmount,0)) 
 TP_Pay,
   isnull(tblinvDetls.PaymentTotalPriceVatAmount,0) - (isnull(VATAmount,0))
  Vat_Pay  FROM tblInvoice AS INV WITH(NOLOCK)
inner join tblOrder ord with (nolock) on INV.OrderId=ord.OrderId

INNER JOIN tblCustMaster C ON C.CustomerMasterId = ord.CustomerMasterId
LEFT JOIN (SELECT InvoiceId,SUM(PaymentAmount) AS PP, SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON INV.InvoiceId = P.InvoiceId 
inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON INV.InvoiceId = TD.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(TPGrandTotal) ReturnTotal FROM tblReturnInvoice  GROUP BY InvoiceId) AS RTN ON INV.InvoiceId= RTN.InvoiceId
inner join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail group by InvoiceId)tblinvDetls on 
tblinvDetls.InvoiceId=INV.InvoiceId
WHERE PaymentInvoiceNo  IS NOT NULL    and INV.InvoiceId =@InvoiceId

end