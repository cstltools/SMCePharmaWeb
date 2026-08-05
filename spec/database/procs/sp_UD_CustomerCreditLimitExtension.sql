-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_CustomerCreditLimitExtension] 

AS
BEGIN
	  

	DECLARE @CustomerId INT
	DECLARE @CompanyId INT
	DECLARE @CreditLimitId INT
	DECLARE @EndDate DATETIME
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT CD.CreditLimitId,CD.CompanyId,CD.CustomerMasterId,CD.EndDate 
	FROM dbo.tblCustomerCreditLimit AS CD WHERE CD.ActionStatus IN ('Accepted') AND CD.EndDate IS NOT NULL 
	AND CONVERT(DATE,GETDATE()) = CD.EndDate
	
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @CreditLimitId,@CompanyId,@CustomerId,@EndDate
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @Due DECIMAL(18,2)
		SET @Due = 0
	    
		-- Check Due Status

		SELECT @Due = SUM(DeliveryTpGrandTotal-ISNULL(PaymentAmount,0)) FROM dbo.tblInvoice AS IV
	    LEFT JOIN dbo.tblCompanyUnit ON  tblCompanyUnit.ComUnitId = IV.ComUnitId 
	    LEFT JOIN dbo.tblCompanyInfo ON tblCompanyInfo.CompanyId = tblCompanyUnit.CompanyId
	    WHERE DeliveryInvoiceStatus IN ('FULL','Partial') AND IV.CustomerMasterId = @CustomerId AND tblCompanyInfo.CompanyId = @CompanyId
	
		IF(@Due = 0)
			
			BEGIN
				UPDATE tblCustomerCreditLimit SET EndDate = DATEADD(DAY,30,@EndDate) WHERE CreditLimitId = @CreditLimitId
			END
	
	
	FETCH NEXT FROM @MyCursor
	INTO @CreditLimitId,@CompanyId,@CustomerId,@EndDate
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor

END
