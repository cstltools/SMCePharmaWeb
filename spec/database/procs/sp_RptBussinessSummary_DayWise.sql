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
