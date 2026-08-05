
CREATE PROCEDURE [dbo].[sp_DeleteInvoiceNotBinding]
	@InvoiceNotBindingId INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM dbo.tblInvoiceNotBinding WHERE InvoiceNotBindingId = @InvoiceNotBindingId;
END
