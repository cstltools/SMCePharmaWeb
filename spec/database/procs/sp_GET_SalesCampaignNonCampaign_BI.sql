
CREATE PROCEDURE [dbo].[sp_GET_SalesCampaignNonCampaign_BI]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = '2021-07-01';
    DECLARE @ToDate   DATE = '2030-06-30';

    ;WITH InvoiceLineSummary AS
    (
        SELECT
            d.InvoiceId,

            -- Non Campaign = Business Policy
            SUM(CASE 
                    WHEN ISNULL(ordD.CampaignName, '') LIKE '%Business Policy%'
                    THEN ISNULL(d.DeliveryNetAmount,0) - ISNULL(d.DeliveryTotalPriceVatAmount,0)
                    ELSE 0
                END) AS NonCampaignAmount,

            -- Campaign = not Business Policy and not blank
            SUM(CASE 
                    WHEN ISNULL(ordD.CampaignName, '') NOT LIKE '%Business Policy%'
                         AND ISNULL(ordD.CampaignName, '') <> ''
                    THEN ISNULL(d.DeliveryNetAmount,0) - ISNULL(d.DeliveryTotalPriceVatAmount,0)
                    ELSE 0
                END) AS CampaignAmount,

            -- Total sales of all lines
            SUM(ISNULL(d.DeliveryNetAmount,0) - ISNULL(d.DeliveryTotalPriceVatAmount,0)) AS TotalSalesAmount

        FROM dbo.tblInvoiceDetail d WITH (NOLOCK)
        INNER JOIN dbo.tblInvoice i2 WITH (NOLOCK)
            ON i2.InvoiceId = d.InvoiceId
        INNER JOIN dbo.tblOrderDetail ordD WITH (NOLOCK)
            ON d.OrderDetailsId = ordD.OrderDetailId
        WHERE i2.UpdateDate >= @FromDate
          AND i2.UpdateDate < DATEADD(DAY, 1, @ToDate)
          AND i2.DeliveryInvoiceStatus IN ('Full', 'Partial')
        GROUP BY d.InvoiceId
    ),
    PaymentSummary AS
    (
        SELECT 
            InvoiceId,
            SUM(ISNULL(TPAmount,0) + ISNULL(VATAmount,0)) AS PP,
            SUM(ISNULL(TPAmount,0))  AS TPAmount,
            SUM(ISNULL(VATAmount,0)) AS VATAmount
        FROM dbo.tblCustPayDetail WITH (NOLOCK)
        GROUP BY InvoiceId
    )

    SELECT 
        CAST(INV.UpdateDate AS DATE) AS SalesDate,
        YEAR(INV.UpdateDate) AS SalesYear,
        MONTH(INV.UpdateDate) AS SalesMonth,
        DATENAME(MONTH, INV.UpdateDate) AS SalesMonthName,

        ord.RegionId  AS ZoneID,
        rg.RegionName AS ZoneName,

        ord.AreaID    AS AreaID,
        ar.AreaName   AS AreaName,

        -- Sales Amount
        SUM(ISNULL(ILS.CampaignAmount,0))    AS CampaignAmount,
        SUM(ISNULL(ILS.NonCampaignAmount,0)) AS NonCampaignAmount,
        SUM(ISNULL(ILS.TotalSalesAmount,0))  AS TotalSalesAmount,

        -- Payment Amount (allocated proportionately based on sales amount)
        SUM(
            CASE 
                WHEN ISNULL(ILS.TotalSalesAmount,0) = 0 THEN 0
                ELSE ISNULL(Pay.PP,0) * ISNULL(ILS.CampaignAmount,0) / NULLIF(ILS.TotalSalesAmount,0)
            END
        ) AS Campaign_PaymentAmount,

        SUM(
            CASE 
                WHEN ISNULL(ILS.TotalSalesAmount,0) = 0 THEN 0
                ELSE ISNULL(Pay.PP,0) * ISNULL(ILS.NonCampaignAmount,0) / NULLIF(ILS.TotalSalesAmount,0)
            END
        ) AS NonCampaign_PaymentAmount,

        SUM(ISNULL(Pay.PP,0)) AS TotalPaymentAmount

    FROM dbo.tblInvoice AS INV WITH (NOLOCK)
    INNER JOIN dbo.tblOrder ord WITH (NOLOCK)
        ON INV.OrderId = ord.OrderId
    LEFT JOIN dbo.tblRegion rg WITH (NOLOCK)
        ON rg.RegionId = ord.RegionId
    LEFT JOIN dbo.tblArea ar WITH (NOLOCK)
        ON ar.AreaId = ord.AreaID
    LEFT JOIN PaymentSummary Pay
        ON Pay.InvoiceId = INV.InvoiceId
    INNER JOIN InvoiceLineSummary ILS
        ON ILS.InvoiceId = INV.InvoiceId

    WHERE INV.PaymentInvoiceNo IS NOT NULL
      AND INV.UpdateDate >= @FromDate
      AND INV.UpdateDate < DATEADD(DAY, 1, @ToDate)

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
END
