
create PROCEDURE [dbo].[sp_UD_StockBatch_new] 
	(
		@dcStoreId INT,
		@batch NVARCHAR(MAX),
		@mfgdate datetime,
		@expDate datetime,
	    @UpdateBy NVARCHAR(MAX),
		@StockQty decimal(18,0)     
	              
	)
AS
BEGIN
	   
	  DECLARE @BatchNo NVARCHAR(500)
	  DECLARE @PMFGDate Datetime
	  DECLARE @PexpDate Datetime
	          
	  --------------------------------------------------------
	  DECLARE @MyCursor CURSOR
	  SET @MyCursor = CURSOR FAST_FORWARD
	  FOR
	  ---------------
	  
	 SELECT BatchNo,MfgDate,ExpDate FROM tblDCStore WHERE DCStoreId = @dcStoreId
	  	
	  ----------
	  OPEN @MyCursor
	  FETCH NEXT FROM @MyCursor
	  INTO @BatchNo,@PMFGDate,@PexpDate
	  
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	  
	  -- Insert in tblStockBatchUpdateTracking

	  INSERT INTO [dbo].[tblStockBatchUpdateTracking]
           ([DcStoreId]
           ,[StockQty]
           ,[BatchNo]
           ,[MFGDate]
           ,[EXPDate]
           ,[UpdateBy]
           ,[UpdateDate])
     VALUES
           (@dcStoreId,@StockQty,@BatchNo,@PMFGDate,@PexpDate,@UpdateBy,GETDATE())

	  -- Update DC Store

	  --UPDATE tblDCStore SET BatchNo = @batch,ExpDate = @expDate, MfgDate = MfgDate,IsBatchUpdate = 1 WHERE DCStoreId = @dcStoreId
	   UPDATE tblDCStore SET  StockQty= @StockQty ,  BatchNo = @batch,ExpDate = @expDate, MfgDate = @mfgdate,IsBatchUpdate = 1 WHERE DCStoreId = @dcStoreId

	  FETCH NEXT FROM @MyCursor
	  INTO @BatchNo,@PMFGDate,@PexpDate
	  
	  END
	  CLOSE @MyCursor
	  DEALLOCATE @MyCursor


END