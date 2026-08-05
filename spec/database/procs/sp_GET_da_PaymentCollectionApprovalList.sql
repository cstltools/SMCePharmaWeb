
CREATE   PROCEDURE [dbo].[sp_GET_da_PaymentCollectionApprovalList]
    @ComUnitId INT,
    @RouteId INT,
    @daid INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LatestLog AS
    (
        SELECT
            L.PaymentCollectionAppLogId,
            L.DaId,
            L.ComUnitId,
            L.RouteId,
            L.InvoiceId,
            L.PayableAmount,
            L.ApprovalStatus,
            L.ApproveDate,
            L.ApproveBy,
            L.Remarks,
            ROW_NUMBER() OVER (PARTITION BY L.InvoiceId ORDER BY L.PaymentCollectionAppLogId DESC) AS rn
        FROM dbo.tblPaymentCollection_appLog L WITH (NOLOCK)
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
        INV.PaymentInvoiceNo AS PaymentInvoiceNo,
        ORD.OrderCode AS OrderNo,
        ORD.Remarks AS Remarks,
        FORMAT(ORD.SubmissionDate, 'dd-MMM-yyyy') AS OrderDate,
        FORMAT(INV.PaymentDate, 'dd-MMM-yyyy') AS InvoiceDate,
        ORD.CustomerCode AS CustomerCode,
        ORD.CustomerName AS CustomerName,
        ORD.OrderSenderName AS OrderSenderName,
        ORD.TerritoryName_Ord AS TerritoryName_Ord,
        ORD.MarketId AS MarketId,
        ORD.DistributionRouteId AS DistributionRouteId,
        ORD.CustomerMasterId AS CustomerMasterId,
        INV.InvoiceId AS InvoiceId,
        TotalDelivery AS TotalDeliveryAmount,
        ISNULL(PP, 0) AS PaymentAmount,
        ISNULL(LL.PayableAmount, (ISNULL(TotalDelivery, 0) - ISNULL(PP, 0))) AS PayableAmount,
        ISNULL(ReturnTotal, 0) AS AdjustableAmount,
        ISNULL(NULLIF(LTRIM(RTRIM(INV.DA_PaymentCollection)), ''), 'Pending') AS Status,
        LL.PaymentCollectionAppLogId AS PaymentCollectionAppLogId,
        ISNULL(LL.ApprovalStatus, '') AS ApprovalStatus,
        ISNULL(LL.Remarks, '') AS ApprovalRemarks,
        LL.ApproveBy AS ApproveBy,
        FORMAT(LL.ApproveDate, 'dd-MMM-yyyy') AS ApproveDate
    FROM dbo.tblInvoice AS INV WITH (NOLOCK)
    INNER JOIN dbo.tblOrder ORD WITH (NOLOCK)
        ON INV.OrderId = ORD.OrderId
    LEFT JOIN
    (
        SELECT
            InvoiceId,
            ISNULL(SUM(TPAmount) + SUM(VATAmount), 0) AS PP
        FROM dbo.tblCustPayDetail WITH (NOLOCK)
        GROUP BY InvoiceId
    ) AS P
        ON INV.InvoiceId = P.InvoiceId
    INNER JOIN
    (
        SELECT
            InvoiceId,
            SUM(PaymentNetAmount) AS TotalDelivery
        FROM dbo.tblInvoiceDetail WITH (NOLOCK)
        GROUP BY InvoiceId
    ) AS TD
        ON INV.InvoiceId = TD.InvoiceId
    LEFT JOIN
    (
        SELECT
            InvoiceId,
            SUM(TPGrandTotal) AS ReturnTotal
        FROM dbo.tblReturnInvoice WITH (NOLOCK)
        GROUP BY InvoiceId
    ) AS RTN
        ON INV.InvoiceId = RTN.InvoiceId
    INNER JOIN
    (
        SELECT
            InvoiceId,
            SUM(PaymentTotalPriceVatAmount) AS PaymentTotalPriceVatAmount,
            SUM(PaymentTotalPrice) AS PaymentTotalPrice
        FROM dbo.tblInvoiceDetail WITH (NOLOCK)
        GROUP BY InvoiceId
    ) AS tblinvDetls
        ON tblinvDetls.InvoiceId = INV.InvoiceId
    INNER JOIN LatestLog LL
        ON LL.InvoiceId = INV.InvoiceId
        AND LL.rn = 1
    WHERE
        (ISNULL(TotalDelivery, 0) - ISNULL(PP, 0)) > 0
        
        AND ORD.ComUnitId = @ComUnitId
        AND ORD.DistributionRouteId = @RouteId
       
    ORDER BY
        INV.InvoiceDate ASC;
END
