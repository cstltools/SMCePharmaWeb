
CREATE PROCEDURE [dbo].[sp_SAP_STODetails] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHMasterInId INT,
	@ReqMasterId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0


    DECLARE @WHStockInDetailID INT
	DECLARE @ProductCode NVARCHAR(MAX)
	DECLARE @ProductName NVARCHAR(MAX)
	DECLARE @PackSize NVARCHAR(MAX)
	DECLARE @Batch NVARCHAR(MAX)
	DECLARE @Qty INT
	DECLARE @ExpDate DATETIME
	DECLARE @MfgDate DATETIME
	DECLARE @ChallanNo NVARCHAR(MAX)
	DECLARE @ChallanDate DATETIME
	DECLARE @Price DECIMAL(18,2)
	DECLARE @VAT DECIMAL(18,2)
	DECLARE @ComUnitId INT
	DECLARE @ComUnitCode NVARCHAR(MAX)
	DECLARE @ComUnitName NVARCHAR(MAX)

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
		
	SELECT WHStockInDetailID,ProductCode,ProductName ,PackSize,Batch,Qty,ExpDate,MfgDate,ChallanNo,ChallanDate,Price,VAT,UT.ComUnitId,UT.ComUnitCode,UT.ComUnitName  FROM tblWHStockInDetail AS D
	LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
	LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
	LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) =  UPPER(RTRIM(LTRIM(SM.challan_code)))
	LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
	WHERE M.WHStockInMasterID =  @WHMasterInId

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ComUnitId,@ComUnitCode,@ComUnitName     
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SELECT @ReceiveIdMAX = (ISNULL(MAX(ReqChildId),0)+1) FROM tblRequsitionChild

	-- WHStockInDetailID is threaded through so sp_SAP_StockInTransfer can pair this
	-- ReqChildId back to the exact tblWHStockInDetail row it came from, instead of
	-- re-deriving the match via ProductCode+BatchNo (ambiguous when more than one
	-- detail row shares the same product+batch - see docs/ReceiveQty_Permanent_Fix_Plan.md
	-- Problem 3). This cursor already iterates tblWHStockInDetail one row at a time,
	-- so @WHStockInDetailID is already the correct 1:1 source for this new row.
	INSERT INTO [dbo].[tblRequsitionChild]
           (ReqChildId
           ,ProductCode
           ,ProductName
           ,PackSize
           ,ReqQty
           ,ReqId,BatchNO
           ,WHStockInDetailID)
     VALUES
           (@ReceiveIdMAX
           ,@ProductCode
           ,@ProductName
           ,@PackSize
           ,@Qty
           ,@ReqMasterId,@Batch
           ,@WHStockInDetailID)
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ComUnitId,@ComUnitCode,@ComUnitName   
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
	-- Return Req Id
	RETURN @ReceiveIdMAX


END