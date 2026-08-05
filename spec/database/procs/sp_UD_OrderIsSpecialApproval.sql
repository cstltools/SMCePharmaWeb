-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_UD_OrderIsSpecialApproval] 

AS
BEGIN
	
	DECLARE @CstmrId INT
	DECLARE @OrderId INT
    Declare @GrossValue DECIMAL
	DECLARE @TermOfPayment NVARCHAR(MAX)
            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT ODR.OrderId,CST.CustomerMasterId,GrossValue,TermOfPayment FROM tblOrder AS ODR 
	LEFT JOIN tblCustMaster AS CST ON ODR.CustomerCode = CST.CustomerCode
	LEFT JOIN tblCompanyUnit AS UNT ON ODR.ComUnitId = UNT.ComUnitId
	LEFT JOIN tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
	WHERE IsFromApp = 1 and IsInvoice = 0 

    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @OrderId,@CstmrId ,
       @GrossValue,
	   @TermOfPayment 
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    
	DECLARE @LimitAmount DECIMAL
	DECLARE @Due DECIMAL
	DECLARE @RemainAmount DECIMAL



	SELECT @LimitAmount = LimitAmount FROM dbo.tblCustomerCreditLimit
    LEFT JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblCustomerCreditLimit.CustomerMasterId
    WHERE tblCustMaster.CustomerMasterId = @CstmrId

	SELECT @Due = ISNULL(SUM(DeliveryTpGrandTotal-ISNULL(PaymentAmount,0)),0) FROM dbo.tblInvoice 
    WHERE (DeliveryInvoiceStatus IS NOT NULL OR DeliveryInvoiceStatus != 'Reject') AND CustomerMasterId = @CstmrId


	SELECT @RemainAmount = SUM(tbltemp.RemainAmount) FROM (SELECT ISNULL(SUM(GrossValue),0)RemainAmount FROM dbo.tblOrder WHERE (IsInvoice IS NULL OR IsInvoice='0') AND CustomerMasterId=@CstmrId
	UNION ALL 
	SELECT SUM(DeliveryTpGrandTotal-ISNULL(tbltemp.Amount,0))RemainAmount FROM dbo.tblInvoice 
	LEFT JOIN  
	(SELECT InvoiceId,ISNULL(SUM(PaymentAmount),0)Amount FROM dbo.tblCustPayDetail GROUP BY InvoiceId) AS tbltemp ON tbltemp.InvoiceId = tblInvoice.InvoiceId 
	WHERE CustomerMasterId=@CstmrId AND PaymentStatus<>'Full')AS tbltemp


	IF(ISNull(@Due,0) > 0)
	BEGIN	

		UPDATE tblOrder SET IsSpecialApproval = 1 WHERE OrderId = @OrderId  
		                                 
	END

	IF(@TermOfPayment = 'Credit' AND (ISNULL(@GrossValue,0) + ISNULL(@Due,0)) > @RemainAmount)
	BEGIN	

		UPDATE tblOrder SET IsSpecialApproval = 1 WHERE OrderId = @OrderId  
		                                 
	END
	
    FETCH NEXT FROM @MyCursor
    INTO @OrderId,@CstmrId ,
       @GrossValue,
	   @TermOfPayment
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END






