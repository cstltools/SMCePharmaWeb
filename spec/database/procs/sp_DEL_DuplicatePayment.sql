
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_DEL_DuplicatePayment] 
	
	@InvoiceNo NVARCHAR(MAX)
	
AS
BEGIN


	DECLARE @CustPayDetailId INT
	DECLARE @CustPayId INT
	    
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	

	SELECT CPD.CustPayDetailId,CustPayId FROM tblCustPayDetail AS CPD 
	LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	WHERE INV.InvoiceNo = @InvoiceNo AND TransctionDetailId IN (SELECT TransctionDetailId FROM tblCustPayDetail
    GROUP BY TransctionDetailId HAVING COUNT(TransctionDetailId) > 1)
	AND CustPayDetailId NOT IN 
	(
		SELECT  TOP 1 CustPayDetailId FROM tblCustPayDetail CP
		LEFT JOIN tblInvoice AS INV ON CP.InvoiceId = INV.InvoiceId WHERE INV.InvoiceNo = @InvoiceNo AND TransctionDetailId IN (SELECT TransctionDetailId FROM tblCustPayDetail
		GROUP BY TransctionDetailId HAVING COUNT(TransctionDetailId) > 1)
	)
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @CustPayDetailId,@CustPayId
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
	
	     -- INNER Courser Start
			
			DECLARE @VoucherMasterId INT
			

			DECLARE @inner_cursor CURSOR
			SET @inner_cursor = CURSOR FAST_FORWARD
			
			FOR
			---------------

			SELECT VoucherMasterId FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE CustPayDetailId = @CustPayDetailId
				
			----------
			OPEN @inner_cursor
			FETCH NEXT FROM @inner_cursor
			INTO @VoucherMasterId
			
				WHILE @@FETCH_STATUS = 0
				BEGIN

					-- DELETE Voucher

					DELETE FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE VoucherMasterId = @VoucherMasterId
					DELETE FROM ZAS_ACCDB..tblDebitCreditVoucherDetail WHERE VoucherMasterId = @VoucherMasterId

						
				FETCH NEXT FROM @inner_cursor
				INTO @VoucherMasterId
			
			CLOSE @inner_cursor
			DEALLOCATE @inner_cursor

		END
		FETCH NEXT FROM @MyCursor
		INTO @CustPayDetailId,@CustPayId

		-- DELETE Payment

		DELETE FROM dbo.tblCustomerPay WHERE CustPayId = @CustPayId
		DELETE FROM tblCustPayDetail WHERE CustPayDetailId = @CustPayDetailId

	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

END





