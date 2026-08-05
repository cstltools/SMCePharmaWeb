
CREATE PROCEDURE [dbo].[sp_InsertInvoiceNotBinding]
	@ApplyType VARCHAR(20) = 'Customer',
	@CustomerId INT = NULL,
	@CustomerCode VARCHAR(50) = NULL,
	@CustomerTypeId INT = NULL,
	@ActiveFromDate DATE,
	@ActiveToDate DATE = NULL,
	@AllowedNoOfInvoice INT = 4,
	@AllowedCreditLimit DECIMAL(18,2) = 100000.00,
	@NumberOfDaysInTransit INT = 45,
	@Remarks NVARCHAR(250) = NULL,
	@IsActive BIT = 1,
	@CreatedBy NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @ApplyType = 'CustomerType'
	BEGIN
		IF @CustomerTypeId IS NULL OR @CustomerTypeId <= 0
		BEGIN
			RAISERROR('Customer Type is required.', 16, 1);
			RETURN;
		END

		IF EXISTS(SELECT 1 FROM dbo.tblInvoiceNotBinding WHERE ApplyType = 'CustomerType' AND CustomerTypeId = @CustomerTypeId)
		BEGIN
			RAISERROR('This customer type already exists in Invoice Limit Setup.', 16, 1);
			RETURN;
		END

		INSERT INTO dbo.tblInvoiceNotBinding
			(ApplyType, CustomerId, CustomerCode, CustomerTypeId, ActiveFromDate, ActiveToDate, AllowedNoOfInvoice, AllowedCreditLimit, NumberOfDaysInTransit, Remarks, IsActive, CreatedBy, CreatedDate)
		VALUES
			('CustomerType', NULL, NULL, @CustomerTypeId, @ActiveFromDate, @ActiveToDate, @AllowedNoOfInvoice, @AllowedCreditLimit, @NumberOfDaysInTransit, @Remarks, @IsActive, @CreatedBy, GETDATE());
	END
	ELSE
	BEGIN
		IF @CustomerId IS NULL OR @CustomerId <= 0
		BEGIN
			RAISERROR('Customer is required.', 16, 1);
			RETURN;
		END

		IF ISNULL(@CustomerCode, '') = ''
		BEGIN
			SELECT @CustomerCode = CustomerCode FROM dbo.tblCustMaster WHERE CustomerMasterId = @CustomerId;
		END

		IF EXISTS(SELECT 1 FROM dbo.tblInvoiceNotBinding WHERE ApplyType = 'Customer' AND CustomerId = @CustomerId)
		BEGIN
			RAISERROR('This customer already exists in Invoice Limit Setup.', 16, 1);
			RETURN;
		END

		INSERT INTO dbo.tblInvoiceNotBinding
			(ApplyType, CustomerId, CustomerCode, CustomerTypeId, ActiveFromDate, ActiveToDate, AllowedNoOfInvoice, AllowedCreditLimit, NumberOfDaysInTransit, Remarks, IsActive, CreatedBy, CreatedDate)
		VALUES
			('Customer', @CustomerId, @CustomerCode, NULL, @ActiveFromDate, @ActiveToDate, @AllowedNoOfInvoice, @AllowedCreditLimit, @NumberOfDaysInTransit, @Remarks, @IsActive, @CreatedBy, GETDATE());
	END
END
