
CREATE PROCEDURE [dbo].[sp_UD_UnitPriceInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
	@CompanyId INT,
    @ProductName  NVARCHAR(MAX),
	@ProductCode  NVARCHAR(MAX),
	@ProductId INT,
	@PackSize  NVARCHAR(MAX),
	@CostPrice decimal(18,2),
	@UnitPrice decimal(18,2),
	@MRPPrice decimal(18,2),
	@VATPercentage decimal(18,2),
	@VATAmountPerUnit decimal(18,2),
	@IsActive BIT,
	@ActiveDate datetime = Null,
	@InActiveDate datetime = NULL,
    @UpdateBy INT 

AS
    BEGIN

		UPDATE tblUnitPrice 
		SET CompanyId = @CompanyId,ProductName=@ProductName,ProductCode=@ProductCode,ProductId=@ProductId,PackSize=@PackSize,MRPPrice=@MRPPrice,
		CostPrice=@CostPrice, UnitPrice=@UnitPrice, VATPercentage=@VATPercentage, VATAmountPerUnit=@VATAmountPerUnit, IsActive=@IsActive, ActiveDate=@ActiveDate,
		InActiveDate= @InActiveDate,UpdateBy = @UpdateBy,UpdateDate = GETDATE()
		WHERE UnitPriceId = @id
       
    END
	   



	