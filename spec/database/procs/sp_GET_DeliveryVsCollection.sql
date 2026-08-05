
CREATE PROCEDURE [dbo].[sp_GET_DeliveryVsCollection]   -- exec sp_GET_DeliveryVsCollection
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

        ord.RegionId      AS ZoneID,
        rg.RegionName     AS ZoneName,

        ord.AreaID        AS AreaID,
        ar.AreaName       AS AreaName,

        
        SUM(ISNULL(NetTP, 0)) AS SalesAmount,
        SUM(ISNULL(PP, 0)) AS PaymentAmount

    FROM tblInvoice AS INV WITH(NOLOCK)

        INNER JOIN tblOrder ord WITH (NOLOCK) 
            ON INV.OrderId = ord.OrderId

        LEFT JOIN dbo.tblRegion rg WITH (NOLOCK)
            ON rg.RegionId = ord.RegionId

        LEFT JOIN dbo.tblArea ar WITH (NOLOCK)
            ON ar.AreaId = ord.AreaID

        LEFT JOIN (
            SELECT InvoiceId, 
                   SUM(ISNULL(TPAmount,0)+ISNULL(VATAmount,0)) AS PP, 
                   SUM(TPAmount) AS TPAmount, 
                   SUM(VATAmount) AS VATAmount 
            FROM tblCustPayDetail 
            GROUP BY InvoiceId
        ) AS P ON INV.InvoiceId = P.InvoiceId 

        INNER JOIN (
            SELECT InvoiceId, 
                   SUM(PaymentNetAmount) AS TotalDelivery 
            FROM tblInvoiceDetail WITH(NOLOCK) 
            GROUP BY InvoiceId
        ) AS TD ON INV.InvoiceId = TD.InvoiceId 

        LEFT JOIN (
            SELECT InvoiceId, 
                   SUM(TPGrandTotal) ReturnTotal 
            FROM tblReturnInvoice  
            GROUP BY InvoiceId
        ) AS RTN ON INV.InvoiceId = RTN.InvoiceId

        INNER JOIN (
            SELECT tblInvoice.InvoiceId,    
                   SUM(DeliveryNetAmount - DeliveryTotalPriceVatAmount) AS NetTP 
            FROM tblInvoiceDetail WITH (NOLOCK)
            LEFT JOIN tblInvoice ON tblInvoiceDetail.InvoiceId=tblInvoice.InvoiceId
            WHERE tblInvoice.UpdateDate >= @FromDate
            AND tblInvoice.UpdateDate <  DATEADD(DAY, 1, @ToDate)
            AND tblInvoice.DeliveryInvoiceStatus IN ('Full', 'Partial')
            GROUP BY tblInvoice.InvoiceId
        ) tblinvDetls ON tblinvDetls.InvoiceId = INV.InvoiceId

    WHERE INV.PaymentInvoiceNo IS NOT NULL
        AND INV.UpdateDate >= @FromDate
        AND INV.UpdateDate <= @ToDate

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
    
    --SELECT 
    --    CAST(INV.UpdateDate AS DATE) AS salesdate,
    --    YEAR(INV.UpdateDate) AS SalesYear,
    --    MONTH(INV.UpdateDate) AS SalesMonth,
    --    DATENAME(MONTH, INV.UpdateDate) AS SalesMonthName,
    --    SUM(ISNULL(NetTP, 0)) AS SalesAmount,
    --    SUM(ISNULL(PP, 0)) AS PaymentAmount
    --FROM tblInvoice AS INV WITH(NOLOCK)
    --    INNER JOIN tblOrder ord WITH (NOLOCK) ON INV.OrderId = ord.OrderId
    --    LEFT JOIN (
    --        SELECT InvoiceId, SUM(PaymentAmount) AS PP, SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount 
    --        FROM tblCustPayDetail 
    --        GROUP BY InvoiceId
    --    ) AS P ON INV.InvoiceId = P.InvoiceId 
    --    INNER JOIN (
    --        SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery 
    --        FROM tblInvoiceDetail AS IVD WITH(NOLOCK) 
    --        GROUP BY InvoiceId
    --    ) AS TD ON INV.InvoiceId = TD.InvoiceId 
    --    LEFT JOIN (
    --        SELECT InvoiceId, SUM(TPGrandTotal) ReturnTotal 
    --        FROM tblReturnInvoice  
    --        GROUP BY InvoiceId
    --    ) AS RTN ON INV.InvoiceId = RTN.InvoiceId
    --    INNER JOIN (
    --        SELECT InvoiceId,    SUM(PaymentTotalPrice)-SUM(PaymentTotalPriceVatAmount) NetTP 
    --        FROM tblInvoiceDetail WITH (NOLOCK)  
    --        GROUP BY InvoiceId
    --    ) tblinvDetls ON tblinvDetls.InvoiceId = INV.InvoiceId
    --WHERE INV.PaymentInvoiceNo IS NOT NULL
    --    AND INV.UpdateDate >= @FromDate
    --    AND INV.UpdateDate <= @ToDate
    --GROUP BY CAST(INV.UpdateDate AS DATE), YEAR(INV.UpdateDate), MONTH(INV.UpdateDate), DATENAME(MONTH, INV.UpdateDate)
    --ORDER BY CAST(INV.UpdateDate AS DATE);
END