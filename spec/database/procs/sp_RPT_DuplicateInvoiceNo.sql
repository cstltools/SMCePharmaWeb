CREATE PROCEDURE [dbo].[sp_RPT_DuplicateInvoiceNo]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		InvoiceNo,
		COUNT(InvoiceNo) AS DuplicateCount
	FROM dbo.tblInvoice WITH (NOLOCK)
	GROUP BY InvoiceNo
	HAVING COUNT(InvoiceNo) > 1
	ORDER BY DuplicateCount DESC, InvoiceNo;

END
