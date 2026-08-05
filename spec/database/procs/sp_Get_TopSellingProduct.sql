CREATE PROCEDURE [dbo].[sp_Get_TopSellingProduct]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2025-07-01';
    DECLARE @ToDate   DATE = '2026-06-30';

    ;WITH Months AS
    (
        SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
        UNION ALL
        SELECT DATEADD(MONTH, 1, MonthStart)
        FROM Months
        WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    ),
    ProductSales AS
    (
        SELECT
            YEAR(M.MonthStart) AS SalesYear,
            MONTH(M.MonthStart) AS SalesMonth,
            DATENAME(MONTH, M.MonthStart) AS SalesMonthName,

            O.RegionId            AS ZoneID,
            O.AreaID              AS AreaID,
            ISNULL(rg.RegionName,'') AS ZoneName,
            ISNULL(ar.AreaName,'')   AS AreaName,

            P.ProductName ProductCode,
            SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) AS Amount,

            ROW_NUMBER() OVER
            (
                PARTITION BY M.MonthStart, O.RegionId, O.AreaID
                ORDER BY SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) DESC
            ) AS RowNum

        FROM Months M
        INNER JOIN dbo.tblInvoice I       WITH (NOLOCK)
            ON I.UpdateDate >= M.MonthStart
           AND I.UpdateDate <  DATEADD(MONTH, 1, M.MonthStart)
        INNER JOIN dbo.tblOrder O         WITH (NOLOCK) ON O.OrderId = I.OrderId
        INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
        INNER JOIN dbo.tblProduct P       WITH (NOLOCK) ON P.ProductCode = D.ProductCode

        LEFT JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = O.RegionId
        LEFT JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = O.AreaID

        WHERE I.DelivaryInvoiceNo IS NOT NULL
          AND I.UpdateDate >= @FromDate
          AND I.UpdateDate <= @ToDate

        GROUP BY
            M.MonthStart,
            O.RegionId, O.AreaID,
            rg.RegionName, ar.AreaName,
            P.ProductName
    )
    SELECT
        SalesYear,
        SalesMonth,
        SalesMonthName,
        ZoneID,
        ZoneName,
        AreaID,
        AreaName,
        ProductCode,
        Amount
    FROM ProductSales
    WHERE RowNum <= 10
    ORDER BY SalesYear, SalesMonth, ZoneName, AreaName, Amount DESC
    OPTION (MAXRECURSION 0);
    --SET NOCOUNT ON;
  
    --DECLARE @FromDate DATE = '2025-07-01';
    --DECLARE @ToDate   DATE = '2026-06-30';
  
    --;WITH Months AS (
    --    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
    --    UNION ALL
    --    SELECT DATEADD(MONTH, 1, MonthStart)
    --    FROM Months
    --    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    --),
    --ProductSales AS (
    --    SELECT 
    --        YEAR(M.MonthStart) AS SalesYear,
    --        MONTH(M.MonthStart) AS SalesMonth,
    --        DATENAME(MONTH, M.MonthStart) AS SalesMonthName,
    --        D.ProductCode,
    --        SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) AS Amount,
    --        '' AS ZoneName,
    --        '' AS AreaName,
    --        0 AS ZoneID,
    --        0 AS AreaID,
    --        ROW_NUMBER() OVER (PARTITION BY M.MonthStart ORDER BY SUM(D.DeliveryNetAmount - D.DeliveryTotalPriceVatAmount) DESC) AS RowNum
    --    FROM Months M
    --        CROSS JOIN dbo.tblInvoice I WITH (NOLOCK)
    --        INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = I.OrderId
    --        INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
    --        INNER JOIN dbo.tblProduct P ON P.ProductCode = D.ProductCode
    --    WHERE I.DelivaryInvoiceNo IS NOT NULL
    --        AND I.UpdateDate >= M.MonthStart
    --        AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    --    GROUP BY M.MonthStart, D.ProductCode
    --)
    --SELECT 
    --    SalesYear,
    --    SalesMonth,
    --    SalesMonthName,
    --    ProductCode,
    --    Amount,
    --    ZoneName,
    --    AreaName,
    --    ZoneID,
    --    AreaID
    --FROM ProductSales
    --WHERE RowNum <= 10
    --ORDER BY SalesYear, SalesMonth, Amount DESC
    --OPTION (MAXRECURSION 0);
END