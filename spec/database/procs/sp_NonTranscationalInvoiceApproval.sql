-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_NonTranscationalInvoiceApproval] 
	(
		 @InvReturnMasterID INT,	
         @ActionStatus NVARCHAR(50) = NULL,
         @ApprovedBy NVARCHAR(50) = NULL,
         @ApprovedDate DATETIME=NULL
		
	
	)
AS
BEGIN
	  
		DECLARE @ProductId int 
	    DECLARE @ProductCode NVARCHAR(50)
	    DECLARE @ProductName NVARCHAR(MAX)
	    DECLARE @PackSize NVARCHAR(50)
	    DECLARE @BatchNo NVARCHAR(50)
	    DECLARE @MfgDate DATETIME
	    DECLARE @ExpDate DATETIME
	    DECLARE @ReceiveDate DATETIME = @ApprovedDate
	    DECLARE @ChalanNo NVARCHAR(50)
	    DECLARE @ChalanDate DATETIME
	    DECLARE @StockInQty DECIMAL(18,2)
	    DECLARE @UnitPrice DECIMAL(18,2)
	    DECLARE @TotalPrice DECIMAL(18,2)
	    DECLARE @VATPerUnit DECIMAL(18,2)
	    DECLARE @TotalVAT DECIMAL(18,2)
	    DECLARE @TotalAmount DECIMAL(18,2)
	    DECLARE @StockCondition NVARCHAR(50) = 'Available'
	    DECLARE @MigoDetailID INT
	    DECLARE @ProductStockType NVARCHAR(50) = 'Regular'
	    DECLARE @WarehouseId INT
		DECLARE @Remarks NVARCHAR(MAX) = 'Non-transcational Invoice Return'
		DECLARE @TotalValue DECIMAL(18,2)

		--Credit Adjustment Entry

		DECLARE @CompanyId INT
	    DECLARE @CustomerMasterId INT
	    DECLARE @InvoiceId INT
	    DECLARE @Amount DECIMAL(18,2)
	    DECLARE @ReturnDate DATETIME
		DECLARE @NTRemarks NVARCHAR(MAX) = 'Non-transcational Invoice Return'

		--Due Invoice value Adjustment
	    DECLARE @DueAmount DECIMAL(18,2)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT INVD.ProductId,PD.ProductCode,PD.ProductName,INVD.Batch,INVD.ExpDate,INVD.MfgDate,
	INVM.ReturnCode,INVM.ReturnDate,INVD.Qty,INVD.Price,INVD.VAT,INVD.InvReturnDetailID,WH.WearhouseId,PD.PackSize,INVM.TotalValue
	FROM dbo.tblNonTranscationalInvoiceDetail AS INVD 
	INNER JOIN dbo.tblNonTranscationalInvoiceMaster AS INVM ON INVM.InvReturnMasterID = INVD.InvReturnMasterID
	INNER JOIN dbo.tblCompanyUnit AS UNT ON UNT.ComUnitId = INVM.ComUnitId
	INNER JOIN dbo.tblWearhouse AS WH ON WH.CompanyId = UNT.CompanyId
	INNER JOIN dbo.tblProduct AS PD ON PD.ProductId = INVD.ProductId
	INNER JOIN dbo.tblPackSize AS PKS ON PKS.PackSizeId = PD.PackSizeId
	WHERE INVD.InvReturnMasterID = @InvReturnMasterID


	--MASTER update
	UPDATE dbo.tblNonTranscationalInvoiceMaster 
	SET ActionStatus = 'Accepted', ApprovedBy = @ApprovedBy, @ApprovedDate = @ApprovedDate
	WHERE InvReturnMasterID = @InvReturnMasterID

	--Credit Adjustment Entry

	SELECT @CompanyId = CompanyId FROM tblNonTranscationalInvoiceMaster 
	INNER JOIN dbo.tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblNonTranscationalInvoiceMaster.ComUnitId WHERE InvReturnMasterID = @InvReturnMasterID
	SELECT @CustomerMasterId = CustomerMasterId FROM tblNonTranscationalInvoiceMaster WHERE InvReturnMasterID = @InvReturnMasterID
	SELECT @InvoiceId = InvoiceId FROM tblNonTranscationalInvoiceMaster WHERE InvReturnMasterID = @InvReturnMasterID
	SELECT @Amount = ISNULL(TotalValue,0) FROM tblNonTranscationalInvoiceMaster WHERE InvReturnMasterID = @InvReturnMasterID
	SELECT @ReturnDate = ReturnDate FROM tblNonTranscationalInvoiceMaster WHERE InvReturnMasterID = @InvReturnMasterID

	-- Plus amount
	INSERT	INTO dbo.tblCreditAdjustment
	(
	    CompanyId,
	    CustomerMasterId,
	    InvoiceId,
	    Amount,
	    ReturnDate,
		NTInvoiceId,
		Remarks,
	    EntryBy,
	    EntryDate
	)
	VALUES
	(   @CompanyId,         -- CompanyId - int
	    @CustomerMasterId,         -- CustomerMasterId - int
	    @InvoiceId,         -- InvoiceId - int
	    @Amount,      -- Amount - decimal(18, 2)
	    @ReturnDate, -- ReturnDate - datetime
		@InvReturnMasterID,
		@NTRemarks,
	    @ApprovedBy,       -- EntryBy - nvarchar(50)
	    @ApprovedDate  -- EntryDate - datetime
	)

	-- Minus amount
	INSERT	INTO dbo.tblCreditAdjustment
	(
	    CompanyId,
	    CustomerMasterId,
	    InvoiceId,
	    Amount,
	    ReturnDate,
		NTInvoiceId,
		Remarks,
	    EntryBy,
	    EntryDate
	)
	VALUES
	(   @CompanyId,         -- CompanyId - int
	    @CustomerMasterId,         -- CustomerMasterId - int
	    @InvoiceId,         -- InvoiceId - int
	    @Amount*-1,      -- Amount - decimal(18, 2)
	    @ReturnDate, -- ReturnDate - datetime
		@InvReturnMasterID,
		@NTRemarks,
	    @ApprovedBy,       -- EntryBy - nvarchar(50)
	    @ApprovedDate  -- EntryDate - datetime
	)

	--- Adjust due invoice value
	SELECT  @DueAmount = DeliveryTpGrandTotal FROM dbo.tblInvoice WHERE InvoiceId = @InvoiceId
	UPDATE dbo.tblInvoice 
	SET DeliveryTpGrandTotal = CASE WHEN @DueAmount <= @Amount THEN 0 ELSE @DueAmount - @Amount END ,
	TpTotal = CASE WHEN @DueAmount <= @Amount THEN 0 ELSE @DueAmount - @Amount END, 
	TpGrandTotal = CASE WHEN @DueAmount <= @Amount THEN 0 ELSE @DueAmount - @Amount END,
	DeliveryTpTotal = CASE WHEN @DueAmount <= @Amount THEN 0 ELSE @DueAmount - @Amount END  
	WHERE InvoiceId = @InvoiceId
	
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProductId,@ProductCode,@ProductName,@BatchNo,@ExpDate,@MfgDate,@ChalanNo,@ChalanDate,@StockInQty,@UnitPrice,@VATPerUnit,@MigoDetailID,@WarehouseId,@PackSize,@TotalValue
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	
	INSERT INTO dbo.tblCentralStore
	(	    
	    ProductId,
	    ProductCode,
	    ProductName,
	    PackSize,
	    BatchNo,
	    Quantity,
	    MfgDate,
	    ExpDate,
	    ReceiveDate,
	    ChalanNo,
	    ChalanDate,
	    StockInQty,
	    UnitPrice,
	    TotalPrice,
	    VATPerUnit,
	    TotalVAT,
	    TotalAmount,
	    StockCondition,
	    MigoDetailID,
		ProductStockType,
	    WarehouseId,
		Remarks
	)
	VALUES
	(  
	    @ProductId,         -- ProductId - int
	    @ProductCode,       -- ProductCode - nvarchar(50)
	    @ProductName,       -- ProductName - nvarchar(max)
	    @PackSize,       -- PackSize - nvarchar(50)
	    @BatchNo,       -- BatchNo - nvarchar(max)
	    @StockInQty,      -- Quantity - decimal(18, 0)
	    @MfgDate, -- MfgDate - datetime
	    @ExpDate, -- ExpDate - datetime
	    @ReceiveDate, -- ReceiveDate - datetime
	    @ChalanNo,       -- ChalanNo - nvarchar(max)
	    @ChalanDate, -- ChalanDate - datetime
	    @StockInQty,      -- StockInQty - decimal(18, 0)
	    @UnitPrice,      -- UnitPrice - decimal(18, 2)
	    (@UnitPrice*@StockInQty),      -- TotalPrice - decimal(18, 2)
	    @VATPerUnit,      -- VATPerUnit - decimal(18, 2)
	    (@VATPerUnit * @StockInQty),      -- TotalVAT - decimal(18, 2)
	    (@UnitPrice*@StockInQty) + (@VATPerUnit * @StockInQty) ,      -- TotalAmount - decimal(18, 2)
	    @StockCondition,       -- StockCondition - nvarchar(50)
	    @MigoDetailID,         -- MigoDetailID - int
	    @ProductStockType,       -- ProductStockType - nvarchar(50)
	    @WarehouseId,         -- WarehouseId - int
		@Remarks
	)
	
	
	
	FETCH NEXT FROM @MyCursor
	INTO @ProductId,@ProductCode,@ProductName,@BatchNo,@ExpDate,@MfgDate,@ChalanNo,@ChalanDate,@StockInQty,@UnitPrice,@VATPerUnit,@MigoDetailID,@WarehouseId,@PackSize,@TotalValue
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor    

END


