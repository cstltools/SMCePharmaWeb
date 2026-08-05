


CREATE PROCEDURE [dbo].[sp_Process_SubDepoProformaInvoiceByOrderId] 

 @OrderId INT,
 @UserId INT,
 @BatchNo1 NVARCHAR(MAX)

AS
BEGIN

DECLARE @NegativeQtyCount INT=0
DECLARE @CreditAmount DECIMAL(18,2)=0

--SELECT FROM dbo.tblOrder
--LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
--LEFT JOIN (SELECT ProductCode,ComUnitId,SUM(StockQty)Qty FROM dbo.tblSubDepotStore GROUP BY ProductCode,ComUnitId)
--AS tblt ON tblt.ProductCode = tblOrderDetail.ProductCode AND tblt.ComUnitId = tblOrder.ComUnitId
--WHERE tblt.Qty-Quantity<0 AND tblOrder.OrderId=@OrderId

SELECT @NegativeQtyCount=COUNT(*)  FROM (SELECT tblt.Qty,ProductId,SUM(Quantity)AS OrdQty FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
LEFT JOIN (SELECT ProductCode,SUM(StockQty)Qty FROM dbo.tblSubDepotStore GROUP BY ProductCode)
AS tblt ON tblt.ProductCode = tblOrderDetail.ProductCode 
WHERE  tblOrder.OrderId=@OrderId GROUP BY tblt.Qty,ProductId) AS tblt WHERE tblt.Qty-tblt.OrdQty<0 


SELECT @CreditAmount=ISNULL(SUM(Amount),0) FROM [dbo].[tblReturnAmount]

IF(@NegativeQtyCount<1 AND @CreditAmount=0)
BEGIN
    

	
		   DECLARE @InvoiceId INT
           DECLARE @InvoiceNo NVARCHAR(MAX)
           DECLARE @InvoiceDate DATETIME
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

	
	SELECT ODR.OrderId,ODR.OrderCode,ODR.SubmissionDate,ODR.CustomerMasterId,ODR.ComUnitId,ODR.MIOId,ODRD.TpTotal,
	ODRD.TpDiscount,ODRD.TpVat,ODRD.TpGrandTotal,ODRD.TotalSpecialAmount,ODR.FixedCustomer,ODR.MIOCode,ODR.MIOName, 
	dbo.tblMarket.MarketCode
	--null
           ,
		   dbo.tblMarket.MarketName
		   --null
		   ,
		   --CV.AreaCode
		   null
           
           ,
		   --CV.ASMEmpMasterCode
		   null
		   ,
		   --CV.ASMEmpName
		   null
           ,
		   --CV.RegionCode
		   null
           ,
		   --CV.RSMEmpName
		   null
		   ,
		   tblCustomerType.CustomerType
		   --null
		   ,
		    --CV.GreenStarBlueStarID
			null
			,
			tblProgramType.ProgramTypeName
			--null 
			FROM tblOrder AS ODR
			
	--INNER JOIN (SELECT CustomerMasterId,FixedCustomer,CustomerCode,
           
 --          MarketCode
 --          ,MarketName
 --          ,AreaCode,ASMEmpMasterCode
 --          ,RSMEmpName
 --          ,ASMEmpName
 --          ,RegionCode
           
	--	   ,Type
 --          ,CASE WHEN (ProgramTypeId = '1' OR ProgramTypeId = '2') THEN CustomerMasterId END GreenStarBlueStarID
 --          ,CustomerType FROM View_CustomerMaster) AS CV ON ODR.CustomerCode = CV.CustomerCode
		   INNER JOIN (SELECT OrderId,SUM(TotalTradePrice) AS TpTotal,
		   
		   SUM(DiscountAmount) AS TpDiscount,
		   SUM(TotalVatAmount) AS TpVat,
		   SUM(NetAmount) AS TpGrandTotal,
		   0.00 AS TotalSpecialAmount
		   FROM dbo.tblOrderDetail GROUP BY OrderId) AS ODRD ON ODRD.OrderId = ODR.OrderId
		   left join tblCustomerType on ODR.CustTypeId=tblCustomerType.CustomerTypeId
		   left join tblProgramType on ODR.ProgramTypeId=tblProgramType.ProgramTypeId
		   LEFT JOIN dbo.tblMarket ON ODR.MarketId=dbo.tblMarket.MarketId
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

	--Invoice Master
	DECLARE @LastNo NVARCHAR(MAX)=''
	DECLARE @ComUnitCode NVARCHAR(MAX)=''

	SELECT @ComUnitCode=ComUnitCode FROM dbo.tblCompanyUnit WHERE ComUnitId=6

	SELECT @InvoiceId = isnull(MAX(InvoiceId),0)+1 FROM dbo.tblSubInvoiceMaster
	SELECT @InvoiceNo =  'S-INV-BD23-00' + CONVERT(varchar(10), isnull(MAX(InvoiceId),0)+1) FROM dbo.tblSubInvoiceMaster
	IF(LEN(@InvoiceId)=1)
	BEGIN
	    SET @LastNo='000000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=2)
	BEGIN
	    SET @LastNo='00000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=3)
	BEGIN
	    SET @LastNo='0000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=4)
	BEGIN
	    SET @LastNo='000000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=5)
	BEGIN
	    SET @LastNo='00000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=6)
	BEGIN
	    SET @LastNo='0000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=7)
	BEGIN
	    SET @LastNo='000'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=8)
	BEGIN
	    SET @LastNo='00'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	IF(LEN(@InvoiceId)=9)
	BEGIN
	    SET @LastNo='0'+CONVERT(NVARCHAR(MAX),@InvoiceId)
	END
	SET @InvoiceNo='S-INV-'+@ComUnitCode+@LastNo


	INSERT INTO tblSubInvoiceMaster
           (InvoiceId
           ,InvoiceNo
           ,InvoiceDate
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
           --,Types
           --,GreenStarBlueStarID
           ,CustomerType)
           
     VALUES
           ( @InvoiceId, -- InvoiceId - int
			 @InvoiceNo, -- InvoiceNo - nvarchar(max)
			 CONVERT(NVARCHAR(11),GETDATE(),106)  -- InvoiceDate - datetime
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
           --,@Types
           --,@GreenStarBlueStarID
           ,@CustomerType)
    
	--Invoice Detail

		   DECLARE @InvoiceDetailId INT
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
				SELECT @InvoiceDetailId=ISNULL(MAX(InvoiceDetailId),0)+1 FROM dbo.tblSubInvoiceDetail
			    
				DECLARE @StockQ INT=0

				SELECT TOP 1 @StockQ=StockQty,@DCStoresId=SubDCStoreId FROM dbo.tblSubDepotStore WHERE ProductCode=@ProductCode AND StockQty<>0 ORDER BY ExpDate DESC

				IF(@StockQ>0)
				BEGIN
				IF(@StockQ>=@MainQty)
				BEGIN
				   --SET @MainQty=0
				   INSERT INTO dbo.tblSubDepotStoreTransaction
				   (
				       DCStoreId,
				       Date,
				       Id,
				       Type,
				       Quantity
				   )
				   VALUES
				   (   @DCStoresId,         -- DCStoreId - int
				       GETDATE(), -- Date - datetime
				       @InvoiceDetailId,         -- Id - int
				       N'ProformaInvoice',       -- Type - nvarchar(50)
				       -@MainQty       -- Quantity - decimal(18, 0)
				       )
				   UPDATE dbo.tblSubDepotStore SET StockQty=StockQty-@MainQty WHERE SubDCStoreId=@DCStoresId

				   			INSERT INTO tblSubInvoiceDetail
           (InvoiceDetailId
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
           ,InvoiceId
           ,SubDCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           (@InvoiceDetailId
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
           ,@InvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)





				    SET @MainQty=0
				END
				ELSE
                BEGIN
                    SET @MainQty=@MainQty-@StockQ
					INSERT INTO dbo.tblSubDepotStoreTransaction
				   (
				       DCStoreId,
				       Date,
				       Id,
				       Type,
				       Quantity
				   )
				   VALUES
				   (   @DCStoresId,         -- DCStoreId - int
				       GETDATE(), -- Date - datetime
				       @InvoiceDetailId,         -- Id - int
				       N'ProformaInvoice',       -- Type - nvarchar(50)
				       -@MainQty       -- Quantity - decimal(18, 0)
				       )
					UPDATE dbo.tblSubDepotStore SET StockQty=0 WHERE SubDCStoreId=@DCStoresId

								INSERT INTO tblSubInvoiceDetail
           (InvoiceDetailId
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
           ,InvoiceId
           ,SubDCStoreId
           ,OrderDetailsId
           ,SpecialAmount
           ,Campaign
           ,ISGiftProduct
           ,CampaignType
           ,IsCampaignProduct)
     VALUES
           ((SELECT ISNULL(MAX(InvoiceDetailId),0)+1 FROM dbo.tblSubInvoiceDetail)
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
           ,@InvoiceId
           ,@DCStoresId
           ,@OrderDetailsId
           ,@SpecialAmount
           ,@Campaign
           ,@ISGiftProduct
           ,@CampaignType
           ,@IsCampaignProduct)




                END
				END
				ELSE
                BEGIN
				SET @MainQty=0
				BREAK
                

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
    
    
    CLOSE @MyCursor
    DEALLOCATE @MyCursor

	INSERT INTO dbo.tblSubInvoiceMasterBatch
	(
	    BatchNo,
	    Date,
	    InvoiceId
	)
	VALUES
	(   @BatchNo1,         -- BatchNo - int
	    GETDATE(), -- Date - datetime
	    @InvoiceId          -- InvoiceId - int
	    )


	END
	
END


	--SELECT TOP 2 * FROM dbo.tblSubInvoiceMaster ORDER BY InvoiceId DESC

	--SELECT * FROM dbo.tblSubInvoiceDetail WHERE InvoiceId IN (479437,479436)
