-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerPaymentPosting] 

	@InvoiceId INT,
	@CustPayId INT
	
AS
BEGIN
	
	DECLARE @CustomerMasterId INT
	DECLARE @CustPayMId INT
	DECLARE @InvDate DATETIME
	DECLARE @CompanyId INT
	DECLARE @BankId INT
	DECLARE @CashId INT
	DECLARE @PaymentAmount DECIMAL(18,2)
	DECLARE @Discount DECIMAL(18,2)
	DECLARE @AIT DECIMAL(18,2)
	DECLARE @InvoiceNo NVARCHAR(500)
	DECLARE @PaymentStatus NVARCHAR(500)
	DECLARE @VoucherType NVARCHAR(500)
	
	DECLARE @VoucherMasterId INT      
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT CPD.PaymentAmount,CPY.CustomerMasterId,CPD.CustPayDetailId,CPY.PaymentDate,UNT.CompanyId,ISNULL(CPD.Discount,0) AS Discount,ISNULL(CPD.AIT,0) AS AIT,
	InvoiceNo,PaymentStatus,CPD.BankAccId,CPD.CashAccId FROM dbo.tblCustPayDetail AS CPD 
	LEFT JOIN dbo.tblCustomerPay AS CPY ON CPD.CustPayId = CPY.CustPayId
	LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = CPD.InvoiceId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = tblInvoice.ComUnitId
	WHERE CPD.InvoiceId = @InvoiceId AND CPD.CustPayId = @CustPayId


		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @PaymentAmount,@CustomerMasterId,@CustPayId,@InvDate,@CompanyId,@Discount,@AIT,@InvoiceNo,@PaymentStatus,@BankId,@CashId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	-- Master Variable Info
    -------------------------------------

	DECLARE @VoucherCode NVARCHAR(MAX)

	
	DECLARE @yearText NVARCHAR(MAX)= SUBSTRING(CONVERT(NVARCHAR(MAX),YEAR(CURRENT_TIMESTAMP)), 3, 3)   
	DECLARE @monthText NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) END)
	DECLARE @dateText NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) END)
    SELECT @VoucherCode = 'CVR-' +  (@yearText+@monthText+@dateText)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(VoucherCode,11,6)),10000))+1)  FROM ZAS_ACCDB..tblDebitCreditVoucherMaster 
	WHERE CURRENT_TIMESTAMP = CURRENT_TIMESTAMP

	DECLARE @FinYearId NVARCHAR(MAX)

	SELECT @FinYearId = FinancialYearId FROM ZAS_ACCDB..tblFinancialYear 
	WHERE CompanyId = @CompanyId AND Status IN ('Active') AND @InvDate BETWEEN StartDate AND EndDate


	SET @VoucherType =  CASE 
		 
		 WHEN @BankId IS NOT NULL AND @BankId != 0 THEN 'CreditVoucherBank'
		 WHEN @CashId != 0 AND @CashId IS NOT NULL THEN 'CreditVoucherCash'
		
		END

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
	    CustPayDetailId,
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
	    'Customer Payment - ( Invoice No:' + @InvoiceNo + ' , Payment Date:' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Payment Amount:' + CONVERT(NVARCHAR(50), @PaymentAmount + @Discount) + ')',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @PaymentAmount + @Discount,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    @VoucherType,       -- VoucherType - nvarchar(50)
	    'Receiveable',       -- JournalType - nvarchar(50)
	    @CustPayId,      -- ProformaId -int
		0,0,0,0,0
	)


	-- Detail Information Posting

	SET @VoucherMasterId = SCOPE_IDENTITY()


	-- Fetch Bank Gl

	DECLARE	@DrGl1 INT 

	IF (@BankId IS NOT NULL AND @BankId != 0)
		
	BEGIN 

	 SELECT @DrGl1 = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE BankAccountId IS NOT NULL AND BankAccountId = @BankId

	END

	-- Fetch Cash Gl

	IF(@CashId IS NOT NULL AND @CashId != 0)
	BEGIN 

	 SELECT @DrGl1 = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE CashAccountId IS NOT NULL AND CashAccountId = @CashId

	END

	

	-- Debit 1 (Cash/Bank GL)

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
	    @PaymentAmount, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE	@DrGl INT 
	SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('CustomerPayment') AND BalanceType IN ('Dr2')

	-- Debit

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
	    @Discount, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)

	)

    IF (@AIT > 0)	
	BEGIN

		DECLARE	@AITGl INT 
	    SELECT @AITGl = AITGLId FROM tblCustMaster WHERE CustomerMasterId = @CustomerMasterId

		 IF (@AITGl > 0)	
		 BEGIN


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
			    @AITGl,    -- AccountId - int
			    'Debit',  -- DebitorCredit - nvarchar(50)
			    0.00, -- DebitAmount - decimal(18, 2)
			    0.00, -- CreditAmount - decimal(18, 2)
			    @AIT, -- DebitAmountBDT - decimal(18, 2)
			    0.00 -- CreditAmountBDT - decimal(18, 2)

			)
		 END
	END

	--- Credit

	DECLARE	@CrGl INT 
	SELECT @CrGl = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE CustomerId IS NOT NULL AND CustomerId = @CustomerMasterId
	
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
	    ISNULL(@CrGl,0),    -- AccountId - int
	    'Credit',  -- DebitorCredit - nvarchar(50)
	    0.00, -- DebitAmount - decimal(18, 2)
	    0.00, -- CreditAmount - decimal(18, 2)
	    0.00, -- DebitAmountBDT - decimal(18, 2)
	    @PaymentAmount + @Discount + @AIT -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE @Count INT = 0 

	SELECT @Count = COUNT(CustPayDetailId) FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE CustPayDetailId = @CustPayMId

	IF (@Count > 0)
		BEGIN
		   
		   UPDATE dbo.tblCustPayDetail SET IsPosting = 1 WHERE CustPayDetailId = @CustPayMId

		END
	ELSE
		BEGIN

		UPDATE tblCustPayDetail SET IsPosting = 0 WHERE CustPayDetailId = @CustPayMId

		END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @PaymentAmount,@CustomerMasterId,@CustPayId,@InvDate,@CompanyId,@Discount,@AIT,@InvoiceNo,@PaymentStatus,@BankId,@CashId
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END





--SELECT CPD.PaymentAmount,CPY.CustomerMasterId,CPD.InvoiceId,CPD.CustPayDetailId,CPY.PaymentDate,UNT.CompanyId,CPD.Discount,InvoiceNo,PaymentStatus,CPD.BankId FROM dbo.tblCustPayDetail AS CPD 
--	LEFT JOIN dbo.tblCustomerPay AS CPY ON CPD.CustPayId = CPY.CustPayId
--	LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = CPD.InvoiceId
--	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = tblInvoice.ComUnitId


