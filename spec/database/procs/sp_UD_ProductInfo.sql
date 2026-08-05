
CREATE PROCEDURE [dbo].[sp_UD_ProductInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
	@CompanyId INT,
    @ProductName   NVARCHAR(MAX),
	@ProductCode   NVARCHAR(MAX),
	@Description   NVARCHAR(MAX),
	@CategoryId INT,
	@ManufacId INT,
	@StockUOMId INT,
	@PackSizeId INT,
	@PackSize  NVARCHAR(MAX),
	@ProTypeId INT,
	@ProductType NVARCHAR(MAX),
	@ProductBrandId INT,
	@ShippingCartonSizeId INT,
	@GenericGroupId INT,
	@TherapueticGroupId INT,
    @UpdateBy INT

AS
    BEGIN

		UPDATE tblProduct 
		SET CompanyId = @CompanyId,ProductName=@ProductName,ProductCode=@ProductCode,Description=@Description,CategoryId=@CategoryId,ManufacId=@ManufacId,
		StockUOMId=@StockUOMId,PackSizeId=@PackSizeId,PackSize=@PackSize,ProTypeId=@ProTypeId,ProductType=@ProductType,ProductBrandId=@ProductBrandId,
		ShippingCartonSizeId=@ShippingCartonSizeId,GenericGroupId=@GenericGroupId,TherapueticGroupId=@TherapueticGroupId,UpdateBy = @UpdateBy,UpdateDate = GETDATE()
		WHERE ProductId =  @id
       
    END




	