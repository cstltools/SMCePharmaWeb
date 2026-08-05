-- =============================================
-- Author:		<Author,Liton>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_StockBatch] 
	(
		@dcStoreId INT,
		@batch NVARCHAR(MAX),
		@mfgdate datetime,
		@expDate datetime,
	    @UpdateBy NVARCHAR(MAX)     
	              
	)
AS
BEGIN
	  
	  DECLARE @StockQty decimal(18,0)
	  DECLARE @BatchNo NVARCHAR(500)
	  DECLARE @PMFGDate Datetime
	  DECLARE @PexpDate Datetime
	          
	  --------------------------------------------------------
	  DECLARE @MyCursor CURSOR
	  SET @MyCursor = CURSOR FAST_FORWARD
	  FOR
	  ---------------
	  
	 SELECT BatchNo,StockQty,MfgDate,ExpDate FROM tblDCStore WHERE DCStoreId = @dcStoreId
	  	
	  ----------
	  OPEN @MyCursor
	  FETCH NEXT FROM @MyCursor
	  INTO @BatchNo,@StockQty,@PMFGDate,@PexpDate
	  
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
	   UPDATE tblDCStore SET BatchNo = @batch,ExpDate = @expDate, MfgDate = @mfgdate,IsBatchUpdate = 1 WHERE DCStoreId = @dcStoreId

	  FETCH NEXT FROM @MyCursor
	  INTO @BatchNo,@StockQty,@PMFGDate,@PexpDate
	  
	  END
	  CLOSE @MyCursor
	  DEALLOCATE @MyCursor


END
