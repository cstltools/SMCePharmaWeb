-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_UD_ResetPaymentExtra] 


AS
BEGIN
	
	DECLARE @InvoiceId INT
	DECLARE @Payment DECIMAL(18,2)
	DECLARE @DeliveryTpGrandTotal DECIMAL(18,2)
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT InvoiceId,DeliveryTpGrandTotal FROM tblInvoice WHERE DeliveryTpGrandTotal < ISnull(PaymentAmount,0) 
	AND DeliveryInvoiceStatus IN ('Full','Partial') AND DeliveryTpGrandTotal > 0
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @InvoiceId,@DeliveryTpGrandTotal
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			SET @Payment = 0;
			SELECT @Payment = ISNULL(SUM(PaymentAmount),0) FROm tblCustPayDetail WHERE InvoiceId = @InvoiceId
			
			UPDATE tblInvoice SET PaymentAmount = @Payment, 
			PaymentStatus = (CASE WHEN @Payment =  @DeliveryTpGrandTotal THEN 'Full' ELSE 'Partial' END) 
			WHERE InvoiceId = @InvoiceId
		
		FETCH NEXT FROM @MyCursor
		INTO @InvoiceId,@DeliveryTpGrandTotal
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
END






