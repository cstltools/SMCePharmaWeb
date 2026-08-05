-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeliveryConfirmationFullPosting] 

	@InvoiceId INT
	
AS
BEGIN
	
	DECLARE @ProformaInvId INT
	DECLARE @InvDate DATETIME
	DECLARE @CompanyId INT
	DECLARE @CustomerMasterId INT
	DECLARE @CostPrice DECIMAL(18,2)
	DECLARE @DiscontPrice DECIMAL(18,2)
	DECLARE @InvoiceNo NVARCHAR(500)
	
	
	DECLARE @VoucherMasterId INT 
	DECLARE @VoucherMasterId2 INT       
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT INV.InvoiceId,INV.UpdateDate,UNT.CompanyId,SUM((((((INVD.UnitPrice*INVD.Quantity) - INVD.DelivarySpecialAmount))/INVD.Quantity)*INVD.DeliveryQuantity)) -INV.DeliveryTpDiscount AS TotalPrice,
	CASE WHEN INV.DeliveryTpDiscount != 0 THEN INV.DeliveryTpDiscount ELSE SUM((INVD.DelivarySpecialAmount / INVD.Quantity) * INVD.DeliveryQuantity) END AS Discount,INV.CustomerMasterId,INV.InvoiceNo FROM tblInvoice AS INV
	LEFT JOIN tblInvoiceDetail AS INVD ON INVD.InvoiceId = INV.InvoiceId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE INV.InvoiceId = @InvoiceId
	GROUP BY INV.InvoiceId,UNT.CompanyId,INV.UpdateDate,CustomerMasterId,INV.InvoiceNo,DeliveryTpDiscount
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	-- Master Variable Info
    -------------------------------------

	DECLARE @VoucherCode NVARCHAR(MAX)
	DECLARE @yearText NVARCHAR(MAX)= SUBSTRING(CONVERT(NVARCHAR(MAX),YEAR(CURRENT_TIMESTAMP)), 3, 3)   
	DECLARE @monthText NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) END)
	DECLARE @dateText NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) END)
    SELECT @VoucherCode = 'JVP-' + (@yearText+@monthText+@dateText)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(VoucherCode,11,6)),10000))+1)  FROM ZAS_ACCDB..tblDebitCreditVoucherMaster 
	WHERE CURRENT_TIMESTAMP = CURRENT_TIMESTAMP


	DECLARE @FinYearId NVARCHAR(MAX)

	SELECT @FinYearId = FinancialYearId FROM ZAS_ACCDB..tblFinancialYear 
	WHERE CompanyId = @CompanyId AND Status IN ('Active') AND @InvDate BETWEEN StartDate AND EndDate

	----------------------------------

	-- Master Information Posting

	INSERT	INTO ZAS_ACCDB..tblDebitCreditVoucherMaster
	(
	    VoucherCode,
	    CompanyInfoId,
	    FinancialYearId,
	    PostingDate,
	    VoucherCategoryID,
	    CurrencyId,
	    CurrencyCovRate,
	    Narration,
	    TotalAmount,
	    TotalAmountBDT,
	    EntryBy,
	    EntryDate,
	    VoucherType, 
	    JournalType,
	    ProformaId,
		IsCostCenter,
		IsInvoice,
		isManualVCRNo,
		IsExportInvoice,
		IsImportInvoice

	)
	VALUES
	(   
	    @VoucherCode,       -- VoucherCode - nvarchar(max)
	    @CompanyId,         -- CompanyInfoId - int
	    @FinYearId,         -- FinancialYearId - int
	    @InvDate, -- PostingDate - datetime
	    2,         -- VoucherCategoryID - int
	    1,         -- CurrencyId - int
	    1.00,      -- CurrencyCovRate - decimal(18, 2)
	    'Delivery Confirmation Full -( Invoice No:' + @InvoiceNo + ' , Invoice Date: ' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Sales Value: ' + CONVERT(NVARCHAR(50), @CostPrice + @DiscontPrice) + ' )',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @CostPrice + @DiscontPrice,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Receivable',       -- JournalType - nvarchar(50)
	    @ProformaInvId,      -- ProformaId -int
		0,0,0,0,0
	)


	-- Detail Information Posting

	SET @VoucherMasterId = SCOPE_IDENTITY()
	--SELECT @VoucherMasterId = VoucherMasterId FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE VoucherCode = @VoucherCode

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
	    @DrGl1,    -- AccountId - int
	    'Debit',  -- DebitorCredit - nvarchar(50)
	    0.00, -- DebitAmount - decimal(18, 2)
	    0.00, -- CreditAmount - decimal(18, 2)
	    @CostPrice, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE	@DrGl INT 
	SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfirmationFull') AND BalanceType IN ('Dr2')

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
	SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfirmationFull') AND BalanceType IN ('Cr')
	
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


    -- Inventory Valuation

	DECLARE @VoucherCode2 NVARCHAR(MAX)
	
	DECLARE @yearText1 NVARCHAR(MAX)= SUBSTRING(CONVERT(NVARCHAR(MAX),YEAR(CURRENT_TIMESTAMP)), 3, 3)   
	DECLARE @monthText1 NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) END)
	DECLARE @dateText1 NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) END)
    SELECT @VoucherCode2 = 'JVP-' + (@yearText1+@monthText1+@dateText1)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(VoucherCode,11,6)),10000))+1)  FROM ZAS_ACCDB..tblDebitCreditVoucherMaster 
	WHERE CURRENT_TIMESTAMP = CURRENT_TIMESTAMP


	DECLARE	@StockValue DECIMAL(18,2)

	SELECT SUM(((CTRS1.UnitPrice*INVD1.DeliveryQuantity) + CTRS1.VATPerUnit)) FROM tblInvoice AS INV
	LEFT JOIN tblInvoiceDetail AS INVD1 ON INVD1.InvoiceId = INV.InvoiceId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD1.DCStoreId
	INNER JOIN tblCentralStore AS CTRS1 ON DCS.TempReceiveId = CTRS1.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE INV.InvoiceId = 76880
	GROUP BY INV.InvoiceId,UNT.CompanyId,INV.InvoiceDate

	-- Master Information Posting

	INSERT	INTO ZAS_ACCDB..tblDebitCreditVoucherMaster
	(
	    VoucherCode,
	    CompanyInfoId,
	    FinancialYearId,
	    PostingDate,
	    VoucherCategoryID,
	    CurrencyId,
	    CurrencyCovRate,
	    Narration,
	    TotalAmount,
	    TotalAmountBDT,
	    EntryBy,
	    EntryDate,
	    VoucherType, 
	    JournalType,
	    ProformaId,
		IsCostCenter,
		IsInvoice,
		isManualVCRNo,
		IsExportInvoice,
		IsImportInvoice

	)
	VALUES
	(   
	    @VoucherCode2,       -- VoucherCode - nvarchar(max)
	    @CompanyId,         -- CompanyInfoId - int
	    @FinYearId,         -- FinancialYearId - int
	    @InvDate, -- PostingDate - datetime
	    2,         -- VoucherCategoryID - int
	    1,         -- CurrencyId - int
	    1.00,      -- CurrencyCovRate - decimal(18, 2)
	    'Delivery Confirmation Full, Inventory Valuation - ( Invoice No:' + @InvoiceNo + ' , Invoice Date: ' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Stock Value: ' + CONVERT(NVARCHAR(50), @StockValue) + ' )',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @StockValue,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Adjustable',       -- JournalType - nvarchar(50)
	    @ProformaInvId,      -- ProformaId -int
		0,0,0,0,0
	)


	SET @VoucherMasterId2 = SCOPE_IDENTITY()

	DECLARE	@DrGlInv1 INT 
	SELECT @DrGlInv1 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfFullInventory') AND BalanceType IN ('Dr')

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
	(   @VoucherMasterId2,    -- VoucherMasterId - int
	    @DrGlInv1,    -- AccountId - int
	    'Debit',  -- DebitorCredit - nvarchar(50)
	    0.00, -- DebitAmount - decimal(18, 2)
	    0.00, -- CreditAmount - decimal(18, 2)
	    @StockValue, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)

	)

	--- Credit

	DECLARE	@DrGlInv2 INT 
	SELECT @DrGlInv2 = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('DeliveryConfFullInventory') AND BalanceType IN ('Cr')
	
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
	    @VoucherMasterId2,    -- VoucherMasterId - int
	    @DrGlInv2,    -- AccountId - int
	    'Credit',  -- DebitorCredit - nvarchar(50)
	    0.00, -- DebitAmount - decimal(18, 2)
	    0.00, -- CreditAmount - decimal(18, 2)
	    0.00, -- DebitAmountBDT - decimal(18, 2)
	    @StockValue  -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE @Count INT = 0 

	SELECT @Count = COUNT(ProformaId) FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE ProformaId = @ProformaInvId

	IF (@Count > 0)
		BEGIN
		   
		   UPDATE tblInvoice SET IsPosting = 1 WHERE InvoiceId = @ProformaInvId

		END
	ELSE
		BEGIN

		UPDATE tblInvoice SET IsPosting = 0 WHERE InvoiceId = @ProformaInvId

		END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END







