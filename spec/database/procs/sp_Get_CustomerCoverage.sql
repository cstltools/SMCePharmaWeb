
CREATE PROCEDURE [dbo].[sp_Get_CustomerCoverage]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FromDate DATE = '2025-07-01';
DECLARE @ToDate   DATE = '2026-06-30';
  
;WITH Months AS (
    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
    UNION ALL
    SELECT DATEADD(MONTH, 1, MonthStart)
    FROM Months
    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
)
 
SELECT
    YEAR(M.MonthStart) AS SalesYear, 
    'Rana' AS MyName,
    MONTH(M.MonthStart) AS SalesMonth,
    DATENAME(MONTH, M.MonthStart) AS SalesMonthName,

    mas.RegionId        AS ZoneID,
    rg.RegionName       AS ZoneName,

    mas.AreaID          AS AreaID,
    ar.AreaName         AS AreaName,

    COUNT(DISTINCT I.CustomerMasterId) AS CustomerCoverageCount

FROM Months M

LEFT JOIN dbo.tblInvoice I WITH (NOLOCK) 
    ON I.UpdateDate >= M.MonthStart 
    AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    AND I.DelivaryInvoiceNo IS NOT NULL

LEFT JOIN dbo.tblOrder mas WITH (NOLOCK) 
    ON mas.OrderId = I.OrderId

LEFT JOIN dbo.tblRegion rg WITH (NOLOCK)
    ON rg.RegionId = mas.RegionId

LEFT JOIN dbo.tblArea ar WITH (NOLOCK)
    ON ar.AreaId = mas.AreaID

GROUP BY 
    M.MonthStart,
    mas.RegionId,
    rg.RegionName,
    mas.AreaID,
    ar.AreaName

ORDER BY 
    M.MonthStart,
    rg.RegionName,
    ar.AreaName

OPTION (MAXRECURSION 0);

    --DECLARE @FromDate DATE = '2025-07-01';
    --DECLARE @ToDate   DATE = '2026-06-30';
  
    --;WITH Months AS (
    --    SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
    --    UNION ALL
    --    SELECT DATEADD(MONTH, 1, MonthStart)
    --    FROM Months
    --    WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
    --)
     
    --SELECT
    --    YEAR(M.MonthStart) AS SalesYear, 
    --    'Rana' AS MyName,
    --    MONTH(M.MonthStart) AS SalesMonth,
    --    DATENAME(MONTH, M.MonthStart) AS SalesMonthName,
    --    COUNT(DISTINCT I.CustomerMasterId) AS CustomerCoverageCount,
    --    '' AS ZoneName,
    --    '' AS AreaName,
    --    0 AS ZoneID,
    --    0 AS AreaID
    --FROM Months M
    --    LEFT JOIN dbo.tblInvoice I WITH (NOLOCK) 
    --        ON I.UpdateDate >= M.MonthStart 
    --        AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    --        AND I.DelivaryInvoiceNo IS NOT NULL
    --    LEFT JOIN dbo.tblOrder mas WITH (NOLOCK) ON mas.OrderId = I.OrderId
    --    LEFT JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
    --GROUP BY M.MonthStart
    --ORDER BY M.MonthStart
    --OPTION (MAXRECURSION 0);
END