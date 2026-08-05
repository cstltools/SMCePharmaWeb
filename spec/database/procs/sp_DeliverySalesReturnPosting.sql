-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeliverySalesReturnPosting] 

	@ReturnId INT
	
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
	DECLARE @VoucherMasterId1 INT        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT INV.InvoiceId,UNT.CompanyId,RTNM.ApprovedDate,SUM((((((INVD.UnitPrice*INVD.Quantity) - INVD.DelivarySpecialAmount))/INVD.Quantity)*RTND.ReturnQty)) AS TotalPrice,
	SUM((INVD.DelivarySpecialAmount / INVD.Quantity) * RTND.ReturnQty) AS Discount,INV.CustomerMasterId,INV.InvoiceNo FROM tblCustomerReturnMaster AS RTNM 
	LEFT JOIN dbo.tblCustomerReturnDetail AS RTND ON RTND.CustReturnId = RTNM.CustReturnId
	LEFT JOIN tblInvoiceDetail AS INVD ON INVD.InvoiceDetailId = RTND.InvoiceDetailId
	LEFT JOIN dbo.tblInvoice AS INV ON INVD.InvoiceId = INV.InvoiceId
	LEFT JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	LEFT JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE RTNM.CustReturnId = @ReturnId
	GROUP BY INV.InvoiceId,UNT.CompanyId,RTNM.ApprovedDate,INV.CustomerMasterId,INV.InvoiceNo

		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@CompanyId,@InvDate,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
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
	    SalesReturnId,
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
	    'Delivery Sales Return -( Invoice No:' + @InvoiceNo + ' , Return Date: ' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Return Value: ' + CONVERT(NVARCHAR(50), @CostPrice + @DiscontPrice) + ' )',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @CostPrice + @DiscontPrice,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Receivable',       -- JournalType - nvarchar(50)
	    @ReturnId,      -- ProformaId -int
		0,0,0,0,0
	)


	-- Detail Information Posting

	SET @VoucherMasterId = SCOPE_IDENTITY()

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


    -- Inventory Valuation

	DECLARE @VoucherCode2 NVARCHAR(MAX)
	
	DECLARE @yearText2 NVARCHAR(MAX)= SUBSTRING(CONVERT(NVARCHAR(MAX),YEAR(CURRENT_TIMESTAMP)), 3, 3)   
	DECLARE @monthText2 NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) END)
	DECLARE @dateText2 NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) END)
    SELECT @VoucherCode2 = 'JVP-' +  (@yearText2+@monthText2+@dateText2)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(VoucherCode,11,6)),10000))+1)  FROM ZAS_ACCDB..tblDebitCreditVoucherMaster 
	WHERE CURRENT_TIMESTAMP = CURRENT_TIMESTAMP


	DECLARE	@StockValue DECIMAL(18,2)


	SELECT @StockValue = SUM(((CTRS1.UnitPrice*RTND.ReturnQty) + (CTRS1.VATPerUnit*RTND.ReturnQty))) FROM tblCustomerReturnMaster AS RTNM 
	LEFT JOIN dbo.tblCustomerReturnDetail AS RTND ON RTND.CustReturnId = RTNM.CustReturnId
	LEFT JOIN tblInvoiceDetail AS INVD ON INVD.InvoiceDetailId = RTND.InvoiceDetailId
	LEFT JOIN dbo.tblInvoice AS INV ON INVD.InvoiceId = INV.InvoiceId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = INVD.DCStoreId
	INNER JOIN tblCentralStore AS CTRS1 ON DCS.TempReceiveId = CTRS1.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = INV.ComUnitId
	WHERE RTNM.CustReturnId = @ReturnId
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
	    SalesReturnId,
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
	    'Delivery Sales Return, Inventory Valuation - ( Invoice No:' + @InvoiceNo + ' , Retu Date: ' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Stock Value: ' + CONVERT(NVARCHAR(50), @StockValue) + ' )',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @StockValue,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Adjustable',       -- JournalType - nvarchar(50)
	    @ReturnId,      -- ProformaId -int
		0,0,0,0,0
	)


	SET @VoucherMasterId1 = SCOPE_IDENTITY()

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
	(   @VoucherMasterId1,    -- VoucherMasterId - int
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
	    @VoucherMasterId1,    -- VoucherMasterId - int
	    @DrGlInv2,    -- AccountId - int
	    'Credit',  -- DebitorCredit - nvarchar(50)
	    0.00, -- DebitAmount - decimal(18, 2)
	    0.00, -- CreditAmount - decimal(18, 2)
	    0.00, -- DebitAmountBDT - decimal(18, 2)
	    @StockValue  -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE @Count INT = 0 

	SELECT @Count = COUNT(SalesReturnId) FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE SalesReturnId = @ReturnId

	IF (@Count > 0)

		BEGIN
		   
		   UPDATE dbo.tblCustomerReturnMaster SET IsPosting = 1 WHERE CustReturnId = @ReturnId

		END

	ELSE

		BEGIN

		UPDATE tblCustomerReturnMaster SET IsPosting = 0 WHERE CustReturnId = @ReturnId

		END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@CompanyId,@InvDate,@CostPrice,@DiscontPrice,@CustomerMasterId,@InvoiceNo
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END







