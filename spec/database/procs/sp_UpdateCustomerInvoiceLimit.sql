
CREATE PROCEDURE [dbo].[sp_UpdateCustomerInvoiceLimit]
	@Id INT,
	@MaximumInvoiceValue DECIMAL(18,2),
	@Remarks NVARCHAR(250),
	@IsActive BIT,
	@UpdatedBy NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    
	UPDATE dbo.tblCustomerInvoiceLimit
	SET 
		MaximumInvoiceValue = @MaximumInvoiceValue,
		Remarks = @Remarks,
		IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = GETDATE()
	WHERE Id = @Id;
END
