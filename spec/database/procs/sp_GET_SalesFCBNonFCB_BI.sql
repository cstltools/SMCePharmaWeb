
CREATE PROCEDURE [dbo].[sp_GET_SalesFCBNonFCB_BI]   -- exec sp_GET_CustomerWiseSalesAnalysis
AS
BEGIN
    SET NOCOUNT ON;
    




DECLARE @FromDate DATE = '2021-07-01';
DECLARE @ToDate   DATE = '2030-06-30';

SELECT 
    CAST(INV.UpdateDate AS DATE) AS salesdate,
    YEAR(INV.UpdateDate) AS SalesYear,
    MONTH(INV.UpdateDate) AS SalesMonth,
    DATENAME(MONTH, INV.UpdateDate) AS SalesMonthName,

    ord.RegionId  AS ZoneID,
    rg.RegionName AS ZoneName,

    ord.AreaID    AS AreaID,
    ar.AreaName   AS AreaName,

    -- SalesAmount (NetTP) Category-wise
    SUM(CASE WHEN ISNULL(cc.CustomerCategory,'') = 'FCB'
             THEN ISNULL(invDet.NetTP,0) ELSE 0 END) AS FCBAmount,

    SUM(CASE WHEN ISNULL(cc.CustomerCategory,'') <> 'FCB'
             THEN ISNULL(invDet.NetTP,0) ELSE 0 END) AS NoFCBAmount,

    SUM(ISNULL(invDet.NetTP,0)) AS TotalSalesAmount,

    -- PaymentAmount (TP+VAT) Category-wise
    SUM(CASE WHEN ISNULL(cc.CustomerCategory,'') = 'FCB'
             THEN ISNULL(Pay.PP,0) ELSE 0 END) AS FCB_PaymentAmount,

    SUM(CASE WHEN ISNULL(cc.CustomerCategory,'') <> 'FCB'
             THEN ISNULL(Pay.PP,0) ELSE 0 END) AS NoFCB_PaymentAmount,

    SUM(ISNULL(Pay.PP,0)) AS TotalPaymentAmount

FROM dbo.tblInvoice AS INV WITH (NOLOCK)

INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
    ON INV.OrderId = ord.OrderId

-- Category joins
INNER JOIN dbo.tblCustomerType ct WITH (NOLOCK)
    ON ct.CustomerTypeId = ord.CustTypeId
INNER JOIN dbo.tblCustomerCategory cc WITH (NOLOCK)
    ON cc.CustomerCategoryId = ct.CustomerCategoryId

LEFT JOIN dbo.tblRegion rg WITH (NOLOCK)
    ON rg.RegionId = ord.RegionId

LEFT JOIN dbo.tblArea ar WITH (NOLOCK)
    ON ar.AreaId = ord.AreaID

-- Payment per invoice
LEFT JOIN (
    SELECT 
        InvoiceId,
        SUM(ISNULL(TPAmount,0) + ISNULL(VATAmount,0)) AS PP,
        SUM(ISNULL(TPAmount,0))  AS TPAmount,
        SUM(ISNULL(VATAmount,0)) AS VATAmount
    FROM dbo.tblCustPayDetail WITH (NOLOCK)
    GROUP BY InvoiceId
) AS Pay
    ON Pay.InvoiceId = INV.InvoiceId

-- NetTP per invoice (DeliveryNetAmount - DeliveryTotalPriceVatAmount)
INNER JOIN (
    SELECT 
        d.InvoiceId,
        SUM(ISNULL(d.DeliveryNetAmount,0) - ISNULL(d.DeliveryTotalPriceVatAmount,0)) AS NetTP
    FROM dbo.tblInvoiceDetail d WITH (NOLOCK)
    INNER JOIN dbo.tblInvoice i2 WITH (NOLOCK)
        ON i2.InvoiceId = d.InvoiceId
    WHERE i2.UpdateDate >= @FromDate
      AND i2.UpdateDate <  DATEADD(DAY, 1, @ToDate)
      AND i2.DeliveryInvoiceStatus IN ('Full', 'Partial')
    GROUP BY d.InvoiceId
) AS invDet
    ON invDet.InvoiceId = INV.InvoiceId

WHERE INV.PaymentInvoiceNo IS NOT NULL
  AND INV.UpdateDate >= @FromDate
  AND INV.UpdateDate <  DATEADD(DAY, 1, @ToDate)

GROUP BY 
    CAST(INV.UpdateDate AS DATE),
    YEAR(INV.UpdateDate),
    MONTH(INV.UpdateDate),
    DATENAME(MONTH, INV.UpdateDate),
    ord.RegionId,
    rg.RegionName,
    ord.AreaID,
    ar.AreaName

ORDER BY 
    CAST(INV.UpdateDate AS DATE),
    rg.RegionName,
    ar.AreaName;

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
    --    SUM(CASE WHEN pCat.CustomerCategory = 'FCB' THEN ID.PaymentTotalPrice - ID.PaymentTotalPriceVatAmount ELSE 0 END) AS FCBAmount,
    --    SUM(CASE WHEN pCat.CustomerCategory <> 'FCB' THEN ID.PaymentTotalPrice - ID.PaymentTotalPriceVatAmount ELSE 0 END) AS NoFCBAmount,
    --    SUM(ID.PaymentTotalPrice - ID.PaymentTotalPriceVatAmount) AS TotalSalesAmount
    --FROM Months M
    --    CROSS JOIN tblInvoice I WITH (NOLOCK)
    --    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    --    INNER JOIN dbo.tblOrder O WITH (NOLOCK) ON O.OrderId = I.OrderId
    --    INNER JOIN tblCustomerType p ON p.CustomerTypeId = O.CustTypeId
    --    INNER JOIN tblCustomerCategory pCat ON p.CustomerCategoryId = pCat.CustomerCategoryId
    --WHERE I.PaymentInvoiceNo IS NOT NULL
    --    AND I.UpdateDate >= M.MonthStart
    --    AND I.UpdateDate < DATEADD(MONTH, 1, M.MonthStart)
    --GROUP BY M.MonthStart
    --ORDER BY M.MonthStart
    --OPTION (MAXRECURSION 0);
END
