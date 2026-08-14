CREATE PROCEDURE [dbo].[sp_RPT_NegativeClosingStock_DCWise]
AS
BEGIN

	SET NOCOUNT ON;

	-- Fixed baseline per business requirement: this chart always looks back from
	-- 31-Jul-2026 to today, for every Distribution Center at once (no @CiD filter).
	DECLARE @fromDate DATE = '2026-07-31';
	DECLARE @toDate DATE = CAST(GETDATE() AS DATE);

	-- Same per-(DC, Product, Batch) closing-stock computation as
	-- sp_RPT_NegativeClosingStock, just with ComUnitId carried through every join
	-- instead of being filtered down to a single @CiD, so it can be grouped by DC.
	;WITH RawClosing AS
	(
		SELECT
			tbldcstr.ComUnitId,
			(ISNULL(vTblsapopening.Sales, 0) + ISNULL(vTblStockReceive.TotalStockReceiveQty, 0) + ISNULL(vTblRtn.Sales, 0) +
				ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0))
				- (ISNULL(vTblsales.Sales, 0) + ISNULL(vTblChallan.Challan, 0)) AS closing
		FROM
		(
			SELECT ComUnitId, ProductCode, BatchNo
			FROM dbo.tblDCStore WITH (NOLOCK)
			GROUP BY ComUnitId, ProductCode, BatchNo
		) tbldcstr
		INNER JOIN dbo.tblProduct P WITH (NOLOCK) ON P.ProductCode = tbldcstr.ProductCode

		LEFT JOIN
		(
			SELECT I.ComUnitId, ID.ProductCode, ID.Batch, SUM(ID.Quantity) AS Sales
			FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales ID WITH (NOLOCK)
			LEFT JOIN tblCompanyUnit I WITH (NOLOCK) ON I.Customer_Code = ID.Plant
			WHERE ID.SalesDocDate BETWEEN @fromDate AND @toDate
			GROUP BY I.ComUnitId, ID.ProductCode, ID.Batch
		) vTblsales
			ON vTblsales.ComUnitId = tbldcstr.ComUnitId
			AND vTblsales.ProductCode = P.SAP_Code
			AND vTblsales.Batch = tbldcstr.BatchNo

		LEFT JOIN
		(
			SELECT I.ComUnitId, ID.ProductCode, ID.Batch, SUM(ID.Quantity) AS Sales
			FROM SAP_API_Data..tbl_Return ID WITH (NOLOCK)
			LEFT JOIN tblCompanyUnit I WITH (NOLOCK) ON I.Customer_Code = ID.Plant
			WHERE ID.SalesDocDate BETWEEN @fromDate AND @toDate
			GROUP BY I.ComUnitId, ID.ProductCode, ID.Batch
		) vTblRtn
			ON vTblRtn.ComUnitId = tbldcstr.ComUnitId
			AND vTblRtn.ProductCode = P.SAP_Code
			AND vTblRtn.Batch = tbldcstr.BatchNo

		LEFT JOIN
		(
			SELECT I.ComUnitId, ID.Sap_Material, ID.Sap_Batch,
				SUM(ID.Sap_Stock) / COALESCE(NULLIF(CQ.ConvertionQty, 0), 1) AS Sales
			FROM Sap_Stock13thSepOpening ID WITH (NOLOCK)
			LEFT JOIN tblProduct P2 WITH (NOLOCK) ON P2.SAP_Code = ID.Sap_Material
			LEFT JOIN
			(
				SELECT ProductCode, MAX(ConvertionQty) AS ConvertionQty
				FROM tblConvQty WITH (NOLOCK)
				GROUP BY ProductCode
			) CQ ON CQ.ProductCode = P2.ProductCode
			LEFT JOIN tblCompanyUnit I WITH (NOLOCK) ON I.SAP_Code = ID.Sap_Plant
			GROUP BY I.ComUnitId, ID.Sap_Material, ID.Sap_Batch, CQ.ConvertionQty
		) vTblsapopening
			ON vTblsapopening.ComUnitId = tbldcstr.ComUnitId
			AND vTblsapopening.Sap_Material = P.SAP_Code
			AND vTblsapopening.Sap_Batch = tbldcstr.BatchNo

		LEFT JOIN (
			SELECT ComUnitId, ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
			FROM dbo.tblDCStore WITH (NOLOCK)
			WHERE StockRcvDate BETWEEN @fromDate AND @toDate
			GROUP BY ComUnitId, ProductCode, BatchNo
		) vTblStockReceive
			ON vTblStockReceive.ComUnitId = tbldcstr.ComUnitId
			AND vTblStockReceive.ProductCode = P.ProductCode
			AND vTblStockReceive.BatchNo = tbldcstr.BatchNo

		LEFT JOIN (
			SELECT CI.FromComUnitId AS ComUnitId, CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS Challan
			FROM dbo.tblChalanDetail CD WITH (NOLOCK)
			JOIN dbo.tblChalanInfo CI ON CI.ChalanId = CD.ChalanId
			WHERE CI.ChalanDate BETWEEN @fromDate AND @toDate
			GROUP BY CI.FromComUnitId, CD.ProductCode, CD.BatchNo
		) vTblChallan
			ON vTblChallan.ComUnitId = tbldcstr.ComUnitId
			AND vTblChallan.ProductCode = P.ProductCode
			AND vTblChallan.BatchNo = tbldcstr.BatchNo

		LEFT JOIN (
			SELECT ComUnitId, ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
			FROM dbo.tblDCStore WITH (NOLOCK)
			WHERE ChalanDetailsId IS NOT NULL
				AND StockRcvDate BETWEEN @fromDate AND @toDate
			GROUP BY ComUnitId, ProductCode, BatchNo
		) vTblChallanReceive
			ON vTblChallanReceive.ComUnitId = tbldcstr.ComUnitId
			AND vTblChallanReceive.ProductCode = P.ProductCode
			AND vTblChallanReceive.BatchNo = tbldcstr.BatchNo

		WHERE P.ProductGroupId = 1
			AND ( ISNULL(vTblsales.Sales, 0) > 0 OR ISNULL(vTblRtn.Sales, 0) > 0 )
	)
	SELECT
		cUnit.ComUnitId,
		cUnit.ShortName,
		SUM(rc.closing) AS TotalNegativeClosing,
		COUNT(*) AS NegativeItemCount
	FROM RawClosing rc
	INNER JOIN dbo.tblCompanyUnit cUnit WITH (NOLOCK) ON cUnit.ComUnitId = rc.ComUnitId
	WHERE rc.closing < 0
	GROUP BY cUnit.ComUnitId, cUnit.ShortName
	ORDER BY TotalNegativeClosing ASC;

END
