
CREATE PROCEDURE [dbo].[sp_GET_CustomerWiseSalesAnalysis]   -- exec sp_GET_CustomerWiseSalesAnalysis
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
    MONTH(M.MonthStart) AS SalesMonth,
    DATENAME(MONTH, M.MonthStart) AS SalesMonthName,

    O.RegionId             AS ZoneID,
    ISNULL(rg.RegionName,'') AS ZoneName,

    O.AreaID               AS AreaID,
    ISNULL(ar.AreaName,'')   AS AreaName,

    p.ProgramTypeName,
    SUM(ID.DeliveryNetAmount)-SUM(ID.TotalPriceVatAmount) AS SalesAmount

FROM Months M
    CROSS JOIN tblInvoice I WITH (NOLOCK)
    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = I.OrderId
    INNER JOIN tblProgramType p WITH (NOLOCK) ON p.ProgramTypeId = O.ProgramTypeId

    LEFT JOIN dbo.tblRegion rg WITH (NOLOCK) ON rg.RegionId = O.RegionId
    LEFT JOIN dbo.tblArea   ar WITH (NOLOCK) ON ar.AreaId   = O.AreaID

WHERE I.PaymentInvoiceNo IS NOT NULL
  AND I.UpdateDate >= M.MonthStart
  AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)

GROUP BY 
    M.MonthStart,
    O.RegionId, rg.RegionName,
    O.AreaID,   ar.AreaName,
    p.ProgramTypeName

ORDER BY 
    M.MonthStart,
    rg.RegionName,
    ar.AreaName,
    p.ProgramTypeName

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
    --    MONTH(M.MonthStart) AS SalesMonth,
    --    DATENAME(MONTH, M.MonthStart) AS SalesMonthName,
    --    p.ProgramTypeName,
    --    SUM(ID.DeliveryNetAmount) AS SalesAmount
    --FROM Months M
    --    CROSS JOIN tblInvoice I WITH (NOLOCK)
    --    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    --    INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = I.OrderId
    --    INNER JOIN tblProgramType p ON p.ProgramTypeId = O.ProgramTypeId
    --WHERE I.PaymentInvoiceNo IS NOT NULL and I.UpdateDate >= M.MonthStart
    --    AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    --GROUP BY M.MonthStart, p.ProgramTypeName
    --ORDER BY M.MonthStart, p.ProgramTypeName
    --OPTION (MAXRECURSION 0);
END
