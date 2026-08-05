CREATE PROCEDURE [dbo].[sp_UD_ProductBrand]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ProductBrandName   NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll

AS
    BEGIN

		UPDATE tblProductBrand
		SET ProductBrandName = @ProductBrandName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive , InactiveBy= @InactiveBy, ActiveInactiveDate=@ActiveInactiveDate
		WHERE ProductBrandId =  @id
       
    END