-- Drop + recreate every stored procedure used by RptBussinessSummary_DayWise.aspx.
-- Source of truth for each proc body is spec\database\procs\<name>.sql - keep both in sync.
-- Run against the SolutionConnectionStringSSIDB target (see runsql.ps1 for the connection pattern).

IF OBJECT_ID('dbo.sp_RptBussinessSummary_DayWise', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RptBussinessSummary_DayWise;
GO

CREATE PROCEDURE [dbo].[sp_RptBussinessSummary_DayWise]

	@ComUnitId INT,
	@Year INT,
	@Month INT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
	DECLARE @EndDate DATE = DATEADD(MONTH, 1, @StartDate);

	-- Same "Net Sales" business rule as sp_RPT_MIS_BusinessSummary's @Type='SC' branch:
	-- JustSalesAmtTP/JustSalesGrossAmt collapse to SalesAmtTP/SalesGrossAmt minus the 1st and
	-- 2nd return amounts (the "Old Return" term used there cancels out algebraically), just
	-- aggregated per calendar day instead of per ComUnitId for the whole range.
	;WITH Days AS (
		SELECT @StartDate AS TheDate
		UNION ALL
		SELECT DATEADD(DAY, 1, TheDate) FROM Days WHERE DATEADD(DAY, 1, TheDate) < @EndDate
	)
	SELECT
		d.TheDate,
		ISNULL(s.SalesAmtTP, 0) - ISNULL(r.ReturnAmountTP, 0) - ISNULL(r2.TP, 0) AS JustSalesAmtTP,
		ISNULL(s.SalesGrossAmt, 0) - ISNULL(r.ReturnGrossAmt, 0) - ISNULL(r2.Gross, 0) AS JustSalesGrossAmt,
		ISNULL(sap.SAPsendAmount, 0) - ISNULL(sapRtn.SAPReturnAmount, 0) - ISNULL(sapExpRtn.SAPExpiryReturnAmount, 0) AS SAPsendAmount
	FROM Days d

	--Sales Confirmation
	LEFT JOIN (
		SELECT CAST(I.UpdateDate AS DATE) AS TheDate,
			SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) AS SalesAmtTP,
			SUM(D.DeliveryNetAmount) AS SalesGrossAmt
		FROM dbo.tblInvoice I WITH (NOLOCK)
		INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
		INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
		WHERE mas.ComUnitId = @ComUnitId
			AND I.UpdateDate >= @StartDate AND I.UpdateDate < @EndDate
			AND I.DelivaryInvoiceNo IS NOT NULL
		GROUP BY CAST(I.UpdateDate AS DATE)
	) s ON s.TheDate = d.TheDate

	--Payment Return (1st Return)
	LEFT JOIN (
		SELECT CAST(I.PaymentDate AS DATE) AS TheDate,
			SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0)) - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)) AS ReturnAmountTP,
			(SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0)) - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)))
				+ SUM(ISNULL(ID.DeliveryTotalPriceVatAmount - ID.PaymentTotalPriceVatAmount, 0)) AS ReturnGrossAmt
		FROM dbo.tblInvoice I WITH (NOLOCK)
		INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
		INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
		WHERE mas.ComUnitId = @ComUnitId
			AND I.PaymentInvoiceNo IS NOT NULL
			AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
			AND I.PaymentDate >= @StartDate AND I.PaymentDate < @EndDate
		GROUP BY CAST(I.PaymentDate AS DATE)
	) r ON r.TheDate = d.TheDate

	--2nd Return
	LEFT JOIN (
		SELECT CAST(iv.SndReturnPaymentDate AS DATE) AS TheDate,
			SUM(ISNULL(ivD.PaymentTotalPrice - ret.sndReturnTotalPrice, 0)) AS TP,
			(SUM(ISNULL(ivD.PaymentTotalPrice - ret.sndReturnTotalPrice, 0)) - SUM(ISNULL(ivD.PaymentDiscountAmount - ret.sndReturnDiscountAmount, 0)))
				+ SUM(ISNULL(ivD.PaymentTotalPriceVatAmount - ret.sndReturnTotalPriceVatAmount, 0)) AS Gross
		FROM dbo.tblInvoice iv WITH (NOLOCK)
		INNER JOIN dbo.tblInvoiceDetail ivD WITH (NOLOCK) ON iv.InvoiceId = ivD.InvoiceId
		INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = iv.OrderId
		INNER JOIN dbo.tblInvoiceDetailReturn ret WITH (NOLOCK) ON ret.InvoiceDetailId = ivD.InvoiceDetailId
		WHERE O.ComUnitId = @ComUnitId
			AND ret.PreviousQuantity <> ret.sndReturnQuantity
			AND iv.SndReturnPaymentDate >= @StartDate AND iv.SndReturnPaymentDate < @EndDate
		GROUP BY CAST(iv.SndReturnPaymentDate AS DATE)
	) r2 ON r2.TheDate = d.TheDate

	--SAP Send Amount
	LEFT JOIN (
		SELECT S.SalesDocDate AS TheDate,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPsendAmount
		FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales S WITH (NOLOCK)
		INNER JOIN dbo.tblCompanyUnit WITH (NOLOCK) ON tblCompanyUnit.Customer_Code = S.Plant
		WHERE tblCompanyUnit.ComUnitId = @ComUnitId
			AND S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
			AND S.isDemo = 1
			AND S.FOCFlag IS NULL
		GROUP BY S.SalesDocDate
	) sap ON sap.TheDate = d.TheDate

	--SAP Return Amount (deducted from SAP Send Amount)
	LEFT JOIN (
		SELECT S.SalesDocDate AS TheDate,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPReturnAmount
		FROM SAP_API_Data..tbl_Return S WITH (NOLOCK)
		INNER JOIN dbo.tblCompanyUnit WITH (NOLOCK) ON tblCompanyUnit.Customer_Code = S.Plant
		WHERE tblCompanyUnit.ComUnitId = @ComUnitId
			AND S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
		GROUP BY S.SalesDocDate
	) sapRtn ON sapRtn.TheDate = d.TheDate

	--SAP Expiry Return Amount (deducted from SAP Send Amount)
	LEFT JOIN (
		SELECT S.SalesDocDate AS TheDate,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPExpiryReturnAmount
		FROM SAP_API_Data..tbl_ExpiryReturn S WITH (NOLOCK)
		INNER JOIN dbo.tblCompanyUnit WITH (NOLOCK) ON tblCompanyUnit.SAP_Code = S.Plant
		WHERE tblCompanyUnit.ComUnitId = @ComUnitId
			AND S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
		GROUP BY S.SalesDocDate
	) sapExpRtn ON sapExpRtn.TheDate = d.TheDate

	ORDER BY d.TheDate

END
GO

IF OBJECT_ID('dbo.sp_RPT_NegativeClosingStock', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_NegativeClosingStock;
GO

CREATE PROCEDURE [dbo].[sp_RPT_NegativeClosingStock]

	@CiD INT,
	@fromDate DATE
AS
BEGIN

	SET NOCOUNT ON;

	-- @toDate is always "today" - not caller-supplied, per business requirement.
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
GO

IF OBJECT_ID('dbo.sp_RPT_NegativeClosingStock_DCWise', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_NegativeClosingStock_DCWise;
GO

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
GO

IF OBJECT_ID('dbo.sp_Get_MonthlyInventoryReportBatchWise', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Get_MonthlyInventoryReportBatchWise;
GO

-- Live proc takes exactly 3 params: @fromDate, @toDate, @CiD - no @ProTypId; ProductGroupId is
-- hardcoded to 1 in the WHERE clause instead. See spec\database\procs\sp_Get_MonthlyInventoryReportBatchWise.sql
-- for the full drift note against the previously-documented version.
CREATE PROCEDURE [dbo].[sp_Get_MonthlyInventoryReportBatchWise]
    @fromDate  DATETIME,
    @toDate    DATETIME,
    @CiD       NVARCHAR(MAX)
    --@ProTypId  NVARCHAR(MAX)
AS
BEGIN

SELECT
    ISNULL(tblBookforDeliveryQty.BookforDeliveryQty, 0)                            AS BookforDeliveryQty,
    ISNULL(tblreturn.ReturnQty, 0) + ISNULL(tbl2ndrtn.Quantity, 0)                 AS ReturnQty,
    ISNULL((SELECT ComUnitName FROM tblCompanyUnit WHERE ComUnitId = @CiD), '')     AS ComUnitName,
    CONVERT(VARCHAR, @fromDate, 6)                                                  AS fromDate,
    CONVERT(VARCHAR, @toDate,   6)                                                  AS toDate,
    P.ProductCode,
    P.ProductName,
    P.PackSize                                                                      AS BaseUnit,
    tbldcstr.BatchNo,                                                               -- BatchNo exposed per row
    ( ISNULL(vTblOB.Quantity,     0) + ISNULL(vTblOBfreez.Quantity, 0) )           AS OpeningStock,
    ISNULL(vTblStoReceive.TotalStockReceiveQty,      0)                             AS ReceiveFromCentralWarehouse,
    ISNULL(vTblChallanReceive.TotalStockReceiveQty,  0)                             AS ReceiveFromAreaOfficeInterTransfer,
    ISNULL(vTblStockReceive.TotalStockReceiveQty,    0)
        + ISNULL(vTblOB.Quantity,        0)
        + ISNULL(vTblSubdeportReturn.qty2, 0)
        + ISNULL(vTblOBfreez.Quantity,   0)                                         AS TotalReceived,
    ( ISNULL(vTblsales.Sales, 0)
        - ( ISNULL(tblD.DelQty,      0)
          ) )                                        AS IssuedToSales,
    ( ISNULL(vTblProductBonus.Sales, 0)
        - ISNULL(tblreturnBonus.DelQty,    0) )
        - ISNULL(tblreturnBonusold.DelQty, 0)                                      AS IssuedToProductBonus,
    ISNULL(vTblChallan.Challan,           0)                                        AS IssuedToAreaOfficeInterTransfer,
    0                                                                               AS IssuedToDamageAndOthers,
    ISNULL(vTblFreez2.Freeze,             0)                                        AS Blocked,
    /* -- Closing Stock -- */
    (
        ( ISNULL(vTblOB.Quantity,          0)
        + ISNULL(vTblOBfreez.Quantity,     0)
        + ISNULL(vTblStoReceive.TotalStockReceiveQty,     0)
        + ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0) )
      - ( ISNULL(vTblsales.Sales, 0)
            - ( ISNULL(tblD.DelQty,      0)
              + ISNULL(tblDRT.DelQty,    0)
              + ISNULL(tblDRTsub.DelQty, 0) ) )
      - ( ISNULL(vTblProductBonus.Sales, 0)
            - ( ISNULL(tblreturnBonus.DelQty,    0)
              + ISNULL(tblreturnBonusold.DelQty,  0) ) )
      - ISNULL(vTblDirectStockOut.StockOutQty, 0)
      - ISNULL(vTblChallan.Challan,            0)
      - ISNULL(vTblChallantoWH.qty,            0)
      + ISNULL(tblreturn.ReturnQty,            0)
    ) + ISNULL(tbl2ndrtn.Quantity, 0)                                               AS ClosingStock,
    ISNULL(vTblChallantoWH.qty,          0)                                         AS WHReturn,
    ISNULL(vTblSubdeportTransfer.qty1,   0)                                         AS SubdepoTransfer,
    ISNULL(vTblSubdeportReturn.qty2,     0)                                         AS Subdeporeturn,
    ISNULL(vTblDirectStockOut.StockOutQty, 0)                                       AS StockOutQty

FROM dbo.tblProduct P WITH (NOLOCK)

-- ====================================================================
-- BatchNo ANCHOR - one row per (ProductCode, BatchNo)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
    GROUP BY ProductCode, BatchNo
) tbldcstr ON tbldcstr.ProductCode = P.ProductCode


-- ====================================================================
-- OPENING BALANCE
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Quantity
    FROM     dbo.tblDCStore_OpeningBalance WITH (NOLOCK)
    WHERE    ComUnitId            = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    DCOpeningBalanceDate = '31-july-2026'
    GROUP BY ProductCode, BatchNo
) vTblOB ON vTblOB.ProductCode = P.ProductCode
        AND vTblOB.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- OPENING BALANCE (FREEZE)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Quantity
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    Opening   = @fromDate
    GROUP BY ProductCode, BatchNo
) vTblOBfreez ON vTblOBfreez.ProductCode = P.ProductCode
             AND vTblOBfreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUB-INVOICE RETURN  (SalesDisDB_SMC)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,

             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblSubInvoiceMaster  I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblSubInvoiceDetail  ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId

    WHERE    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode
) tblDRTsub ON tblDRTsub.ProductCode = P.ProductCode



-- ====================================================================
-- RECEIVE FROM CENTRAL WAREHOUSE
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId        = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    SChalanDetailsId IS NULL
      AND    ChalanDetailsId  IS NULL
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode
                AND vTblStoReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RECEIVE FROM AREA OFFICE (INTER TRANSFER)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    ChalanDetailsId IS NOT NULL
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode
                    AND vTblChallanReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- TOTAL STOCK RECEIVE  (used in TotalReceived formula)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode
                  AND vTblStockReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SALES  (Issued to Sales)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS Sales
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 0
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) vTblsales ON vTblsales.ProductCode = P.ProductCode
           AND vTblsales.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- DELIVERY RETURN  (tblD - current DB)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     dbo.tblInvoice       I  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblD ON tblD.ProductCode = P.ProductCode
      AND tblD.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- BOOK FOR DELIVERY
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS BookforDeliveryQty
    FROM     dbo.tblInvoice       I
    JOIN     dbo.tblInvoiceDetail ID ON I.InvoiceId = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.DelivaryInvoiceNo IS NULL
      AND    I.UpdateDate        IS NULL
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) tblBookforDeliveryQty ON tblBookforDeliveryQty.ProductCode = P.ProductCode
                       AND tblBookforDeliveryQty.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- PRODUCT BONUS  (Gift)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.TotalQuantity) AS Sales
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 1
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) vTblProductBonus ON vTblProductBonus.ProductCode = P.ProductCode
                  AND vTblProductBonus.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RETURN BONUS  (Gift return - current DB)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))                         AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     dbo.tblInvoice       I  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 1
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturnBonus ON tblreturnBonus.ProductCode = P.ProductCode
               AND tblreturnBonus.BatchNo       = tbldcstr.BatchNo


-- ====================================================================
-- RETURN BONUS OLD  (Gift return - SalesDisDB_SMC)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))                         AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblInvoice       I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore                  ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 1
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturnBonusold ON tblreturnBonusold.ProductCode = P.ProductCode
                   AND tblreturnBonusold.BatchNo       = tbldcstr.BatchNo


-- ====================================================================
-- ISSUED TO AREA OFFICE  (Inter Transfer Challan)
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS Challan
    FROM     dbo.tblChalanDetail CD WITH (NOLOCK)
    JOIN     dbo.tblChalanInfo   CI ON CI.ChalanId = CD.ChalanId
    WHERE    CI.FromComUnitId = COALESCE(NULLIF(@CiD, 0), CI.FromComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblChallan ON vTblChallan.ProductCode = P.ProductCode
             AND vTblChallan.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- FREEZE  (date range - vTblFreez, kept for reference)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo,
             (SUM(StockQty) + SUM(DamageQty)) AS Freeze
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblFreez ON vTblFreez.ProductCode = P.ProductCode
           AND vTblFreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- BLOCKED STOCK
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo,
             (SUM(StockQty) + SUM(DamageQty)) AS Freeze
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockCondition  = 'Blocked'
      AND    ReceiveDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode
            AND vTblFreez2.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- CURRENT STOCK  (reference only - not used in SELECT)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Closingstock
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
    GROUP BY ProductCode, BatchNo
) currentStock ON currentStock.ProductCode = P.ProductCode
              AND currentStock.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- WH RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty
    FROM     dbo.tblDepotToWHChalanInfo   CI WITH (NOLOCK)
    JOIN     dbo.tblDepotToWHChalanDetail CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit           CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblChallantoWH ON vTblChallantoWH.ProductCode = P.ProductCode
                 AND vTblChallantoWH.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUBDEPO TRANSFER
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty1
    FROM     dbo.tblSubDepotChalanInfo   CI WITH (NOLOCK)
    JOIN     dbo.tblSubDepotChalanDetail CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit          CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblSubdeportTransfer ON vTblSubdeportTransfer.ProductCode = P.ProductCode
                       AND vTblSubdeportTransfer.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUBDEPO RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty2
    FROM     dbo.tblSubDepotChalanReturnInfo    CI WITH (NOLOCK)
    JOIN     dbo.tblSubDepotChalanRetuenDetail  CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit                 CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CI.IsDeliver = 'True'
      AND    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode
                     AND vTblSubdeportReturn.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- DIRECT STOCK OUT / ADJUSTMENT VOUCHER
-- ====================================================================
LEFT JOIN (
    SELECT   DD.ProductCode, DD.BatchNo, SUM(DD.StackOutQty) AS StockOutQty
    FROM     dbo.tblDeStockOutMaster  DM WITH (NOLOCK)
    JOIN     dbo.tblDeStockOutDetails DD ON DM.DcStockOutMasterId = DD.DcStockOutMasterId
    JOIN     dbo.tblCompanyUnit       CU ON DM.ComUnitId          = CU.ComUnitId
    WHERE    DM.ComUnitId = COALESCE(NULLIF(@CiD, 0), DM.ComUnitId)
      AND    DM.ApprovedDate BETWEEN @fromDate AND @toDate
    GROUP BY DD.ProductCode, DD.BatchNo
) vTblDirectStockOut ON vTblDirectStockOut.ProductCode = P.ProductCode
                    AND vTblDirectStockOut.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- FREEZE STOCK  (tblfreez - date range, no ComUnitId filter - kept as original)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS StockQty
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) tblfreez ON tblfreez.ProductCode = P.ProductCode
          AND tblfreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- OLD DELIVERY RETURN  (SalesDisDB_SMC - tblDRT)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblInvoice       I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore                  ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblDRT ON tblDRT.ProductCode = P.ProductCode
        AND tblDRT.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- 2ND RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   ivD.ProductCode,
             ds.BatchNo,
             SUM(ISNULL(IDR.PreviousQuantity,    0))
           - SUM(ISNULL(IDR.sndReturnQuantity,   0)) AS Quantity
    FROM     dbo.tblInvoice             iv  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail       ivD WITH (NOLOCK) ON iv.InvoiceId       = ivD.InvoiceId
    LEFT JOIN dbo.tblDCStore            ds  WITH (NOLOCK) ON ds.DCStoreId       = ivD.DCStoreId
    JOIN     dbo.tblInvoiceDetailReturn IDR              ON IDR.InvoiceDetailId = ivD.InvoiceDetailId
    WHERE    IDR.PreviousQuantity  <> IDR.sndReturnQuantity
      AND    iv.SndReturnPaymentDate BETWEEN @fromDate AND @toDate
      AND    iv.ComUnitId = COALESCE(NULLIF(@CiD, 0), iv.ComUnitId)
    GROUP BY ivD.ProductCode, ds.BatchNo
) tbl2ndrtn ON tbl2ndrtn.ProductCode = P.ProductCode
           AND tbl2ndrtn.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- INVOICE ACTUAL QTY
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS InvActualQty
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 0
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) TblInvActual ON TblInvActual.ProductCode = P.ProductCode
              AND TblInvActual.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RETURN QTY  (tblreturn)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             SUM(ID.DeliveryQuantity) - SUM(ID.PaymentQuantity) AS ReturnQty
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.PaymentInvoiceNo IS NOT NULL
      AND    ID.DeliveryQuantity <> ID.PaymentQuantity
      AND    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    I.PaymentDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturn ON tblreturn.ProductCode = P.ProductCode
           AND tblreturn.BatchNo      = tbldcstr.BatchNo

-- ====================================================================
-- WHERE / ORDER
-- ====================================================================
WHERE  P.ProductGroupId = COALESCE(NULLIF(1, 0), P.ProductGroupId) and tbldcstr.BatchNo is not null and

 (( ISNULL(vTblsales.Sales, 0)
        - ( ISNULL(tblD.DelQty,      0)
          + ISNULL(tblDRT.DelQty,    0)
          + ISNULL(tblDRTsub.DelQty, 0) ) )  ) >  (ISNULL(vTblStockReceive.TotalStockReceiveQty,    0) + (  ISNULL(tblreturn.ReturnQty, 0) + ISNULL(tbl2ndrtn.Quantity, 0)   ))
        + ISNULL(vTblOB.Quantity,        0)
        + ISNULL(vTblSubdeportReturn.qty2, 0)
        + ISNULL(vTblOBfreez.Quantity,   0)



ORDER BY P.ProductName, tbldcstr.BatchNo

END
GO

IF OBJECT_ID('dbo.sp_RPT_DuplicateOrderCode', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_DuplicateOrderCode;
GO

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
GO

IF OBJECT_ID('dbo.sp_RPT_DuplicateOrderNoInInvoice', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_DuplicateOrderNoInInvoice;
GO

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
GO

IF OBJECT_ID('dbo.sp_RPT_DuplicateInvoiceNo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_DuplicateInvoiceNo;
GO

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
GO

IF OBJECT_ID('dbo.sp_RPT_DuplicateCustomerCode', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_DuplicateCustomerCode;
GO

CREATE PROCEDURE [dbo].[sp_RPT_DuplicateCustomerCode]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		CustomerCode,
		COUNT(CustomerCode) AS DuplicateCount
	FROM dbo.tblCustMaster WITH (NOLOCK)
	GROUP BY CustomerCode
	HAVING COUNT(CustomerCode) > 1
	ORDER BY DuplicateCount DESC, CustomerCode;

END
GO

IF OBJECT_ID('dbo.sp_RPT_InvoicePaymentVatTpMismatch', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_InvoicePaymentVatTpMismatch;
GO

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
GO

IF OBJECT_ID('dbo.sp_RPT_TourPlanMissingSerial', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RPT_TourPlanMissingSerial;
GO

CREATE PROCEDURE [dbo].[sp_RPT_TourPlanMissingSerial]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT
		tp.EmpInfoId,
		emp.EmpName
	FROM dbo.tbl_TourPlanInfo tp WITH (NOLOCK)
	LEFT JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK) ON emp.EmpInfoId = tp.EmpInfoId
	WHERE CONVERT(date, tp.TourPlanDate) = CONVERT(date, GETDATE())
		AND tp.EmpInfoId NOT IN (
			SELECT EmpInfoId
			FROM dbo.tbl_TourPlanInfo WITH (NOLOCK)
			WHERE SerialNo = 1 AND CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		)
	ORDER BY tp.EmpInfoId;

END
GO

IF OBJECT_ID('dbo.sp_FixTourPlanMissingSerial', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FixTourPlanMissingSerial;
GO

CREATE PROCEDURE [dbo].[sp_FixTourPlanMissingSerial]
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.tbl_TourPlanInfo
	SET SerialNo = 1
	WHERE CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		AND EmpInfoId NOT IN (
			SELECT EmpInfoId
			FROM dbo.tbl_TourPlanInfo
			WHERE SerialNo = 1 AND CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		);

	SELECT @@ROWCOUNT AS UpdatedRows;

END
GO
