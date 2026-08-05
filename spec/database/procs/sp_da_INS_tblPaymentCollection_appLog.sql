
--------------------------------------------------
-- PROCEDURE: sp_da_INS_tblPaymentCollection_appLog
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_da_INS_tblPaymentCollection_appLog]
    @DaId INT,
    @ComUnitId INT,
    @BankId INT,
    @RouteId INT,
    @InvoiceId INT,
    @PayableAmount DECIMAL(18,2) = NULL,
    @ApprovalStatus NVARCHAR(50) = N'Pending',
    @ApproveBy INT = NULL,
    @Remarks NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ServerApproveDate DATETIME2(0) = GETDATE();

    INSERT INTO dbo.tblPaymentCollection_appLog
    (
        DaId,
        ComUnitId,
        RouteId,
        InvoiceId,
        PayableAmount,
        ApprovalStatus,
        ApproveDate,
        ApproveBy,
        Remarks,BankId
    )
    VALUES
    (
        @DaId,
        @ComUnitId,
        @RouteId,
        @InvoiceId,
        @PayableAmount,
        ISNULL(@ApprovalStatus, N'Pending'),
        @ServerApproveDate,
        @ApproveBy,
        @Remarks,@BankId
    );

    UPDATE dbo.tblInvoice
    SET DA_PaymentCollection = ISNULL(@ApprovalStatus, N'Pending')
    WHERE InvoiceId = @InvoiceId;

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

