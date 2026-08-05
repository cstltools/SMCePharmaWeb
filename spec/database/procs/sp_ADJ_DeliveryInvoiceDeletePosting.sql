-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_DeliveryInvoiceDeletePosting] 

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


	SELECT INV.InvoiceId,UNT.CompanyId  ,INV.UpdateDate,SUM((((((INVD.UnitPrice*INVD.Quantity) - INVD.DelivarySpecialAmount))/INVD.Quantity)*INVD.DeliveryQuantity)) AS TotalPrice,
	SUM((INVD.DelivarySpecialAmount / INVD.Quantity) * INVD.DeliveryQuantity) AS Discount,INV.CustomerMasterId,INV.InvoiceNo FROM tblInvoice AS INV
	LEFT JOIN tblInvoiceDetail AS INVD ON INVD.InvoiceId = INV.InvoiceId
    INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE INV.InvoiceId = @InvoiceId
	GROUP BY INV.InvoiceId,UNT.CompanyId,INV.UpdateDate,CustomerMasterId,INV.InvoiceNo
	
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@CompanyId,@InvDate,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	



	

	IF(@Type = 'Sales')
	BEGIN
		DECLARE	@CrGl1 INT 
		SELECT @CrGl1 = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE CustomerId IS NOT NULL AND CustomerId = @CustomerMasterId

		-- Credit 1 (Customer GL)

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
		    @CrGl1,    -- AccountId - int
		    'Credit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    0.00, -- DebitAmountBDT - decimal(18, 2)
		    @CostPrice -- CreditAmountBDT - decimal(18, 2)
		)


		DECLARE	@CrGl INT 
		SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliverySalesReturn') AND BalanceType IN ('Cr2')

		-- Credit 2

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
		    @CrGl,    -- AccountId - int
		    'Credit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    0.00, -- DebitAmountBDT - decimal(18, 2)
		    @DiscontPrice -- CreditAmountBDT - decimal(18, 2)

		)

		--- Debit

		DECLARE	@DrGl INT 
		SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliverySalesReturn') AND BalanceType IN ('Dr')
		
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
		    'Debit',  -- DebitorCredit - nvarchar(50)
		    0.00, -- DebitAmount - decimal(18, 2)
		    0.00, -- CreditAmount - decimal(18, 2)
		    @CostPrice + @DiscontPrice, -- DebitAmountBDT - decimal(18, 2)
		    0.00  -- CreditAmountBDT - decimal(18, 2)
		)
	END


	IF(@Type = 'Inventory')
	BEGIN
		-- Inventory Valuation

		DECLARE	@StockValue DECIMAL(18,2)


		SELECT @StockValue = SUM(((CTRS1.UnitPrice*INVD1.DeliveryQuantity) + CTRS1.VATPerUnit)) FROM tblInvoice AS INV
		LEFT JOIN tblInvoiceDetail AS INVD1 ON INVD1.InvoiceId = INV.InvoiceId
		INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD1.DCStoreId
		INNER JOIN tblCentralStore AS CTRS1 ON DCS.TempReceiveId = CTRS1.ReceiveId
		INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
		WHERE INV.InvoiceId = @InvoiceId
		GROUP BY INV.InvoiceId,UNT.CompanyId,INV.InvoiceDate

		DECLARE	@DrGlInv1 INT 
		SELECT @DrGlInv1 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliverySalesReturnInventory') AND BalanceType IN ('Dr')

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
		SELECT @DrGlInv2 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliverySalesReturnInventory') AND BalanceType IN ('Cr')
		
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
    

	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@CompanyId,@InvDate,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END








