

CREATE PROCEDURE [dbo].[sp_Process_ProformaSampleInvoiceByOrderId] 

 @OrderId INT,
 @UserId INT

AS
BEGIN

DECLARE @NegativeQtyCount INT=0

SELECT @NegativeQtyCount=COUNT(*) FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
LEFT JOIN (SELECT ProductCode,SUM(StockQty)Qty FROM dbo.tblDCStore GROUP BY ProductCode) AS tblt ON tblt.ProductCode = tblOrderDetail.ProductCode
WHERE tblt.Qty-Quantity<0 AND tblOrder.OrderId=@OrderId
IF(@NegativeQtyCount<1)
BEGIN
    

	
		   DECLARE @SampleInvoiceId INT
           DECLARE @SampleInvoiceNo NVARCHAR(MAX)
           DECLARE @SampleInvoiceDate DATETIME
           DECLARE @OrderNo NVARCHAR(MAX)
           DECLARE @OrderDate DATETIME
           DECLARE @CustomerMasterId INT
           DECLARE @ComUnitId INT
           DECLARE @MiaId INT
           DECLARE @PaymentTypeId INT
           DECLARE @TpTotal DECIMAL(18,2)
           DECLARE @TpDiscount DECIMAL(18,2)
           DECLARE @TpVat DECIMAL(18,2)
           DECLARE @TpGrandTotal DECIMAL(18,2)
           DECLARE @TotalSpecialAmount DECIMAL(18,2)
           DECLARE @ProductOffer BIT
           DECLARE @OldTradePolicy BIT
           DECLARE @FixedCustomer BIT
           DECLARE @MIACode NVARCHAR(MAX)
           DECLARE @MIAName NVARCHAR(MAX)
           DECLARE @MarketCode NVARCHAR(MAX)
           DECLARE @MarketName NVARCHAR(MAX)
           DECLARE @AreaCode NVARCHAR(MAX)
           DECLARE @DisCode NVARCHAR(MAX)
           DECLARE @FEName NVARCHAR(MAX)
           DECLARE @RegionCode NVARCHAR(MAX)
           DECLARE @DZSMName NVARCHAR(MAX)
           DECLARE @Types NVARCHAR(MAX)
           DECLARE @GreenStarBlueStarID INT
           DECLARE @CustomerType NVARCHAR(MAX)

            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT ODR.OrderId,ODR.OrderCode,ODR.SubmissionDate,CV.CustomerMasterId,ODR.ComUnitId,CV.MiaId,ODRD.TpTotal,
	ODRD.TpDiscount,ODRD.TpVat,ODRD.TpGrandTotal,ODRD.TotalSpecialAmount,CV.FixedCustomer,CV.MIACode,CV.MIAName, CV.MarketCode
           ,CV.MarketName,CV.AreaCode
           ,CV.DistrictCode
           ,CV.FEName
           ,CV.RegionCode
           ,CV.DZSMName
		   ,CV.Type,
		    CV.GreenStarBlueStarID,CV.CustomerType FROM tblOrder AS ODR
	INNER JOIN (SELECT CustomerMasterId,FixedCustomer,CustomerCode,
           MIACode,
		   MiaId
           ,MIAName
           ,MarketCode
           ,MarketName
           ,AreaCode
           ,DistrictCode
           ,FEName
           ,RegionCode
           ,DZSMName
		   ,Type
           ,CASE WHEN (Type = 'Green Star' OR Type = 'Blue Star') THEN CustomerMasterId END GreenStarBlueStarID
           ,CustomerType FROM View_CustomerMaster) AS CV ON ODR.CustomerCode = CV.CustomerCode
		   INNER JOIN (SELECT OrderId,SUM(TotalTradePrice) AS TpTotal,
		   SUM(DiscountAmount) AS TpDiscount,
		   SUM(TotalVatAmount) AS TpVat,
		   SUM(NetAmount) AS TpGrandTotal,
		   0.00 AS TotalSpecialAmount
		   FROM dbo.tblOrderDetail GROUP BY OrderId) AS ODRD ON ODRD.OrderId = ODR.OrderId
		   WHERE ODR.IsInvoice = 0 AND ODR.OrderId = @OrderId


    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO   @OrderId,
           @OrderNo ,
           @OrderDate ,
           @CustomerMasterId ,
           @ComUnitId ,
           @MiaId ,
           @TpTotal ,
           @TpDiscount ,
           @TpVat ,
           @TpGrandTotal ,
           @TotalSpecialAmount ,
           @FixedCustomer ,
           @MIACode ,
           @MIAName ,
           @MarketCode ,
           @MarketName ,
           @AreaCode ,
           @DisCode ,
           @FEName ,
           @RegionCode ,
           @DZSMName ,
           @Types ,
           @GreenStarBlueStarID ,
           @CustomerType 
    
    WHILE @@FETCH_STATUS = 0
    BEGIN

	--SampleInvoice Master

	SELECT @SampleInvoiceId = ISNULL(MAX(SampleInvoiceId),0)+1 FROM dbo.tblSampleInvoice
	SELECT @SampleInvoiceNo =  'INV-BD23-00' + CONVERT(varchar(10), ISNULL(MAX(SampleInvoiceId),0)+1) FROM dbo.tblSampleInvoice


	INSERT INTO tblSampleInvoice
           (SampleInvoiceId
           ,SampleInvoiceNo
           ,SampleInvoiceDate
           ,OrderId
           ,OrderNo
           ,OrderDate
           ,CustomerMasterId
           ,ComUnitId
           ,MiaId
           ,PaymentTypeId
           ,TpTotal
           ,TpDiscount
           ,TpVat
           ,TpGrandTotal
           ,UserId
           ,CreateDate
           ,TotalSpecialAmount 
           ,ProductOffer
           ,OldTradePolicy
           ,FixedCustomer
           ,MIACode
           ,MIAName
           ,MarketCode
           ,MarketName
           ,AreaCode
           ,DisCode
           ,FEName
           ,RegionCode
           ,DZSMName
           ,Types
           ,GreenStarBlueStarID
           ,CustomerType)
           
     VALUES
           ( @SampleInvoiceId, -- SampleInvoiceId - int
			 @SampleInvoiceNo, -- SampleInvoiceNo - nvarchar(max)
			 CONVERT(NVARCHAR(11),GETDATE(),106)  -- SampleInvoiceDate - datetime
           ,@OrderId
           ,@OrderNo
           ,@OrderDate
           ,@CustomerMasterId
           ,@ComUnitId
           ,@MiaId
           ,1
           ,@TpTotal
           ,@TpDiscount
           ,@TpVat
           ,@TpGrandTotal
           ,@UserId
           ,CONVERT(NVARCHAR(11),GETDATE(),106)
           ,@TotalSpecialAmount 
           , N'False' , -- ProductOffer - nvarchar(50)
			 N'False'  -- OldTradePolicy - nvarchar(50)
           ,@FixedCustomer
           ,@MIACode
           ,@MIAName
           ,@MarketCode
           ,@MarketName
           ,@AreaCode
           ,@DisCode
           ,@FEName
           ,@RegionCode
           ,@DZSMName
           ,@Types
           ,@GreenStarBlueStarID
           ,@CustomerType)
    
	--SampleInvoice Detail

		   DECLARE @SampleInvoiceDetailId INT
           DECLARE @ProductCode NVARCHAR(MAX)
           DECLARE @ProductName NVARCHAR(MAX)
           DECLARE @PackSize NVARCHAR(MAX)
           DECLARE @BatchNo NVARCHAR(MAX)
           DECLARE @ReceiveDate DATETIME
           DECLARE @ExpDate NVARCHAR(MAX)
           DECLARE @CostPrice DECIMAL(18,2)
           DECLARE @UnitPrice DECIMAL(18,2)
           DECLARE @UnitVatAmount DECIMAL(18,2)
           DECLARE @Quantity DECIMAL(18,2)
           DECLARE @BonusQuantity DECIMAL(18,2)
           DECLARE @TotalQuantity DECIMAL(18,2)
           DECLARE @TotalPrice DECIMAL(18,2)
           DECLARE @TotalPriceVatAmount DECIMAL(18,2)
           DECLARE @DiscountPercentage DECIMAL(18,2)
           DECLARE @DiscountAmount DECIMAL(18,2)
           DECLARE @NetAmount DECIMAL(18,2)
           DECLARE @DCStoreId INT
           DECLARE @OrderDetailsId INT
           DECLARE @SpecialAmount DECIMAL(18,2)
		   DECLARE @Campaign NVARCHAR(MAX)
           DECLARE @ISGiftProduct BIT
           DECLARE @CampaignType NVARCHAR(MAX)
           DECLARE @IsCampaignProduct BIT
			        
			--------------------------------------------------------
			DECLARE @MyCursor2 CURSOR
			SET @MyCursor2 = CURSOR FAST_FORWARD
			FOR
			---------------

			SELECT PD.ProductCode
           ,PD.ProductName
           ,PD.PackSize
		   ,1
           ,'2018-10-01 00:00:00.000'
           ,'2020-01-31 00:00:00.000',CostPrice
           ,UnitPrice
           ,UnitVatAmount
		   ,Quantity
           ,0
           ,Quantity
           ,OD.TradePrice
           ,OD.TotalVatAmount
           ,OD.DiscountPercent
           ,DiscountAmount
           ,NetAmount
           ,270
		   ,OD.OrderDetailId
		   ,0
		   ,NULL
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct FROM tblOrderDetail AS OD
			LEFT JOIN dbo.tblProduct AS PD ON PD.ProductCode = OD.ProductCode
			LEFT JOIN dbo.tblUnitPrice AS UP ON UP.ProductCode = OD.ProductCode
			WHERE OrderId = @OrderId AND UP.IsActive = 1
			----------
			OPEN @MyCursor2
			FETCH NEXT FROM @MyCursor2
			INTO  @ProductCode ,
            @ProductName ,
            @PackSize ,
            @BatchNo ,
            @ReceiveDate ,
            @ExpDate ,
            @CostPrice ,
            @UnitPrice ,
            @UnitVatAmount ,
            @Quantity ,
            @BonusQuantity ,
            @TotalQuantity ,
            @TotalPrice ,
            @TotalPriceVatAmount ,
            @DiscountPercentage ,
            @DiscountAmount ,
            @NetAmount ,
            @DCStoreId ,
            @OrderDetailsId ,
            @SpecialAmount ,
		    @Campaign ,
            @ISGiftProduct ,
            @CampaignType ,
            @IsCampaignProduct 
			
			WHILE @@FETCH_STATUS = 0
			BEGIN


			DECLARE @MainQty INT=0
			DECLARE @DCStoresId INT=0

			SET @MainQty=@Quantity

			WHILE (@MainQty>0)
			BEGIN
			    
				DECLARE @StockQ INT=0

				SELECT TOP 1 @StockQ=StockQty,@DCStoresId=DCStoreId FROM dbo.tblDCStore WHERE ProductCode=@ProductCode AND StockQty<>0 ORDER BY ExpDate DESC


				IF(@StockQ>=@MainQty)
				BEGIN
				   SET @MainQty=0

				   UPDATE dbo.tblDCStore SET StockQty=StockQty-@MainQty WHERE DCStoreId=@DCStoresId

				   			INSERT INTO tblSampleInvoiceDetail
           (SampleInvoiceDetailId
           ,ProductCode
           ,ProductName
           ,PackSize
           ,BatchNo
           ,ReceiveDate
           ,ExpDate
           ,CostPrice
           ,UnitPrice
           ,UnitVatAmount
           ,Quantity
           ,BonusQuantity
           ,TotalQuantity
           ,TotalPrice
           ,TotalPriceVatAmount
           ,DiscountPercentage
           ,DiscountAmount
           ,NetAmount
           ,SampleInvoiceId
           ,DCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           ((SELECT MAX(SampleInvoiceDetailId)+1 FROM dbo.tblSampleInvoiceDetail)
           ,@ProductCode
           ,@ProductName
           ,@PackSize
           ,@BatchNo
           ,@ReceiveDate
           ,@ExpDate
           ,@CostPrice
           ,@UnitPrice
           ,@UnitVatAmount
           ,@MainQty
           ,@BonusQuantity
           ,@MainQty
           ,@TotalPrice
           ,@TotalPriceVatAmount
           ,@DiscountPercentage
           ,@DiscountAmount
           ,@NetAmount
           ,@SampleInvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)





				    
				END
				ELSE
                BEGIN
                    SET @MainQty=@MainQty-@StockQ

					UPDATE dbo.tblDCStore SET StockQty=0 WHERE DCStoreId=@DCStoresId

								INSERT INTO tblSampleInvoiceDetail
           (SampleInvoiceDetailId
           ,ProductCode
           ,ProductName
           ,PackSize
           ,BatchNo
           ,ReceiveDate
           ,ExpDate
           ,CostPrice
           ,UnitPrice
           ,UnitVatAmount
           ,Quantity
           ,BonusQuantity
           ,TotalQuantity
           ,TotalPrice
           ,TotalPriceVatAmount
           ,DiscountPercentage
           ,DiscountAmount
           ,NetAmount
           ,SampleInvoiceId
           ,DCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           ((SELECT MAX(SampleInvoiceDetailId)+1 FROM dbo.tblSampleInvoiceDetail)
           ,@ProductCode
           ,@ProductName
           ,@PackSize
           ,@BatchNo
           ,@ReceiveDate
           ,@ExpDate
           ,@CostPrice
           ,@UnitPrice
           ,@UnitVatAmount
           ,@StockQ
           ,@BonusQuantity
           ,@StockQ
           ,@TotalPrice
           ,@TotalPriceVatAmount
           ,@DiscountPercentage
           ,@DiscountAmount
           ,@NetAmount
           ,@SampleInvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)




                END


			END


			








			
			
			                                   
			
			
			FETCH NEXT FROM @MyCursor2
			INTO  @ProductCode ,
            @ProductName ,
            @PackSize ,
            @BatchNo ,
            @ReceiveDate ,
            @ExpDate ,
            @CostPrice ,
            @UnitPrice ,
            @UnitVatAmount ,
            @Quantity ,
            @BonusQuantity ,
            @TotalQuantity ,
            @TotalPrice ,
            @TotalPriceVatAmount ,
            @DiscountPercentage ,
            @DiscountAmount ,
            @NetAmount ,
            @DCStoreId ,
            @OrderDetailsId ,
            @SpecialAmount ,
		    @Campaign ,
            @ISGiftProduct ,
            @CampaignType ,
            @IsCampaignProduct 
			
			END
			CLOSE @MyCursor2
			DEALLOCATE @MyCursor2

    --Detail END
	                                   
	END


	UPDATE dbo.tblOrder SET IsInvoice = 1 WHERE OrderId = @OrderId
	
    FETCH NEXT FROM @MyCursor
    INTO   @OrderId,
           @OrderNo ,
           @OrderDate ,
           @CustomerMasterId ,
           @ComUnitId ,
           @MiaId ,
           @TpTotal ,
           @TpDiscount ,
           @TpVat ,
           @TpGrandTotal ,
           @TotalSpecialAmount ,
           @FixedCustomer ,
           @MIACode ,
           @MIAName ,
           @MarketCode ,
           @MarketName ,
           @AreaCode ,
           @DisCode ,
           @FEName ,
           @RegionCode ,
           @DZSMName ,
           @Types ,
           @GreenStarBlueStarID ,
           @CustomerType 
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END


	--SELECT TOP 2 * FROM dbo.tblSampleInvoice ORDER BY SampleInvoiceId DESC

	--SELECT * FROM dbo.tblSampleInvoiceDetail WHERE SampleInvoiceId IN (479437,479436)