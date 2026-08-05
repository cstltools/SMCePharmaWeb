CREATE PROCEDURE [dbo].[sp_GET_TargetvsAchivement_BIReport]   -- exec sp_GET_TargetvsAchivement_BIReport
AS
BEGIN

SET NOCOUNT ON;

DECLARE @FromDate DATE = '2021-07-01';
DECLARE @ToDate   DATE = '2030-06-30';
DECLARE @ZoneId   NVARCHAR(MAX) = NULL;
DECLARE @Area     INT = NULL;  -- Area filter

SELECT
    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
         ELSE CAST(ISNULL(OrderValue,0)   * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS OrderAchiv,
    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
         ELSE CAST(ISNULL(InvoiceValue,0) * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS InvoiceAchiv,
    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
         ELSE CAST(ISNULL(SalesValue,0)   * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS SalesAchiv,
    *
FROM
(
    SELECT
        ROW_NUMBER() OVER (ORDER BY rg.RegionCode, ar.AreaCode) AS SerialNo,
        rg.RegionCode,
        rg.RegionName + ' : ' + rg.RegionCode AS RegionName,
        ar.AreaCode,                                              -- ✅ Area Code
        ar.AreaName + ' : ' + ar.AreaCode AS AreaName,           -- ✅ Area Name

        tm.MonthName AS targetMonthNo,
        tm.YearValue AS targetYear,

        SUM(CAST(ISNULL(tm.Value,0) AS DECIMAL(18,2))) AS TargetValue,

        ISNULL(tblOrd.TotalOrder,0)   AS OrderValue,
        ISNULL(tblInv.TotalInvoice,0) AS InvoiceValue,
        ISNULL(tblSal.TotalSales,0)   AS SalesValue

    FROM tblRegion rg WITH (NOLOCK)
    INNER JOIN tblTerritoryDataMigration tm WITH (NOLOCK)
        ON tm.ZoneId_tr = rg.RegionId
    INNER JOIN tblArea ar WITH (NOLOCK)                          -- ✅ Area join
        ON ar.AreaId = tm.AreaId_tr

    -- ORDER: Area + MonthNo + Year wise
    LEFT JOIN
    (
        SELECT
            Ord.AreaId,                                          -- ✅ AreaId দিয়ে group
            MONTH(Ord.SubmissionDate) AS MonthName,
            YEAR(Ord.SubmissionDate)  AS YearValue,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(OrdD.TotalTradePrice) - SUM(OrdD.DiscountAmount), 0)
            ) AS TotalOrder
        FROM tblOrder Ord WITH (NOLOCK)
        INNER JOIN tblOrderDetail OrdD WITH (NOLOCK)
            ON Ord.OrderId = OrdD.OrderId
        WHERE Ord.ActionStatus = '2'
          AND Ord.SubmissionDate >= @FromDate
          AND Ord.SubmissionDate <  DATEADD(DAY, 1, @ToDate)    -- ✅ index-friendly
        GROUP BY Ord.AreaId, MONTH(Ord.SubmissionDate), YEAR(Ord.SubmissionDate)
    ) tblOrd
        ON tblOrd.AreaId    = ar.AreaId
       AND tblOrd.MonthName = tm.MonthName
       AND tblOrd.YearValue = tm.YearValue

    -- INVOICE: Area + MonthNo + Year wise
    LEFT JOIN
    (
        SELECT
            ord.AreaId,
            MONTH(A.InvoiceDate) AS MonthName,
            YEAR(A.InvoiceDate)  AS YearValue,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount,0)), 0)
            ) AS TotalInvoice
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        WHERE A.InvoiceDate >= @FromDate
          AND A.InvoiceDate <  DATEADD(DAY, 1, @ToDate)
        GROUP BY ord.AreaId, MONTH(A.InvoiceDate), YEAR(A.InvoiceDate)
    ) tblInv
        ON tblInv.AreaId    = ar.AreaId
       AND tblInv.MonthName = tm.MonthName
       AND tblInv.YearValue = tm.YearValue

    -- SALES: Area + MonthNo + Year wise
    LEFT JOIN
    (
        SELECT
            ord.AreaId,
            MONTH(A.UpdateDate) AS MonthName,
            YEAR(A.UpdateDate)  AS YearValue,
            CONVERT(DECIMAL(18,0),
                ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount,0)), 0)
            ) AS TotalSales
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID WITH (NOLOCK)
            ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK)
            ON ord.OrderId = A.OrderId
        WHERE A.UpdateDate >= @FromDate
          AND A.UpdateDate <  DATEADD(DAY, 1, @ToDate)
          AND A.DeliveryInvoiceStatus IN ('Full', 'Partial')
        GROUP BY ord.AreaId, MONTH(A.UpdateDate), YEAR(A.UpdateDate)
    ) tblSal
        ON tblSal.AreaId    = ar.AreaId
       AND tblSal.MonthName = tm.MonthName
       AND tblSal.YearValue = tm.YearValue

    WHERE tm.TerritoryId IS NOT NULL
      AND (rg.RegionId = COALESCE(NULLIF(@ZoneId, 0), rg.RegionId))
      AND (ar.AreaId   = COALESCE(NULLIF(@Area,   0), ar.AreaId))  -- ✅ Area filter
      AND DATEFROMPARTS(tm.YearValue, tm.MonthName, 1) 
        BETWEEN DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1)
        AND DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
      --AND tm.MonthName IN (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))
      --AND tm.YearValue  IN (SELECT YearValue  FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))

    GROUP BY
        rg.RegionCode, rg.RegionName,
        ar.AreaCode,   ar.AreaName,               -- ✅ GROUP BY তে Area যোগ
        tm.MonthName,  tm.YearValue,
        tblOrd.TotalOrder,
        tblInv.TotalInvoice,
        tblSal.TotalSales
) tbl
ORDER BY RegionCode, AreaCode;

--    DECLARE @FromDate DATE = '2025-07-01';
--DECLARE @ToDate   DATE = '2026-06-30';
--DECLARE @ZoneId   NVARCHAR(MAX)  = NULL;

--SELECT
--    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
--         ELSE CAST(ISNULL(OrderValue,0)   * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS OrderAchiv,
--    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
--         ELSE CAST(ISNULL(InvoiceValue,0) * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS InvoiceAchiv,
--    CASE WHEN CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) = 0 THEN 0
--         ELSE CAST(ISNULL(SalesValue,0)   * 100.0 / CAST(ISNULL(TargetValue,0) AS DECIMAL(18,2)) AS DECIMAL(18,2)) END AS SalesAchiv,
--    *
--FROM
--(
--    SELECT
--        ROW_NUMBER() OVER (ORDER BY rg.RegionCode) AS SerialNo,
--        rg.RegionCode,
--        rg.RegionName + ' : ' + rg.RegionCode AS RegionName,

--        tm.MonthName AS targetMonthNo,
--        tm.YearValue AS targetYear,

--        SUM(CAST(ISNULL(tm.Value,0) AS DECIMAL(18,2))) AS TargetValue,

--        ISNULL(tblOrd.TotalOrder,0)     AS OrderValue,
--        ISNULL(tblInv.TotalInvoice,0)   AS InvoiceValue,
--        ISNULL(tblSal.TotalSales,0)     AS SalesValue

--    FROM tblRegion rg WITH (NOLOCK)
--    INNER JOIN tblTerritoryDataMigration tm
--        ON tm.ZoneId_tr = rg.RegionId

--    -- ORDER: Region + MonthNo + Year wise
--    LEFT JOIN
--    (
--        SELECT
--            Ord.RegionId,
--            MONTH(Ord.SubmissionDate) AS MonthName,   -- MonthNo
--            YEAR(Ord.SubmissionDate)  AS YearValue,
--            CONVERT(DECIMAL(18,2),
--                ISNULL(SUM(OrdD.TotalTradePrice) - SUM(OrdD.DiscountAmount), 0)
--            ) AS TotalOrder
--        FROM tblOrder Ord WITH (NOLOCK)
--        INNER JOIN tblOrderDetail OrdD WITH (NOLOCK)
--            ON Ord.OrderId = OrdD.OrderId
--        WHERE Ord.ActionStatus='2'
--          AND CONVERT(DATE, Ord.SubmissionDate) BETWEEN @FromDate AND @ToDate
--        GROUP BY Ord.RegionId, MONTH(Ord.SubmissionDate), YEAR(Ord.SubmissionDate)
--    ) tblOrd
--        ON tblOrd.RegionId  = rg.RegionId
--       AND tblOrd.MonthName = tm.MonthName
--       AND tblOrd.YearValue = tm.YearValue

--    -- INVOICE: Region + MonthNo + Year wise (InvoiceDate)
--    LEFT JOIN
--    (
--        SELECT
--            ord.RegionId,
--            MONTH(A.InvoiceDate) AS MonthName,  -- MonthNo
--            YEAR(A.InvoiceDate)  AS YearValue,
--            CONVERT(DECIMAL(18,2),
--                ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount,0)), 0)
--            ) AS TotalInvoice
--        FROM dbo.tblInvoice A WITH (NOLOCK)
--        INNER JOIN tblInvoiceDetail ID
--            ON A.InvoiceId = ID.InvoiceId
--        INNER JOIN tblOrder ord WITH (NOLOCK)
--            ON ord.OrderId = A.OrderId
--        WHERE CONVERT(DATE, A.InvoiceDate) BETWEEN @FromDate AND @ToDate
--        GROUP BY ord.RegionId, MONTH(A.InvoiceDate), YEAR(A.InvoiceDate)
--    ) tblInv
--        ON tblInv.RegionId  = rg.RegionId
--       AND tblInv.MonthName = tm.MonthName
--       AND tblInv.YearValue = tm.YearValue

--    -- SALES: Region + MonthNo + Year wise (UpdateDate)
--    LEFT JOIN
--    (
--        SELECT
--            ord.RegionId,
--            MONTH(A.UpdateDate) AS MonthName,  -- MonthNo
--            YEAR(A.UpdateDate)  AS YearValue,
--            CONVERT(DECIMAL(18,0),
--                ISNULL(SUM(ID.TotalPrice - ID.DiscountAmount) - SUM(ISNULL(ID.AdjustmentAmount,0)), 0)
--            ) AS TotalSales
--        FROM dbo.tblInvoice A WITH (NOLOCK)
--        INNER JOIN tblInvoiceDetail ID
--            ON A.InvoiceId = ID.InvoiceId
--        INNER JOIN tblOrder ord WITH (NOLOCK)
--            ON ord.OrderId = A.OrderId
--        WHERE CONVERT(DATE, A.UpdateDate) BETWEEN @FromDate AND @ToDate
--          AND A.DeliveryInvoiceStatus IN ('Full','Partial')
--        GROUP BY ord.RegionId, MONTH(A.UpdateDate), YEAR(A.UpdateDate)
--    ) tblSal
--        ON tblSal.RegionId  = rg.RegionId
--       AND tblSal.MonthName = tm.MonthName
--       AND tblSal.YearValue = tm.YearValue

--    WHERE tm.TerritoryId IS NOT NULL
--      AND (rg.RegionId = COALESCE(NULLIF(@ZoneId, 0), rg.RegionId))
--      AND tm.MonthName IN (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))
--      AND tm.YearValue  IN (SELECT YearValue  FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))

--    GROUP BY
--        rg.RegionCode, rg.RegionName,
--        tm.MonthName, tm.YearValue,
--        ISNULL(tblOrd.TotalOrder,0),
--        ISNULL(tblInv.TotalInvoice,0),
--        ISNULL(tblSal.TotalSales,0)
--) tbl
--ORDER BY RegionCode;

END
