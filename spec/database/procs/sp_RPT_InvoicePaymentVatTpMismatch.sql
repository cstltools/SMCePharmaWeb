CREATE PROCEDURE [dbo].[sp_RPT_InvoicePaymentVatTpMismatch]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		pay.TPAmount,
		pay.VATAmount,
		invde.tp,
		invde.vat,
		tblInvoice.InvoiceNo,
		pay.VATAmount - invde.vat AS VatDifference,
		tblInvoice.InvoiceId,
		tblInvoice.SndReturnPaymentDate
	FROM dbo.tblInvoice WITH (NOLOCK)
	INNER JOIN (
		SELECT SUM(PaymentTotalPriceVatAmount) AS vat, SUM(PaymentTotalPrice) AS tp, InvoiceId
		FROM dbo.tblInvoiceDetail WITH (NOLOCK)
		GROUP BY InvoiceId
	) invde ON invde.InvoiceId = tblInvoice.InvoiceId
	LEFT JOIN (
		SELECT SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount, InvoiceId
		FROM dbo.tblCustPayDetail WITH (NOLOCK)
		GROUP BY InvoiceId
	) pay ON pay.InvoiceId = tblInvoice.InvoiceId
	WHERE pay.TPAmount > invde.tp
		AND pay.VATAmount - invde.vat > 0
	ORDER BY tblInvoice.InvoiceId;

END
