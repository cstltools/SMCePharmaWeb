

CREATE PROCEDURE [dbo].[sp_UD_SubDcStockOutApproval] 
	(
		@SubDcStockOutMasterId INT ,
		@Status NVARCHAR(50),
		@ApprovedBy NVARCHAR(50),
		@ApprovedDate DateTime
	             			
	)
AS
BEGIN
  
	Declare @SubStoreId int
	Declare @SubStockoutqty int

	Declare @SubgetStore Cursor 
	Set @SubgetStore = cursor for
	Select SubDCStoreId, StockOutQty from tblSubDepotStockOutDetails where SubDcStockOutMasterId= @SubDcStockOutMasterId
	order by SubDcStockOutDetailsId

	OPEN @SubgetStore 
	FETCH NEXT
	
	FROM  @SubgetStore INTO @SubStoreId, @SubStockoutqty

	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	     IF @SubStockoutqty > 0
	     BEGIN
	        UPDATE tblSubDepotStore
	        SET StockQty = StockQty - @SubStockoutqty
	        WHERE SubDCStoreId = @SubStoreId
	     END

	   FETCH NEXT
	   FROM @SubgetStore INTO 
	   @SubStoreId, @SubStockoutqty
	   END
   	
       CLOSE @SubgetStore	

       DEALLOCATE @SubgetStore

   BEGIN
     UPDATE [dbo].[tblSubDepotStockOutMaster]
        SET  Status=@Status,
			[ApprovedBy]=@ApprovedBy
           ,[ApprovedDate]=@ApprovedDate        		
		WHERE SubDcStockOutMasterId=@SubDcStockOutMasterId	
	END

			
END
