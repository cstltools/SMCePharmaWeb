
CREATE PROCEDURE [dbo].[sp_webapi_SaveOrderDetail]
	-- Add the parameters for the stored procedure here
    @orderid INT ,
    @productid INT ,
    @quantity DECIMAL(18, 2) ,
    @unitprice DECIMAL(18, 3) ,
    @unitvatPercentage DECIMAL(18, 3) ,
    @IsGiftProduct BIT = NULL ,
    @IsCampaignProduct BIT = NULL ,
    @DiscountPercentage DECIMAL(18, 3) = NULL ,
    @CampaingName NVARCHAR(MAX) = NULL ,
    @CampaignType NVARCHAR(MAX) = NULL ,
    @DiscountValue DECIMAL(18, 3) = NULL
AS
    BEGIN
		
        DECLARE @totalVatAmount DECIMAL(18, 3) ,
            @totalAmount DECIMAL(18, 3) ,
            @NetAmount DECIMAL(18, 3),
			@CampaignCategory nvarchar(max)=''

		
        DECLARE @vatAmtPerUnit DECIMAL(18, 3)=0


		-----pulak
		declare @TempUnitPrice decimal(18,3)=0
		declare @quoteddiscamount decimal(18,3)=0
		declare @quoteddisctotamng decimal(18,3)=0
		declare @quoteddisctotalqtyamnt decimal(18,3)=0
		--------pula

		SELECT @unitvatPercentage=VATPercentage,@vatAmtPerUnit=VATAmountPerUnit,		@TempUnitPrice=UnitPrice FROM dbo.tblUnitPrice WHERE ProductId=@productid AND IsActive=1
		declare @cusId int=null
		
		select @cusId=CustomerMasterId from  tblorder  where orderid=@orderid

		--------Pulak-----------------
		select @quoteddiscamount=isnull(Vat,0) from tblQuotedPriceDetail A
		left join tblQuotedPriceMaster B on A.QuotedPriceMasterId=B.QuotedPriceMasterId
		 where ProductId=@productid and B.CustomerMasterId=@cusId and getdate() between ActiveFromDate and ActiveToDate


		 SET @CampaignCategory = 
    ISNULL(
        (SELECT cat.CampaignCategory 
         FROM tbl_BonusCampaignNewMaster cam
         INNER JOIN tbl_BonusCampaignNewDetail bd ON bd.CampaignMasterId = cam.CampgainMasterId
         INNER JOIN tblCampaignCategory cat ON cam.CampaignCategoryId = cat.CampaignCategoryId
         WHERE bd.CampaignDetailId = 
             CASE 
                 WHEN @CampaignType IS NULL OR @CampaignType = '' THEN 0 
                 ELSE @CampaignType 
             END), 
        ''
    );


		if(@quoteddiscamount>0)
		begin 

		set @quoteddisctotamng=@TempUnitPrice*(@quoteddiscamount/100)
		set @quoteddisctotalqtyamnt=@quantity*@quoteddisctotamng



		set @DiscountPercentage=@quoteddiscamount
		set @DiscountValue=@quoteddisctotalqtyamnt

		set @unitprice=@TempUnitPrice

		end
		------------------------------



        --SET @vatAmtPerUnit = ( ( @unitprice * @unitvatPercentage ) / 100 )
	
        SET @totalAmount = @quantity * @unitprice	
        --SET @totalVatAmount = ( ( @totalAmount * @unitvatPercentage ) / 100 )
		SET @totalVatAmount = ( ( @vatAmtPerUnit * @quantity ))


        SET @NetAmount = @totalAmount + @totalVatAmount-@DiscountValue

        DECLARE @productCode NVARCHAR(max),@productName NVARCHAR(max)

        SELECT  @productCode = ProductCode,@productName=ProductName
        FROM    dbo.tblProduct
        WHERE   ProductId = @productid
		IF(@IsGiftProduct=1)
		BEGIN
		SET @unitprice =0
                  SET @totalAmount=0 
                  SET @vatAmtPerUnit=0
                  SET @totalVatAmount=0
                  SET @NetAmount=0
                  
                  SET @DiscountPercentage=0
                  SET @DiscountValue=0
                  
		    
		END
		DECLARE @CustId INT
		DECLARE @CustTypeId INT
		SELECT @CustId=CustomerMasterId FROM dbo.tblOrder WHERE OrderId=@orderid
	SELECT @CustTypeId=CustomerTypeId FROM dbo.tblCustMaster WHERE CustomerMasterId=@CustId
	DECLARE @IsSpec BIT
    IF(@CustTypeId='3')
	BEGIN
	    SET @IsSpec=1
	END
	ELSE
    BEGIN
        SET @IsSpec=0
    END

        INSERT  INTO dbo.tblOrderDetail
                ( ProductId ,
                  Quantity ,
                  TradePrice ,
                  TotalTradePrice ,
                  OrderId ,
                  UnitVatAmount ,
                  TotalVatAmount ,
                  NetAmount ,
                  ProductCode ,
                  IsSpDis ,
                  ISGiftProduct ,
                  CampaignType ,
                  CampaignName ,
                  DiscountPercent ,
                  DiscountAmount ,
                  IsCampaignProduct,ProductName,CampaignCategory
		        )
        VALUES  ( @productid ,
                  @quantity ,
                  @unitprice ,
                  @totalAmount ,
                  @orderid ,
                  @vatAmtPerUnit ,
                  @totalVatAmount ,
                  @NetAmount ,
                  @productCode ,
                  @IsSpec ,
                  @IsGiftProduct ,
                  @CampaignType ,
                  @CampaingName ,
                  @DiscountPercentage ,
                  @DiscountValue ,
                  @IsCampaignProduct,@productName,@CampaignCategory
					
		        )


        UPDATE  dbo.tblOrder
        SET     GrossValue = ISNULL(GrossValue, 0) + @totalAmount,
		        TotalVat = ISNULL(TotalVat, 0) + @totalVatAmount,
		        TotalDiscount = ISNULL(TotalDiscount, 0) + @DiscountValue,
		        TotalNetPayable = ISNULL(TotalNetPayable, 0) + @NetAmount



        WHERE   OrderId = @orderid



    END