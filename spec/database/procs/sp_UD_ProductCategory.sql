
create PROCEDURE [dbo].[sp_UD_ProductCategory]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ProductCategory  NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN


		UPDATE tblProductCategory 
		SET ProductCategory = @ProductCategory,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy=@InactiveBy, InactiveDate = @InactiveDate
		WHERE ProductCategoryId =  @id
       

    END


