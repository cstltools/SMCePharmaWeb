CREATE PROCEDURE sp_RejectInvoiceDASalesConfirmStatus
    @InvoiceId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update the Invoice status
    UPDATE dbo.tblInvoice 
    SET DA_SalesConfirmStatus = 'Rejected' 
    WHERE InvoiceId = @InvoiceId;
    
    -- Delete from logs
    DELETE FROM dbo.tblSalesConfirmation_appLog WHERE InvoiceId = @InvoiceId;
    DELETE FROM dbo.tblSalesConfirmation_appLogDetail WHERE InvoiceId = @InvoiceId;
END
GO
