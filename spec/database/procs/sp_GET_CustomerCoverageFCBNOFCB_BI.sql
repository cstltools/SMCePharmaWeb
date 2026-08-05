

CREATE PROCEDURE [dbo].[sp_GET_CustomerCoverageFCBNOFCB_BI]   -- exec sp_GET_CustomerCoverage_BI
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
    WHERE DATEADD(MONTH, 1, MonthStart) 
          <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
)

SELECT 
    YEAR(M.MonthStart) AS SalesYear,
    MONTH(M.MonthStart) AS SalesMonth,
    DATENAME(MONTH, M.MonthStart) AS SalesMonthName,

    O.RegionId AS ZoneID,
    ISNULL(rg.RegionName,'') AS ZoneName,

    O.AreaID AS AreaID,
    ISNULL(ar.AreaName,'') AS AreaName,

    -- FCB Customer
    COUNT(DISTINCT CASE 
        WHEN ISNULL(pCat.CustomerCategory,'') = 'FCB' 
        THEN I.CustomerMasterId 
    END) AS FCBCustomerCount,

    -- Non FCB Customer (NULL সহ)
    COUNT(DISTINCT CASE 
        WHEN ISNULL(pCat.CustomerCategory,'') <> 'FCB' 
        THEN I.CustomerMasterId 
    END) AS NoFCBCustomerCount,

    -- Total Customer
    COUNT(DISTINCT I.CustomerMasterId) AS TotalCustomerCount

FROM Months M

LEFT JOIN tblInvoice I WITH (NOLOCK) 
    ON I.UpdateDate >= M.MonthStart 
    AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    AND I.DelivaryInvoiceNo IS NOT NULL

LEFT JOIN dbo.tblOrder O WITH (NOLOCK) 
    ON O.OrderId = I.OrderId

LEFT JOIN dbo.tblRegion rg WITH (NOLOCK)
    ON rg.RegionId = O.RegionId

LEFT JOIN dbo.tblArea ar WITH (NOLOCK)
    ON ar.AreaId = O.AreaID

LEFT JOIN tblCustomerType ct WITH (NOLOCK) 
    ON ct.CustomerTypeId = O.CustTypeId

LEFT JOIN tblCustomerCategory pCat WITH (NOLOCK) 
    ON pCat.CustomerCategoryId = ct.CustomerCategoryId

GROUP BY 
    M.MonthStart,
    O.RegionId, rg.RegionName,
    O.AreaID, ar.AreaName

ORDER BY 
    M.MonthStart,
    rg.RegionName,
    ar.AreaName

OPTION (MAXRECURSION 0);
  --DECLARE @FromDate DATE = '2025-07-01';
  --  DECLARE @ToDate   DATE = '2026-06-30';
    
  --  ;WITH Months AS (
  --      SELECT DATEFROMPARTS(YEAR(@FromDate), MONTH(@FromDate), 1) AS MonthStart
  --      UNION ALL
  --      SELECT DATEADD(MONTH, 1, MonthStart)
  --      FROM Months
  --      WHERE DATEADD(MONTH, 1, MonthStart) <= DATEFROMPARTS(YEAR(@ToDate), MONTH(@ToDate), 1)
  --  )
    
  --  SELECT 
  --      YEAR(M.MonthStart) AS SalesYear,
  --      MONTH(M.MonthStart) AS SalesMonth,
  --      DATENAME(MONTH, M.MonthStart) AS SalesMonthName,
  --      COUNT(DISTINCT CASE WHEN pCat.CustomerCategory = 'FCB' THEN I.CustomerMasterId END) AS FCBCustomerCount,
  --      COUNT(DISTINCT CASE WHEN pCat.CustomerCategory <> 'FCB' THEN I.CustomerMasterId END) AS NoFCBCustomerCount,
  --      COUNT(DISTINCT I.CustomerMasterId) AS TotalCustomerCount
  --  FROM Months M
  --      LEFT JOIN tblInvoice I WITH (NOLOCK) 
  --          ON I.UpdateDate >= M.MonthStart 
  --          AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
  --          AND I.DelivaryInvoiceNo IS NOT NULL
  --      LEFT JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = I.OrderId
  --      LEFT JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON I.InvoiceId = D.InvoiceId
  --      LEFT JOIN tblCustomerType p ON p.CustomerTypeId = O.CustTypeId
  --      LEFT JOIN tblCustomerCategory pCat ON p.CustomerCategoryId = pCat.CustomerCategoryId
  --  GROUP BY M.MonthStart
  --  ORDER BY M.MonthStart
  --  OPTION (MAXRECURSION 0);

    end
