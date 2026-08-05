
CREATE PROCEDURE [dbo].[sp_GetCustomerInvoiceLimitById]
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT 
		CIL.Id,
		CIL.CustomerId,
		C.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		CIL.MaximumInvoiceValue,
		CIL.Remarks,
		CIL.IsActive
	FROM dbo.tblCustomerInvoiceLimit CIL
	INNER JOIN dbo.tblCustMaster C ON CIL.CustomerId = C.CustomerMasterId
	WHERE CIL.Id = @Id;
END
