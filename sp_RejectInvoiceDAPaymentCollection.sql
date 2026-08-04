CREATE PROCEDURE sp_RejectInvoiceDAPaymentCollection
    @InvoiceId INT,
    @PaymentCollectionAppLogId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update the Invoice status
    UPDATE dbo.tblInvoice 
    SET DA_PaymentCollection = 'Rejected' 
    WHERE InvoiceId = @InvoiceId;
    
    -- Delete the log if ID is provided
    IF ISNULL(@PaymentCollectionAppLogId, 0) > 0
    BEGIN
        DELETE FROM dbo.tblPaymentCollection_appLog 
        WHERE PaymentCollectionAppLogId = @PaymentCollectionAppLogId;
    END
END
GO
