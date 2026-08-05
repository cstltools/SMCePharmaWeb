CREATE   PROCEDURE [dbo].[sp_GET_CollectionVsSales_BI] --EXEC sp_GET_Dashboard_BI
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
DECLARE @ToDate   DATE = '2030-06-30';

;WITH

-- =========================================================
-- SALES CTE
-- =========================================================
SalesCTE AS
(
    SELECT
        CU.ComUnitCode,
        CU.ComUnitName,
        tblRegion.RegionCode                    AS ZoneCode,
        tblRegion.RegionName                    AS ZoneName,
        ddd.AreaCode,
        ddd.AreaName,
        SUM(ID.DeliveryNetAmount)               AS Total_Sales
    FROM dbo.tblInvoice I WITH (NOLOCK)
    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON ID.InvoiceId = I.InvoiceId
    INNER JOIN dbo.tblOrder mas WITH (NOLOCK)
        ON I.OrderId = mas.OrderId
    INNER JOIN tblCustMaster C WITH (NOLOCK)
        ON C.CustomerMasterId = mas.CustomerMasterId
    LEFT JOIN dbo.tblCompanyUnit CU WITH (NOLOCK)
        ON CU.ComUnitId = mas.ComUnitId
    LEFT JOIN tblMarket aa WITH (NOLOCK)
        ON aa.MarketId = C.MarketId
    LEFT JOIN tblSubTerritory bb WITH (NOLOCK)
        ON bb.SubTerritoryId = aa.SubTerritoryId
       AND bb.IsActive = 1
    LEFT JOIN tblTerritory cc WITH (NOLOCK)
        ON cc.TerritoryId = bb.TerritoryId
       AND cc.IsActive = 1
    LEFT JOIN tblArea ddd WITH (NOLOCK)
        ON ddd.AreaId = cc.AreaId
       AND ddd.IsActive = 1
    LEFT JOIN tblRegion WITH (NOLOCK)
        ON tblRegion.RegionId = ddd.RegionId
       AND tblRegion.IsActive = 1
    WHERE ID.DeliveryStatus IN ('Full', 'Partial')
      AND CONVERT(DATE, I.InvoiceDate) BETWEEN @FromDate AND @ToDate
    GROUP BY
        CU.ComUnitCode,
        CU.ComUnitName,
        tblRegion.RegionCode,
        tblRegion.RegionName,
        ddd.AreaCode,
        ddd.AreaName
),

-- =========================================================
-- COLLECTION BASE CTE
-- Web report-এর TotalPay logic অনুযায়ী
-- =========================================================
CollectionBaseCTE AS
(
    SELECT
        I.InvoiceId,
        CU.ComUnitCode,
        CU.ComUnitName,
        tblRegion.RegionCode                    AS ZoneCode,
        tblRegion.RegionName                    AS ZoneName,
        ddd.AreaCode,
        ddd.AreaName,

        SUM(ISNULL(custDtl.TPAmount, 0))
        + SUM(ISNULL(custDtl.VATAmount, 0))      AS TotalPay

    FROM dbo.tblCustPayDetail custDtl WITH (NOLOCK)
    INNER JOIN dbo.tblInvoice I WITH (NOLOCK)
        ON I.InvoiceId = custDtl.InvoiceId
    LEFT JOIN dbo.tblOrder mas WITH (NOLOCK)
        ON I.OrderId = mas.OrderId
    INNER JOIN tblCustMaster C WITH (NOLOCK)
        ON C.CustomerMasterId = mas.CustomerMasterId
    LEFT JOIN dbo.tblCompanyUnit CU WITH (NOLOCK)
        ON CU.ComUnitId = mas.ComUnitId
    LEFT JOIN tblMarket aa WITH (NOLOCK)
        ON aa.MarketId = C.MarketId
    LEFT JOIN tblSubTerritory bb WITH (NOLOCK)
        ON bb.SubTerritoryId = aa.SubTerritoryId
       AND bb.IsActive = 1
    LEFT JOIN tblTerritory cc WITH (NOLOCK)
        ON cc.TerritoryId = bb.TerritoryId
       AND cc.IsActive = 1
    LEFT JOIN tblArea ddd WITH (NOLOCK)
        ON ddd.AreaId = cc.AreaId
       AND ddd.IsActive = 1
    LEFT JOIN tblRegion WITH (NOLOCK)
        ON tblRegion.RegionId = ddd.RegionId
       AND tblRegion.IsActive = 1

    WHERE I.InvoiceId > 0
      AND CONVERT(DATE, custDtl.CustPaymentDate) BETWEEN @FromDate AND @ToDate

    GROUP BY
        I.InvoiceId,
        CU.ComUnitCode,
        CU.ComUnitName,
        tblRegion.RegionCode,
        tblRegion.RegionName,
        ddd.AreaCode,
        ddd.AreaName
),

-- =========================================================
-- COLLECTION CTE
-- Area-wise summarized collection
-- =========================================================
CollectionCTE AS
(
    SELECT
        ComUnitCode,
        ComUnitName,
        ZoneCode,
        ZoneName,
        AreaCode,
        AreaName,
        SUM(TotalPay) AS Total_Collection
    FROM CollectionBaseCTE
    GROUP BY
        ComUnitCode,
        ComUnitName,
        ZoneCode,
        ZoneName,
        AreaCode,
        AreaName
)

-- =========================================================
-- FINAL DETAILS RESULT
-- =========================================================
SELECT
    ISNULL(S.ComUnitCode, C.ComUnitCode)         AS ComUnitCode,
    ISNULL(S.ComUnitName, C.ComUnitName)         AS ComUnitName,
    ISNULL(S.ZoneCode, C.ZoneCode)               AS ZoneCode,
    ISNULL(S.ZoneName, C.ZoneName)               AS ZoneName,
    ISNULL(S.AreaCode, C.AreaCode)               AS AreaCode,
    ISNULL(S.AreaName, C.AreaName)               AS AreaName,

    ISNULL(S.Total_Sales, 0)                     AS Total_Sales,
    ISNULL(C.Total_Collection, 0)                AS Total_Collection,

    ISNULL(S.Total_Sales, 0)
        - ISNULL(C.Total_Collection, 0)          AS Outstanding_Amount,

    CASE
        WHEN ISNULL(S.Total_Sales, 0) = 0 THEN 0
        ELSE CAST(
            ISNULL(C.Total_Collection, 0) * 100.0
            / ISNULL(S.Total_Sales, 1)
        AS DECIMAL(10, 2))
    END                                          AS Collection_Pct

FROM SalesCTE S
FULL OUTER JOIN CollectionCTE C
    ON  ISNULL(C.ComUnitCode, '') = ISNULL(S.ComUnitCode, '')
    AND ISNULL(C.ZoneCode, '')    = ISNULL(S.ZoneCode, '')
    AND ISNULL(C.AreaCode, '')    = ISNULL(S.AreaCode, '')

END
    