
CREATE   PROCEDURE [dbo].[sp_GET_da_SalesConfirmationApprovalList]
    @ComUnitId INT,
    @RouteId INT,
    @daid INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LatestLog AS
    (
        SELECT
            L.SalesConfirmationAppLogId,
            L.DaId,
            L.ComUnitId,
            L.RouteId,
            L.InvoiceId,
            L.ApprovalStatus,
            L.ApproveDate,
            L.ApproveBy,
            L.Remarks,
            ROW_NUMBER() OVER (PARTITION BY L.InvoiceId ORDER BY L.SalesConfirmationAppLogId DESC) AS rn
        FROM dbo.tblSalesConfirmation_appLog L WITH (NOLOCK)
        WHERE
            L.ComUnitId = @ComUnitId
            AND L.RouteId = @RouteId
            AND L.DaId = @daid
    )
    SELECT
        CU.ComUnitName AS DistributionCenter,
        ORD.DistributionRoute_Ord AS Route,
        CU.ComUnitCode + ':' + CU.ComUnitName AS SaleCenter,
        '' AS FeName,
        ORD.CustomerType AS CustomerCategory,
        '' AS Address,
        ORD.MIOCode AS MioCode,
        ORD.MIOName AS MioName,
        '' AS DeliveryPersonMobile,
        ORD.OrderSenderName AS DeliveryPersonName,
        ORD.Remarks AS Remarks,
        INV.InvoiceNo AS InvoiceNo,
        ORD.OrderCode AS OrderNo,
        FORMAT(INV.InvoiceDate, 'dd-MMM-yyyy') AS InvoiceDate,
        FORMAT(ORD.SubmissionDate, 'dd-MMM-yyyy') AS OrderDate,
        ORD.ComUnitId AS ComUnitId,
        ORD.ManufacId AS ManufacId,
        ORD.OrderId AS OrderId,
        INV.InvoiceId AS InvoiceId,
        ORD.MarketId AS MarketId,
        ORD.CustomerMasterId AS CustomerMasterId,
        ORD.CustomerCode AS CustomerCode,
        ORD.CustomerName AS CustomerName,
        ORD.MIOName AS Mio,
        ORD.TerritoryName_Ord AS Territory,
        ORD.MarketName_Ord AS Market,
        D.TpGrandTotal AS Amount,
        ISNULL(NULLIF(LTRIM(RTRIM(INV.DA_SalesConfirmStatus)), ''), 'Pending') AS Status,
        LL.SalesConfirmationAppLogId AS SalesConfirmationAppLogId,
        ISNULL(LL.ApprovalStatus, '') AS ApprovalStatus,
        ISNULL(LL.Remarks, '') AS ApprovalRemarks,
        LL.ApproveBy AS ApproveBy,
        FORMAT(LL.ApproveDate, 'dd-MMM-yyyy') AS ApproveDate
    FROM dbo.tblOrder ORD WITH (NOLOCK)
    INNER JOIN dbo.tblInvoice INV WITH (NOLOCK)
        ON ORD.OrderId = INV.OrderId
    INNER JOIN dbo.tblCompanyUnit CU WITH (NOLOCK)
        ON ORD.ComUnitCode = CU.ComUnitCode
    INNER JOIN
    (
        SELECT
            D.InvoiceId,
            SUM(D.NetAmount) AS TpGrandTotal
        FROM dbo.tblInvoiceDetail D WITH (NOLOCK)
        GROUP BY D.InvoiceId
    ) AS D
        ON INV.InvoiceId = D.InvoiceId
    INNER JOIN LatestLog LL
        ON LL.InvoiceId = INV.InvoiceId
        AND LL.rn = 1
    WHERE
        
          ORD.ComUnitId = @ComUnitId
        AND ORD.DistributionRouteId = @RouteId
    ORDER BY
        INV.InvoiceDate ASC;
END
