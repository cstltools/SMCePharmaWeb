CREATE PROCEDURE [dbo].[sp_RPT_DuplicateOrderNoInInvoice]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		OrderNo,
		COUNT(OrderNo) AS DuplicateCount
	FROM dbo.tblInvoice WITH (NOLOCK)
	WHERE InvoiceDate > '2026-07-01'
	GROUP BY OrderNo
	HAVING COUNT(OrderNo) > 1
	ORDER BY DuplicateCount DESC, OrderNo;

END
