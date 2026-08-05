
CREATE PROCEDURE [dbo].[sp_Save_ProductBrand]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ProductBrandName NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll
	
AS
    BEGIN
	
	if not exists (select ProductBrandName from tblProductBrand where  ProductBrandName= @ProductBrandName)
    begin 

        DECLARE @ProductBrandCode NVARCHAR(MAX)

        SELECT  @ProductBrandCode = 'PROB-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ProductBrandId) + 10001 )) ) FROM  tblProductBrand

        INSERT INTO tblProductBrand
           (
			ProductBrandName
			,ProductBrandCode	
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,ActiveInactiveDate     
           )
     VALUES
           (
		    @ProductBrandName,
			@ProductBrandCode,
			@IsActive,
		    @EntryBy,
		    GETDATE(),
			@InactiveBy,
			@ActiveInactiveDate
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
