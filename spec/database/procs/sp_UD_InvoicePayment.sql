-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_UD_InvoicePayment] 

	@InvoiceId INT

AS
BEGIN
	
    Declare @Status nvarchar(250)  
    Declare @PaymentAmount DECIMAL(18,2)
	Declare @DeliveryTpGrandTotal DECIMAL(18,2)
	Declare @AIT DECIMAL(18,2)
	Declare @Discount DECIMAL(18,2)
            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT INV.DeliveryTpGrandTotal,SUM(CPD.PaymentAmount) AS PaymentAmount, SUM(Isnull(CPD.AIT,0)) AIT, SUM(Isnull(CPD.Discount,0)) Discount FROM tblCustPayDetail AS CPD
	LEFT JOIN tblInvoice AS INV ON CPD.InvoiceId = INV.InvoiceId
	WHERE CPD.InvoiceId = @InvoiceId GROUP BY INV.DeliveryTpGrandTotal
	
    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @DeliveryTpGrandTotal ,
		 @PaymentAmount, @AIT, @Discount
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    
	

	IF(@DeliveryTpGrandTotal = (@PaymentAmount + @AIT + @Discount))
	BEGIN
		
	    SET @Status = 'Full'
		                               
	END

	ELSE 
	BEGIN
		
	    SET @Status = 'Partial'
		                               
	END


	UPDATE dbo.tblInvoice SET PaymentAmount = @PaymentAmount,AIT = @AIT, DiscountOnPayment = @Discount, PaymentStatus = @Status WHERE InvoiceId = @InvoiceId

	
    FETCH NEXT FROM @MyCursor
    INTO @DeliveryTpGrandTotal ,
		 @PaymentAmount, @AIT, @Discount  
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END
