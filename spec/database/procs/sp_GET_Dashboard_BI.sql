CREATE PROCEDURE [dbo].[sp_GET_Dashboard_BI] --EXEC sp_GET_Dashboard_BI
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
DECLARE @ToDate   DATE = '2030-06-30';

;WITH
/* =========================
   ORDER monthly aggregate
   ========================= */
OrderAgg AS
(
    SELECT
        DATEFROMPARTS(YEAR(o.SubmissionDate), MONTH(o.SubmissionDate), 1) AS MonthStart,
        o.RegionId,
        o.AreaID,
        CASE WHEN MONTH(o.SubmissionDate) >= 7 THEN YEAR(o.SubmissionDate) ELSE YEAR(o.SubmissionDate) - 1 END AS FiscalYearStart,

        SUM(od.Quantity)  AS MTDOrderQuantity,
        SUM(od.NetAmount) AS MTDOrderAmount,
        COUNT(*)          AS OrderTotalLines,
        COUNT(DISTINCT o.OrderId) AS OrderTotalOrders
    FROM dbo.tblOrder o WITH (NOLOCK)
    INNER JOIN dbo.tblOrderDetail od WITH (NOLOCK) ON od.OrderId = o.OrderId
    WHERE o.SubmissionDate >= @FromDate
      AND o.SubmissionDate <= @ToDate
      AND o.ActionStatus = '2'
    GROUP BY
        DATEFROMPARTS(YEAR(o.SubmissionDate), MONTH(o.SubmissionDate), 1),
        o.RegionId, o.AreaID,
        CASE WHEN MONTH(o.SubmissionDate) >= 7 THEN YEAR(o.SubmissionDate) ELSE YEAR(o.SubmissionDate) - 1 END
),

/* =========================
   INVOICE monthly aggregate
   ========================= */
InvoiceAgg AS
(
    SELECT
        DATEFROMPARTS(YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), 1) AS MonthStart,
        o.RegionId,
        o.AreaID,
        CASE WHEN MONTH(i.InvoiceDate) >= 7 THEN YEAR(i.InvoiceDate) ELSE YEAR(i.InvoiceDate) - 1 END AS FiscalYearStart,

        COUNT(DISTINCT i.InvoiceId) AS MTDInvoiceQuantity,
        --SUM(((id.TotalPrice)*(id.TotalPriceVatAmount)) - id.DiscountAmount - ISNULL(id.AdjustmentAmount,0)) AS MTDInvoiceAmount,
        SUM(ISNULL(id.NetAmount,0)) AS MTDInvoiceAmount,
        COUNT(*) AS InvoiceTotalLines,
        COUNT(DISTINCT i.InvoiceId) AS InvoiceTotalInvoices
    FROM dbo.tblInvoice i WITH (NOLOCK)
    INNER JOIN dbo.tblOrder o WITH (NOLOCK) ON o.OrderId = i.OrderId
    INNER JOIN dbo.tblInvoiceDetail id WITH (NOLOCK) ON id.InvoiceId = i.InvoiceId
    WHERE i.TpGrandTotal > 0
      AND i.InvoiceDate >= @FromDate
      AND i.InvoiceDate <= @ToDate
    GROUP BY
        DATEFROMPARTS(YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), 1),
        o.RegionId, o.AreaID,
        CASE WHEN MONTH(i.InvoiceDate) >= 7 THEN YEAR(i.InvoiceDate) ELSE YEAR(i.InvoiceDate) - 1 END
),

/* =========================
   SALE monthly aggregate (Delivered)
   ========================= */
SaleAgg AS
(
    SELECT
        DATEFROMPARTS(YEAR(i.UpdateDate), MONTH(i.UpdateDate), 1) AS MonthStart,
        o.RegionId,
        o.AreaID,
        CASE WHEN MONTH(i.UpdateDate) >= 7 THEN YEAR(i.UpdateDate) ELSE YEAR(i.UpdateDate) - 1 END AS FiscalYearStart,

        COUNT(DISTINCT i.InvoiceId) AS MTDSaleQuantity,
        SUM(d.DeliveryNetAmount) AS MTDSaleAmount,
        COUNT(*) AS SaleTotalLines,
        COUNT(DISTINCT i.InvoiceId) AS SaleTotalInvoices
    FROM dbo.tblInvoice i WITH (NOLOCK)
    INNER JOIN dbo.tblOrder o WITH (NOLOCK) ON o.OrderId = i.OrderId
    INNER JOIN dbo.tblInvoiceDetail d WITH (NOLOCK) ON d.InvoiceId = i.InvoiceId
    WHERE i.DelivaryInvoiceNo IS NOT NULL
      AND i.UpdateDate >= @FromDate
      AND i.UpdateDate <= @ToDate
    GROUP BY
        DATEFROMPARTS(YEAR(i.UpdateDate), MONTH(i.UpdateDate), 1),
        o.RegionId, o.AreaID,
        CASE WHEN MONTH(i.UpdateDate) >= 7 THEN YEAR(i.UpdateDate) ELSE YEAR(i.UpdateDate) - 1 END
),

/* =========================
   RETURN monthly aggregate (Payment/Return)
   ========================= */
ReturnAgg AS
(
    SELECT
        DATEFROMPARTS(YEAR(i.PaymentDate), MONTH(i.PaymentDate), 1) AS MonthStart,
        o.RegionId,
        o.AreaID,
        CASE WHEN MONTH(i.PaymentDate) >= 7 THEN YEAR(i.PaymentDate) ELSE YEAR(i.PaymentDate) - 1 END AS FiscalYearStart,

        COUNT(DISTINCT i.InvoiceId) AS MTDtReturnQuantity,
        (
            SUM(ISNULL(id.DeliveryTotalPrice - id.PaymentTotalPrice, 0))
            - SUM(ISNULL(id.DeliveryDiscountAmount - id.PaymentDiscountAmount, 0))
        ) AS MTDtReturnAmount,
        COUNT(*) AS ReturnTotalLines,
        COUNT(DISTINCT i.InvoiceId) AS ReturnTotalInvoices
    FROM dbo.tblInvoice i WITH (NOLOCK)
    INNER JOIN dbo.tblOrder o WITH (NOLOCK) ON o.OrderId = i.OrderId
    INNER JOIN dbo.tblInvoiceDetail id WITH (NOLOCK) ON id.InvoiceId = i.InvoiceId
    WHERE i.PaymentInvoiceNo IS NOT NULL
      AND i.PaymentDate >= @FromDate
      AND i.PaymentDate <= @ToDate
      AND ISNULL(id.PaymentTotalQuantity,0) <> ISNULL(id.DeliveryTotalQuantity,0)
    GROUP BY
        DATEFROMPARTS(YEAR(i.PaymentDate), MONTH(i.PaymentDate), 1),
        o.RegionId, o.AreaID,
        CASE WHEN MONTH(i.PaymentDate) >= 7 THEN YEAR(i.PaymentDate) ELSE YEAR(i.PaymentDate) - 1 END
),

/* =========================
   Keys union (covers months where any metric exists)
   ========================= */
Keys AS
(
    SELECT MonthStart, RegionId, AreaID, FiscalYearStart FROM OrderAgg
    UNION
    SELECT MonthStart, RegionId, AreaID, FiscalYearStart FROM InvoiceAgg
    UNION
    SELECT MonthStart, RegionId, AreaID, FiscalYearStart FROM SaleAgg
    UNION
    SELECT MonthStart, RegionId, AreaID, FiscalYearStart FROM ReturnAgg
),

/* =========================
   Join all aggregates into one base
   ========================= */
Base AS
(
    SELECT
        k.MonthStart,
        YEAR(k.MonthStart)  AS SalesYear,
        MONTH(k.MonthStart) AS SalesMonth,
        DATENAME(MONTH, k.MonthStart) AS SalesMonthName,
        k.FiscalYearStart,
        CONCAT(k.FiscalYearStart, '-', k.FiscalYearStart + 1) AS FiscalYearLabel,
        (YEAR(k.MonthStart)*100 + MONTH(k.MonthStart)) AS YearMonthKey,

        k.RegionId,
        k.AreaID,

        ISNULL(o.MTDOrderQuantity,0) AS MTDOrderQuantity,
        ISNULL(o.MTDOrderAmount,0)   AS MTDOrderAmount,
        ISNULL(o.OrderTotalLines,0)  AS OrderTotalLines,
        ISNULL(o.OrderTotalOrders,0) AS OrderTotalOrders,

        ISNULL(iv.MTDInvoiceQuantity,0) AS MTDInvoiceQuantity,
        ISNULL(iv.MTDInvoiceAmount,0)   AS MTDInvoiceAmount,
        ISNULL(iv.InvoiceTotalLines,0)  AS InvoiceTotalLines,
        ISNULL(iv.InvoiceTotalInvoices,0) AS InvoiceTotalInvoices,

        ISNULL(s.MTDSaleQuantity,0) AS MTDSaleQuantity,
        ISNULL(s.MTDSaleAmount,0)   AS MTDSaleAmount,
        ISNULL(s.SaleTotalLines,0)  AS SaleTotalLines,
        ISNULL(s.SaleTotalInvoices,0) AS SaleTotalInvoices,

        ISNULL(r.MTDtReturnQuantity,0) AS MTDtReturnQuantity,
        ISNULL(r.MTDtReturnAmount,0)   AS MTDtReturnAmount,
        ISNULL(r.ReturnTotalLines,0)   AS ReturnTotalLines,
        ISNULL(r.ReturnTotalInvoices,0) AS ReturnTotalInvoices
    FROM Keys k
    LEFT JOIN OrderAgg  o  ON o.MonthStart=k.MonthStart AND o.RegionId=k.RegionId AND o.AreaID=k.AreaID AND o.FiscalYearStart=k.FiscalYearStart
    LEFT JOIN InvoiceAgg iv ON iv.MonthStart=k.MonthStart AND iv.RegionId=k.RegionId AND iv.AreaID=k.AreaID AND iv.FiscalYearStart=k.FiscalYearStart
    LEFT JOIN SaleAgg   s  ON s.MonthStart=k.MonthStart AND s.RegionId=k.RegionId AND s.AreaID=k.AreaID AND s.FiscalYearStart=k.FiscalYearStart
    LEFT JOIN ReturnAgg r  ON r.MonthStart=k.MonthStart AND r.RegionId=k.RegionId AND r.AreaID=k.AreaID AND r.FiscalYearStart=k.FiscalYearStart
)

SELECT
    ISNULL(ar.AreaName,'')   AS AreaName,
    ISNULL(ar.AreaCode,'')   AS AreaCode,
    ISNULL(rg.RegionName,'') AS ZoneName,
    ISNULL(rg.RegionCode,'') AS ZoneCode,

    b.SalesYear,
    b.SalesMonth,
    b.SalesMonthName,
    b.FiscalYearStart,
    b.FiscalYearLabel,

    b.RegionId,
    b.AreaID,

    /* ===== MTD ===== */
    b.MTDOrderQuantity,
    b.MTDOrderAmount,
    b.MTDInvoiceQuantity,
    b.MTDInvoiceAmount,
    b.MTDSaleQuantity,
    b.MTDSaleAmount,
    b.MTDtReturnQuantity,
    b.MTDtReturnAmount,
    ISNULL(b.OrderTotalLines,0)  AS OrderTotalLines,
ISNULL(b.OrderTotalOrders,0) AS OrderTotalOrders,
ISNULL(b.InvoiceTotalLines,0)  AS InvoiceTotalLines,
ISNULL(b.InvoiceTotalInvoices,0) AS InvoiceTotalInvoices,
ISNULL(b.SaleTotalLines,0)  AS SaleTotalLines,
ISNULL(b.SaleTotalInvoices,0) AS SaleTotalInvoices,
ISNULL(b.ReturnTotalLines,0)  AS ReturnTotalLines,
ISNULL(b.ReturnTotalInvoices,0) AS ReturnTotalInvoices,
    /* ===== YTD (Fiscal reset) ===== */
    SUM(b.MTDOrderQuantity) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDOrderQuantity,
    SUM(b.MTDOrderAmount)   OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDOrderAmount,

    SUM(b.MTDInvoiceQuantity) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDInvoiceQuantity,
    SUM(b.MTDInvoiceAmount)   OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDInvoiceAmount,

    SUM(b.MTDSaleQuantity) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDSaleQuantity,
    SUM(b.MTDSaleAmount)   OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDSaleAmount,

    SUM(b.MTDtReturnQuantity) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDReturnQuantity,
    SUM(b.MTDtReturnAmount)   OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) AS YTDReturnAmount,

    /* ===== LPC MTD ===== */
    CAST(b.OrderTotalLines * 1.0 / NULLIF(b.OrderTotalOrders,0) AS DECIMAL(18,12)) AS MTDOrderLPC,
    CAST(b.InvoiceTotalLines * 1.0 / NULLIF(b.InvoiceTotalInvoices,0) AS DECIMAL(18,12)) AS MTDInvoiceLPC,
    CAST(b.SaleTotalLines * 1.0 / NULLIF(b.SaleTotalInvoices,0) AS DECIMAL(18,12)) AS MTDSaleLPC,
    CAST(b.ReturnTotalLines * 1.0 / NULLIF(b.ReturnTotalInvoices,0) AS DECIMAL(18,12)) AS MTDtReturnLPC,

    /* ===== LPC YTD (Fiscal reset) ===== */
    CAST(
        SUM(b.OrderTotalLines) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) * 1.0
        / NULLIF(SUM(b.OrderTotalOrders) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart), 0)
    AS DECIMAL(18,12)) AS YTDOrderLPC,

    CAST(
        SUM(b.InvoiceTotalLines) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) * 1.0
        / NULLIF(SUM(b.InvoiceTotalInvoices) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart), 0)
    AS DECIMAL(18,12)) AS YTDInvoiceLPC,

    CAST(
        SUM(b.SaleTotalLines) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) * 1.0
        / NULLIF(SUM(b.SaleTotalInvoices) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart), 0)
    AS DECIMAL(18,12)) AS YTDSaleLPC,

    CAST(
        SUM(b.ReturnTotalLines) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart) * 1.0
        / NULLIF(SUM(b.ReturnTotalInvoices) OVER (PARTITION BY b.RegionId, b.AreaID, b.FiscalYearStart ORDER BY b.MonthStart), 0)
    AS DECIMAL(18,12)) AS YTDReturnLPC

FROM Base b
LEFT JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = b.RegionId
LEFT JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = b.AreaID
ORDER BY b.RegionId, b.AreaID, b.MonthStart
OPTION (MAXRECURSION 0);
    




    --DECLARE @FromDate DATE = '2021-07-01';
    --DECLARE @ToDate   DATE = '2030-06-30';

    --;WITH
    --Months AS
    --(
    --    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
    --    UNION ALL
    --    SELECT DATEADD(MONTH, 1, MonthStart)
    --    FROM Months
    --    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    --),
    ---- ✅ All Zone/Area combinations within date range (so months with 0 data also show)
    --DimZoneArea AS
    --(
    --    SELECT DISTINCT A.RegionId, A.AreaID
    --    FROM dbo.tblOrder A WITH (NOLOCK)
    --    WHERE A.SubmissionDate >= @FromDate
    --      AND A.SubmissionDate <= @ToDate
    --      --AND A.OrderType = 'Regular'
    --      AND A.ActionStatus = '2'
    --),

    ---- ✅ Order MTD grouped by Month + Zone + Area
    --OrderMTD AS
    --(
    --    SELECT 
    --        DATEFROMPARTS(YEAR(A.SubmissionDate), MONTH(A.SubmissionDate), 1) AS MonthStart,
    --        A.RegionId,
    --        A.AreaID,
    --        SUM(B.Quantity) AS Quantity,
    --        SUM(B.NetAmount) AS Amount,
    --        COUNT(*) AS TotalLines,
    --        COUNT(DISTINCT A.OrderId) AS TotalOrders
    --    FROM dbo.tblOrder A WITH (NOLOCK)
    --    INNER JOIN dbo.tblOrderDetail B WITH (NOLOCK) ON B.OrderId = A.OrderId
    --    WHERE A.SubmissionDate >= @FromDate
    --      AND A.SubmissionDate <= @ToDate
    --      --AND A.OrderType = 'Regular'
    --      AND A.ActionStatus = '2'
    --    GROUP BY DATEFROMPARTS(YEAR(A.SubmissionDate), MONTH(A.SubmissionDate), 1),
    --             A.RegionId, A.AreaID
    --),

    ---- ✅ Invoice MTD grouped by Month + Zone + Area
    --InvoiceMTD AS
    --(
    --    SELECT 
    --        DATEFROMPARTS(YEAR(I.InvoiceDate), MONTH(I.InvoiceDate), 1) AS MonthStart,
    --        mas.RegionId,
    --        mas.AreaID,
    --        COUNT(DISTINCT I.InvoiceId) AS Quantity,
    --        SUM(ID.TotalPrice - ID.DiscountAmount - ISNULL(ID.AdjustmentAmount,0)) AS Amount,
    --        COUNT(*) AS TotalLines,
    --        COUNT(DISTINCT I.InvoiceId) AS TotalInvoices
    --    FROM dbo.tblInvoice I WITH (NOLOCK)
    --    INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    --    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    --    WHERE I.TpGrandTotal > 0
    --      AND I.InvoiceDate >= @FromDate
    --      AND I.InvoiceDate <= @ToDate
    --    GROUP BY DATEFROMPARTS(YEAR(I.InvoiceDate), MONTH(I.InvoiceDate), 1),
    --             mas.RegionId, mas.AreaID
    --),

    ---- ✅ Sales MTD grouped by Month + Zone + Area
    --SaleMTD AS
    --(
    --    SELECT 
    --        DATEFROMPARTS(YEAR(I.UpdateDate), MONTH(I.UpdateDate), 1) AS MonthStart,
    --        mas.RegionId,
    --        mas.AreaID,
    --        COUNT(DISTINCT I.InvoiceId) AS Quantity,
    --        SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) AS Amount,
    --        COUNT(*) AS TotalLines,
    --        COUNT(DISTINCT I.InvoiceId) AS TotalInvoices
    --    FROM dbo.tblInvoice I WITH (NOLOCK)
    --    INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    --    INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
    --    WHERE I.DelivaryInvoiceNo IS NOT NULL
    --      AND I.UpdateDate >= @FromDate
    --      AND I.UpdateDate <= @ToDate
    --    GROUP BY DATEFROMPARTS(YEAR(I.UpdateDate), MONTH(I.UpdateDate), 1),
    --             mas.RegionId, mas.AreaID
    --),

    ---- ✅ Return MTD grouped by Month + Zone + Area
    --ReturnMTD AS
    --(
    --    SELECT 
    --        DATEFROMPARTS(YEAR(I.PaymentDate), MONTH(I.PaymentDate), 1) AS MonthStart,
    --        mas.RegionId,
    --        mas.AreaID,
    --        COUNT(DISTINCT I.InvoiceId) AS Quantity,
    --        ( SUM(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0))
    --          - SUM(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0)) ) AS Amount,
    --        COUNT(*) AS TotalLines,
    --        COUNT(DISTINCT I.InvoiceId) AS TotalInvoices
    --    FROM dbo.tblInvoice I WITH (NOLOCK)
    --    INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    --    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    --    WHERE I.PaymentInvoiceNo IS NOT NULL
    --      AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
    --      AND I.PaymentDate >= @FromDate
    --      AND I.PaymentDate <= @ToDate
    --    GROUP BY DATEFROMPARTS(YEAR(I.PaymentDate), MONTH(I.PaymentDate), 1),
    --             mas.RegionId, mas.AreaID
    --)

    --SELECT
    --    -- ✅ Names from master tables
    --    ISNULL(ar.AreaName,'') AS AreaName,
    --    ISNULL(ar.AreaCode,'') AS AreaCode,
    --    ISNULL(rg.RegionName,'') AS ZoneName,
    --    ISNULL(rg.RegionCode,'') AS ZoneCode,

    --    YEAR(m.MonthStart) AS SalesYear,
    --    MONTH(m.MonthStart) AS SalesMonth,
    --    DATENAME(MONTH, m.MonthStart) AS SalesMonthName,

    --    za.RegionId,
    --    za.AreaID,

    --    -- Order MTD/YTD
    --    ISNULL(ord.Quantity, 0) AS MTDOrderQuantity,
    --    SUM(ISNULL(ord.Quantity, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDOrderQuantity,

    --    ISNULL(ord.Amount, 0) AS MTDOrderAmount,
    --    SUM(ISNULL(ord.Amount, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDOrderAmount,

    --    -- Invoice MTD/YTD
    --    ISNULL(inv.Quantity, 0) AS MTDInvoiceQuantity,
    --    SUM(ISNULL(inv.Quantity, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDInvoiceQuantity,

    --    ISNULL(inv.Amount, 0) AS MTDInvoiceAmount,
    --    SUM(ISNULL(inv.Amount, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDInvoiceAmount,

    --    -- Sale MTD/YTD
    --    ISNULL(sal.Quantity, 0) AS MTDSaleQuantity,
    --    SUM(ISNULL(sal.Quantity, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDSaleQuantity,

    --    -- Return MTD/YTD
    --    ISNULL(ret.Quantity, 0) AS MTDtReturnQuantity,
    --    SUM(ISNULL(ret.Quantity, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDReturnQuantity,

    --    -- Amounts
    --    ISNULL(sal.Amount, 0) AS MTDSaleAmount,
    --    SUM(ISNULL(sal.Amount, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDSaleAmount,

    --    ISNULL(ret.Amount, 0) AS MTDtReturnAmount,
    --    SUM(ISNULL(ret.Amount, 0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) AS YTDReturnAmount,

    --    -- ✅ LPC (MTD = lines/orders, YTD = cumulative lines / cumulative orders)
    --    CAST(ISNULL(ord.TotalLines,0) * 1.0 / NULLIF(ISNULL(ord.TotalOrders,0),0) AS DECIMAL(18,12)) AS MTDOrderLPC,
    --    CAST(
    --        SUM(ISNULL(ord.TotalLines,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) * 1.0
    --        / NULLIF(SUM(ISNULL(ord.TotalOrders,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart), 0)
    --    AS DECIMAL(18,12)) AS YTDOrderLPC,

    --    CAST(ISNULL(inv.TotalLines,0) * 1.0 / NULLIF(ISNULL(inv.TotalInvoices,0),0) AS DECIMAL(18,12)) AS MTDInvoiceLPC,
    --    CAST(
    --        SUM(ISNULL(inv.TotalLines,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) * 1.0
    --        / NULLIF(SUM(ISNULL(inv.TotalInvoices,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart), 0)
    --    AS DECIMAL(18,12)) AS YTDInvoiceLPC,

    --    CAST(ISNULL(sal.TotalLines,0) * 1.0 / NULLIF(ISNULL(sal.TotalInvoices,0),0) AS DECIMAL(18,12)) AS MTDSaleLPC,
    --    CAST(
    --        SUM(ISNULL(sal.TotalLines,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) * 1.0
    --        / NULLIF(SUM(ISNULL(sal.TotalInvoices,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart), 0)
    --    AS DECIMAL(18,12)) AS YTDSaleLPC,

    --    CAST(ISNULL(ret.TotalLines,0) * 1.0 / NULLIF(ISNULL(ret.TotalInvoices,0),0) AS DECIMAL(18,12)) AS MTDtReturnLPC,
    --    CAST(
    --        SUM(ISNULL(ret.TotalLines,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart) * 1.0
    --        / NULLIF(SUM(ISNULL(ret.TotalInvoices,0)) OVER (PARTITION BY za.RegionId, za.AreaID ORDER BY m.MonthStart), 0)
    --    AS DECIMAL(18,12)) AS YTDReturnLPC

    --FROM Months m
    --CROSS JOIN DimZoneArea za
    --LEFT JOIN OrderMTD  ord ON ord.MonthStart = m.MonthStart AND ord.RegionId = za.RegionId AND ord.AreaID = za.AreaID
    --LEFT JOIN InvoiceMTD inv ON inv.MonthStart = m.MonthStart AND inv.RegionId = za.RegionId AND inv.AreaID = za.AreaID
    --LEFT JOIN SaleMTD   sal ON sal.MonthStart = m.MonthStart AND sal.RegionId = za.RegionId AND sal.AreaID = za.AreaID
    --LEFT JOIN ReturnMTD ret ON ret.MonthStart = m.MonthStart AND ret.RegionId = za.RegionId AND ret.AreaID = za.AreaID

    --LEFT JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = za.RegionId
    --LEFT JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = za.AreaID

    --ORDER BY za.RegionId, za.AreaID, m.MonthStart
    --OPTION (MAXRECURSION 400);

END