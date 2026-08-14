CREATE PROCEDURE [dbo].[sp_RPT_DuplicateOrderCode]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		OrderCode,
		COUNT(OrderCode) AS DuplicateCount
	FROM dbo.tblOrder WITH (NOLOCK)
	GROUP BY OrderCode
	HAVING COUNT(OrderCode) > 1
	ORDER BY DuplicateCount DESC, OrderCode;

END
