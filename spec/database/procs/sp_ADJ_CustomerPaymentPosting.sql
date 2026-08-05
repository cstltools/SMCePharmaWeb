-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_CustomerPaymentPosting] 

	@PayDetailID INT,
	@VoucherMasterId INT

AS
BEGIN
	
	DECLARE @CustomerMasterId INT
	DECLARE @CustPayId INT
	DECLARE @InvDate DATETIME
	DECLARE @CompanyId INT
	DECLARE @BankId INT
	DECLARE @CashId INT
	DECLARE @PaymentAmount DECIMAL(18,2)
	DECLARE @Discount DECIMAL(18,2)
	DECLARE @InvoiceNo NVARCHAR(500)
	DECLARE @PaymentStatus NVARCHAR(500)
	DECLARE @VoucherType NVARCHAR(500)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT CPD.PaymentAmount,CPY.CustomerMasterId,CPD.CustPayDetailId,CPY.PaymentDate,UNT.CompanyId,ISNULL(CPD.Discount,0) AS Discount,
	InvoiceNo,PaymentStatus,CPD.BankAccId,CPD.CashAccId FROM dbo.tblCustPayDetail AS CPD 
	LEFT JOIN dbo.tblCustomerPay AS CPY ON CPD.CustPayId = CPY.CustPayId
	LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = CPD.InvoiceId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = tblInvoice.ComUnitId
	WHERE  CPD.CustPayDetailId = @PayDetailID

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @PaymentAmount,@CustomerMasterId,@CustPayId,@InvDate,@CompanyId,@Discount,@InvoiceNo,@PaymentStatus,@BankId,@CashId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	


	-- Fetch Bank Gl

	DECLARE	@DrGl1 INT 

	IF (@BankId IS NOT NULL AND @BankId != 0)
		
	BEGIN 

	 SELECT @DrGl1 = AccountId FROM ZAS_ACCDB..tblChartOfAccounts WHERE BankAccountId IS NOT NULL AND BankAccountId = @BankId

	END

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
	    @PaymentAmount + @Discount -- CreditAmountBDT - decimal(18, 2)
	)

	
	FETCH NEXT FROM @MyCursor
	INTO @PaymentAmount,@CustomerMasterId,@CustPayId,@InvDate,@CompanyId,@Discount,@InvoiceNo,@PaymentStatus,@BankId,@CashId
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END





--SELECT CPD.PaymentAmount,CPY.CustomerMasterId,CPD.InvoiceId,CPD.CustPayDetailId,CPY.PaymentDate,UNT.CompanyId,CPD.Discount,InvoiceNo,PaymentStatus,CPD.BankId FROM dbo.tblCustPayDetail AS CPD 
--	LEFT JOIN dbo.tblCustomerPay AS CPY ON CPD.CustPayId = CPY.CustPayId
--	LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = CPD.InvoiceId
--	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = tblInvoice.ComUnitId


