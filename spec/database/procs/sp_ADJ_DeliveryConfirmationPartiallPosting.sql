-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_DeliveryConfirmationPartiallPosting] 

	@InvoiceId INT,
	@VoucherMasterId INT,
	@Type NVARCHAR(MAX)
	
AS
BEGIN
	
	DECLARE @ProformaInvId INT
	DECLARE @InvDate DATETIME
	DECLARE @CompanyId INT
	DECLARE @CustomerMasterId INT
	DECLARE @CostPrice DECIMAL(18,2)
	DECLARE @DiscontPrice DECIMAL(18,2)
	DECLARE @InvoiceNo NVARCHAR(500)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT INV.InvoiceId,INV.UpdateDate,UNT.CompanyId,SUM((((((INVD.UnitPrice*INVD.Quantity) - INVD.DelivarySpecialAmount))/INVD.Quantity)*INVD.DeliveryQuantity)) AS TotalPrice,
	SUM((INVD.DelivarySpecialAmount / INVD.Quantity) * INVD.DeliveryQuantity) AS Discount,INV.CustomerMasterId,INV.InvoiceNo FROM tblInvoice AS INV
	LEFT JOIN tblInvoiceDetail AS INVD ON INVD.InvoiceId = INV.InvoiceId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE INV.InvoiceId = @InvoiceId
	GROUP BY INV.InvoiceId,UNT.CompanyId,INV.UpdateDate,CustomerMasterId,INV.InvoiceNo
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	IF(@Type = 'Sales')
	BEGIN
		DECLARE	@DrGl1 INT 
		SELECT @DrGl1 = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE CustomerId IS NOT NULL AND CustomerId = @CustomerMasterId

		-- Debit 1 (Customer GL)

		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   @VoucherMasterId,    -- VoucherMasterId - int
		    ISNULL(@DrGl1,0),    -- AccountId - int
		    'Debit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    @CostPrice, -- DebitAmountBDT - decimal(18, 2)
		    0.00 -- CreditAmountBDT - decimal(18, 2)
		)


		DECLARE	@DrGl INT 
		SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfirmationPartial') AND BalanceType IN ('Dr2')

		-- Debit 2

		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   @VoucherMasterId,    -- VoucherMasterId - int
		    @DrGl,    -- AccountId - int
		    'Debit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    @DiscontPrice, -- DebitAmountBDT - decimal(18, 2)
		    0.00 -- CreditAmountBDT - decimal(18, 2)

		)

		--- Credit

		DECLARE	@CrGl INT 
		SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfirmationPartial') AND BalanceType IN ('Cr')
		
		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   
		    @VoucherMasterId,    -- VoucherMasterId - int
		    @CrGl,    -- AccountId - int
		    'Credit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    0.00, -- DebitAmountBDT - decimal(18, 2)
		    @CostPrice + @DiscontPrice  -- CreditAmountBDT - decimal(18, 2)
		)
	END


	-- Inventory Valuation

	IF(@Type = 'Inventory')
	BEGIN
		DECLARE	@StockValue DECIMAL(18,2)

		SELECT @StockValue = SUM(((CTRS1.UnitPrice*INVD1.DeliveryQuantity) + CTRS1.VATPerUnit)) FROM tblInvoice AS INV
		LEFT JOIN tblInvoiceDetail AS INVD1 ON INVD1.InvoiceId = INV.InvoiceId
		INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD1.DCStoreId
		INNER JOIN tblCentralStore AS CTRS1 ON DCS.TempReceiveId = CTRS1.ReceiveId
		INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
		WHERE INV.InvoiceId = @InvoiceId
		GROUP BY INV.InvoiceId,UNT.CompanyId,INV.InvoiceDate

		

		DECLARE	@DrGlInv1 INT 
		SELECT @DrGlInv1 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfPartialnventory') AND BalanceType IN ('Dr')

		-- Debit 2

		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   @VoucherMasterId,    -- VoucherMasterId - int
		    @DrGlInv1,    -- AccountId - int
		    'Debit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    @StockValue, -- DebitAmountBDT - decimal(18, 2)
		    0.00 -- CreditAmountBDT - decimal(18, 2)

		)

		--- Credit

		DECLARE	@DrGlInv2 INT 
		SELECT @DrGlInv2 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfPartialnventory') AND BalanceType IN ('Cr')
		
		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   
		    @VoucherMasterId,    -- VoucherMasterId - int
		    @DrGlInv2,    -- AccountId - int
		    'Credit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    0.00, -- DebitAmountBDT - decimal(18, 2)
		    @StockValue  -- CreditAmountBDT - decimal(18, 2)
		)
	END


	-- Freeze Stock 
	IF(@Type = 'Freeze')
    
	BEGIN
		DECLARE	@ReturnStockValue DECIMAL(18,2)

		SELECT @ReturnStockValue = SUM(CTRS1.UnitPrice*(INVD2.Quantity-INVD2.DeliveryQuantity)) FROM tblInvoice AS INV2
		LEFT JOIN tblInvoiceDetail AS INVD2 ON INVD2.InvoiceId = INV2.InvoiceId
		INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD2.DCStoreId
		INNER JOIN tblStockInTransfar AS TNS ON TNS.StockInTransfarId = DCS.StockInTransfarId
		INNER JOIN tblCentralStore AS CTRS1 ON TNS.ReceiveId = CTRS1.ReceiveId
		INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV2.ComUnitId
		WHERE INV2.InvoiceId = @InvoiceId
		GROUP BY INV2.InvoiceId,UNT.CompanyId,INV2.InvoiceDate

		DECLARE	@DrGlInv3 INT 
		SELECT @DrGlInv3 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfPartialFreeze') AND BalanceType IN ('Dr')

		-- Debit 3

		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   @VoucherMasterId,    -- VoucherMasterId - int
		    @DrGlInv3,    -- AccountId - int
		    'Debit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    @ReturnStockValue, -- DebitAmountBDT - decimal(18, 2)
		    0.00 -- CreditAmountBDT - decimal(18, 2)

		)

		--- Credit

		DECLARE	@DrGlInv4 INT 
		SELECT @DrGlInv4 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfPartialFreeze') AND BalanceType IN ('Cr')
		
		INSERT INTO ZAS_ACCDB..tblDebitCreditVoucherDetail
		(
		    VoucherMasterId,
		    AccountId,
		    DebitorCredit,
		    DebitAmount,
		    CreditAmount,
		    DebitAmountBDT,
		    CreditAmountBDT
		)
		VALUES
		(   
		    @VoucherMasterId,    -- VoucherMasterId - int
		    @DrGlInv4,    -- AccountId - int
		    'Credit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    0.00, -- DebitAmountBDT - decimal(18, 2)
		    @ReturnStockValue  -- CreditAmountBDT - decimal(18, 2)
		)
	END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END







