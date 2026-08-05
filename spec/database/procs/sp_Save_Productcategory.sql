
CREATE PROCEDURE [dbo].[sp_Save_Productcategory]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ProductCategory NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN
	
	if not exists (select ProductCategory from tblProductCategory where ProductCategory=@ProductCategory)
    begin 

        DECLARE @ProductCategoryCode NVARCHAR(MAX)

        SELECT  @ProductCategoryCode = 'PROC-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ProductCategoryId) + 10001 )) ) FROM  tblProductCategory

        INSERT INTO tblProductCategory
           (
			ProductCategory
			,ProductCategoryCode			
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,InactiveDate        
           )
     VALUES
           (
		    @ProductCategory,
			@ProductCategoryCode,
			@IsActive,
		    @EntryBy,
		    GETDATE(),
			@InactiveBy,
			@InactiveDate
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
