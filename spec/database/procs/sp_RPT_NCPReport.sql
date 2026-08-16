CREATE PROCEDURE [dbo].[sp_RPT_NCPReport]

	@FromDate	DATE,
	@ToDate		DATE,
	@ComUnitId	INT = 0		-- 0 = All Depot, same convention as sp_RPT_StockOutReport's @ComUnitId
AS
BEGIN

	SET NOCOUNT ON;

	-- Output shape matches sp_RPT_StockOutReport (Depo, Plant, Reason, StockOutDate, ProductCode,
	-- ProductName, SapCode, StockOutQty) so StockOutReport.aspx's existing GridView/DataFields work
	-- unchanged for both the "Gift" and "NCP" report types - only the column header text differs,
	-- swapped in code-behind based on which radio button is selected. NCP has no Reason concept, so
	-- that column is NULL for every row.
	SELECT
		tblCompanyUnit.ComUnitName				AS Depo,
		tblCompanyUnit.SAP_Code					AS Plant,
		CAST(NULL AS NVARCHAR(255))				AS Reason,
		E.SalesDocDate								AS StockOutDate,
		E.ProductCode,
		tblProduct.ProductName,
		E.ProductCode								AS SapCode,
		E.Quantity									AS StockOutQty
	FROM SAP_API_Data.dbo.tbl_ExpiryReturn E
	INNER JOIN dbo.tblCompanyUnit WITH (NOLOCK)
		ON tblCompanyUnit.SAP_Code = E.Plant
	INNER JOIN dbo.tblProduct WITH (NOLOCK)
		ON tblProduct.SAP_Code = E.ProductCode
	WHERE tblCompanyUnit.ComUnitId = COALESCE(NULLIF(@ComUnitId, 0), tblCompanyUnit.ComUnitId)
		AND E.SalesDocDate >= @FromDate
		AND E.SalesDocDate < DATEADD(DAY, 1, @ToDate)
	ORDER BY
		E.SalesDocDate DESC,
		tblCompanyUnit.ComUnitName,
		tblProduct.ProductName;

END
