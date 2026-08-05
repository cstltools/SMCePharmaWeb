-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SubdeportDeliveryConformationFull] ---- sp_DeliveryConformationFull 'INV-BD32-00001394','Test','29-Oct-2018'
	@InvoiceNo NVARCHAR(250),
	@UpdateBy NVARCHAR(250),
	@UpdateDate DATETIME 
AS
BEGIN
	
	IF EXISTS (SELECT * FROM dbo.tblSubInvoiceMaster WHERE InvoiceNo=@InvoiceNo AND DeliveryInvoiceStatus IS NULL)
	BEGIN

	   DECLARE @InvoiceId INT
	   DECLARE @TpTotal decimal(18,2)
	   DECLARE @TpDiscount decimal(18,2)
	   DECLARE @TpVat decimal(18,2)
	   DECLARE @TpGrandTotal decimal(18,2)
	   DECLARE @TotalSpecialAmount decimal(18,2)

	    SELECT @InvoiceId=InvoiceId ,
               @TpTotal=TpTotal ,
               @TpDiscount=TpDiscount ,
               @TpVat=TpVat ,
               @TpGrandTotal=TpGrandTotal ,
			   @TotalSpecialAmount=TotalSpecialAmount
                FROM dbo.tblSubInvoiceMaster WHERE InvoiceNo=@InvoiceNo

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
					   D.Quantity ,
					   D.BonusQuantity ,
					   D.TotalQuantity ,
					   D.TotalPrice ,
					   D.TotalPriceVatAmount ,
					   D.DiscountPercentage ,
					   D.DiscountAmount ,
					   D.NetAmount ,
					   D.SubDCStoreId ,
					   D.SpecialAmount 
						FROM dbo.tblSubInvoiceDetail D INNER JOIN
				dbo.tblSubInvoiceMaster I ON I.InvoiceId = D.InvoiceId WHERE D.InvoiceId=@InvoiceId

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

				UPDATE tblSubInvoiceDetail SET DeliveryQuantity=@Quantity ,
				   DeliveryBonusQuantity=@BonusQuantity ,
				   DeliveryTotalQuantity=@TotalQuantity ,
				   DeliveryTotalPrice=@TotalPrice ,
				   DeliveryTotalPriceVatAmount=@TotalPriceVatAmount ,
				   DeliveryDiscountPercentage=@DiscountPercentage ,
				   DeliveryDiscountAmount=@DiscountAmount ,
				   DeliveryNetAmount=@NetAmount ,
				   DeliveryStatus ='Full', 
				   DelivarySpecialAmount=@SpecialAmount WHERE InvoiceDetailId=@InvoiceDetailId

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

			UPDATE tblSubInvoiceMaster SET DeliveryTpTotal=@TpTotal,DeliveryTpDiscount=@TpDiscount,DeliveryTpVat=@TpVat,
			DeliveryTpGrandTotal=@TpGrandTotal,DeliveryInvoiceStatus='Full',
			DelivaryInvoiceNo='DEL-'+@InvoiceNo,DelivarySpecialAmount=@TotalSpecialAmount,
			UpdateBy=@UpdateBy,UpdateDate=CONVERT(NVARCHAR(11),@UpdateDate,106),UpdateDatetime=GETDATE() WHERE InvoiceId=@InvoiceId
	END
    


END

