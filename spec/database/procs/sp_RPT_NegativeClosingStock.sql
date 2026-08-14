CREATE PROCEDURE [dbo].[sp_RPT_NegativeClosingStock]

	@CiD INT,
	@fromDate DATE
AS
BEGIN

	SET NOCOUNT ON;

	-- @toDate is always "today" — not caller-supplied, per business requirement.
	DECLARE @toDate DATE = CAST(GETDATE() AS DATE);

	SELECT
		P.ProductCode, P.SAP_Code,
		P.ProductName,

		tbldcstr.BatchNo,

		ISNULL(vTblsapopening.Sales, 0) AS OpeningQty,

		ISNULL(vTblRtn.Sales, 0) AS ReturnQty,
		ISNULL(vTblsales.Sales, 0) AS SalesQty,
		ISNULL(vTblStockReceive.TotalStockReceiveQty, 0) AS totalrcv,
		(ISNULL(vTblsapopening.Sales, 0) + ISNULL(vTblStockReceive.TotalStockReceiveQty, 0) + ISNULL(vTblRtn.Sales, 0) +
			ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0))

			- (ISNULL(vTblsales.Sales, 0) + ISNULL(vTblChallan.Challan, 0)) AS closing

	FROM dbo.tblProduct P WITH (NOLOCK)

	/* =========================================================
	   BATCH ANCHOR
	   One row per ProductCode + BatchNo
	   ========================================================= */
	LEFT JOIN
	(
		SELECT
			ProductCode,
			BatchNo
		FROM dbo.tblDCStore WITH (NOLOCK)
		WHERE ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
		GROUP BY
			ProductCode,
			BatchNo
	) tbldcstr
		ON tbldcstr.ProductCode = P.ProductCode

	/* =========================================================
	   OPENING BALANCE
	   ========================================================= */
	LEFT JOIN
	(
		SELECT
			ProductCode,
			BatchNo,
			SUM(StockQty) AS Quantity
		FROM dbo.tblDCStore_OpeningBalance WITH (NOLOCK)
		WHERE ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
			AND DCOpeningBalanceDate = @fromDate
		GROUP BY
			ProductCode,
			BatchNo
	) vTblOB
		ON vTblOB.ProductCode = P.ProductCode
		AND vTblOB.BatchNo = tbldcstr.BatchNo

	/* =========================================================
	   SALES
	   ========================================================= */
	LEFT JOIN
	(
		SELECT
			ID.ProductCode,
			ID.Batch,
			SUM(ID.Quantity) AS Sales
		FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales ID WITH (NOLOCK)

		LEFT JOIN tblCompanyUnit I WITH (NOLOCK)
			ON I.Customer_Code = ID.Plant

		WHERE I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
			AND ID.SalesDocDate BETWEEN @fromDate AND @toDate

		GROUP BY
			ID.ProductCode,
			ID.Batch
	) vTblsales
		ON vTblsales.ProductCode = P.SAP_Code
		AND vTblsales.Batch = tbldcstr.BatchNo

	/* =========================================================
	   RETURN
	   ========================================================= */
	LEFT JOIN
	(
		SELECT
			ID.ProductCode,
			ID.Batch,
			SUM(ID.Quantity) AS Sales
		FROM SAP_API_Data..tbl_Return ID WITH (NOLOCK)

		LEFT JOIN tblCompanyUnit I WITH (NOLOCK)
			ON I.Customer_Code = ID.Plant

		WHERE I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
			AND ID.SalesDocDate BETWEEN @fromDate AND @toDate

		GROUP BY
			ID.ProductCode,
			ID.Batch
	) vTblRtn
		ON vTblRtn.ProductCode = P.SAP_Code
		AND vTblRtn.Batch = tbldcstr.BatchNo

	LEFT JOIN
	(
		SELECT
			ID.Sap_Material,
			ID.Sap_Batch,
			SUM(ID.Sap_Stock)
				/ COALESCE(NULLIF(CQ.ConvertionQty, 0), 1) AS Sales
		FROM Sap_Stock13thSepOpening ID WITH (NOLOCK)

		LEFT JOIN tblProduct P WITH (NOLOCK)
			ON P.SAP_Code = ID.Sap_Material

		LEFT JOIN
		(
			SELECT
				ProductCode,
				MAX(ConvertionQty) AS ConvertionQty
			FROM tblConvQty WITH (NOLOCK)
			GROUP BY ProductCode
		) CQ
			ON CQ.ProductCode = P.ProductCode

		LEFT JOIN tblCompanyUnit I WITH (NOLOCK)
			ON I.SAP_Code = ID.Sap_Plant

		WHERE I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)

		GROUP BY
			ID.Sap_Material,
			ID.Sap_Batch,
			CQ.ConvertionQty

	) vTblsapopening
		ON vTblsapopening.Sap_Material = P.SAP_Code
		AND vTblsapopening.Sap_Batch = tbldcstr.BatchNo

	LEFT JOIN (
		SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
		FROM     dbo.tblDCStore WITH (NOLOCK)
		WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
			AND    StockRcvDate BETWEEN @fromDate AND @toDate
		GROUP BY ProductCode, BatchNo
	) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode
					AND vTblStockReceive.BatchNo      = tbldcstr.BatchNo

	/* ════════════════════════════════════════════════════════════════
	   ISSUED TO AREA OFFICE  (Inter Transfer Challan)
	   ════════════════════════════════════════════════════════════════ */
	LEFT JOIN (
		SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS Challan
		FROM     dbo.tblChalanDetail CD WITH (NOLOCK)
		JOIN     dbo.tblChalanInfo   CI ON CI.ChalanId = CD.ChalanId
		WHERE    CI.FromComUnitId = COALESCE(NULLIF(@CiD, 0), CI.FromComUnitId)
			AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
		GROUP BY CD.ProductCode, CD.BatchNo
	) vTblChallan ON vTblChallan.ProductCode = P.ProductCode
				AND vTblChallan.BatchNo      = tbldcstr.BatchNo
	/* ════════════════════════════════════════════════════════════════
	   RECEIVE FROM AREA OFFICE (INTER TRANSFER)
	   ════════════════════════════════════════════════════════════════ */
	LEFT JOIN (
		SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
		FROM     dbo.tblDCStore WITH (NOLOCK)
		WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
			AND    ChalanDetailsId IS NOT NULL
			AND    StockRcvDate BETWEEN @fromDate AND @toDate
		GROUP BY ProductCode, BatchNo
	) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode
						AND vTblChallanReceive.BatchNo      = tbldcstr.BatchNo

	/* =========================================================
	   FILTER
	   ========================================================= */
	WHERE P.ProductGroupId = 1

		AND
		(
			ISNULL(vTblsales.Sales, 0) > 0
			OR
			ISNULL(vTblRtn.Sales, 0) > 0
		)
		AND (ISNULL(vTblsapopening.Sales, 0) + ISNULL(vTblStockReceive.TotalStockReceiveQty, 0) + ISNULL(vTblRtn.Sales, 0) +
			ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0))

			- (ISNULL(vTblsales.Sales, 0) + ISNULL(vTblChallan.Challan, 0)) < 0

	/* =========================================================
	   ORDER
	   ========================================================= */
	ORDER BY
		P.ProductCode,
		tbldcstr.BatchNo ASC;

END
