-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_InvoiceMaster] 
	(
		 @InvoiceId int OUT,	
		 @InvoiceDate DATETIME = NULL,
         @OrderNo NVARCHAR(MAX) = NULL,
		 @OrderDate DATETIME=NULL,
		 @CustomerMasterId INT = NULL,
		 @ComUnitId INT = NULL,
		 @MiaId INT = NULL,
		 @PaymentTypeId INT = NULL,
		 @TpTotal DECIMAL(18,2)=NULL,
		 @TpDiscount DECIMAL(18,2)=NULL,
		 @TpVat DECIMAL(18,2)=NULL,
		 @TpGrandTotal DECIMAL(18,2)=NULL,
		 @UserId INT = NULL,
         @OrderId INT = NULL,
		 @TotalSpecialAmount DECIMAL(18,2)=NULL,
         @OldTradePolicy NVARCHAR(50) = NULL,
         @ProductOffer NVARCHAR(50) = NULL,
         @Remarks NVARCHAR(MAX) = NULL,
		 @DeliveryManId INT = NULL,
		 @UnitCode NVARCHAR(50) = NULL
         
	)
AS
BEGIN
	 
	DECLARE @InvoiceNo NVARCHAR(MAX)
	DECLARE @NoOfInvoice INT
	DECLARE @Count INT

	IF (@ComUnitId > 99)
	BEGIN
			SELECT @NoOfInvoice = (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,11,12)) AS INT)),0)+1) FROM dbo.tblInvoice 
			WHERE ComUnitId = @ComUnitId AND Remarks != 'Due' GROUP BY ComUnitId
	END
	ELSE
	BEGIN
			SELECT @NoOfInvoice = (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,10,11)) AS INT)),0)+1) FROM dbo.tblInvoice 
			WHERE ComUnitId = @ComUnitId AND Remarks != 'Due' GROUP BY ComUnitId
	END
	
	IF (@NoOfInvoice IS NULL)
	BEGIN
			SET @NoOfInvoice = 1
	END


	DECLARE @length INT = 0
	SET @length = LEN(CONVERT(NVARCHAR(MAX),@NoOfInvoice))

	IF(@length > 0 OR @length is null)
	BEGIN

		

		IF(@length = 1)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '00000000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 2)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '0000000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 3)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-'+ '000000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 4)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '00000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 5)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '0000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 6)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '000' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END

		IF(@length = 6)
		BEGIN
			SET @InvoiceNo ='INV-' + @UnitCode + '-' + '00' + (CONVERT(NVARCHAR(MAX),@NoOfInvoice))
		END
	END

	SELECT @Count = COUNT(InvoiceNo) FROM tblInvoice WHERE InvoiceNo = @InvoiceNo

	PRINT @InvoiceNo

	if (@Count = 0)
	BEGIN

		INSERT INTO dbo.tblInvoice ( 
           InvoiceNo ,  
           InvoiceDate ,  
           OrderNo ,  
           OrderDate ,  
           CustomerMasterId ,  
           ComUnitId ,  
           MiaId ,  
           PaymentTypeId ,  
           TpTotal ,  
           TpDiscount ,  
           TpVat ,  
           TpGrandTotal ,  
           UserId,  
           OrderId, 
           TotalSpecialAmount,  
           OldTradePolicy,  
           ProductOffer,
		   Remarks,
		   DeliveryManId 
         ) 
		 VALUES (		 
		   @InvoiceNo ,  
           @InvoiceDate ,  
           @OrderNo ,  
           @OrderDate ,  
           @CustomerMasterId ,  
           @ComUnitId ,  
           @MiaId ,  
           @PaymentTypeId ,  
           @TpTotal ,  
           @TpDiscount ,  
           @TpVat ,  
           @TpGrandTotal ,  
           @UserId,  
           @OrderId, 
           @TotalSpecialAmount,  
           @OldTradePolicy,  
           @ProductOffer,
		   @Remarks,
		   @DeliveryManId 

		 )
           
           
     SET @InvoiceId = SCOPE_IDENTITY() 
	END
	  
         

END

