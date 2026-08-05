
CREATE PROCEDURE [dbo].[sp_GET_ReturnReasonAnalysis]   -- exec sp_GET_ReturnReasonAnalysis
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
    DECLARE @ToDate   DATE = '2030-06-30';

    ;WITH Months AS (
        SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
        UNION ALL
        SELECT DATEADD(MONTH, 1, MonthStart)
        FROM Months
        WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    ),

    -- 2nd return: aggregate per InvoiceDetailId (duplication stop)
    RetAgg AS (
        SELECT
            r.InvoiceDetailId,
            SUM(ISNULL(r.sndReturnTotalPrice, 0))          AS sndReturnTotalPrice,
            SUM(ISNULL(r.sndReturnTotalPriceVatAmount, 0)) AS sndReturnTotalPriceVatAmount,
            SUM(ISNULL(r.sndReturnDiscountAmount, 0))      AS sndReturnDiscountAmount,
            SUM(CAST(ISNULL(r.PreviousQuantity,0) AS decimal(18,1))
              - CAST(ISNULL(r.sndReturnQuantity,0) AS decimal(18,1))) AS sndReturnQty
        FROM dbo.tblInvoiceDetailReturn r WITH (NOLOCK)
        GROUP BY r.InvoiceDetailId
    ),

    -- 1st Return (Payment Return): Month = PaymentDate
    FirstReturn AS (
        SELECT
            m.MonthStart,
            YEAR(m.MonthStart) AS SalesYear,
            MONTH(m.MonthStart) AS SalesMonth,
            DATENAME(MONTH, m.MonthStart) AS SalesMonthName,

            mas.RegionId             AS ZoneID,
            ISNULL(rg.RegionName,'') AS ZoneName,
            mas.AreaID               AS AreaID,
            ISNULL(ar.AreaName,'')   AS AreaName,

            CASE
                WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
                ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
            END AS Return_Reason,

            -- 1st return amount (TP only; if you want VAT add it separately)
            SUM(
                (ISNULL(ID.DeliveryTotalPrice,0) - ISNULL(ID.PaymentTotalPrice,0))
              - (ISNULL(ID.DeliveryDiscountAmount,0) - ISNULL(ID.PaymentDiscountAmount,0))
            ) AS Return_Amount,

            SUM(ISNULL(ID.DeliveryTotalQuantity, 0) - ISNULL(ID.PaymentTotalQuantity, 0)) AS Return_Qty
        FROM Months m
        INNER JOIN dbo.tblInvoice I WITH (NOLOCK)
            ON I.PaymentDate >= m.MonthStart
           AND I.PaymentDate <  DATEADD(MONTH, 1, m.MonthStart)
        INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
        LEFT  JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = mas.RegionId
        LEFT  JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = mas.AreaID
        WHERE
            I.PaymentInvoiceNo IS NOT NULL
            AND ID.PaymentReturnReason IS NOT NULL
            AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
            AND CONVERT(date, I.PaymentDate) BETWEEN @FromDate AND @ToDate
        GROUP BY
            m.MonthStart,
            mas.RegionId, rg.RegionName,
            mas.AreaID,   ar.AreaName,
            CASE
                WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
                ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
            END
    ),

    -- 2nd Return: Month = SndReturnPaymentDate (like MIS)
    SecondReturn AS (
        SELECT
            m.MonthStart,
            YEAR(m.MonthStart) AS SalesYear,
            MONTH(m.MonthStart) AS SalesMonth,
            DATENAME(MONTH, m.MonthStart) AS SalesMonthName,

            mas.RegionId             AS ZoneID,
            ISNULL(rg.RegionName,'') AS ZoneName,
            mas.AreaID               AS AreaID,
            ISNULL(ar.AreaName,'')   AS AreaName,

            CASE
                WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
                ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
            END AS Return_Reason,

            -- 2nd return amount (TP net of discount difference)
            SUM(
                (ISNULL(ID.PaymentTotalPrice,0) - ISNULL(RA.sndReturnTotalPrice,0))
              - (ISNULL(ID.PaymentDiscountAmount,0) - ISNULL(RA.sndReturnDiscountAmount,0))
            ) AS Return_Amount,

            SUM(ISNULL(RA.sndReturnQty,0)) AS Return_Qty
        FROM Months m
        INNER JOIN dbo.tblInvoice I WITH (NOLOCK)
            ON I.SndReturnPaymentDate >= m.MonthStart
           AND I.SndReturnPaymentDate <  DATEADD(MONTH, 1, m.MonthStart)
        INNER JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
        INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
        INNER JOIN RetAgg RA ON RA.InvoiceDetailId = ID.InvoiceDetailId
        LEFT  JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = mas.RegionId
        LEFT  JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = mas.AreaID
        WHERE
            I.PaymentInvoiceNo IS NOT NULL
            AND ID.PaymentReturnReason IS NOT NULL
            AND CONVERT(date, I.SndReturnPaymentDate) BETWEEN @FromDate AND @ToDate
            AND ISNULL(RA.sndReturnQty,0) <> 0
        GROUP BY
            m.MonthStart,
            mas.RegionId, rg.RegionName,
            mas.AreaID,   ar.AreaName,
            CASE
                WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
                ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
            END
    ),

    Base AS (
        SELECT * FROM FirstReturn
        UNION ALL
        SELECT * FROM SecondReturn
    ),

    Ranked AS (
        SELECT
            MonthStart,
            SalesYear,
            SalesMonth,
            SalesMonthName,
            ZoneID,
            ZoneName,
            AreaID,
            AreaName,
            Return_Reason,
            Return_Amount,
            Return_Qty,
            DENSE_RANK() OVER (
                PARTITION BY MonthStart, ZoneID, AreaID
                ORDER BY Return_Amount DESC
            ) AS rn
        FROM Base
    )
    SELECT
        SalesYear,
        SalesMonth,
        SalesMonthName,
        ZoneID,
        ZoneName,
        AreaID,
        AreaName,
        CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END AS Return_Reason_Group,
        SUM(Return_Amount) AS Return_Amount,
        SUM(Return_Qty)    AS Return_Qty
    FROM Ranked
    GROUP BY
        MonthStart,
        SalesYear, SalesMonth, SalesMonthName,
        ZoneID, ZoneName,
        AreaID, AreaName,
        CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END
    ORDER BY
        SalesYear,
        SalesMonth,
        ZoneName,
        AreaName,
        CASE WHEN (CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END) = 'Other Reason' THEN 2 ELSE 1 END,
        SUM(Return_Amount) DESC
    OPTION (MAXRECURSION 0);
--    DECLARE @FromDate DATE = '2025-07-01';
--DECLARE @ToDate   DATE = '2026-06-30';

--;WITH Months AS (
--    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
--    UNION ALL
--    SELECT DATEADD(MONTH, 1, MonthStart)
--    FROM Months
--    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
--),
--Base AS (
--    SELECT
--        M.MonthStart,
--        YEAR(M.MonthStart) AS SalesYear,
--        MONTH(M.MonthStart) AS SalesMonth,
--        DATENAME(MONTH, M.MonthStart) AS SalesMonthName,

--        mas.RegionId              AS ZoneID,
--        ISNULL(rg.RegionName,'')  AS ZoneName,

--        mas.AreaID                AS AreaID,
--        ISNULL(ar.AreaName,'')    AS AreaName,

--        CASE
--            WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
--            ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
--        END AS Return_Reason,

--        sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0))
--        + sum(ISNULL(ID.PaymentTotalPrice- tblInvoiceDetailReturn.sndReturnTotalPrice,0))     as Return_Amount,
--        --SUM(
--        --    ISNULL(ID.DeliveryTotalPrice, 0) + ISNULL(ID.DeliveryTotalPriceVatAmount, 0) - ISNULL(ID.DeliveryDiscountAmount, 0)
--        --    - (ISNULL(ID.PaymentTotalPrice, 0) + ISNULL(ID.PaymentTotalPriceVatAmount, 0) - ISNULL(ID.PaymentDiscountAmount, 0))
--        --) AS Return_Amount,

--        SUM(ISNULL(ID.DeliveryTotalQuantity, 0) - ISNULL(ID.PaymentTotalQuantity, 0)) AS Return_Qty

--    FROM Months M
--        CROSS JOIN dbo.tblInvoice AS I WITH (NOLOCK)
--        INNER JOIN dbo.tblOrder AS mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
--        INNER JOIN dbo.tblInvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
--        inner join tblInvoiceDetailReturn on tblInvoiceDetailReturn.InvoiceDetailId=ID.InvoiceDetailId
--        LEFT JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = mas.RegionId
--        LEFT JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = mas.AreaID

--    WHERE I.PaymentInvoiceNo IS NOT NULL
--        AND ID.PaymentReturnReason IS NOT NULL
--        AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
--        AND I.PaymentDate >= M.MonthStart
--        AND I.PaymentDate < DATEADD(MONTH, 1, M.MonthStart)

--    GROUP BY
--        M.MonthStart,
--        mas.RegionId, rg.RegionName,
--        mas.AreaID,   ar.AreaName,
--        CASE
--            WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
--            ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
--        END
--),
--Ranked AS (
--    SELECT
--        MonthStart,
--        SalesYear,
--        SalesMonth,
--        SalesMonthName,
--        ZoneID,
--        ZoneName,
--        AreaID,
--        AreaName,
--        Return_Reason,
--        Return_Amount,
--        Return_Qty,
--        DENSE_RANK() OVER (
--            PARTITION BY MonthStart, ZoneID, AreaID
--            ORDER BY Return_Amount DESC
--        ) AS rn
--    FROM Base
--)
--SELECT
--    SalesYear,
--    SalesMonth,
--    SalesMonthName,

--    ZoneID,
--    ZoneName,
--    AreaID,
--    AreaName,

--    CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END AS Return_Reason_Group,
--    SUM(Return_Amount) AS Return_Amount,
--    SUM(Return_Qty) AS Return_Qty
--FROM Ranked
--GROUP BY
--    MonthStart,
--    SalesYear,
--    SalesMonth,
--    SalesMonthName,
--    ZoneID, ZoneName,
--    AreaID, AreaName,
--    CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END
--ORDER BY
--    SalesYear,
--    SalesMonth,
--    ZoneName,
--    AreaName,
--    CASE WHEN (CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END) = 'Other Reason' THEN 2 ELSE 1 END,
--    SUM(Return_Amount) DESC
--OPTION (MAXRECURSION 0);








    --DECLARE @FromDate DATE = '2025-07-01';
    --DECLARE @ToDate   DATE = '2026-06-30';
    
    --;WITH Months AS (
    --    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
    --    UNION ALL
    --    SELECT DATEADD(MONTH, 1, MonthStart)
    --    FROM Months
    --    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    --),
    --Base AS (
    --    SELECT
    --        M.MonthStart,
    --        YEAR(M.MonthStart) AS SalesYear,
    --        MONTH(M.MonthStart) AS SalesMonth,
    --        DATENAME(MONTH, M.MonthStart) AS SalesMonthName,
    --        CASE
    --            WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
    --            ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
    --        END AS Return_Reason,
    --        SUM(
    --            ISNULL(ID.DeliveryTotalPrice, 0) + ISNULL(ID.DeliveryTotalPriceVatAmount, 0) - ISNULL(ID.DeliveryDiscountAmount, 0)
    --            - (ISNULL(ID.PaymentTotalPrice, 0) + ISNULL(ID.PaymentTotalPriceVatAmount, 0) - ISNULL(ID.PaymentDiscountAmount, 0))
    --        ) AS Return_Amount,
    --        SUM(ISNULL(ID.DeliveryTotalQuantity, 0) - ISNULL(ID.PaymentTotalQuantity, 0)) AS Return_Qty
    --    FROM Months M
    --        CROSS JOIN dbo.tblInvoice AS I WITH (NOLOCK)
    --        INNER JOIN dbo.tblOrder AS mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    --        INNER JOIN dbo.tblInvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    --    WHERE I.PaymentInvoiceNo IS NOT NULL
    --        AND ID.PaymentReturnReason IS NOT NULL
    --        AND ISNULL(ID.PaymentTotalQuantity, 0) <> ISNULL(ID.DeliveryTotalQuantity, 0)
    --        AND I.UpdateDate >= M.MonthStart
    --        AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    --    GROUP BY
    --        M.MonthStart,
    --        CASE
    --            WHEN NULLIF(LTRIM(RTRIM(ID.PaymentReturnReason)), '') IS NULL THEN 'No Order'
    --            ELSE LTRIM(RTRIM(ID.PaymentReturnReason))
    --        END
    --),
    --Ranked AS (
    --    SELECT
    --        MonthStart,
    --        SalesYear,
    --        SalesMonth,
    --        SalesMonthName,
    --        Return_Reason,
    --        Return_Amount,
    --        Return_Qty,
    --        DENSE_RANK() OVER (PARTITION BY MonthStart ORDER BY Return_Amount DESC) AS rn
    --    FROM Base
    --)
    --SELECT
    --    SalesYear,
    --    SalesMonth,
    --    SalesMonthName,
    --    CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END AS Return_Reason_Group,
    --    SUM(Return_Amount) AS Return_Amount,
    --    SUM(Return_Qty) AS Return_Qty
    --FROM Ranked
    --GROUP BY
    --    MonthStart,
    --    SalesYear,
    --    SalesMonth,
    --    SalesMonthName,
    --    CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END
    --ORDER BY
    --    SalesYear, 
    --    SalesMonth,
    --    CASE WHEN (CASE WHEN rn <= 5 THEN Return_Reason ELSE 'Other Reason' END) = 'Other Reason' THEN 2 ELSE 1 END,
    --    SUM(Return_Amount) DESC
    --OPTION (MAXRECURSION 0);
END