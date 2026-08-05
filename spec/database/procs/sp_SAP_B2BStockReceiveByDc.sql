
create PROCEDURE [dbo].[sp_SAP_B2BStockReceiveByDc] --- exec sp_StockInMIGOtoCentralStore 1

	@MasterId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0

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
	DECLARE @ChalanDetailsId INT

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------


	SELECT PD.ProductCode,PD.ProductName,PD.PackSize,CD.BatchNo,Quantity,DC.ExpDate,DC.ReceiveDate,CI.ChalanNo,CI.ChalanDate, 
	C.ComUnitId,DC.MfgDate,CD.ChalanDetailsId
	FROM tblChalanDetail AS CD
	LEFT JOIN tblChalanInfo AS CI ON CD.ChalanId = CI.ChalanId
	LEFT JOIN tblDCStore AS DC ON CD.DCStoreId = DC.DCStoreId
	LEFT JOIN tblProduct AS PD ON CD.ProductCode = PD.ProductCode
	LEFT JOIN tblCompanyUnit AS C ON CI.ToComUnitCode = C.ComUnitCode
	WHERE CD.ChalanId = @MasterId

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
         ,@MfgDate,@ChalanDetailsId

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SELECT @ReceiveIdMAX = (ISNULL(MAX(DCStoreId),0)+1) FROM tblDCStore

	INSERT INTO [dbo].[tblDCStore]
           (DCStoreId
           ,StorageLocation
           ,ProductCode
           ,ProductName
           ,PackSize
           ,BatchNo
           ,TotalQuantity
           ,ExpDate
           ,ReceiveDate
           ,ChalanNo
           ,ChalanDate
           ,ComUnitId
           ,StockQty
           ,DamageQty
           ,StockRcvDate
           ,StockCondition
           ,MfgDate,ChalanDetailsId)
     VALUES
           (@ReceiveIdMAX
           ,''
           ,@ProductCode
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
           ,0
           ,GETDATE()
           ,'Available'
           ,@MfgDate,@ChalanDetailsId)
	
	 
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
         ,@MfgDate,@ChalanDetailsId  
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
	-- Return Req Id
	RETURN @ReceiveIdMAX


END