
CREATE PROCEDURE [dbo].[sp_GetCustomerInvoiceLimits]
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
		CIL.IsActive,
		CIL.CreatedBy,
		CIL.CreatedDate
	FROM dbo.tblCustomerInvoiceLimit CIL
	INNER JOIN dbo.tblCustMaster C ON CIL.CustomerId = C.CustomerMasterId
	ORDER BY CIL.CreatedDate DESC;
END
