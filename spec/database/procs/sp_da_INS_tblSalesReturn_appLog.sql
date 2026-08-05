
CREATE   PROCEDURE dbo.sp_da_INS_tblSalesReturn_appLog
    @DaId INT,
    @ComUnitId INT,
    @RouteId INT,
    @InvoiceId INT,
    @ApprovalStatus NVARCHAR(50) = N'Pending',
    @ApproveBy INT = NULL,
    @Remarks NVARCHAR(500) = NULL,
    @ReturnType NVARCHAR(50) = N'Partial',
    @Details dbo.SalesReturnLogDetailTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ServerApproveDate DATETIME2(0) = GETDATE();
    DECLARE @LogId INT;

    INSERT INTO dbo.tblSalesReturn_appLog
    (
        DaId,
        ComUnitId,
        RouteId,
        InvoiceId,
        ApprovalStatus,
        ApproveDate,
        ApproveBy,
        Remarks,
        ReturnType
    )
    VALUES
    (
        @DaId,
        @ComUnitId,
        @RouteId,
        @InvoiceId,
        ISNULL(@ApprovalStatus, N'Pending'),
        @ServerApproveDate,
        @ApproveBy,
        @Remarks,
        ISNULL(@ReturnType, N'Partial')
    );

    SET @LogId = CAST(SCOPE_IDENTITY() AS INT);

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
    SELECT
        @LogId,
        @InvoiceId,
        d.InvoiceDetailId,
        d.OrderDetailsId,
        d.DCStoreId,
        d.ProductCode,
        d.ProductName,
        d.StockQty,
        d.OrderedQty,
        d.ReturnQty,
        d.UnitPrice,
        d.UnitVat,
        d.DiscountAmount,
        d.NetPrice,
        d.TotalQty,
        d.ReturnStatus,
        d.ReasonCode,
        d.ReasonLabel
    FROM @Details d;

    UPDATE dbo.tblInvoice
    SET DA_SalesReturn = ISNULL(@ApprovalStatus, N'Pending')
    WHERE InvoiceId = @InvoiceId;

    SELECT @LogId;
END
