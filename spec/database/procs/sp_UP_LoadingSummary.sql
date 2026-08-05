
CREATE PROCEDURE [dbo].[sp_UP_LoadingSummary] ---- sp_DeliveryConformationFull 'INV-BD32-00001394','Test','29-Oct-2018'
	@InvoiceId NVARCHAR(250),
	@UpdateBy NVARCHAR(250),
	@LoadingSummaryStatus NVARCHAR(250)  
AS
BEGIN
	

	declare @InvoiceNo nvarchar(max)
	declare @DelInvoiceNo nvarchar(max)=''
	declare @OrderId nvarchar(max)
	select  @InvoiceNo=InvoiceNo, @OrderId=OrderId, @DelInvoiceNo=isnull(tblInvoice.DelivaryInvoiceNo,'') from tblInvoice where  InvoiceId=@InvoiceId
	declare @nnDate date

 set @nnDate=convert(date, getdate()) 

	if(@LoadingSummaryStatus='Rejection'  )
	begin 
	
	if(@DelInvoiceNo ='')
    begin
	insert into  tblRejectionInvoiceMaster  ( [InvoiceId]
      ,[InvoiceNo]
      ,[InvoiceDate]
      ,[OrderId]
      ,[OrderNo]
      ,[OrderDate]
      ,[CustomerMasterId]
      ,[ComUnitId]
      ,[MiaId]
      ,[PaymentTypeId]
      ,[TpTotal]
      ,[TpDiscount]
      ,[TpVat]
      ,[TpGrandTotal]
      ,[UserId]
      ,[DeliveryTpTotal]
      ,[DeliveryTpDiscount]
      ,[DeliveryTpVat]
      ,[DeliveryTpGrandTotal]
      ,[DeliveryInvoiceStatus]
      ,[DelivaryInvoiceNo]
      ,[PaymentTpTotal]
      ,[PaymentTpDiscount]
      ,[PaymentTpVat]
      ,[PaymentTpGrandTotal]
      ,[PaymentInvoiceStatus]
      ,[PaymentInvoiceNo]
      ,[CreateBy]
      ,[CreateDate]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[TotalSpecialAmount]
      ,[DelivarySpecialAmount]
      ,[PaymentAmount]
      ,[PaymentStatus]
      ,[ProductOffer]
      ,[OldTradePolicy]
      ,[Remarks]
      ,[FixedCustomer]
      ,[MIACode]
      ,[MIAName]
      ,[MarketCode]
      ,[MarketName]
      ,[AreaCode]
      ,[DisCode]
      ,[FEName]
      ,[RegionCode]
      ,[DZSMName]
      ,[DeliveryPersonName]
      ,[DeliveryPersonPhNo]
      ,[Types]
      ,[GreenStarBlueStarID]
      ,[AdjustAmount]
      ,[IsAdjustInvoice]
      ,[ReceivableAmount]
      ,[IsSalesTransfer]
      ,[TransferInvoiceDate]
      ,[UpdateDatetime]
      ,[CampaignName]
      ,[OrderSenderType]
      ,[OrderSenderCode]
      ,[OrderSenderName]
      ,[CustomerType]
      ,[AdjustInvoiceNo_ReturnInvoiceNo]
      ,[DeliveryManId]
      ,[AIT]
      ,[DiscountOnPayment]
      ,[IsPosting]
      ,[MIOId]
      ,[IsAuto]
      ,[LoadingSummaryStatus]
      ,[LoadingSummaryUpdateBy]
      ,[LoadingSummaryUpdateDate]
      ,[loadingsummaryFinalStatus]
      ,[loadingsummaryFinalStatusUpdateBy]
      ,[loadingsummaryFinalStatusUpdateDatetime]
      ,[PaymentBy]
      ,[PaymentDate], RejectionBy, RejectionDate)
	
SELECT  [InvoiceId]
      ,[InvoiceNo]
      ,[InvoiceDate]
      ,[OrderId]
      ,[OrderNo]
      ,[OrderDate]
      ,[CustomerMasterId]
      ,[ComUnitId]
      ,[MiaId]
      ,[PaymentTypeId]
      ,[TpTotal]
      ,[TpDiscount]
      ,[TpVat]
      ,[TpGrandTotal]
      ,[UserId]
      ,[DeliveryTpTotal]
      ,[DeliveryTpDiscount]
      ,[DeliveryTpVat]
      ,[DeliveryTpGrandTotal]
      ,[DeliveryInvoiceStatus]
      ,[DelivaryInvoiceNo]
      ,[PaymentTpTotal]
      ,[PaymentTpDiscount]
      ,[PaymentTpVat]
      ,[PaymentTpGrandTotal]
      ,[PaymentInvoiceStatus]
      ,[PaymentInvoiceNo]
      ,[CreateBy]
      ,[CreateDate]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[TotalSpecialAmount]
      ,[DelivarySpecialAmount]
      ,[PaymentAmount]
      ,[PaymentStatus]
      ,[ProductOffer]
      ,[OldTradePolicy]
      ,[Remarks]
      ,[FixedCustomer]
      ,[MIACode]
      ,[MIAName]
      ,[MarketCode]
      ,[MarketName]
      ,[AreaCode]
      ,[DisCode]
      ,[FEName]
      ,[RegionCode]
      ,[DZSMName]
      ,[DeliveryPersonName]
      ,[DeliveryPersonPhNo]
      ,[Types]
      ,[GreenStarBlueStarID]
      ,[AdjustAmount]
      ,[IsAdjustInvoice]
      ,[ReceivableAmount]
      ,[IsSalesTransfer]
      ,[TransferInvoiceDate]
      ,[UpdateDatetime]
      ,[CampaignName]
      ,[OrderSenderType]
      ,[OrderSenderCode]
      ,[OrderSenderName]
      ,[CustomerType]
      ,[AdjustInvoiceNo_ReturnInvoiceNo]
      ,[DeliveryManId]
      ,[AIT]
      ,[DiscountOnPayment]
      ,[IsPosting]
      ,[MIOId]
      ,[IsAuto]
      ,[LoadingSummaryStatus]
      ,[LoadingSummaryUpdateBy]
      ,[LoadingSummaryUpdateDate]
      ,[loadingsummaryFinalStatus]
      ,[loadingsummaryFinalStatusUpdateBy]
      ,[loadingsummaryFinalStatusUpdateDatetime]
      ,[PaymentBy]
      ,[PaymentDate], @UpdateBy, getdate()
  FROM [dbo].[tblInvoice] where InvoiceId=@InvoiceId



  insert into [dbo].[tblRejectionInvoiceDetail] ([InvoiceDetailId]
      ,[ProductCode]
      ,[ProductName]
      ,[PackSize]
      ,[BatchNo]
      ,[ReceiveDate]
      ,[ExpDate]
      ,[CostPrice]
      ,[UnitPrice]
      ,[UnitVatAmount]
      ,[Quantity]
      ,[BonusQuantity]
      ,[TotalQuantity]
      ,[TotalPrice]
      ,[TotalPriceVatAmount]
      ,[DiscountPercentage]
      ,[DiscountAmount]
      ,[NetAmount]
      ,[InvoiceId]
      ,[DCStoreId]
      ,[DeliveryQuantity]
      ,[DeliveryBonusQuantity]
      ,[DeliveryTotalQuantity]
      ,[DeliveryTotalPrice]
      ,[DeliveryTotalPriceVatAmount]
      ,[DeliveryDiscountPercentage]
      ,[DeliveryDiscountAmount]
      ,[DeliveryNetAmount]
      ,[DeliveryStatus]
      ,[PaymentQuantity]
      ,[PaymentBonusQuantity]
      ,[PaymentTotalQuantity]
      ,[PaymentTotalPrice]
      ,[PaymentTotalPriceVatAmount]
      ,[PaymentDiscountPercentage]
      ,[PaymentDiscountAmount]
      ,[PaymentNetAmount]
      ,[PaymentReturnReason]
      ,[PaymentStatus]
      ,[OrderDetailsId]
      ,[SpecialAmount]
      ,[DelivarySpecialAmount]
      ,[ReturnReason]
      ,[Campaign]
      ,[ISGiftProduct]
      ,[CampaignType]
      ,[IsCampaignProduct]
      ,[AdjustmentAmount])
  



  SELECT [InvoiceDetailId]
      ,[ProductCode]
      ,[ProductName]
      ,[PackSize]
      ,[BatchNo]
      ,[ReceiveDate]
      ,[ExpDate]
      ,[CostPrice]
      ,[UnitPrice]
      ,[UnitVatAmount]
      ,[Quantity]
      ,[BonusQuantity]
      ,[TotalQuantity]
      ,[TotalPrice]
      ,[TotalPriceVatAmount]
      ,[DiscountPercentage]
      ,[DiscountAmount]
      ,[NetAmount]
      ,[InvoiceId]
      ,[DCStoreId]
      ,[DeliveryQuantity]
      ,[DeliveryBonusQuantity]
      ,[DeliveryTotalQuantity]
      ,[DeliveryTotalPrice]
      ,[DeliveryTotalPriceVatAmount]
      ,[DeliveryDiscountPercentage]
      ,[DeliveryDiscountAmount]
      ,[DeliveryNetAmount]
      ,[DeliveryStatus]
      ,[PaymentQuantity]
      ,[PaymentBonusQuantity]
      ,[PaymentTotalQuantity]
      ,[PaymentTotalPrice]
      ,[PaymentTotalPriceVatAmount]
      ,[PaymentDiscountPercentage]
      ,[PaymentDiscountAmount]
      ,[PaymentNetAmount]
      ,[PaymentReturnReason]
      ,[PaymentStatus]
      ,[OrderDetailsId]
      ,[SpecialAmount]
      ,[DelivarySpecialAmount]
      ,[ReturnReason]
      ,[Campaign]
      ,[ISGiftProduct]
      ,[CampaignType]
      ,[IsCampaignProduct]
      ,[AdjustmentAmount]
  FROM [dbo].[tblInvoiceDetail] where InvoiceId=@InvoiceId





		INSERT INTO [dbo].[tblRejectionLoadSum]
           ([InvoiceId]
           ,[InvoiceNo]
           ,[Lstatus], Updateby)
     VALUES
           (@InvoiceId 
           ,@InvoiceNo 
           ,@LoadingSummaryStatus, @UpdateBy )
 

EXEC	  [dbo].[sp_Delete_ProformaInvoice]
		@InvoiceCode =@InvoiceNo,
		@User =@UpdateBy

		update tblOrder set isInvoice=1, IsRejectionInvoice=1  where OrderId= @OrderId


	

	end
	end



	if(@LoadingSummaryStatus='Cash')
	begin 
	 
	 
 
 exec  sp_DeliveryConformationFull @InvoiceNo =@InvoiceNo,
		@UpdateBy =@UpdateBy, @UpdateDate=@nnDate

	UPDATE tblInvoice SET LoadingSummaryStatus='Full',LoadingSummaryUpdateBy=@UpdateBy,LoadingSummaryUpdateDate=GETDATE(),loadingsummaryFinalStatus='Completed',loadingsummaryFinalStatusUpdateBy=@UpdateBy,loadingsummaryFinalStatusUpdateDatetime=GETDATE() WHERE InvoiceId=@InvoiceId

		INSERT INTO [dbo].[tblRejectionLoadSum]
           ([InvoiceId]
           ,[InvoiceNo]
           ,[Lstatus], Updateby)
     VALUES
           (@InvoiceId 
           ,@InvoiceNo 
           ,@LoadingSummaryStatus, @UpdateBy )


		   exec sp_PaymentConformationFull  @InvoiceNo =@InvoiceNo,
		@UpdateBy =@UpdateBy, @UpdateDate=@nnDate

	end


	else
	begin
		UPDATE tblInvoice SET LoadingSummaryStatus=@LoadingSummaryStatus,LoadingSummaryUpdateBy=@UpdateBy,LoadingSummaryUpdateDate=GETDATE() WHERE InvoiceId=@InvoiceId

		   exec sp_PaymentConformationFull  @InvoiceNo =@InvoiceNo,
		@UpdateBy =@UpdateBy, @UpdateDate=@nnDate
	end
	 
		


			--SELECT GETDATE(); 
	 
    


END