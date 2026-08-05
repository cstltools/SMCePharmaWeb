
--------------------------------------------------
-- PROCEDURE: sp_da_INS_tblSalesReturn_appLogDetail
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_da_INS_tblSalesReturn_appLogDetail]
    @SalesReturnAppLogId INT,
    @InvoiceId INT,
    @InvoiceDetailId INT,
    @OrderDetailsId INT = 0,
    @DCStoreId INT = 0,
    @ProductCode NVARCHAR(50),
    @ProductName NVARCHAR(200) = NULL,
    @StockQty DECIMAL(18, 2) = 0,
    @OrderedQty DECIMAL(18, 2) = 0,
    @ReturnQty DECIMAL(18, 2),
    @UnitPrice DECIMAL(18, 4) = 0,
    @UnitVat DECIMAL(18, 4) = 0,
    @DiscountAmount DECIMAL(18, 4) = 0,
    @NetPrice DECIMAL(18, 4) = 0,
    @TotalQty DECIMAL(18, 2) = 0,
    @ReturnStatus NVARCHAR(50) = NULL,
    @ReasonCode NVARCHAR(50) = NULL,
    @ReasonLabel NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.tblSalesReturn_appLogDetail
    (
        SalesReturnAppLogId,
        InvoiceId,
        InvoiceDetailId,
        OrderDetailsId,
        DCStoreId,
        ProductCode,
        ProductName,
        StockQty,
        OrderedQty,
        ReturnQty,
        UnitPrice,
        UnitVat,
        DiscountAmount,
        NetPrice,
        TotalQty,
        ReturnStatus,
        ReasonCode,
        ReasonLabel
    )
    VALUES
    (
        @SalesReturnAppLogId,
        @InvoiceId,
        @InvoiceDetailId,
        ISNULL(@OrderDetailsId, 0),
        ISNULL(@DCStoreId, 0),
        LTRIM(RTRIM(@ProductCode)),
        NULLIF(LTRIM(RTRIM(@ProductName)), N''),
        ISNULL(@StockQty, 0),
        ISNULL(@OrderedQty, 0),
        @ReturnQty,
        ISNULL(@UnitPrice, 0),
        ISNULL(@UnitVat, 0),
        ISNULL(@DiscountAmount, 0),
        ISNULL(@NetPrice, 0),
        ISNULL(@TotalQty, 0),
        NULLIF(LTRIM(RTRIM(@ReturnStatus)), N''),
        NULLIF(LTRIM(RTRIM(@ReasonCode)), N''),
        NULLIF(LTRIM(RTRIM(@ReasonLabel)), N'')
    );
 
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

