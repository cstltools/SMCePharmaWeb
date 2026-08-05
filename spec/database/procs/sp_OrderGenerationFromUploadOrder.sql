-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OrderGenerationFromUploadOrder] --- exec sp_OrderGenerationFromUploadOrder_NewOperation 0,1
	@OrderMasterID_In INT=0,
	@IsApiData BIT=1
AS
BEGIN

SELECT @OrderMasterID_In=OrderMasterID FROM dbo.tblOrderListMaster WHERE GenerateOrder=0

DECLARE @OrderId INT

DECLARE @ManufacID INT
DECLARE @OrderMasterID INT
DECLARE @OrderCode NVARCHAR(500)
DECLARE @SubmissionDate DATETIME
DECLARE @SalesCentre NVARCHAR(500)
DECLARE @SalesCentreName NVARCHAR(MAX)
DECLARE @MIOCode NVARCHAR(500)
DECLARE @MIOName NVARCHAR(MAX)
DECLARE @TerritoryCode NVARCHAR(500)
DECLARE @CustomerID NVARCHAR(500)
DECLARE @CustomerName NVARCHAR(MAX)
DECLARE @CampaignName NVARCHAR(MAX)
DECLARE @OrderSenderType NVARCHAR(MAX)
DECLARE @OrderSenderCode NVARCHAR(MAX)
DECLARE @OrderSenderName NVARCHAR(MAX)

DECLARE @FECode NVARCHAR(MAX)
DECLARE @DZSMCode NVARCHAR(MAX)
DECLARE @Address NVARCHAR(MAX)
DECLARE @CellNo NVARCHAR(MAX)
DECLARE @ConPerson NVARCHAR(MAX)
DECLARE @MarketCode NVARCHAR(MAX)
DECLARE @MarketName NVARCHAR(MAX)
DECLARE @TerritoryName NVARCHAR(MAX)
DECLARE @FEName NVARCHAR(MAX)
DECLARE @DZSMName NVARCHAR(MAX)
DECLARE @FixedCustomer NVARCHAR(MAX)
DECLARE @ProgramType NVARCHAR(MAX)
DECLARE @CustomerStation NVARCHAR(MAX)
DECLARE @Division NVARCHAR(MAX)
DECLARE @District NVARCHAR(MAX)
DECLARE @Thana NVARCHAR(MAX)
DECLARE @Upazila NVARCHAR(MAX)
DECLARE @CustomerType NVARCHAR(MAX)
DECLARE @IsSpDis bit


DECLARE @MyCursor_Master CURSOR
SET @MyCursor_Master = CURSOR FAST_FORWARD
FOR
---------------
--SELECT DISTINCT M.ManufacId,R.OrderMasterID,REPLACE(R.OrderCode,' ','')OrderCode,R.SubmissionDate,REPLACE(R.SalesCentre,' ','')SalesCentre,R.SalesCentreName,R.MIOCode,R.MIOName,R.TerritoryCode,R.CustomerID,
--R.CustomerName FROM dbo.tblOrderListMaster M 
--INNER JOIN dbo.tblOrderListDetail R ON R.OrderMasterID = M.OrderMasterID
--WHERE M.GenerateOrder=0 AND M.OrderMasterID=@OrderMasterID_In

SELECT DISTINCT M.ManufacId,R.OrderMasterID,REPLACE(R.OrderCode,' ','')OrderCode,R.SubmissionDate,REPLACE(C.ComUnitCode,' ','')SalesCentre,
C.ComUnitName SalesCentreName,R.MIOCode,R.MIOName,R.TerritoryCode,REPLACE(C.CustomerCode,' ','') CustomerID,
C.CustomerName ,
'' as  CampaignName,OrderSenderType,OrderSenderCode,OrderSenderName,
R.FECode,
R.DZSMCode,
R.Address,
R.CellNo,
R.ConPerson,
R.MarketCode,
R.MarketName,
R.TerritoryName,
R.FEName,
R.DZSMName,
R.FixedCustomer,
R.ProgramType,
R.CustomerStation,
R.Division,
R.District,
R.Thana,
R.Upazila,R.CustomerType,R.IsSpDis

 FROM dbo.tblOrderListMaster M WITH (NOLOCK)
INNER JOIN dbo.tblOrderListDetail R WITH (NOLOCK) ON R.OrderMasterID = M.OrderMasterID
INNER JOIN dbo.View_CustomerMaster C WITH (NOLOCK) ON C.CustomerCode=R.CustomerID
WHERE M.GenerateOrder=0 and M.OrderMasterID=@OrderMasterID_In
----------
OPEN @MyCursor_Master
FETCH NEXT FROM @MyCursor_Master
INTO 
 @ManufacID,
 @OrderMasterID ,
 @OrderCode ,
 @SubmissionDate,
 @SalesCentre ,
 @SalesCentreName ,
 @MIOCode ,
 @MIOName ,
 @TerritoryCode ,
 @CustomerID,
 @CustomerName,


 @CampaignName ,
 @OrderSenderType ,
 @OrderSenderCode,
 @OrderSenderName,

 
 @FECode,
@DZSMCode,
@Address,
@CellNo,
@ConPerson,
@MarketCode,
@MarketName,
@TerritoryName,
@FEName,
@DZSMName,
@FixedCustomer,
@ProgramType,
@CustomerStation,
@Division,
@District,
@Thana,
@Upazila,@CustomerType,@IsSpDis

------
WHILE @@FETCH_STATUS = 0
BEGIN----S

IF NOT EXISTS (SELECT * FROM dbo.tblOrder WITH (NOLOCK) WHERE OrderCode=@OrderCode)	
BEGIN
-------- new cust create
IF not	EXISTS(SELECT * FROM dbo.tblCustMaster WITH (NOLOCK) WHERE CustomerCode=@CustomerID ) --AND ComUnitCode=@SalesCentre) --AND AreaCode=@TerritoryCode )
--AND MiaCode=@MIOCode)
 BEGIN--

   INSERT INTO SalesDisDB_SMC..tblCustMaster
                    ( 
				 CustomerCode,CategoryId,
    CustomerName,
    Address,
    CellNo,
    --MarketId,
    --Addrees2,
    --City,
    ConPerson,
    --ShippingCond,
    MarketCode,
    MarketName,
    MIACode,
    MIAName,
    AreaCode,
   -- TerritoryName,
    DisCode,
    FEName,
    ComUnitCode,
    ComUnitName,
    RegionCode,
    DZSMName,
    TermOfPayment,
    FixedCustomer,
    Type,
    IsActive,
   -- InActiveDate,
    CustomerStation,
    UploadDate,
   -- CreateBy,
   -- UpdateDate,
   -- UpdateBy,
    --IsImport,
    --ImportTime,
    Division,
    District,
    Thana,
    Upazila,CustomerType

                    
                    )
            VALUES  ( 
					 @CustomerID,'1',
    @CustomerName,
    @Address,
    @CellNo,
    --@MarketId,
    --@Addrees2,
    --@City,
    @ConPerson,
    --@ShippingCond,
    @MarketCode,
    @MarketName,
    @MIOCode,
    @MIOName,
    @TerritoryCode,
    --@TerritoryName,
    @FECode,
    @FEName,
    @SalesCentre,
    @SalesCentreName,
    @DZSMCode,
    @DZSMName,
    'Cash',
    @FixedCustomer,
    @ProgramType,
    '1',
    --@InActiveDate,
    @CustomerStation,
    GETDATE(),
  -- @CreateBy,
   -- @UpdateDate,
  --  @UpdateBy,
    --@IsImport,
    --@ImportTime,
    @Division,
    @District,
    @Thana,
    @Upazila,@CustomerType
                   
                    )
        
  
 end
 -------- new cust create


IF	EXISTS(SELECT * FROM dbo.tblCustMaster WITH (NOLOCK) WHERE CustomerCode=@CustomerID and IsActive=1) --AND ComUnitCode=@SalesCentre) --AND AreaCode=@TerritoryCode )
--AND MiaCode=@MIOCode)
 BEGIN----------cond1
 ------------------------------------new work
 ----------customer update

 
 	--------------------------- MIO
		IF NOT EXISTS(SELECT * FROM SalesDisDB_SMC..tblMIAInfo WHERE MiaCode=@MIOCode)
		BEGIN
		INSERT INTO SalesDisDB_SMC..tblMIAInfo
		        ( MiaId ,
		          MiaCode ,
		          MiaName ,
		          ManufacId ,
		          AreaId,Entrydate
		        )
		VALUES  ( (SELECT ISNULL(MAX(MiaId),0)+1 FROM SalesDisDB_SMC..tblMIAInfo) , -- MiaId - int
		          @MIOCode , -- MiaCode - nvarchar(500)
		          @MIOName , -- MiaName - nvarchar(500)
		          1 , -- ManufacId - int
		          NULL,
				  GETDATE()  -- AreaId - int
		        )
		end
		--------------------------- MIO


		----------------------------- Region
		IF NOT EXISTS(SELECT * FROM SalesDisDB_SMC..tblRegion WHERE RegionCode=@DZSMCode)
		BEGIN
		INSERT INTO SalesDisDB_SMC..tblRegion
           ([RegionId]
           ,[RegionCode]
           ,[RegionName]
           ,[CompanyId])
     VALUES
           ((SELECT ISNULL(MAX(RegionId),0)+1 FROM SalesDisDB_SMC..tblRegion) 
           ,@DZSMCode
           ,@DZSMName
           ,1)
		end
		--	--------------------------- Region

			--------------------------- district   REPLACE(CONTACTNUMBER ,' ','')CONTACTNUMBER,
			IF NOT EXISTS(SELECT * FROM SalesDisDB_SMC..tblDistrict WHERE DistrictCode=@FECode)
		BEGIN
		INSERT INTO SalesDisDB_SMC..tblDistrict
           ([DistrictId]
           ,[DistrictCode]
           ,[DistrictName]
           ,[ComUnitId],
		   EntryDate)
     VALUES
           ((SELECT ISNULL(MAX(DistrictId),0)+1 FROM SalesDisDB_SMC..tblDistrict)
           ,@FECode
           ,@FEName
           ,1,
		   Getdate())
		end
		--------------------------- district


		---area


		IF NOT EXISTS(SELECT * FROM SalesDisDB_SMC..tblArea WHERE AreaCode=@TerritoryCode)
		BEGIN
		INSERT INTO SalesDisDB_SMC..tblArea
		        ( AreaId ,
		          AreaCode ,
		          AreaName ,
		          DistrictId ,
		          MiaId
		        )
		VALUES  ( (SELECT ISNULL(MAX(AreaId),0)+1 FROM SalesDisDB_SMC..tblArea) , -- MiaId - int
		          @TerritoryCode , -- MiaCode - nvarchar(500)
		          @TerritoryName , -- MiaName - nvarchar(500)
		          NULL , -- ManufacId - int
		          NULL  -- AreaId - int
		        )
		end

		---area


		---------------MArket


			IF NOT EXISTS(SELECT * FROM SalesDisDB_SMC..tblMarket WHERE MarketCode=@MarketCode)
		BEGIN
		INSERT INTO SalesDisDB_SMC..tblMarket
           ([MarketId]
           ,[MarketCode]
           ,[MarketName]
           ,[AreaId])
     VALUES
           ((SELECT ISNULL(MAX(MarketId),0)+1 FROM SalesDisDB_SMC..tblMarket)
           ,@MarketCode
           ,@MarketName
           ,0)
		end

		---------------market





 
UPDATE SalesDisDB_SMC..tblCustMaster
					   SET 
					--	 @CustomerCode= @CustomerCode,
					CustomerName=@CustomerName,
					Address= @Address,
					CellNo=@CellNo,
					MarketCode= @MarketCode,
					MarketName= @MarketName,
					MIACode= @MIOCode,
					MIAName= @MIOName,
					AreaCode= @TerritoryCode,
					DisCode= @FECode,
					FEName= @FEName,
					ComUnitCode= @SalesCentre,
					ComUnitName = @SalesCentreName,
					RegionCode= @DZSMCode,
					DZSMName= @DZSMName,
					FixedCustomer= @FixedCustomer,
					Type= @ProgramType,
					CustomerStation= @CustomerStation,
					Division=  @Division,
					District=  @District,
					Thana=   @Thana,
					Upazila=  @Upazila,
					CustomerType=@CustomerType

					 WHERE CustomerCode=@CustomerID

  ----------customer update

 IF NOT EXISTS (SELECT * FROM dbo.tblOrder WITH (NOLOCK) WHERE OrderCode=@OrderCode)
  BEGIN----------cond2

DECLARE @ComUnitId INT
SELECT @ComUnitId=ComUnitId FROM dbo.tblCompanyUnit WITH (NOLOCK) WHERE ComUnitCode=@SalesCentre

-----Temporary
SELECT @MIOCode=MiaCode,@MIOName=MiaName FROM dbo.View_CustomerMaster WITH (NOLOCK) WHERE CustomerCode=@CustomerID

---
--select @CampaignName=CampaignName,@OrderSenderType=OrderSenderType,@OrderSenderCode=OrderSenderCode,@OrderSenderName=OrderSenderName
--FROM dbo.tblOrderListMaster M WITH (NOLOCK)
--INNER JOIN dbo.tblOrderListDetail R WITH (NOLOCK) ON R.OrderMasterID = M.OrderMasterID

--WHERE  M.OrderMasterID=@OrderMasterID_In AND R.OrderCode=@OrderCode

---
INSERT INTO tblOrder (OrderCode,ComUnitId,ComUnitCode,ComUnitName,
MIOCode,MIOName,ManufacId,CustomerCode,
CustomerName,SubmissionDate,IsInvoice,TerritoryCode,CampaignName,OrderSenderType,OrderSenderCode,OrderSenderName,FixedCustomer,CustomerType) VALUES
(@OrderCode,@ComUnitId,@SalesCentre,@SalesCentreName,@MIOCode,@MIOName,@ManufacID,@CustomerID,@CustomerName,@SubmissionDate,'False',@TerritoryCode
,@CampaignName,@OrderSenderType,@OrderSenderCode,@OrderSenderName,@FixedCustomer,@CustomerType)

SET @OrderId=SCOPE_IDENTITY()



INSERT into tblOrderDetail (
	ProductId,ProductCode,ProductName,Quantity,TradePrice,TotalTradePrice,OrderId,OrderListDetailId,

	DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount	,
CampaignName,	
OrderSenderType	,
OrderSenderCode,
OrderSenderName	,
ISGiftProduct	,

CampaignType,IsCampaignProduct,IsSpDis
) 

SELECT O.ProductId,R.ProductCode,R.ProductName,R.OrderQty,(R.GrossValue/R.OrderQty) TradePrice ,R.GrossValue,@OrderId,r.OrderDetailId ,
DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount	,
CampaignName,	
OrderSenderType	,
OrderSenderCode,
OrderSenderName	,
ISGiftProduct,CampaignType,IsCampaignProduct,IsSpDis
FROM dbo.tblOrderListMaster M WITH (NOLOCK)
INNER JOIN dbo.tblOrderListDetail R WITH (NOLOCK) ON R.OrderMasterID = M.OrderMasterID
INNER JOIN dbo.tblProduct O WITH (NOLOCK) ON O.ProductCode = R.ProductCode
WHERE  M.OrderMasterID=@OrderMasterID_In AND R.OrderCode=@OrderCode

 

 ---@ProductId,@ProductCode,@ProductName,@OrderQty,(@GrossValue/@OrderQty),@GrossValue,@OrderId,@OrderDetailId



-----------------------------------


DECLARE @TotalGrossVal DECIMAL(18,2)=0

SELECT @TotalGrossVal=ISNULL(SUM(TotalTradePrice),0) FROM tblOrderDetail WHERE OrderId=@OrderId


IF(@TotalGrossVal>0)
BEGIN
UPDATE tblOrder SET GrossValue=@TotalGrossVal WHERE  OrderId=@OrderId

-----------------------
if(@IsApiData=1)
begin
insert into SystemTest..ProcessedOrder	(OrderCode,ProcessDateTime)values(@OrderCode,GETDATE())

end
-------------------------
END
else
BEGIN
DELETE FROM tblOrder WHERE  OrderId=@OrderId
END

END-----------cond2

END-----------cond1
 
FETCH NEXT FROM @MyCursor_Master
INTO 
 @ManufacID,
 @OrderMasterID ,
 @OrderCode ,
 @SubmissionDate,
 @SalesCentre ,
 @SalesCentreName ,
 @MIOCode ,
 @MIOName ,
 @TerritoryCode ,
 @CustomerID,
 @CustomerName,


 @CampaignName ,
 @OrderSenderType ,
 @OrderSenderCode,
 @OrderSenderName,


 @FECode,
@DZSMCode,
@Address,
@CellNo,
@ConPerson,
@MarketCode,
@MarketName,
@TerritoryName,
@FEName,
@DZSMName,
@FixedCustomer,
@ProgramType,
@CustomerStation,
@Division,
@District,
@Thana,
@Upazila,@CustomerType,@IsSpDis
 
 
 END
 
END-----E
CLOSE @MyCursor_Master
DEALLOCATE @MyCursor_Master

UPDATE dbo.tblOrderListMaster SET GenerateOrder=1 WHERE OrderMasterID=@OrderMasterID_In

END
