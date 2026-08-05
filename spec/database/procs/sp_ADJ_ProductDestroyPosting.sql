-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_ProductDestroyPosting] 

	@DestroyId INT,
	@VoucherMasterId INT
	
AS
BEGIN
	
	DECLARE @DCFreezeId INT
	DECLARE @InvDate DATETIME 
	DECLARE @CompanyId INT
	DECLARE @CostPrice DECIMAL (18,2)
	DECLARE @StockOutQty DECIMAL (18,2)


	DECLARE @StockOutDate DATETIME 
	DECLARE @Reason NVARCHAR(500)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------


	SELECT DFZS.DCStoreFreezeId,DSP.StockOutQty,UNT.CompanyId,CTRS.UnitPrice,DSP.StockOutDate,DSP.Reason FROM tblDestroyProduct AS DSP
	INNER JOIN tblDCStoreFreeze AS DFZS ON DSP.DcFreezeId = DFZS.DCStoreFreezeId
	INNER JOIN tblDCStore AS DCS ON DCS.DCStoreId = DFZS.DCStoreId
	INNER JOIN tblCentralStore AS CTRS ON DCS.TempReceiveId = CTRS.ReceiveId
	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = DFZS.ComUnitId
	WHERE DSP.DestroyId = @DestroyId  


	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DCFreezeId,@StockOutQty,@CompanyId,@CostPrice,@StockOutDate,@Reason
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	-- Master Variable Info
    -------------------------------------


	DECLARE	@DrGl INT 
	SELECT @DrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('ProductDestroy') AND BalanceType IN ('Dr')

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
	    @CostPrice*@StockOutQty, -- DebitAmountBDT - decimal(18, 2)
	    0.00 -- CreditAmountBDT - decimal(18, 2)

	)

	--- Credit

	DECLARE	@CrGl INT 
	SELECT @CrGl = GlId FROM ZAS_ACCDB..tblSalesIntegrationMaping WHERE Particular IN ('ProductDestroy') AND BalanceType IN ('Cr')
	
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
	    @CostPrice*@StockOutQty -- CreditAmountBDT - decimal(18, 2)
	)

	
	FETCH NEXT FROM @MyCursor
	INTO @DCFreezeId,@StockOutQty,@CompanyId,@CostPrice,@StockOutDate,@Reason

	
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


SELECT F.DCStoreFreezeId,F.DCStoreId,F.ProductCode,F.ProductName,F.BatchNo,F.ExpDate,F.StockQty,
(U.UnitPrice*F.StockQty) AS Amount,F.StockCondition,F.Remarks
FROM dbo.tblDCStoreFreeze F
INNER JOIN dbo.tblUnitPrice U ON F.ProductCode = U.ProductCode
INNER JOIN dbo.tblProduct P ON F.ProductCode = P.ProductCode
INNER JOIN dbo.tblCompanyUnit AS IUNT ON IUNT.ComUnitId = F.ComUnitId
WHERE StockQty > 0 AND U.IsActive = 1   AND F.DCStoreFreezeId = 5621 ORDER BY F.ExpDate 




