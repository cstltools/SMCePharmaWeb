
CREATE
 PROCEDURE [dbo].[sp_webapi_SaveOrderCampaign]
	-- Add the parameters for the stored procedure here
@orderid INT,
@campaignMasterId INT

AS
BEGIN

DECLARE @CustomerId INT=0
DECLARE @CustomerTypeId INT =0 
DECLARE @CountData INT=0

SELECT @CustomerId=tblCustMaster.CustomerMasterId,@CustomerTypeId=CustomerTypeId FROM dbo.tblOrder
LEFT JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblOrder.CustomerMasterId
 WHERE OrderId=@orderid

 SELECT @CountData=COUNT(*) FROM dbo.GetCampaignCustomer(@CustomerTypeId) WHERE CustomerId=@CustomerId
 IF(@CountData>0)
 BEGIN
     

	 DECLARE @OrderCode NVARCHAR(MAX)=NULL
	 DECLARE @OrderProductId INT=0
	 DECLARE @OrderDetailId INT=0
	 DECLARE @OrderMasterId INT=0
	 DECLARE @Qty DECIMAL(18,0)=0
	 DECLARE @TradePrice DECIMAL(18,2)=0
	 DECLARE @TotalTradePrice DECIMAL(18,2)=0

	 DECLARE @Main CURSOR
     SET @Main = CURSOR FAST_FORWARD
     FOR

	 SELECT OrderCode,ProductId,OrderDetailId,tblOrder.OrderId,Quantity,TradePrice,TotalTradePrice FROM dbo.tblOrder
	 LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
	 WHERE tblOrder.OrderId=@orderid

	 OPEN @Main
     FETCH NEXT FROM @Main
     INTO @OrderCode,@OrderProductId,@OrderDetailId,@OrderMasterId,@Qty,@TradePrice,@TotalTradePrice
         
    WHILE @@FETCH_STATUS=0
    BEGIN

	DECLARE @CampaignCode NVARCHAR(MAX)=NULL
	 DECLARE @CampaignTypeId INT=0
	 DECLARE @Amount DECIMAL(18,2)=0
	 DECLARE @MaxAmount DECIMAL(18,2)=0
	 DECLARE @ProQty DECIMAL(18,0)=0
	 DECLARE @IsTradePolicy BIT
     DECLARE @BonusProductId INT=0
	 DECLARE @DisPercentage DECIMAL(18,0)=0
	 DECLARE @DisAmount DECIMAL(18,0)=0
	 DECLARE @ProductId INT=0
	 DECLARE @BonusQty DECIMAL(18,0)=0
	 DECLARE @BonusTypeId INT=0

	


	SELECT @CampaignCode=ISNULL(CampaignCode,''),@CampaignTypeId=CampainTypeId,@Amount=Amount,@MaxAmount=tbl_BonusCampaignNewMaster.MaxAmount
	,@ProQty=Quantity,@IsTradePolicy=IsTradePolicy,@BonusProductId=tbl_BonusCampaignNewDetail.BonusProductId
	,@DisPercentage=DiscountPercentage,@ProductId=ProductId,@BonusQty=BonusQuantity,@BonusTypeId=BonusTypeId,@DisAmount=DiscountAmount FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	WHERE CampaignMasterId=@campaignMasterId AND tbl_BonusCampaignNewDetail.BonusProductId=@OrderProductId AND BonusQuantity<=@Qty

	IF(@CampaignCode IS NOT NULL OR @CampaignCode<>'')
	BEGIN
	IF(@BonusTypeId='5')
	BEGIN
	    
		DECLARE @CamQty INT=0

		SET @CamQty=CONVERT(INT,@Qty/@ProQty)*@BonusQty

		INSERT INTO dbo.tblOrderDetail
		(
		    ProductId,
		    ProductCode,
		    ProductName,
		    Quantity,
		    TradePrice,
		    TotalTradePrice,
		    OrderId,
		    OrderListDetailId,
		    Status,
		    ISGiftProduct,
		    CampaignType,
		    DiscountPercent,
		    DiscountAmount,
		    UnitVatAmount,
		    TotalVatAmount,
		    NetAmount,
		    CampaignName,
		    OrderSenderType,
		    OrderSenderCode,
		    OrderSenderName,
		    IsCampaignProduct,
		    IsSpDis
		)
		SELECT 
               ProductId,
               ProductCode,
               ProductName,
               @CamQty,
               '0',
               '0',
               OrderId,
               OrderListDetailId,
               Status,
               '1',
               CampaignType,
               '0',
               '0',
               '0',
               '0',
               '0',
               CampaignName,
               OrderSenderType,
               OrderSenderCode,
               OrderSenderName,
               '1',
               IsSpDis FROM dbo.tblOrderDetail WHERE OrderDetailId=@OrderDetailId

	END
	IF(@BonusTypeId='1')
	BEGIN
	    
		DECLARE @PercentTradePrice DECIMAL(18,2)=0
		DECLARE @PercentTotalTradePrice DECIMAL(18,2)=0

		SET @PercentTradePrice=@TradePrice*(@DisPercentage/100)
		SET @PercentTotalTradePrice=@TotalTradePrice*(@DisPercentage/100)

		UPDATE dbo.tblOrderDetail SET DiscountPercent=@DisPercentage,DiscountAmount=@PercentTotalTradePrice,NetAmount=NetAmount-@PercentTotalTradePrice
		
		WHERE OrderDetailId=@OrderDetailId


	END
	IF(@BonusTypeId='2')
	BEGIN
	    

		UPDATE dbo.tblOrderDetail SET DiscountPercent=0,DiscountAmount=@DisAmount,NetAmount=NetAmount-@DisAmount
		
		WHERE OrderDetailId=@OrderDetailId

	END

	--IF(@CampaignTypeId='2')
	--BEGIN
	    

	--	UPDATE dbo.tblOrderDetail SET DiscountPercent=0,DiscountAmount=@DisAmount,NetAmount=NetAmount-@DisAmount
		
	--	WHERE OrderDetailId=@OrderDetailId

	--END

	END
   

	FETCH NEXT FROM @Main
    INTO @OrderCode,@OrderProductId,@OrderDetailId,@OrderMasterId,@Qty,@TradePrice,@TotalTradePrice
	END

	CLOSE @Main
	DEALLOCATE @Main

	DECLARE @Perc DECIMAL(18,0)=0
	DECLARE @RemTotalAmount DECIMAL(18,2)=0
	SELECT @RemTotalAmount=SUM(TotalTradePrice) FROM dbo.tblOrderDetail WHERE OrderId=@orderid AND ProductId
	NOT IN (SELECT tbl_BonusCampaignNewDetail.BonusProductId FROM dbo.tbl_BonusCampaignNewDetail
	LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = tbl_BonusCampaignNewDetail.CampaignMasterId
	 WHERE CampaignMasterId=ISNULL(@campaignMasterId,CampaignMasterId) and (GETDATE() BETWEEN FromDate AND Todate))



	 DECLARE @CountRemCampaign INT
	 SELECT @CountRemCampaign=COUNT(*) FROM dbo.tbl_BonusCampaignNewDetail
	LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = tbl_BonusCampaignNewDetail.CampaignMasterId
	 WHERE CampaignMasterId<>@campaignMasterId and (GETDATE() BETWEEN FromDate AND Todate)


	 IF(@CountRemCampaign>0)
	 BEGIN
    SELECT @Perc=DiscountPercentage FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	WHERE (@RemTotalAmount BETWEEN Amount AND tbl_BonusCampaignNewMaster.MaxAmount) AND (GETDATE() BETWEEN FromDate AND Todate)

	UPDATE dbo.tblOrderDetail SET DiscountPercent=@Perc,DiscountAmount=TotalTradePrice*(@Perc/100),NetAmount=NetAmount-(TotalTradePrice*(@Perc/100))
	WHERE OrderId=@orderid AND ProductId IN 
	(SELECT tbl_BonusCampaignNewDetail.BonusProductId FROM dbo.tbl_BonusCampaignNewDetail
	LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = tbl_BonusCampaignNewDetail.CampaignMasterId
	 WHERE CampaignMasterId=ISNULL(@campaignMasterId,CampaignMasterId) and (GETDATE() BETWEEN FromDate AND Todate))
	
	end
	    





 END



END



