
CREATE   PROCEDURE [dbo].[sp_GET_da_SalesReturnDetailsByInvoiceId]
    @InvoiceId INT
AS
BEGIN
    SET NOCOUNT ON;

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
        ISNULL(ID.ProductCode, '') AS ProductCode,
        ISNULL(P.ProductName, '') AS ProductName,
        ISNULL(ID.OrderDetailsId, 0) AS OrderDetailsId,
        ISNULL(ID.DCStoreId, 0) AS DCStoreId,
        ISNULL(ID.Campaign, '') AS Campaign,
        ISNULL(OD.CampaignName, '') AS CampaignName,
        ISNULL(OD.CampaignType, '') AS CampaignType,
        CAST(ISNULL(OD.ISGiftProduct, 0) AS bit) AS IsGiftProduct,
        CASE
            WHEN ISNULL(OD.DiscountAmount, 0) > 0 THEN 0
            ELSE 1
        END AS IsCampaignProduct,
        '0' AS SL,
        CAST(0 AS decimal(18, 2)) AS StockQty,
        CAST(ISNULL(ID.UnitPrice, 0) AS decimal(18, 2)) AS UnitPrice,
        CAST(ISNULL(ID.UnitVatAmount, 0) AS decimal(18, 2)) AS UnitVAT,
        CAST(ISNULL(ID.DeliveryQuantity, 0) AS decimal(18, 2)) AS DelTotalQty,
        CAST(ISNULL(ID.TotalQuantity, 0) AS decimal(18, 2)) AS Quantity,
        CAST(ISNULL(ID.TotalPrice, 0) AS decimal(18, 2)) AS TotalPrice,
        CAST(ISNULL(ID.TotalPriceVatAmount, 0) AS decimal(18, 2)) AS VAT,
        CAST(ISNULL(ID.DiscountPercentage, 0) AS decimal(18, 2)) AS DiscountPercentage,
        CAST(ISNULL(ID.DiscountAmount, 0) AS decimal(18, 2)) AS DiscountAmount,
        CAST(ISNULL(ID.NetAmount, 0) AS decimal(18, 2)) AS NetPrice,
        CAST(0 AS decimal(18, 2)) AS BonusQty,
        CAST(ISNULL(ID.TotalQuantity, 0) AS decimal(18, 2)) AS TotalQty
    FROM dbo.tblInvoice I WITH (NOLOCK)
    LEFT JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK)
        ON I.InvoiceId = ID.InvoiceId
    LEFT JOIN dbo.tblOrderDetail OD WITH (NOLOCK)
        ON OD.OrderDetailId = ID.OrderDetailsId
    LEFT JOIN dbo.tblProduct P WITH (NOLOCK)
        ON ID.ProductCode = P.ProductCode
    LEFT JOIN dbo.tblCustMaster CM WITH (NOLOCK)
        ON I.CustomerMasterId = CM.CustomerMasterId
    WHERE I.InvoiceId = @InvoiceId
    ORDER BY ID.InvoiceDetailId;
END
