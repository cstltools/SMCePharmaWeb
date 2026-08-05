
CREATE PROCEDURE [dbo].[sp_UD_productQuotedPrice]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,    
	@ProductId INT,
	@CustomerMasterId INT,
	@QuotedPrice  decimal(18, 2),
	@ActiveDate Datetime,
	@InactiveDate Datetime,
	@UpdateBy Nvarchar(50),
	@ApprovedBy Nvarchar(50)

AS
    BEGIN



        DECLARE @ActionStatus NVARCHAR(50)
		
		Select @ActionStatus=ActionValue from tblAction where ActionValue='Approved' 

		UPDATE tblProductQuotedPrice 
		SET ProductId = @ProductId, CustomerMasterId=@CustomerMasterId, QuotedPrice=@QuotedPrice, ActiveDate=@ActiveDate, InactiveDate=@InactiveDate,
		    ApprovedBy=@ApprovedBy, ApprovedDate = GETDATE(), ActionStatus=@ActionStatus,  UpdateBy = @UpdateBy, UpdateDate = GETDATE()
		WHERE QuotedPriceId =  @id
       

    END
