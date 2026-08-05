

CREATE PROCEDURE [dbo].[sp_Save_QuotedPrice]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,    
	@ProductId INT,
	@CustomerMasterId INT,
	@QuotedPrice  decimal(18, 2),
	@ActiveDate Datetime,
	@EntryBy Nvarchar(50),
	@ApprovedBy Nvarchar(50)
AS
    BEGIN
	
IF NOT EXISTS (select ProductId from tblProductQuotedPrice where  IsActive =1 and ProductId = @ProductId And CustomerMasterId=@CustomerMasterId)
    BEGIN 
	    DECLARE @ActionStatus NVARCHAR(50)	
		Select @ActionStatus=ActionValue from tblAction where ActionValue='Approved' 
        INSERT INTO tblProductQuotedPrice
           (
			ProductId
           ,CustomerMasterId
		   ,QuotedPrice
		   ,ActiveDate
           ,EntryBy
           ,EntryDate
           ,IsActive
		   ,ApprovedBy
		   ,ApprovedDate
		   ,ActionStatus
           )
     VALUES
           (
		   @ProductId,
		   @CustomerMasterId,
		   @QuotedPrice,
		   @ActiveDate,
		   @EntryBy,
		   GETDATE(),
		   1,
		   @ApprovedBy,
		   GETDATE(),
		   @ActionStatus	   
		   )
		SELECT SCOPE_IDENTITY()
  
End
  else  Return 0
END
