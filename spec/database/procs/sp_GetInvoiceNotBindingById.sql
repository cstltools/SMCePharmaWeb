
CREATE PROCEDURE [dbo].[sp_GetInvoiceNotBindingById]
	@InvoiceNotBindingId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		INB.InvoiceNotBindingId,
		INB.ApplyType,
		INB.CustomerId,
		INB.CustomerCode,
		C.CustomerName,
		ISNULL(C.CellNo, '') AS MobileNo,
		INB.CustomerTypeId,
		CT.CustomerType AS CustomerTypeName,
		INB.ActiveFromDate,
		INB.ActiveToDate,
		ISNULL(INB.AllowedNoOfInvoice, 4) AS AllowedNoOfInvoice,
		ISNULL(INB.AllowedCreditLimit, 100000.00) AS AllowedCreditLimit,
		ISNULL(INB.NumberOfDaysInTransit, 45) AS NumberOfDaysInTransit,
		INB.Remarks,
		INB.IsActive
	FROM dbo.tblInvoiceNotBinding INB
	LEFT JOIN dbo.tblCustMaster C ON INB.CustomerId = C.CustomerMasterId
	LEFT JOIN dbo.tblCustomerType CT ON INB.CustomerTypeId = CT.CustomerTypeId
	WHERE INB.InvoiceNotBindingId = @InvoiceNotBindingId;
END
