-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_FreezeStockPosting] 

	@DcStockConditionId INT,
	@VoucherMasterId INT
	
AS
BEGIN
	
	DECLARE @DCFreezeId INT
	DECLARE @InvDate DATETIME 
	DECLARE @CompanyId INT
	DECLARE @CostPrice DECIMAL(18,2)
	DECLARE @TotalQuantity DECIMAL(18,2)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------


	SELECT DFZS.DCStoreFreezeId,UNT.CompanyId,CTRS.UnitPrice,STCF.EntryDate,DFZS.TotalQuantity FROM dbo.tblStockConditionFreeze AS STCF
	INNER JOIN dbo.tblDCStoreFreeze AS DFZS ON DFZS.StockConditionFreezeID = STCF.StockConditionFreezeID
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = DFZS.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = DFZS.ComUnitId
	WHERE DFZS.DCStoreFreezeId = @DcStockConditionId 



	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DCFreezeId,@CompanyId,@CostPrice,@InvDate,@TotalQuantity
	
	WHILE @@FETCH_STATUS = 0
	BEGIN


	-- Detail Information Posting

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
	    @CostPrice*@TotalQuantity, -- DebitAmountBDT - decimal(18, 2)
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
	    @CostPrice*@TotalQuantity -- CreditAmountBDT - decimal(18, 2)
	)


	
	
	
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




