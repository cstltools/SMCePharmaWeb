
create PROCEDURE [dbo].[sp_SAP_WHStockInApprove] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHMasterInId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0


    DECLARE @WHStockInDetailID INT
	DECLARE @ProductId INT
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

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
		
	SELECT WHStockInDetailID,ProductCode,ProductName ,PackSize,Batch,Qty,ExpDate,MfgDate,ChallanNo,ChallanDate,Price,VAT,PD.ProductId  FROM tblWHStockInDetail AS D
	LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
	LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
	WHERE WHStockInDetailID NOT IN (SELECT DISTINCT MigoDetailID FROM tblCentralStore WHERE MigoDetailID IS NOT NULL) AND M.WHStockInMasterID = @WHMasterInId

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ProductId      
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SELECT @ReceiveIdMAX=(ISNULL(MAX(ReceiveId),0)+1) FROM tblCentralStore
	
	INSERT INTO dbo.tblCentralStore
	        ( ProductId,
	          StorageLocation ,
	          ProductCode ,
	          ProductName ,
	          PackSize ,
	          BatchNo ,
	          Quantity ,
	          ExpDate ,
	          MfgDate,
	          ReceiveDate ,
	          ChalanNo ,
	          ChalanDate ,
	          StockInQty ,
	          UnitPrice ,
	          VATPerUnit,
	          TotalPrice,
	          TotalVAT,
	          TotalAmount ,
	          StockCondition,
	          MigoDetailID,
			  ProductStockType,
			  Remarks
	        )
	VALUES  (@ProductId,
	          NULL , -- StorageLocation - nvarchar(max)
	          @ProductCode , -- ProductCode - nvarchar(50)
	          @ProductName , -- ProductName - nvarchar(max)
	          @PackSize,
	          @Batch , -- BatchNo - nvarchar(max)
	          0 , -- Quantity - decimal
	          @ExpDate , -- ExpDate - datetime
	          @MfgDate,
	          GETDATE() , -- ReceiveDate - datetime
	          @ChallanNo, -- ChalanNo - nvarchar(max)
	          @ChallanDate , -- ChalanDate - datetime
	          @Qty , -- StockInQty - decimal
	          @Price , -- UnitPrice - decimal
	          @VAT, -- VATPerUnit - decimal
	          (@Price*@Qty),--TotalPrice
	          (@VAT*@Qty),--TotalVAT
	          (@Price*@Qty) + (@VAT*@Qty) , -- TotalAmount - decimal
	          N'Available',  -- StockCondition - nvarchar(50)
	          @WHStockInDetailID,
			  'Regular',
			  'From SAP'
	        )
	
	SET @ReceiveIdMAX = SCOPE_IDENTITY()
	 
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ProductId  
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	

	-- Update Master

	IF (@ReceiveIdMAX > 0)
	BEGIN 

		UPDATE tblWHStockInMaster SET ApproveBy = 'Auto Approve' , ApproveDate = GETDATE(), Status = 'Approved' WHERE WHStockInMasterID = @WHMasterInId

	END

	RETURN @ReceiveIdMAX

END