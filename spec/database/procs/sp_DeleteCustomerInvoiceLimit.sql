
CREATE PROCEDURE [dbo].[sp_DeleteCustomerInvoiceLimit]
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
    
	DELETE FROM dbo.tblCustomerInvoiceLimit WHERE Id = @Id;
END
