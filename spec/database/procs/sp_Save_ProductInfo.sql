
CREATE PROCEDURE [dbo].[sp_Save_ProductInfo]
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
    @EntryBy INT 

AS
    BEGIN
	
	if not exists (select ProductName from tblProduct where ProductName=@ProductName )
    begin 

        --DECLARE @ProductCode NVARCHAR(MAX)

        --SELECT  @ProductCode = 'PRO-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ProductId) + 10001 )) ) FROM  tblProduct

        INSERT INTO tblProduct
           (
			CompanyId
			,ProductName
			,ProductCode			
           ,Description
		   ,CategoryId
		   ,ManufacId
		   ,StockUOMId
		   ,PackSizeId
		   ,PackSize
		   ,ProTypeId
		   ,ProductType
		   ,ProductBrandId
		   ,ShippingCartonSizeId
		   ,GenericGroupId
		   ,TherapueticGroupId	   
           ,EntryBy
           ,EntryDate 

		          
           )
     VALUES
           (
		    @CompanyId,
			@ProductName,
			@ProductCode,
			@Description,
			@CategoryId,
			@ManufacId,
			@StockUOMId,
			@PackSizeId,
			@PackSize,
			@ProTypeId,
			@ProductType,
			@ProductBrandId,
			@ShippingCartonSizeId,
			@GenericGroupId,
			@TherapueticGroupId,
		    @EntryBy,
		    GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
