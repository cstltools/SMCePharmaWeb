
CREATE PROCEDURE [dbo].[sp_UD_DcStockOutApproval] 
	(
		@DcStockOutMasterId INT ,
		@Status NVARCHAR(50),
		@ApprovedBy NVARCHAR(50),
		@ApprovedDate DateTime
	             			
	)
AS
BEGIN
  
	Declare @StoreId int
	Declare @Stockoutqty int

	Declare @getStore Cursor 
	Set @getStore = cursor for
	Select DcStoreId, StackOutQty from tblDeStockOutDetails where DcStockOutMasterId= @DcStockOutMasterId
	order by DcStockOutDetailsId

	open @getStore 
	fetch next
	
	from  @getStore into @StoreId, @Stockoutqty

	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	     If @Stockoutqty > 0
	     BEGIN
	        UPDATE tblDCStore
	        SET StockQty = StockQty - @Stockoutqty
	        Where DCStoreId = @StoreId
	     END

	   FETCH NEXT
	   FROM @getStore INTO 
	   @StoreId, @Stockoutqty
	   END
   	
       CLOSE @getStore	

       DEALLOCATE @getStore

   BEGIN
     UPDATE [dbo].[tblDeStockOutMaster]
        SET  Status=@Status,
			[ApprovedBy]=@ApprovedBy
           ,[ApprovedDate]=@ApprovedDate        		
		WHERE DcStockOutMasterId=@DcStockOutMasterId	
	END

			
END