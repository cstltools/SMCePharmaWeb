-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SampleInvoicePosting] 

	@InvoiceId INT
	
AS
BEGIN
	
	DECLARE @ProformaInvId INT
	DECLARE @InvDate DATETIME
	DECLARE @CompanyId INT
	DECLARE @CostPrice NVARCHAR(500)
	DECLARE @InvoiceNo NVARCHAR(500)
	DECLARE @VoucherMasterId INT      
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	
	SELECT SI.OrderId,SI.SubmissionDate,UNT.CompanyId,SUM(((CTRS.UnitPrice*(SIT.Quantity*-1)) + (CTRS.VATPerUnit*(SIT.Quantity*-1)))) AS TotalPrice,
	SI.OrderCode FROM tblSampleIssue AS SI
	LEFT JOIN tblSampleIssueDetail AS SD ON SI.OrderId = SD.OrderId
	LEFT JOIN tblSampleIssueTranscation AS SIT ON SIT.IssueId = SI.OrderId AND IssueDetailId = SD.OrderDetailId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = SIT.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = SI.ComUnitId
	WHERE SI.OrderId = @InvoiceId
	GROUP BY SI.OrderId,SI.SubmissionDate,UNT.CompanyId,SI.OrderCode 
	
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@InvoiceNo
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	-- Master Variable Info
    -------------------------------------

	DECLARE @VoucherCode NVARCHAR(MAX)

	DECLARE @yearText NVARCHAR(MAX)= SUBSTRING(CONVERT(NVARCHAR(MAX),YEAR(CURRENT_TIMESTAMP)), 3, 3)   
	DECLARE @monthText NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),MONTH(CURRENT_TIMESTAMP)) END)
	DECLARE @dateText NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(CURRENT_TIMESTAMP))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) ELSE CONVERT(NVARCHAR(MAX),DAY(CURRENT_TIMESTAMP)) END)
    SELECT @VoucherCode = 'JVP-' +(@yearText+@monthText+@dateText)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(VoucherCode,11,6)),10000))+1)  FROM ZAS_ACCDB..tblDebitCreditVoucherMaster 
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
	    'Sample Invoice - ( Invoice No:' + @InvoiceNo + ' , Invoice Date:' + CONVERT(NVARCHAR(50), @InvDate, 101) + ', Stock Value:' + CONVERT(NVARCHAR(50), @CostPrice) + ')',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @CostPrice,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Adjustable',       -- JournalType - nvarchar(50)
	    @ProformaInvId,      -- ProformaId -int
		0,0,0,0,0
	)


	-- Detail Information Posting

	
	SET @VoucherMasterId = SCOPE_IDENTITY()

	DECLARE	@DrGl INT 
	SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('SampleInvoice') AND BalanceType IN ('Dr')

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
	    @CostPrice, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)

	)

	--- Credit

	DECLARE	@CrGl INT 
	SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('SampleInvoice') AND BalanceType IN ('Cr')
	
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
	    @CostPrice -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE @Count INT = 0 

	SELECT @Count = COUNT(ProformaId) FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE SampleInvoiceId = @ProformaInvId

	IF (@Count > 0)
		BEGIN
		   
		   UPDATE tblSampleIssue SET IsPosting = 1 WHERE OrderId = @ProformaInvId

		END
	ELSE
		BEGIN

		UPDATE tblSampleIssue SET IsPosting = 0 WHERE OrderId = @ProformaInvId

		END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @ProformaInvId,@InvDate,@CompanyId,@CostPrice,@InvoiceNo
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END




