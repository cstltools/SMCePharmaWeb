
CREATE PROCEDURE [dbo].[sp_SAP_StockInTransferUpdate] --- exec sp_StockInMIGOtoCentralStore 1

	@ReqMasterId INT

AS
BEGIN




	DECLARE @ProductCode NVARCHAR(MAX)
    DECLARE @ProductName NVARCHAR(MAX)
    DECLARE @PackSize NVARCHAR(MAX)
    DECLARE @BatchNo NVARCHAR(MAX)
    DECLARE @Quantity INT
    DECLARE @ExpDate DATETIME
    DECLARE @ReceiveDate DATETIME
    DECLARE @ChalanNo NVARCHAR(MAX)
    DECLARE @ChalanDate DATETIME
    DECLARE @ComUnitId INT
    DECLARE @ReqId INT
    DECLARE @ReqChildId INT
    DECLARE @StockInTransfarId INT
    DECLARE @MfgDate DATETIME

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------



	SELECT ST.ProductCode
           ,ST.ProductName
           ,ST.PackSize
           ,ST.BatchNo
           ,ST.Quantity
           ,ST.ExpDate
           ,CS.ReceiveDate
           ,ChalanNo
           ,ChalanDate
           ,ComUnitId
           ,ST.Quantity
           ,ST.ReqId
           ,ReqChildId
           ,StockInTransfarId
           ,ST.MfgDate,ST.BatchNo FROM tblStockInTransfar AS ST 
	LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
	LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
	WHERE ST.ReqId = @ReqMasterId
		
	

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProductCode
         ,@ProductName
         ,@PackSize
         ,@BatchNo
         ,@Quantity
         ,@ExpDate
         ,@ReceiveDate
         ,@ChalanNo
         ,@ChalanDate
         ,@ComUnitId
         ,@Quantity
         ,@ReqId
         ,@ReqChildId
         ,@StockInTransfarId
         ,@MfgDate,@BatchNo   

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		UPDATE dbo.tblStockInTransfar SET IsTransfared='OK' WHERE StockInTransfarId = @StockInTransfarId
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @ProductCode
         ,@ProductName
         ,@PackSize
         ,@BatchNo
         ,@Quantity
         ,@ExpDate
         ,@ReceiveDate
         ,@ChalanNo
         ,@ChalanDate
         ,@ComUnitId
         ,@Quantity
         ,@ReqId
         ,@ReqChildId
         ,@StockInTransfarId
         ,@MfgDate,@BatchNo    
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	


END