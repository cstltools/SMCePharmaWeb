
CREATE PROCEDURE [dbo].[sp_Update_InvoiceFinalPayment]
    @InvoiceId INT = 0,
    @PaymentAmount DECIMAL(18,2),
    @ptStatus NVARCHAR(50),
    @FinalPaymentBy NVARCHAR(50),
    @PaymentCollectionAppLogId INT = NULL
AS
BEGIN
    DECLARE @CountDataOrd INT
    SELECT @CountDataOrd = COUNT(*) FROM dbo.tblCustPayDetail WHERE InvoiceId = @InvoiceId AND CONVERT(DATE, custPaymentDate) = CONVERT(DATE, GETDATE()) AND ISNULL(PaymentAmount, 0) = ISNULL(@PaymentAmount, 0)

    IF (@CountDataOrd = 0)
    BEGIN
        UPDATE tblInvoice
        SET PaymentAmount = ISNULL(PaymentAmount, 0) + @PaymentAmount,
            FinalPaymentNo = 'PYT-' + InvoiceNo,
            PaymentStatus = @ptStatus,
            FinalPaymentBy = @FinalPaymentBy,
            FinalPaymentDate = GETDATE()
        WHERE InvoiceId = @InvoiceId
        
        IF (@PaymentCollectionAppLogId IS NOT NULL AND @PaymentCollectionAppLogId > 0)
        BEGIN
            UPDATE tblPaymentCollection_appLog 
            SET ApprovalStatus = 'Approved',
                approvebyDIC = @FinalPaymentBy,
                ApproveDICDate = GETDATE()
            WHERE PaymentCollectionAppLogId = @PaymentCollectionAppLogId
        END
    END

    IF @CountDataOrd <> 0
        RETURN 0 
    ELSE
        RETURN 1 
END
