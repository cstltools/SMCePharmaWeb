
CREATE PROCEDURE [dbo].[sp_InsertCustomerInvoiceLimit]
	@CustomerId INT,
	@MaximumInvoiceValue DECIMAL(18,2),
	@Remarks NVARCHAR(250),
	@IsActive BIT,
	@CreatedBy NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    
	IF EXISTS(SELECT 1 FROM dbo.tblCustomerInvoiceLimit WHERE CustomerId = @CustomerId)
	BEGIN
		RAISERROR('This customer already has a maximum invoice configuration.', 16, 1);
		RETURN;
	END

	INSERT INTO dbo.tblCustomerInvoiceLimit (CustomerId, MaximumInvoiceValue, Remarks, IsActive, CreatedBy, CreatedDate)
	VALUES (@CustomerId, @MaximumInvoiceValue, @Remarks, @IsActive, @CreatedBy, GETDATE());
END
