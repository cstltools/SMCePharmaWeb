-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_PaymentDeleteLog] 
	(
		 @payMaserId INT,
		 @payDetailId INT,
		 @EntryBy NVARCHAR(MAX),
		 @EntryDate DATETIME
	)
AS
BEGIN
	 
	IF(@payMaserId > 0) 
	BEGIN
		

		      DECLARE @CustPayId INT
              DECLARE @CustomerMasterId INT
              DECLARE @PaymentDate DATETIME
              DECLARE @PaymentAmount DECIMAL(18,2)
              DECLARE @PayType NVARCHAR(50)
              DECLARE @RefNo NVARCHAR (50)
              DECLARE @RefDate DATETIME
              DECLARE @CreateBy NVARCHAR(50)
              DECLARE @CreateDate DATETIME
		        
		--------------------------------------------------------
		DECLARE @MyCursor CURSOR
		SET @MyCursor = CURSOR FAST_FORWARD
		FOR
		---------------
		
		SELECT CustPayId,
               CustomerMasterId,
               PaymentDate,
               PaymentAmount,
               PayType,
               RefNo,
               RefDate,
               CreateBy,
               CreateDate FROM dbo.tblCustomerPay WHERE CustPayId = @payMaserId
			
		----------
		OPEN @MyCursor
		FETCH NEXT FROM @MyCursor
		INTO   @CustPayId,
               @CustomerMasterId,
               @PaymentDate,
               @PaymentAmount,
               @PayType,
               @RefNo,
               @RefDate,
               @CreateBy,
               @CreateDate
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
		INSERT INTO [dbo].[tblCustomerPayDeleteLog]
		(
		    CustPayId,
		    CustomerMasterId,
		    PaymentDate,
		    PaymentAmount,
		    PayType,
		    RefNo,
		    RefDate,
		    CreateBy,
		    CreateDate,
			[DeleteBy],
			[DeleteDate]
		)
		VALUES
		(   @CustPayId,         -- CustPayId - int
		    @CustomerMasterId,         -- CustomerMasterId - int
		    @PaymentDate, -- PaymentDate - datetime
		    @PaymentAmount,      -- PaymentAmount - decimal(18, 2)
		    @PayType,       -- PayType - nvarchar(50)
		    @RefNo,       -- RefNo - nvarchar(50)
		    @RefDate, -- RefDate - datetime
		    @CreateBy,       -- CreateBy - nvarchar(50)
		    @CreateDate, -- CreateDate - datetime
		    @EntryBy,       -- UpdateBy - nvarchar(50)
		    @EntryDate  -- UpdateDate - datetime
		)
		
		
		
		FETCH NEXT FROM @MyCursor
		INTO @CustPayId,
               @CustomerMasterId,
               @PaymentDate,
               @PaymentAmount,
               @PayType,
               @RefNo,
               @RefDate,
               @CreateBy,
               @CreateDate
		
		END
		CLOSE @MyCursor
		DEALLOCATE @MyCursor  
    END


	-- Pay Detai Info

    IF(@payDetailId > 0) 
	BEGIN


		DECLARE @CustPayDetailId INT
        DECLARE @InvoiceId INT
        DECLARE @PaymentDAmount DECIMAL(18,2) 
        DECLARE @CustPayMId INT

		        
		--------------------------------------------------------
		DECLARE @MyCursor2 CURSOR
		SET @MyCursor2 = CURSOR FAST_FORWARD
		FOR
		---------------
		SELECT CustPayDetailId,
               InvoiceId,
               PaymentAmount,
               CustPayId FROM dbo.tblCustPayDetail WHERE CustPayDetailId = @payDetailId
			
		----------
		OPEN @MyCursor2
		FETCH NEXT FROM @MyCursor2
		INTO   @CustPayDetailId,
               @InvoiceId,
               @PaymentDAmount,
               @CustPayMId
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
		INSERT INTO [dbo].[tblCustPayDetailDeleteLog]
		(
		    CustPayDetailId,
		    InvoiceId,
		    PaymentAmount,
		    CustPayId
		)
		VALUES
		(   @CustPayDetailId,    -- CustPayDetailId - int
		    @InvoiceId,    -- InvoiceId - int
		    @PaymentDAmount, -- PaymentAmount - decimal(18, 2)
		    @CustPayMId    -- CustPayId - int
		)
		
		
		
		FETCH NEXT FROM @MyCursor2
		INTO   @CustPayDetailId,
               @InvoiceId,
               @PaymentDAmount,
               @CustPayMId
		
		END
		CLOSE @MyCursor2
		DEALLOCATE @MyCursor2 
    END

END



