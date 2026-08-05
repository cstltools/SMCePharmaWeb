
CREATE PROCEDURE [dbo].[sp_UpdateInvoiceNotBinding]
	@InvoiceNotBindingId INT,
	@ActiveFromDate DATE,
	@ActiveToDate DATE = NULL,
	@AllowedNoOfInvoice INT = 4,
	@AllowedCreditLimit DECIMAL(18,2) = 100000.00,
	@NumberOfDaysInTransit INT = 45,
	@Remarks NVARCHAR(250) = NULL,
	@IsActive BIT = 1,
	@UpdatedBy NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	-- ApplyType, CustomerId/CustomerCode and CustomerTypeId are fixed at creation time and not editable.
	UPDATE dbo.tblInvoiceNotBinding
	SET
		ActiveFromDate = @ActiveFromDate,
		ActiveToDate = @ActiveToDate,
		AllowedNoOfInvoice = @AllowedNoOfInvoice,
		AllowedCreditLimit = @AllowedCreditLimit,
		NumberOfDaysInTransit = @NumberOfDaysInTransit,
		Remarks = @Remarks,
		IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = GETDATE()
	WHERE InvoiceNotBindingId = @InvoiceNotBindingId;
END
