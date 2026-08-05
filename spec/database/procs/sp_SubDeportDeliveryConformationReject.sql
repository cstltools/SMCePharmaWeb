-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SubDeportDeliveryConformationReject] ---- sp_DeliveryConformationFull 'INV-BD32-00001394','Test','29-Oct-2018'
	@InvoiceNo NVARCHAR(250),
	@UpdateBy NVARCHAR(250),
	@ReturnReason NVARCHAR(250),
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
       DECLARE @TotalPrice decimal(18,0)
       DECLARE @TotalPriceVatAmount decimal(18,0)
       DECLARE @DiscountPercentage decimal(18,0)
       DECLARE @DiscountAmount decimal(18,0)
       DECLARE @NetAmount decimal(18,0)
       DECLARE @DCStoreId INT
	   DECLARE @SpecialAmount decimal(18,0)

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

				UPDATE tblSubInvoiceDetail SET DeliveryQuantity=0 ,
				   DeliveryBonusQuantity=0 ,
				   DeliveryTotalQuantity=0 ,
				   DeliveryTotalPrice=0 ,
				   DeliveryTotalPriceVatAmount=0 ,
				   DeliveryDiscountPercentage=0 ,
				   DeliveryDiscountAmount=0 ,
				   DeliveryNetAmount=0 ,
				   DeliveryStatus ='Reject', 
				   DelivarySpecialAmount=0, 
				   ReturnReason=@ReturnReason 
				   WHERE InvoiceDetailId=@InvoiceDetailId


				   declare @CountDetail int
				   select @CountDetail=COUNT(*) from tblSubDepotStoreFreeze where InvoiceDetailId=@InvoiceDetailId

				   if(@CountDetail=0)
				   begin
				   -----------------
				     declare @DcStoreFreezeId int=null
					 declare @StorageLocation nvarchar(max)=null
					 declare @ProductCode nvarchar(max) =null
					 declare @ProductName nvarchar(max) =null
					 declare @PackSize nvarchar(max)=null
					 declare @BatchNo nvarchar(max) =null
					 declare @ExpDate datetime=null
					 declare @ReceiveDate datetime=null
					 declare @ChalanNo nvarchar(max)=null
					 declare @ChalanDate datetime=null
					 declare @ComUnitId int=null
					 declare @StockQty decimal(18,0)=@TotalQuantity
					 declare @DamageQty decimal(18,0)=0
					 declare @StockRcvDate datetime=null
					 declare @ReqId int=null
					 declare @ReqChildId int=null
					 declare @StockInTransfarId int=null
					 declare @StockCondition int=null
					 declare @ChalanDetailsId int=null

				   SELECT @DcStoreFreezeId=(isnull(MAX(SDStoreFreezeId),0)+1)  FROM tblSubDepotStoreFreeze

				   SELECT @StorageLocation=StorageLocation,@ProductCode=ProductCode,@ProductName=ProductName,@PackSize=PackSize,@BatchNo=BatchNo
				   ,@ExpDate=ExpDate,@ReceiveDate=ReceiveDate,@ChalanNo=ChalanNo,@ChalanDate=ChalanDate,@ComUnitId=SubDepotId,@StockRcvDate=StockRcvDate
				   ,@ReqId=ReqId,@ReqChildId=ReqChildId,@StockInTransfarId=StockInTransfarId,@ChalanDetailsId=SChalanDetailsId FROM dbo.tblSubDepotStore WHERE SubDCStoreId=@DCStoreId

				   INSERT INTO dbo.tblSubDepotStoreFreeze 
         ( SubDCStoreId , 
             SDStoreFreezeId, 
             InvoiceDetailId, 
             StorageLocation , 
             ProductCode , 
             ProductName , 
             PackSize , 
             BatchNo , 
             TotalQuantity , 
             ExpDate , 
             ReceiveDate , 
             ChalanNo , 
             ChalanDate , 
             SubDepotId , 
             StockQty , 
             DamageQty , 
             StockRcvDate , 
             ReqId ,
             ReqChildId , 
             StockInTransfarId, 
             StockCondition,SChalanDetailsId 
          ) 
		  values (@DCStoreId , 
             @DCStoreFreezeId, 
             @InvoiceDetailId, 
             @StorageLocation , 
             @ProductCode , 
             @ProductName , 
             @PackSize , 
             @BatchNo , 
             @TotalQuantity , 
             @ExpDate , 
             @ReceiveDate , 
             @ChalanNo , 
             @ChalanDate , 
             @ComUnitId , 
             @StockQty , 
             @DamageQty , 
             @StockRcvDate , 
             @ReqId ,
             @ReqChildId , 
             @StockInTransfarId, 
             @StockCondition,@ChalanDetailsId )
        

				   ----------------
		end

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

			UPDATE tblSubInvoiceMaster SET DeliveryTpTotal=0,DeliveryTpDiscount=0,DeliveryTpVat=0,
			DeliveryTpGrandTotal=0,DeliveryInvoiceStatus='Reject',
			DelivaryInvoiceNo='DEL-'+@InvoiceNo,
			DelivarySpecialAmount=0,
			UpdateBy=@UpdateBy,UpdateDate=CONVERT(NVARCHAR(11),@UpdateDate,106),UpdateDatetime=GETDATE()
			WHERE InvoiceId=@InvoiceId
	END
    


END

