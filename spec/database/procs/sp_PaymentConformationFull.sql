
CREATE PROCEDURE [dbo].[sp_PaymentConformationFull] ---- sp_DeliveryConformationFull 'INV-BD32-00001394','Test','29-Oct-2018'
	@InvoiceNo NVARCHAR(250),
	@UpdateBy NVARCHAR(250),
	@UpdateDate DATETIME 
AS
BEGIN
	
	--IF EXISTS (SELECT InvoiceNo FROM dbo.tblInvoice WHERE InvoiceNo=@InvoiceNo AND   ( LoadingSummaryStatus is not null  ) and  PaymentInvoiceNo  is  null )
	--BEGIN

	   DECLARE @InvoiceId INT
	   DECLARE @TpTotal decimal(18,2)
	   DECLARE @TpDiscount decimal(18,2)
	   DECLARE @TpVat decimal(18,2)
	   DECLARE @TpGrandTotal decimal(18,2)
	   DECLARE @TotalSpecialAmount decimal(18,2)

	    SELECT @InvoiceId=InvoiceId ,
               @TpTotal=DeliveryTpTotal ,
               @TpDiscount=DeliveryTpDiscount ,
               @TpVat=DeliveryTpVat ,
               @TpGrandTotal=DeliveryTpGrandTotal ,
			   @TotalSpecialAmount=TotalSpecialAmount
                FROM dbo.tblInvoice WHERE InvoiceNo=@InvoiceNo

	   DECLARE @InvoiceDetailId INT
       DECLARE @Quantity decimal(18,0)
       DECLARE @BonusQuantity decimal(18,0)
       DECLARE @TotalQuantity decimal(18,0)
       DECLARE @TotalPrice decimal(18,2)
       DECLARE @TotalPriceVatAmount decimal(18,2)
       DECLARE @DiscountPercentage decimal(18,2)
       DECLARE @DiscountAmount decimal(18,2)
       DECLARE @NetAmount decimal(18,2)
       DECLARE @DCStoreId INT
	   DECLARE @SpecialAmount decimal(18,2)

       DECLARE MY_data CURSOR FOR

				SELECT D.InvoiceDetailId ,
					   D.DeliveryQuantity ,
					   D.DeliveryBonusQuantity ,
					   D.DeliveryTotalQuantity ,
					   D.DeliveryTotalPrice ,
					   D.DeliveryTotalPriceVatAmount ,
					   D.DeliveryDiscountPercentage ,
					   D.DeliveryDiscountAmount ,
					   D.DeliveryNetAmount ,
					   D.DCStoreId ,
					   D.SpecialAmount 
						FROM dbo.tblInvoiceDetail D INNER JOIN
				dbo.tblInvoice I ON I.InvoiceId = D.InvoiceId WHERE D.InvoiceId=@InvoiceId

			    OPEN MY_data
				FETCH NEXT FROM MY_data INTO @InvoiceDetailId ,
				   @Quantity ,
				   @BonusQuantity ,
				   @TotalQuantity ,
				   @TotalPrice ,
				   @TotalPriceVatAmount ,
				   @DiscountPercentage ,
				   @DiscountAmount ,
				   @NetAmount ,
				   @DCStoreId ,
				   @SpecialAmount
					WHILE @@FETCH_STATUS = 0
					BEGIN

				UPDATE tblInvoiceDetail SET PaymentQuantity=@Quantity ,
				   PaymentBonusQuantity=@BonusQuantity ,
				   PaymentTotalQuantity=@TotalQuantity ,
				   PaymentTotalPrice=@TotalPrice ,
				   PaymentTotalPriceVatAmount=@TotalPriceVatAmount ,
				   PaymentDiscountPercentage=@DiscountPercentage ,
				   PaymentDiscountAmount=@DiscountAmount ,
				  PaymentNetAmount=@NetAmount  
				     WHERE InvoiceDetailId=@InvoiceDetailId

					FETCH NEXT FROM MY_data INTO @InvoiceDetailId ,
				   @Quantity ,
				   @BonusQuantity ,
				   @TotalQuantity ,
				   @TotalPrice ,
				   @TotalPriceVatAmount ,
				   @DiscountPercentage ,
				   @DiscountAmount ,
				   @NetAmount ,
				   @DCStoreId ,
				   @SpecialAmount
					END
				CLOSE MY_data
			DEALLOCATE MY_data

			UPDATE tblInvoice SET PaymentTpTotal=@TpTotal,PaymentTpDiscount=@TpDiscount,PaymentTpVat=@TpVat,
			PaymentTpGrandTotal=@TpGrandTotal,PaymentInvoiceStatus='Full',
			PaymentInvoiceNo='RTN-'+@InvoiceNo, 
			PaymentBy=@UpdateBy,PaymentDate=CONVERT(NVARCHAR(11),@UpdateDate,106)  WHERE InvoiceId=@InvoiceId


			--SELECT GETDATE(); 
	END
    


--END