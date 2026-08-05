-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ADJ_VoucherMasterDetailPosting] 


AS
BEGIN
	
	DECLARE @VoucherMasterId INT
	DECLARE @Narration NVARCHAR(MAX)
	DECLARE @ProformaId INT
	DECLARE @DcFreezeId INT
	DECLARE @DestroyId INT
	DECLARE @SalesReturnId INT
	DECLARE @CustPayDetailId INT
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT M.VoucherMasterId,M.Narration,M.ProformaId,M.DcFreezeId,M.DestroyId,M.SalesReturnId,M.CustPayDetailId FROM ZAS_ACCDB..tblDebitCreditVoucherMaster AS M
	LEFT JOIN ZAS_ACCDB..tblDebitCreditVoucherDetail AS D ON D.VoucherMasterId = M.VoucherMasterId
    WHERE D.VoucherMasterId IS NULL 


	

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @VoucherMasterId
		,@Narration
		,@ProformaId
		,@DcFreezeId
		,@DestroyId
		,@SalesReturnId
		,@CustPayDetailId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	--DELETE FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE VoucherMasterId = @VoucherMasterId

	IF(@CustPayDetailId IS NOT NULL)
	BEGIN	

		EXEC sp_ADJ_CustomerPaymentPosting 
		     @PayDetailID = @CustPayDetailId,@VoucherMasterId = @VoucherMasterId

	END


	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Proforma Invoice (%')
	BEGIN	

		EXEC sp_ADJ_ProformaPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId

	END
	

	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Proforma Invoice Return (%')
	BEGIN	

		EXEC sp_ADJ_ProformaReturnPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId

	END


	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Confirmation Full -(%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationFullPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId,@Type = 'Sales'

	END


	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Confirmation Full, Inventory Valuation - (%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationFullPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId,@Type = 'Inventory'

	END

	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Confirmation Partial -(%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationPartiallPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId,@Type = 'Sales'

	END

	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Confirmation Partial, Inventory Valuation - (%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationPartiallPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId,@Type = 'Inventory'

	END

	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Confirmation Partial , Return Stock Valuation - (%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationPartiallPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId,@Type = 'Freeze'

	END


	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Proforma Full Reject%')
	BEGIN	

		EXEC sp_ADJ_ProformaFullReturnPosting
		     @InvoiceId = @ProformaId,@VoucherMasterId = @VoucherMasterId

	END

	IF(@DestroyId IS NOT NULL)
	BEGIN	

		EXEC sp_ADJ_ProductDestroyPosting 
		     @DestroyId = @DestroyId,@VoucherMasterId = @VoucherMasterId

	END

	IF(@DcFreezeId IS NOT NULL AND @Narration LIKE '%Freeze Stock  - (%')
	BEGIN	

		EXEC sp_ADJ_FreezeStockPosting 
		     @DcStockConditionId = @DcFreezeId,@VoucherMasterId = @VoucherMasterId

	END
	
	IF(@DcFreezeId IS NOT NULL AND @Narration LIKE '%Freeze Stock Release - (%')
	BEGIN	

		EXEC sp_ADJ_FreezeStockReleasePosting
		     @FreezeId = @DcFreezeId,@VoucherMasterId = @VoucherMasterId

	END

	
	IF(@SalesReturnId IS NOT NULL AND @Narration LIKE '%Delivery Sales Return -(%')
	BEGIN	

		EXEC sp_ADJ_DeliverySalesReturnPosting
		     @ReturnId = @SalesReturnId,@VoucherMasterId = @VoucherMasterId,@Type = 'Sales'

	END

	IF(@ProformaId IS NOT NULL AND @Narration LIKE '%Delivery Sales Return, Inventory Valuation - ( %')
	BEGIN	

		EXEC sp_ADJ_DeliverySalesReturnPosting
		     @ReturnId = @SalesReturnId,@VoucherMasterId = @VoucherMasterId,@Type = 'Inventory'

	END


	IF(@SalesReturnId IS NOT NULL AND @Narration LIKE '%Delivery Invoice Delete -(%')
	BEGIN	

		EXEC sp_ADJ_DeliveryConfirmationFullPosting
		     @InvoiceId = @SalesReturnId,@VoucherMasterId = @VoucherMasterId,@Type = 'Sales'

	END


	IF(@SalesReturnId IS NOT NULL AND @Narration LIKE '%Delivery Invoice Delete, Inventory Valuation - (%')
	BEGIN	

		EXEC sp_ADJ_DeliveryInvoiceDeletePosting
		     @InvoiceId = @SalesReturnId,@VoucherMasterId = @VoucherMasterId,@Type = 'Inventory'

	END

	FETCH NEXT FROM @MyCursor
	INTO @VoucherMasterId
		,@Narration
		,@ProformaId
		,@DcFreezeId
		,@DestroyId
		,@SalesReturnId
		,@CustPayDetailId
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

	
END





--SELECT CPD.PaymentAmount,CPY.CustomerMasterId,CPD.InvoiceId,CPD.CustPayDetailId,CPY.PaymentDate,UNT.CompanyId,CPD.Discount,InvoiceNo,PaymentStatus,CPD.BankId FROM dbo.tblCustPayDetail AS CPD 
--	LEFT JOIN dbo.tblCustomerPay AS CPY ON CPD.CustPayId = CPY.CustPayId
--	LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = CPD.InvoiceId
--	INNER JOIN tblCompanyUnit AS UNT ON UNT.ComUnitId = tblInvoice.ComUnitId


