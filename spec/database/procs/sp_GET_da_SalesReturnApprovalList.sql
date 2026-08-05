
CREATE   PROCEDURE [dbo].[sp_GET_da_SalesReturnApprovalList]
    @ComUnitId INT,
    @RouteId INT,
    @daid INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LatestLog AS
    (
        SELECT
            L.SalesReturnAppLogId,
            L.DaId,
            L.ComUnitId,
            L.RouteId,
            L.InvoiceId,
            L.ApprovalStatus,
            L.ApproveDate,
            L.ApproveBy,
            L.Remarks,
            ROW_NUMBER() OVER (PARTITION BY L.InvoiceId ORDER BY L.SalesReturnAppLogId DESC) AS rn
        FROM dbo.tblSalesReturn_appLog L WITH (NOLOCK)
        WHERE
            L.ComUnitId = @ComUnitId
            AND L.RouteId = @RouteId
            
    )
    SELECT
        ORD.ComUnitName AS DistributionCenter,
        ORD.DistributionRoute_Ord AS RouteName,
        ORD.ComUnitCode + ':' + ORD.ComUnitName AS SaleCenter,
        '' AS FeName,
        ORD.CustomerType AS CustomerType,
        ORD.MIOCode AS MioCode,
        ORD.MIOName AS MioName,
        INV.InvoiceNo AS PaymentInvoiceNo,
        INV.InvoiceNo AS InvoiceNo,
        ORD.OrderCode AS OrderNo,
        ORD.Remarks AS Remarks,
        FORMAT(ORD.SubmissionDate, 'dd-MMM-yyyy') AS OrderDate,
        FORMAT(INV.InvoiceDate, 'dd-MMM-yyyy') AS InvoiceDate,
        ORD.CustomerCode AS CustomerCode,
        ORD.CustomerName AS CustomerName,
        ORD.OrderSenderName AS OrderSenderName,
        ORD.TerritoryName_Ord AS TerritoryName_Ord,
        ORD.MarketId AS MarketId,
        ORD.DistributionRouteId AS DistributionRouteId,
        ISNULL(IsAdjustInvoice, 0) AS IsAdjustInvoice,
        tblD.ManufacId AS TpGrandTotal,
        CASE
            WHEN CONVERT(date, INV.InvoiceDate) >= CONVERT(date, '30-June-2022') THEN 'True'
            ELSE 'False'
        END AS ChkStatus,
        INV.InvoiceId AS InvoiceId,
        INV.CustomerMasterId AS CustomerMasterId,
        ISNULL(NULLIF(LTRIM(RTRIM(INV.DA_SalesReturn)), ''), 'Pending') AS Status,
        LL.SalesReturnAppLogId AS SalesReturnAppLogId,
        ISNULL(LL.ApprovalStatus, '') AS ApprovalStatus,
        ISNULL(LL.Remarks, '') AS ApprovalRemarks,
        LL.ApproveBy AS ApproveBy,
        FORMAT(LL.ApproveDate, 'dd-MMM-yyyy') AS ApproveDate
    FROM dbo.tblOrder ORD WITH (NOLOCK)
    INNER JOIN dbo.tblInvoice INV WITH (NOLOCK)
        ON ORD.OrderId = INV.OrderId
    INNER JOIN dbo.tblCompanyUnit CU WITH (NOLOCK)
        ON ORD.ComUnitCode = CU.ComUnitCode
    INNER JOIN dbo.tblMarket WITH (NOLOCK)
        ON ORD.MarketId = dbo.tblMarket.MarketId
    INNER JOIN
    (
        SELECT
            D.InvoiceId,
            CASE
                WHEN IV.DeliveryInvoiceStatus = 'Partial' THEN SUM(D.DeliveryNetAmount)
                ELSE SUM(D.NetAmount)
            END AS ManufacId
        FROM dbo.tblInvoiceDetail D WITH (NOLOCK)
        INNER JOIN dbo.tblInvoice IV WITH (NOLOCK)
            ON D.InvoiceId = IV.InvoiceId
        GROUP BY
            D.InvoiceId,
            IV.DeliveryInvoiceStatus
    ) AS tblD
        ON INV.InvoiceId = tblD.InvoiceId
    INNER JOIN LatestLog LL
        ON LL.InvoiceId = INV.InvoiceId
        AND LL.rn = 1
    WHERE
         ORD.ComUnitId = @ComUnitId
        AND ORD.DistributionRouteId = @RouteId  and INV.DelivaryInvoiceNo is not null
        
    ORDER BY
        INV.InvoiceDate ASC;
END
