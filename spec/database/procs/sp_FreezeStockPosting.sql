-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_FreezeStockPosting] 

	@DcStockConditionId INT,
	@Quantity DECIMAL(18,2)
	
AS
BEGIN
	
	DECLARE @DCFreezeId INT
	DECLARE @InvDate DATETIME 
	DECLARE @CompanyId INT
	DECLARE @CostPrice NVARCHAR(500)

   DECLARE @VoucherMasterId INT
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------


	SELECT DFZS.DCStoreFreezeId,UNT.CompanyId,CTRS.UnitPrice,STCF.EntryDate FROM dbo.tblStockConditionFreeze AS STCF
	INNER JOIN dbo.tblDCStoreFreeze AS DFZS ON DFZS.StockConditionFreezeID = STCF.StockConditionFreezeID
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = DFZS.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = DFZS.ComUnitId
	WHERE STCF.StockConditionFreezeID = @DcStockConditionId 



	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DCFreezeId,@CompanyId,@CostPrice,@InvDate
	
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
	WHERE CompanyId = @CompanyId AND Status IN ('Active') AND CONVERT(varchar, GETDATE(), 5) BETWEEN StartDate AND EndDate

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
	    DcFreezeId,
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
	    ISNULL(@FinYearId,0),         -- FinancialYearId - int
	    @InvDate, -- PostingDate - datetime
	    2,         -- VoucherCategoryID - int
	    1,         -- CurrencyId - int
	    1.00,      -- CurrencyCovRate - decimal(18, 2)
	    'Freeze Stock  - ( Freeze Date: ' + CONVERT(NVARCHAR(50), GETDATE(), 101) + ', Stock Value: ' + CONVERT(NVARCHAR(50), @CostPrice*@Quantity) + ' )',       -- Narration - nvarchar(max)
	    0.00,      -- TotalAmount - decimal(18, 2)
	    @CostPrice*@Quantity,      -- TotalAmountBDT - decimal(18, 2)
	    'Auto Process',       -- EntryBy - nvarchar(max)
	    CURRENT_TIMESTAMP, -- EntryDate - datetime	  
	    'Journal',       -- VoucherType - nvarchar(50)
	    'Receivable',       -- JournalType - nvarchar(50)
	    @DCFreezeId,      -- ProformaId -int
		0,0,0,0,0
	)


	-- Detail Information Posting

	SET @VoucherMasterId = SCOPE_IDENTITY()

	DECLARE	@DrGl INT 
	SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('FreezeStock') AND BalanceType IN ('Dr')

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
	    @CostPrice*@Quantity, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)

	)

	--- Credit

	DECLARE	@CrGl INT 
	SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('FreezeStock') AND BalanceType IN ('Cr')
	
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
	    @CostPrice*@Quantity -- CreditAmountBDT - decimal(18, 2)
	)


	DECLARE @Count INT = 0 

	SELECT @Count = COUNT(DcFreezeId) FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE DcFreezeId = @DCFreezeId

	IF (@Count > 0)
		BEGIN
		   
		   UPDATE dbo.tblDCStoreFreeze SET IsPosting = 1 WHERE DCStoreFreezeId = @DCFreezeId

		END

	ELSE

		BEGIN

		UPDATE tblDCStoreFreeze SET IsPosting = 0 WHERE DCStoreFreezeId = @DCFreezeId

		END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @DCFreezeId,@CompanyId,@CostPrice,@InvDate

	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END


--SELECT * FROM tblInvoice

--SELECT * FROM dbo.tblDeliveryManInfo
--INNER JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblDeliveryManInfo.EmpInfoId
--WHERE DeliveryManId = 4


--SELECT * FROM dbo.tblDCStoreFreeze


--SELECT DISTINCT * FROM dbo.tblCustMaster AS CSTMR
--LEFT JOIN dbo.tblMarket AS MKT ON MKT.MarketId = CSTMR.MarketId
--LEFT JOIN dbo.tblTerritory AS TTR ON TTR.TerritoryId = MKT.TerritoryId
--LEFT JOIN dbo.tblArea AS ARA ON ARA.AreaId = TTR.AreaId
--INNER JOIN dbo.tblDcWiseAreaInfo AS DCA ON DCA.AreaId = ARA.AreaId


--SELECT * FROM dbo.tblStockConditionFreeze




