CREATE OR ALTER PROCEDURE dbo.sp_RejectInvoiceDASalesReturn
    @InvoiceId INT = NULL,
    @SalesReturnAppLogId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If SalesReturnAppLogId is provided, delete by SalesReturnAppLogId
    IF @SalesReturnAppLogId IS NOT NULL AND @SalesReturnAppLogId > 0
    BEGIN
        -- Find InvoiceId if not provided
        IF @InvoiceId IS NULL OR @InvoiceId = 0
        BEGIN
            SELECT TOP 1 @InvoiceId = InvoiceId 
            FROM dbo.tblSalesReturn_appLog 
            WHERE SalesReturnAppLogId = @SalesReturnAppLogId;
        END

        DELETE FROM dbo.tblSalesReturn_appLogDetail WHERE SalesReturnAppLogId = @SalesReturnAppLogId;
        DELETE FROM dbo.tblSalesReturn_appLog WHERE SalesReturnAppLogId = @SalesReturnAppLogId;
    END
    ELSE IF @InvoiceId IS NOT NULL AND @InvoiceId > 0
    BEGIN
        DELETE FROM dbo.tblSalesReturn_appLogDetail 
        WHERE InvoiceId = @InvoiceId 
           OR SalesReturnAppLogId IN (SELECT SalesReturnAppLogId FROM dbo.tblSalesReturn_appLog WHERE InvoiceId = @InvoiceId);

        DELETE FROM dbo.tblSalesReturn_appLog WHERE InvoiceId = @InvoiceId;
    END

    -- Update the Invoice status
    IF @InvoiceId IS NOT NULL AND @InvoiceId > 0
    BEGIN
        UPDATE dbo.tblInvoice 
        SET DA_SalesReturn = 'Rejected' 
        WHERE InvoiceId = @InvoiceId;
    END
END
GO
