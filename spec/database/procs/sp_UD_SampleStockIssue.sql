-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_SampleStockIssue] 
	(
		 @MasterId int,
		 @OrderDetailsId int,
		 @DcId int,
		 @Quantity DECIMAL(18,2),
		 @ProductCode NVARCHAR(MAX)
	)
AS
BEGIN
	  
	DECLARE @ComUnitId INT=@DcId
	DECLARE @CustomerMasterId INT
	DECLARE @TempQty DECIMAL(18,2)

	--FOR Stock
	DECLARE @DcStoreId INT
	DECLARE @StockQuantity DECIMAL(18,2)

	SET @TempQty = @Quantity
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT DCStoreId,StockQty FROM dbo.tblDCStore WHERE StockQty > 0 AND ComUnitId = @ComUnitId AND ProductCode = @ProductCode

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@StockQuantity
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SET @CustomerMasterId = NULL
	SET @ComUnitId = NULL
	
	SELECT @CustomerMasterId = CustomerMasterId FROM tblSampleIssue WHERE OrderId = @MasterId
	SELECT @ComUnitId = ComUnitId FROM tblSampleIssue WHERE OrderId = @MasterId


	IF (@TempQty > 0 )
	BEGIN

		IF(@StockQuantity >= @TempQty)
		BEGIN

			-- Minus Stock 
			UPDATE dbo.tblDCStore SET StockQty = (@StockQuantity - @TempQty)
			WHERE DCStoreId = @DcStoreId

			-- Insert into tblStockTrannsctionForSample (-)
			INSERT INTO [dbo].[tblSampleIssueTranscation] ([ComUnitId],[CustomerMasterId],[IssueId],[IssueDetailId],[DCStoreId],[Quantity]) 
			VALUES(@ComUnitId,@CustomerMasterId,@MasterId,@OrderDetailsId,@DcStoreId,@TempQty*-1)

			SET @TempQty = 0

		END

		ELSE -- Else block 

		BEGIN

			-- Minus Stock 
			UPDATE tblDCStore SET StockQty = 0
			WHERE DCStoreId = @DcStoreId

			-- Insert into tblStockTrannsctionForSample (-)
			INSERT INTO [dbo].[tblSampleIssueTranscation] ([ComUnitId],[CustomerMasterId],[IssueId],[IssueDetailId],[DCStoreId],[Quantity]) 
			VALUES(@ComUnitId,@CustomerMasterId,@MasterId,@OrderDetailsId,@DcStoreId,@StockQuantity*-1)

			SET @TempQty = @TempQty - @StockQuantity

		END

	END

	
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@StockQuantity
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor    

END






