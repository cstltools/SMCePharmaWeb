CREATE PROCEDURE [dbo].[sp_RPT_StockOutReport]

	@FromDate	DATE,
	@ToDate		DATE,
	@ComUnitId	INT = 0		-- 0 = All Depot, same "0 means unfiltered" convention as sp_RPT_NegativeClosingStock's @CiD
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		tblCompanyUnit.ComUnitName				AS Depo,
		tblCompanyUnit.SAP_Code					AS Plant,
		tblDeStockOutMaster.Reason,
		tblDeStockOutMaster.StockOutDate,
		tblDeStockOutDetails.ProductCode,
		tblDeStockOutDetails.ProductName,
		tblProduct.SAP_Code						AS SapCode,
		tblDeStockOutDetails.StackOutQty			AS StockOutQty
	FROM dbo.tblDeStockOutMaster WITH (NOLOCK)
	INNER JOIN dbo.tblDeStockOutDetails WITH (NOLOCK)
		ON tblDeStockOutDetails.DcStockOutMasterId = tblDeStockOutMaster.DcStockOutMasterId
	INNER JOIN dbo.tblCompanyUnit WITH (NOLOCK)
		ON tblCompanyUnit.ComUnitId = tblDeStockOutMaster.ComUnitId
	INNER JOIN dbo.tblProduct WITH (NOLOCK)
		ON tblProduct.ProductCode = tblDeStockOutDetails.ProductCode
	WHERE tblCompanyUnit.ComUnitId = COALESCE(NULLIF(@ComUnitId, 0), tblCompanyUnit.ComUnitId)
		AND tblDeStockOutMaster.StockOutDate >= @FromDate
		AND tblDeStockOutMaster.StockOutDate < DATEADD(DAY, 1, @ToDate)
	ORDER BY
		tblDeStockOutMaster.StockOutDate DESC,
		tblCompanyUnit.ComUnitName,
		tblDeStockOutDetails.ProductName;

END
