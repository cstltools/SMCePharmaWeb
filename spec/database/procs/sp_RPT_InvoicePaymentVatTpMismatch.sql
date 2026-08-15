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
		tblInvoice.InvoiceDate,
		pay.TPAmount - invde.tp AS TpDifference,
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

	UNION ALL

	SELECT
		pay.TPAmount,
		pay.VATAmount,
		invde.tp,
		invde.vat,
		tblInvoice.InvoiceNo,
		tblInvoice.InvoiceDate,
		pay.TPAmount - invde.tp AS TpDifference,
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
	WHERE pay.VATAmount > invde.vat

	ORDER BY InvoiceId;

END
