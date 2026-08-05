
CREATE     PROCEDURE [dbo].[sp_GET_CustomerWiseSalesAnalysis_BI]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
    DECLARE @ToDate   DATE = '2030-06-30';

    SELECT 
        C.CustomerMasterId,
        C.CustomerName,
        C.CustomerCode,
        CT.CustomerType,
        CC.CustomerCategory,

        /* ===== Financial Year ===== */
        CASE 
            WHEN MONTH(I.UpdateDate) >= 7 
            THEN YEAR(I.UpdateDate)
            ELSE YEAR(I.UpdateDate) - 1
        END AS FiscalYearStart,

        CONCAT(
            CASE 
                WHEN MONTH(I.UpdateDate) >= 7 
                THEN YEAR(I.UpdateDate)
                ELSE YEAR(I.UpdateDate) - 1
            END,
            '-',
            CASE 
                WHEN MONTH(I.UpdateDate) >= 7 
                THEN YEAR(I.UpdateDate) + 1
                ELSE YEAR(I.UpdateDate)
            END
        ) AS FinancialYear,

        -- Location Info
        RG.RegionName AS ZoneName,
        RG.RegionCode AS RegionCode,
        RG.RegionId AS RegionId,

        AR.AreaName AS AreaName,
        AR.AreaCode AS AreaCode,
        AR.AreaId AS AreaId,

        -- Time Info
        YEAR(I.UpdateDate) AS SalesYear,
        MONTH(I.UpdateDate) AS SalesMonth,
        DATENAME(MONTH, I.UpdateDate) AS SalesMonthName,

        -- Sales Calculation
        SUM(
            ISNULL(ID.DeliveryNetAmount, 0) 
            - ISNULL(ID.TotalPriceVatAmount, 0)
        ) AS NetSalesAmount

    FROM dbo.tblInvoice I WITH (NOLOCK)

    INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON ID.InvoiceId = I.InvoiceId

    INNER JOIN dbo.tblOrder O WITH (NOLOCK)
        ON O.OrderId = I.OrderId

    INNER JOIN dbo.tblCustMaster C WITH (NOLOCK)
        ON O.CustomerMasterId = C.CustomerMasterId

    LEFT JOIN dbo.tblCustomerType CT WITH (NOLOCK)
        ON C.CustomerTypeId = CT.CustomerTypeId

    LEFT JOIN dbo.tblCustomerCategory CC WITH (NOLOCK)
        ON C.CategoryId = CC.CustomerCategoryId

    LEFT JOIN dbo.tblRegion RG WITH (NOLOCK)
        ON RG.RegionId = O.RegionId

    LEFT JOIN dbo.tblArea AR WITH (NOLOCK)
        ON AR.AreaId = O.AreaID

    WHERE 
        I.PaymentInvoiceNo IS NOT NULL
        AND CAST(I.UpdateDate AS DATE) 
            BETWEEN @FromDate AND @ToDate

    GROUP BY 
        C.CustomerMasterId,
        C.CustomerName,
        C.CustomerCode,
        CT.CustomerType,
        CC.CustomerCategory,

        RG.RegionName,
        RG.RegionCode,
        RG.RegionId,

        AR.AreaName,
        AR.AreaCode,
        AR.AreaId,

        YEAR(I.UpdateDate),
        MONTH(I.UpdateDate),
        DATENAME(MONTH, I.UpdateDate),

        CASE 
            WHEN MONTH(I.UpdateDate) >= 7 
            THEN YEAR(I.UpdateDate)
            ELSE YEAR(I.UpdateDate) - 1
        END

    ORDER BY 
        NetSalesAmount DESC;
END
