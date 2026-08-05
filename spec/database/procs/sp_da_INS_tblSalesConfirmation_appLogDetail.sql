
CREATE   PROCEDURE dbo.sp_da_INS_tblSalesConfirmation_appLogDetail
    @SalesConfirmationAppLogId INT,
    @InvoiceId INT,
    @InvoiceDetailId INT,
    @OrderDetailsId INT = 0,
    @DCStoreId INT = 0,
    @ProductCode NVARCHAR(50),
    @ProductName NVARCHAR(200) = NULL,
    @StockQty DECIMAL(18, 2) = 0,
    @OrderedQty DECIMAL(18, 2) = 0,
    @DeliveredQty DECIMAL(18, 2) = 0,
    @UnitPrice DECIMAL(18, 4) = 0,
    @UnitVat DECIMAL(18, 4) = 0,
    @DiscountAmount DECIMAL(18, 4) = 0,
    @NetPrice DECIMAL(18, 4) = 0,
    @TotalQty DECIMAL(18, 2) = 0,
    @DeliveryStatus NVARCHAR(50) = NULL,
    @DeliveryReason NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.tblSalesConfirmation_appLogDetail
    (
        SalesConfirmationAppLogId,
        InvoiceId,
        InvoiceDetailId,
        OrderDetailsId,
        DCStoreId,
        ProductCode,
        ProductName,
        StockQty,
        OrderedQty,
        DeliveredQty,
        UnitPrice,
        UnitVat,
        DiscountAmount,
        NetPrice,
        TotalQty,
        DeliveryStatus,
        DeliveryReason
    )
    VALUES
    (
        @SalesConfirmationAppLogId,
        @InvoiceId,
        @InvoiceDetailId,
        ISNULL(@OrderDetailsId, 0),
        ISNULL(@DCStoreId, 0),
        @ProductCode,
        NULLIF(@ProductName, N''),
        ISNULL(@StockQty, 0),
        ISNULL(@OrderedQty, 0),
        ISNULL(@DeliveredQty, 0),
        ISNULL(@UnitPrice, 0),
        ISNULL(@UnitVat, 0),
        ISNULL(@DiscountAmount, 0),
        ISNULL(@NetPrice, 0),
        ISNULL(@TotalQty, 0),
        NULLIF(@DeliveryStatus, N''),
        NULLIF(@DeliveryReason, N'')
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END
