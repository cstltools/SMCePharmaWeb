CREATE PROCEDURE [dbo].[sp_RptBussinessSummary_DCWise]

	@Year INT,
	@Month INT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
	DECLARE @EndDate DATE = DATEADD(MONTH, 1, @StartDate);

	-- Same "Net Sales" business rule as sp_RptBussinessSummary_DayWise, just aggregated per
	-- Distribution Center for the whole month instead of per calendar day for one DC.
	SELECT
		cu.ComUnitId,
		cu.ComUnitCode + ':' + cu.ComUnitName AS ComUnitName,
		ISNULL(s.SalesAmtTP, 0) - ISNULL(r.ReturnAmountTP, 0) - ISNULL(r2.TP, 0) AS JustSalesAmtTP,
		ISNULL(s.SalesGrossAmt, 0) - ISNULL(r.ReturnGrossAmt, 0) - ISNULL(r2.Gross, 0) AS JustSalesGrossAmt,
		ISNULL(sap.SAPsendAmount, 0) - ISNULL(sapRtn.SAPReturnAmount, 0) - ISNULL(sapExpRtn.SAPExpiryReturnAmount, 0) AS SAPsendAmount
	FROM dbo.tblCompanyUnit cu WITH (NOLOCK)

	--Sales Confirmation
	LEFT JOIN (
		SELECT mas.ComUnitId,
			SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) AS SalesAmtTP,
			SUM(D.DeliveryNetAmount) AS SalesGrossAmt
		FROM dbo.tblInvoice I WITH (NOLOCK)
		INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
		INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
		WHERE I.UpdateDate >= @StartDate AND I.UpdateDate < @EndDate
			AND I.DelivaryInvoiceNo IS NOT NULL
		GROUP BY mas.ComUnitId
	) s ON s.ComUnitId = cu.ComUnitId

	--Payment Return (1st Return)
	LEFT JOIN (
		SELECT mas.ComUnitId,
			SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0)) - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)) AS ReturnAmountTP,
			(SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0)) - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)))
				+ SUM(ISNULL(ID.DeliveryTotalPriceVatAmount - ID.PaymentTotalPriceVatAmount, 0)) AS ReturnGrossAmt
		FROM dbo.tblInvoice I WITH (NOLOCK)
		INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
		INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
		WHERE I.PaymentInvoiceNo IS NOT NULL
			AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
			AND I.PaymentDate >= @StartDate AND I.PaymentDate < @EndDate
		GROUP BY mas.ComUnitId
	) r ON r.ComUnitId = cu.ComUnitId

	--2nd Return
	LEFT JOIN (
		SELECT O.ComUnitId,
			SUM(ISNULL(ivD.PaymentTotalPrice - ret.sndReturnTotalPrice, 0)) AS TP,
			(SUM(ISNULL(ivD.PaymentTotalPrice - ret.sndReturnTotalPrice, 0)) - SUM(ISNULL(ivD.PaymentDiscountAmount - ret.sndReturnDiscountAmount, 0)))
				+ SUM(ISNULL(ivD.PaymentTotalPriceVatAmount - ret.sndReturnTotalPriceVatAmount, 0)) AS Gross
		FROM dbo.tblInvoice iv WITH (NOLOCK)
		INNER JOIN dbo.tblInvoiceDetail ivD WITH (NOLOCK) ON iv.InvoiceId = ivD.InvoiceId
		INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = iv.OrderId
		INNER JOIN dbo.tblInvoiceDetailReturn ret WITH (NOLOCK) ON ret.InvoiceDetailId = ivD.InvoiceDetailId
		WHERE ret.PreviousQuantity <> ret.sndReturnQuantity
			AND iv.SndReturnPaymentDate >= @StartDate AND iv.SndReturnPaymentDate < @EndDate
		GROUP BY O.ComUnitId
	) r2 ON r2.ComUnitId = cu.ComUnitId

	--SAP Send Amount (joined on Plant = tblCompanyUnit.Customer_Code, as in the day wise report)
	LEFT JOIN (
		SELECT S.Plant,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPsendAmount
		FROM SAP_API_Data..tbl_DeliveryConfirmation_Sales S WITH (NOLOCK)
		WHERE S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
			AND S.isDemo = 1
			AND S.FOCFlag IS NULL
		GROUP BY S.Plant
	) sap ON sap.Plant = cu.Customer_Code

	--SAP Return Amount (deducted from SAP Send Amount)
	LEFT JOIN (
		SELECT S.Plant,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPReturnAmount
		FROM SAP_API_Data..tbl_Return S WITH (NOLOCK)
		WHERE S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
		GROUP BY S.Plant
	) sapRtn ON sapRtn.Plant = cu.Customer_Code

	--SAP Expiry Return Amount (joined on SAP_Code, not Customer_Code - same as the day wise report)
	LEFT JOIN (
		SELECT S.Plant,
			(SUM(S.Quantity * S.UnitPrice) + SUM(S.VAT)) - SUM(S.DiscountAmount) AS SAPExpiryReturnAmount
		FROM SAP_API_Data..tbl_ExpiryReturn S WITH (NOLOCK)
		WHERE S.SalesDocDate >= @StartDate AND S.SalesDocDate < @EndDate
		GROUP BY S.Plant
	) sapExpRtn ON sapExpRtn.Plant = cu.SAP_Code

	ORDER BY cu.ComUnitCode

END
