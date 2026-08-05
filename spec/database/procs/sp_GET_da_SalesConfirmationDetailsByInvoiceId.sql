
CREATE   PROCEDURE [dbo].[sp_GET_da_SalesConfirmationDetailsByInvoiceId]
    @InvoiceId INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LatestLog AS
    (
        SELECT TOP (1)
            L.SalesConfirmationAppLogId
        FROM dbo.tblSalesConfirmation_appLog L WITH (NOLOCK)
        WHERE L.InvoiceId = @InvoiceId
        ORDER BY L.SalesConfirmationAppLogId DESC
    )
    SELECT
        I.InvoiceId AS InvoiceId,
        ISNULL(I.InvoiceNo, '') AS InvoiceNo,
        ISNULL(I.OrderId, 0) AS OrderId,
        ISNULL(I.OrderNo, '') AS OrderNo,
        CONVERT(varchar(10), I.OrderDate, 23) AS OrderDate,
        ISNULL(I.CustomerMasterId, 0) AS CustomerMasterId,
        ISNULL(CM.CustomerCode, '') AS CustomerCode,
        ISNULL(CM.CustomerName, '') AS CustomerName,
        ISNULL(I.DeliveryPersonName, '') AS DeliveryPersonName,
        ISNULL(I.DeliveryPersonPhNo, '') AS DeliveryPersonMobile,
        ISNULL(I.Remarks, '') AS Remarks,
        ISNULL(ID.InvoiceDetailId, 0) AS InvoiceDetailId,
        ISNULL(COALESCE(LD.ProductCode, ID.ProductCode), '') AS ProductCode,
        ISNULL(COALESCE(LD.ProductName, P.ProductName), '') AS ProductName,
        ISNULL(COALESCE(LD.OrderDetailsId, ID.OrderDetailsId), 0) AS OrderDetailsId,
        ISNULL(COALESCE(LD.DCStoreId, ID.DCStoreId), 0) AS DCStoreId,
        ISNULL(ID.Campaign, '') AS Campaign,
        ISNULL(OD.CampaignName, '') AS CampaignName,
        ISNULL(OD.CampaignType, '') AS CampaignType,
        CAST(ISNULL(OD.ISGiftProduct, 0) AS bit) AS IsGiftProduct,
        CASE WHEN ISNULL(OD.DiscountAmount, 0) > 0 THEN 0 ELSE 1 END AS IsCampaignProduct,
        '0' AS Sl,
        CAST(COALESCE(LD.StockQty, 0) AS decimal(18, 2)) AS StockQty,
        CAST(COALESCE(LD.UnitPrice, ID.UnitPrice, 0) AS decimal(18, 2)) AS UnitPrice,
        CAST(COALESCE(LD.UnitVat, ID.UnitVatAmount, 0) AS decimal(18, 2)) AS UnitVat,
        CAST(COALESCE(LD.OrderedQty, ID.TotalQuantity, 0) AS decimal(18, 2)) AS OrderedQty,
        CAST(COALESCE(LD.DeliveredQty, ID.TotalQuantity, 0) AS decimal(18, 2)) AS DeliveredQty,
        ISNULL(ID.TotalQuantity, 0) AS Quantity,
        ISNULL(ID.TotalPrice, 0) AS TotalPrice,
        ISNULL(ID.TotalPriceVatAmount, 0) AS Vat,
        ISNULL(ID.DiscountPercentage, 0) AS DiscountPercentage,
        CAST(COALESCE(LD.DiscountAmount, ID.DiscountAmount, 0) AS decimal(18, 2)) AS DiscountAmount,
        CAST(COALESCE(LD.NetPrice, ID.NetAmount, 0) AS decimal(18, 2)) AS NetPrice,
        CAST(0 AS decimal(18, 2)) AS BonusQty,
        CAST(COALESCE(LD.TotalQty, ID.TotalQuantity, 0) AS decimal(18, 2)) AS TotalQty
    FROM dbo.tblInvoice I WITH (NOLOCK)
    LEFT JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON I.InvoiceId = ID.InvoiceId
    LEFT JOIN dbo.tblOrderDetail OD WITH (NOLOCK)
        ON OD.OrderDetailId = ID.OrderDetailsId
    LEFT JOIN dbo.tblProduct P WITH (NOLOCK)
        ON ID.ProductCode = P.ProductCode
    LEFT JOIN dbo.tblCustMaster CM WITH (NOLOCK)
        ON I.CustomerMasterId = CM.CustomerMasterId
    LEFT JOIN LatestLog LL
        ON 1 = 1
    LEFT JOIN dbo.tblSalesConfirmation_appLogDetail LD WITH (NOLOCK)
        ON LD.SalesConfirmationAppLogId = LL.SalesConfirmationAppLogId
        AND LD.InvoiceDetailId = ID.InvoiceDetailId
    WHERE
        I.InvoiceId = @InvoiceId
    ORDER BY
        ID.InvoiceDetailId;
END
