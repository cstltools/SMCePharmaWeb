-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_AutoInvoiceGeneration --sp_AutoInvoiceGeneration '10386817954'
	@OrderCodeInPut NVARCHAR(500),
	@UserId INT
AS
BEGIN
	--SELECT * FROM dbo.tblOrder WHERE IsInvoice=0
	--SELECT * FROM dbo.tblInvoice WHERE InvoiceDate='30-Jun-2020' and  DelivaryInvoiceNo IS NULL
	--SELECT * FROM dbo.tblOrder WHERE IsManual IS NOT NULL
    

DECLARE @OrderId INT
      DECLARE @OrderCode NVARCHAR(500)
      DECLARE @ComUnitId INT
      DECLARE @ComUnitCode NVARCHAR(500)
      DECLARE @ComUnitName NVARCHAR(500)
      DECLARE @MIOCode NVARCHAR(500)
      DECLARE @MIOName NVARCHAR(500)
      DECLARE @ManufacId INT
      DECLARE @CustomerCode NVARCHAR(500)
      DECLARE @CustomerName NVARCHAR(500)
      DECLARE @GrossValue DECIMAL(18,2)
      DECLARE @SubmissionDate DATETIME
      DECLARE @IsInvoice INT
      DECLARE @IsManual NVARCHAR(50)
      DECLARE @TerritoryCode NVARCHAR(500)
      DECLARE @CampaignName NVARCHAR(500)
	  DECLARE @OrderSenderType NVARCHAR(500)
	  DECLARE @OrderSenderCode NVARCHAR(500)
	  DECLARE @OrderSenderName NVARCHAR(500)

Declare MY_Order CURSOR FOR

SELECT OrderId ,
      OrderCode ,
      ComUnitId ,
      ComUnitCode ,
      ComUnitName ,
      MIOCode ,
      MIOName ,
      ManufacId ,
      CustomerCode ,
      CustomerName ,
      GrossValue ,
      SubmissionDate ,
      IsInvoice ,
      IsManual ,
      TerritoryCode ,
      CampaignName,
	  OrderSenderType,
	  OrderSenderCode,
	  OrderSenderName FROM dbo.tblOrder WHERE IsInvoice=0 AND OrderCode=@OrderCodeInPut

OPEN MY_Order
    FETCH NEXT FROM MY_Order INTO @OrderId ,
      @OrderCode ,
      @ComUnitId ,
      @ComUnitCode ,
      @ComUnitName ,
      @MIOCode ,
      @MIOName ,
      @ManufacId ,
      @CustomerCode ,
      @CustomerName ,
      @GrossValue ,
      @SubmissionDate ,
      @IsInvoice ,
      @IsManual ,
      @TerritoryCode ,
      @CampaignName,
	  @OrderSenderType,
	  @OrderSenderCode,
	  @OrderSenderName


        WHILE @@FETCH_STATUS = 0
        BEGIN
		--------------------Loop Start 1
		DECLARE @CheckOrderDetailsRowNo INT =0
		DECLARE @CheckOrderStockRowNo INT =0
		SELECT @CheckOrderDetailsRowNo=COUNT(*) FROM dbo.tblOrderDetail WHERE OrderId=@OrderId
          
		  
		   SELECT @CheckOrderStockRowNo=COUNT(D.ProductCode) FROM tblOrderDetail D INNER JOIN dbo.tblOrder O ON O.OrderId = D.OrderId
		   INNER JOIN (SELECT ComUnitId,ProductCode,SUM(StockQty)StockQty FROM dbo.tblDCStore GROUP BY ComUnitId,ProductCode) DC 
		   ON DC.ComUnitId = O.ComUnitId AND DC.ProductCode = D.ProductCode AND DC.StockQty>=D.Quantity
		   WHERE D.OrderId=@OrderId

		   IF(@CheckOrderStockRowNo>0 AND @CheckOrderDetailsRowNo=@CheckOrderStockRowNo)
		   	BEGIN---------------------------------------
            --SELECT * FROM dbo.tblInvoice WHERE InvoiceDate='30-Jun-2020' and DelivaryInvoiceNo IS NULL
			          DECLARE @CustomerMasterId INT
					  DECLARE @FixedCustomer BIT
			          DECLARE @MIACode NVARCHAR(50)
			          DECLARE @MIAName NVARCHAR(50)
			          DECLARE @MarketCode NVARCHAR(50)
			          DECLARE @MarketName NVARCHAR(50)
			          DECLARE @AreaCode NVARCHAR(50)
			          DECLARE @DisCode NVARCHAR(50)
			          DECLARE @FEName NVARCHAR(50)
			          DECLARE @RegionCode NVARCHAR(50)
			          DECLARE @DZSMName NVARCHAR(50)
			          DECLARE @Types NVARCHAR(50)
					  DECLARE @MiaId INT
					   DECLARE @PaymentTypeId INT


					  SELECT  
					  @CustomerMasterId=CustomerMasterId,
					  @FixedCustomer=FixedCustomer ,
			          @MIACode=MIACode ,
			          @MIAName=MIAName ,
			          @MarketCode=MarketCode ,
			          @MarketName=MarketName ,
			          @AreaCode=AreaCode ,
			          @DisCode=DistrictCode ,
			          @FEName=FEName ,
			          @RegionCode=RegionCode ,
			          @DZSMName=DZSMName ,
			          @Types=Type,
					  @MiaId=MiaId ,
					  @PaymentTypeId=1
					  FROM dbo.View_CustomerMaster WHERE CustomerCode=@CustomerCode 

					  DECLARE @InvoiceId INT

					  SELECT @InvoiceId=MAX(InvoiceId)+1 FROM dbo.tblInvoice

			INSERT INTO dbo.tblInvoice
			        ( InvoiceId ,
			          InvoiceNo ,
			          InvoiceDate ,
			          OrderId ,
			          OrderNo ,
			          OrderDate ,
			          CustomerMasterId ,
			          ComUnitId ,
			          MiaId ,
			          PaymentTypeId ,
			          --TpTotal ,
			          --TpDiscount ,
			          --TpVat ,
			          --TpGrandTotal ,
			          UserId ,
			         
			          CreateDate ,
			         
			          TotalSpecialAmount ,
			         
			          ProductOffer ,
			          OldTradePolicy ,
			         
			          FixedCustomer ,
			          MIACode ,
			          MIAName ,
			          MarketCode ,
			          MarketName ,
			          AreaCode ,
			          DisCode ,
			          FEName ,
			          RegionCode ,
			          DZSMName ,
			         
			          Types ,
			         
			          AdjustAmount ,
			          IsAdjustInvoice ,
			          --ReceivableAmount ,
			          
			          
			          
			          CampaignName ,
			          OrderSenderType ,
			          OrderSenderCode ,
			          OrderSenderName
			        )
			VALUES  (  @InvoiceId, -- InvoiceId - int
			          N'' , -- InvoiceNo - nvarchar(max)
			          CONVERT(NVARCHAR(11),GETDATE(),106) , -- InvoiceDate - datetime
			          @OrderId , -- OrderId - int
			          @OrderCode , -- OrderNo - nvarchar(max)
			          @SubmissionDate, -- OrderDate - datetime
			          @CustomerMasterId , -- CustomerMasterId - int
			          @ComUnitId , -- ComUnitId - int
			          @MiaId , -- MiaId - int
			          @PaymentTypeId , -- PaymentTypeId - int
			          --NULL , -- TpTotal - decimal
			          --NULL , -- TpDiscount - decimal
			          --NULL , -- TpVat - decimal
			          --NULL , -- TpGrandTotal - decimal
			          @UserId , -- UserId - int
			         
			          GETDATE() , -- CreateDate - datetime
			         
			          0 , -- TotalSpecialAmount - decimal
			         
			          N'False' , -- ProductOffer - nvarchar(50)
			          N'False' , -- OldTradePolicy - nvarchar(50)
			        
			          @FixedCustomer , -- FixedCustomer - bit
			          @MIACode , -- MIACode - nvarchar(50)
			          @MIAName , -- MIAName - nvarchar(50)
			          @MarketCode , -- MarketCode - nvarchar(50)
			          @MarketName , -- MarketName - nvarchar(50)
			          @AreaCode , -- AreaCode - nvarchar(50)
			          @DisCode , -- DisCode - nvarchar(50)
			          @FEName , -- FEName - nvarchar(50)
			          @RegionCode , -- RegionCode - nvarchar(50)
			          @DZSMName , -- DZSMName - nvarchar(50)
			         
			          @Types , -- Types - nvarchar(50)
			         
			          0 , -- AdjustAmount - decimal
			          0 , -- IsAdjustInvoice - bit
			          --NULL , -- ReceivableAmount - decimal
			        
			          
			          @CampaignName , -- CampaignName - nvarchar(max)
			          @OrderSenderType , -- OrderSenderType - nvarchar(max)
			          @OrderSenderCode , -- OrderSenderCode - nvarchar(max)
			          @OrderSenderName  -- OrderSenderName - nvarchar(max)
			        )


					DECLARE @TableOrderDetail AS TABLE
					(
						ID INT IDENTITY(1,1),
							OrderDetailId INT,
                           ProductId INT,
                           ProductCode NVARCHAR(50),
                           ProductName NVARCHAR(50),
                           Quantity DECIMAL(18,0),
                           TradePrice DECIMAL(18,2),
                           TotalTradePrice DECIMAL(18,2),
                           OrderId INT,
                           OrderListDetailId INT,
                          
                           ISGiftProduct BIT,
                           CampaignType NVARCHAR(500),
                           DiscountPercent DECIMAL(18,2),
                           DiscountAmount DECIMAL(18,2),
                           UnitVatAmount DECIMAL(18,2),
                           TotalVatAmount DECIMAL(18,2),
                           NetAmount DECIMAL(18,2),
                           CampaignName NVARCHAR(500),
                           OrderSenderType NVARCHAR(500),
                           OrderSenderCode NVARCHAR(500),
                           OrderSenderName NVARCHAR(500)
						);


						INSERT INTO @TableOrderDetail
					    SELECT OrderDetailId ,
                           ProductId ,
                           ProductCode ,
                           ProductName ,
                           Quantity ,
                           TradePrice ,
                           TotalTradePrice ,
                           OrderId ,
                           OrderListDetailId ,
                          
                           ISGiftProduct ,
                           CampaignType ,
                           DiscountPercent ,
                           DiscountAmount ,
                           UnitVatAmount ,
                           TotalVatAmount ,
                           NetAmount ,
                           CampaignName ,
                           OrderSenderType ,
                           OrderSenderCode ,
                           OrderSenderName FROM dbo.tblOrderDetail	WHERE OrderId=@OrderId

						   DECLARE @CurrentIndex_OrderDetail  INT = 1;
						   DECLARE @TotalCount_OrderDetail  INT;

SELECT @TotalCount_OrderDetail = MAX(ID)
FROM @TableOrderDetail


WHILE(@TotalCount_OrderDetail >= @CurrentIndex_OrderDetail)
BEGIN---OrderDetail loop start


DECLARE @ProductCode NVARCHAR(50)
	DECLARE @ProductName NVARCHAR(50)
	DECLARE @CampaignName_D NVARCHAR(50)
	DECLARE @ISGiftProduct_D NVARCHAR(50)
	DECLARE @CampaignType_D NVARCHAR(50)
	DECLARE @OrderSenderName_D NVARCHAR(50)
            SELECT @ProductCode=ProductCode,@ProductName=ProductName,@CampaignName_D=CampaignName ,
                           @ISGiftProduct_D=ISGiftProduct ,
                           @CampaignType_D=CampaignType FROM @TableOrderDetail WHERE ID=@CurrentIndex_OrderDetail

Declare @DCStoreId as INT
Declare @PackSize as nvarchar(300)
Declare @BatchNo as nvarchar(200)
DECLARE @ExpDate DATETIME
Declare @StockQty as DECIMAL(18,0)
DECLARE @MfgDate DATETIME
DECLARE @StockRcvDate DATETIME

Declare MY_data CURSOR FOR

SELECT DCStoreId,PackSize,BatchNo,ExpDate,StockQty,MfgDate,StockRcvDate FROM dbo.tblDCStore WHERE ProductCode=@ProductCode AND StockQty>0 AND ComUnitId=@ComUnitId

OPEN MY_data
    FETCH NEXT FROM MY_data INTO @DCStoreId,@PackSize,@BatchNo,@ExpDate,@StockQty,@MfgDate,@StockRcvDate
        WHILE @@FETCH_STATUS = 0
        BEGIN----- MY_data start

		DECLARE @QuantityMain DECIMAL(18,0)
		DECLARE @Quantity DECIMAL(18,0)
		DECLARE @OrderDetailId INT
		DECLARE @UnitPrice  DECIMAL(18,2)
		 DECLARE @UnitVatAmount  DECIMAL(18,2)
		  DECLARE @DiscountPercent  DECIMAL(18,2)
		  DECLARE @DiscountAmount  DECIMAL(18,2)


            SELECT @QuantityMain=Quantity,@Quantity=Quantity,@OrderDetailId=OrderDetailId,@UnitPrice=TradePrice,@UnitVatAmount=UnitVatAmount,@DiscountPercent=DiscountPercent ,
			@DiscountAmount=DiscountAmount
			 FROM @TableOrderDetail WHERE ID=@CurrentIndex_OrderDetail
			IF(@Quantity>0 AND @StockQty>@Quantity)	
			BEGIN
			UPDATE tblDCStore SET StockQty=(@StockQty-@Quantity) WHERE DCStoreId=@DCStoreId
			-------------------

			INSERT INTO dbo.tblInvoiceDetail
						           ( InvoiceDetailId ,
						             ProductCode ,
						             ProductName ,
						             PackSize ,
						             BatchNo ,
						             ReceiveDate ,
						             ExpDate ,
						             CostPrice ,
						             UnitPrice ,
						             UnitVatAmount ,
						             Quantity ,
						             BonusQuantity ,
						             TotalQuantity ,
						             TotalPrice ,
						             TotalPriceVatAmount ,
						             DiscountPercentage ,
						             DiscountAmount ,
						             NetAmount ,
						             InvoiceId ,
						             DCStoreId ,
						         
						             OrderDetailsId ,
						             SpecialAmount ,
						            
						             Campaign ,
						             ISGiftProduct ,
						             CampaignType
						           )
						   VALUES  ( (SELECT MAX(InvoiceDetailId)+1 FROM dbo.tblInvoiceDetail) , -- InvoiceDetailId - int
						             @ProductCode , -- ProductCode - nvarchar(max)
						             @ProductName , -- ProductName - nvarchar(max)
						             @PackSize , -- PackSize - nvarchar(max)
						             @BatchNo , -- BatchNo - nvarchar(max)
						             @StockRcvDate , -- ReceiveDate - datetime
						             @ExpDate , -- ExpDate - datetime
						             @UnitPrice , -- CostPrice - decimal
						             @UnitPrice , -- UnitPrice - decimal
						             @UnitVatAmount , -- UnitVatAmount - decimal
						             @Quantity , -- Quantity - decimal
						             0 , -- BonusQuantity - decimal
						             @Quantity , -- TotalQuantity - decimal
						             @Quantity*@UnitPrice , -- TotalPrice - decimal
						             @Quantity*@UnitVatAmount , -- TotalPriceVatAmount - decimal
						             @DiscountPercent , -- DiscountPercentage - decimal
						             (@DiscountAmount/@QuantityMain)*@Quantity , -- DiscountAmount - decimal
						             ((@Quantity*@UnitPrice)-((@DiscountAmount/@QuantityMain)*@Quantity))+(@Quantity*@UnitVatAmount) , -- NetAmount - decimal
						             @InvoiceId , -- InvoiceId - int
						             @DCStoreId , -- DCStoreId - int
						            
						             @OrderDetailId , -- OrderDetailsId - int
						             0 , -- SpecialAmount - decimal
						             
						             @CampaignName_D , -- Campaign - nvarchar(500)
						             @ISGiftProduct_D , -- ISGiftProduct - bit
						             @CampaignType_D  -- CampaignType - nvarchar(max)
						           )


			-----------------
			SET @Quantity=0
			end
			IF(@Quantity>0 AND @Quantity>=@StockQty)	
			BEGIN
			UPDATE tblDCStore SET StockQty=0 WHERE DCStoreId=@DCStoreId

			-------------------

			INSERT INTO dbo.tblInvoiceDetail
						           ( InvoiceDetailId ,
						             ProductCode ,
						             ProductName ,
						             PackSize ,
						             BatchNo ,
						             ReceiveDate ,
						             ExpDate ,
						             CostPrice ,
						             UnitPrice ,
						             UnitVatAmount ,
						             Quantity ,
						             BonusQuantity ,
						             TotalQuantity ,
						             TotalPrice ,
						             TotalPriceVatAmount ,
						             DiscountPercentage ,
						             DiscountAmount ,
						             NetAmount ,
						             InvoiceId ,
						             DCStoreId ,
						         
						             OrderDetailsId ,
						             SpecialAmount ,
						            
						             Campaign ,
						             ISGiftProduct ,
						             CampaignType
						           )
						   VALUES  ( (SELECT MAX(InvoiceDetailId)+1 FROM dbo.tblInvoiceDetail) , -- InvoiceDetailId - int
						             @ProductCode , -- ProductCode - nvarchar(max)
						             @ProductName , -- ProductName - nvarchar(max)
						             @PackSize , -- PackSize - nvarchar(max)
						             @BatchNo , -- BatchNo - nvarchar(max)
						             @StockRcvDate , -- ReceiveDate - datetime
						             @ExpDate , -- ExpDate - datetime
						             @UnitPrice , -- CostPrice - decimal
						             @UnitPrice , -- UnitPrice - decimal
						             @UnitVatAmount , -- UnitVatAmount - decimal
						             @Quantity , -- Quantity - decimal
						             0 , -- BonusQuantity - decimal
						             @StockQty , -- TotalQuantity - decimal
						             @StockQty*@UnitPrice , -- TotalPrice - decimal
						             @StockQty*@UnitVatAmount , -- TotalPriceVatAmount - decimal
						             @DiscountPercent , -- DiscountPercentage - decimal
						             (@DiscountAmount/@QuantityMain)*@StockQty , -- DiscountAmount - decimal
						             ((@StockQty*@UnitPrice)-((@DiscountAmount/@QuantityMain)*@StockQty))+(@StockQty*@UnitVatAmount) , -- NetAmount - decimal
						             @InvoiceId , -- InvoiceId - int
						             @DCStoreId , -- DCStoreId - int
						            
						             @OrderDetailId , -- OrderDetailsId - int
						             0 , -- SpecialAmount - decimal
						             
						             @CampaignName_D , -- Campaign - nvarchar(500)
						             @ISGiftProduct_D , -- ISGiftProduct - bit
						             @CampaignType_D  -- CampaignType - nvarchar(max)
						           )


			-----------------


			SET @Quantity=@Quantity-@StockQty
			end


        FETCH NEXT FROM MY_data INTO @DCStoreId,@PackSize,@BatchNo,@ExpDate,@StockQty,@MfgDate,@StockRcvDate
        END----- MY_data End
    CLOSE MY_data
DEALLOCATE MY_data







--SELECT * FROM tblInvoiceDetail WHERE InvoiceId=258758


SET @CurrentIndex_OrderDetail=@CurrentIndex_OrderDetail+1
END---OrderDetail loop start


						   

			END-----------------
            



		--------------------Loop End 1
        FETCH NEXT FROM MY_Order INTO  @OrderId,
		@OrderCode ,
      @ComUnitId ,
      @ComUnitCode ,
      @ComUnitName ,
      @MIOCode ,
      @MIOName ,
      @ManufacId ,
      @CustomerCode ,
      @CustomerName ,
      @GrossValue ,
      @SubmissionDate ,
      @IsInvoice ,
      @IsManual ,
      @TerritoryCode ,
      @CampaignName,
	  @OrderSenderType,
	  @OrderSenderCode,
	  @OrderSenderName
        END
    CLOSE MY_Order
DEALLOCATE MY_Order
END
