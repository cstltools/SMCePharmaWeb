-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Execute_SingleOrder] --- exec sp_OrderGenerationFromUploadOrder_SingleOrder 20037,'10001026555',1
	@OrderMasterID_In INT,
	@OrderCode NVARCHAR(max),
	@IsApiData BIT=0
	
AS
BEGIN



DECLARE @OrderId INT

DECLARE @ManufacID INT
DECLARE @OrderMasterID INT
--DECLARE @OrderCode NVARCHAR(500)
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


DECLARE @MyCursor_Master CURSOR
SET @MyCursor_Master = CURSOR FAST_FORWARD
FOR
---------------
SELECT DISTINCT M.ManufacId,R.OrderMasterID,REPLACE(R.OrderCode,' ','')OrderCode,R.SubmissionDate,REPLACE(R.SalesCentre,' ','')SalesCentre,R.SalesCentreName,R.MIOCode,R.MIOName,R.TerritoryCode,R.CustomerID,
R.CustomerName,
'' as  CampaignName,OrderSenderType,OrderSenderCode,OrderSenderName FROM dbo.tblOrderListMaster M 
INNER JOIN dbo.tblOrderListDetail R ON R.OrderMasterID = M.OrderMasterID
WHERE R.OrderCode=@OrderCode AND M.OrderMasterID=@OrderMasterID_In
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
 @OrderSenderName

 
------
WHILE @@FETCH_STATUS = 0
BEGIN

IF	EXISTS(SELECT * FROM dbo.View_CustomerMaster WHERE CustomerCode=@CustomerID AND ComUnitCode=@SalesCentre) --AND AreaCode=@TerritoryCode )
--AND MiaCode=@MIOCode)
 BEGIN----------cond1

 IF NOT EXISTS (SELECT * FROM dbo.tblOrder WHERE OrderCode=@OrderCode)
  BEGIN----------cond2

DECLARE @ComUnitId INT
SELECT @ComUnitId=ComUnitId FROM dbo.tblCompanyUnit WHERE ComUnitCode=@SalesCentre

-----Temporary
SELECT @MIOCode=MiaCode,@MIOName=MiaName,@TerritoryCode=AreaCode FROM dbo.View_CustomerMaster WHERE CustomerCode=@CustomerID

--Select * from dbo.View_CustomerMaster

---
PRINT @OrderCode 
INSERT INTO tblOrder (OrderCode,ComUnitId,ComUnitCode,ComUnitName,
MIOCode,MIOName,ManufacId,CustomerCode,
CustomerName,SubmissionDate,IsInvoice,TerritoryCode,CampaignName,OrderSenderType,OrderSenderCode,OrderSenderName) VALUES
(@OrderCode,@ComUnitId,@SalesCentre,@SalesCentreName,@MIOCode,@MIOName,@ManufacID,@CustomerID,@CustomerName,@SubmissionDate,'False',@TerritoryCode
,@CampaignName,@OrderSenderType,@OrderSenderCode,@OrderSenderName)

SET @OrderId=SCOPE_IDENTITY()

-----------------------------------
DECLARE @OrderDetailId int
DECLARE @ProductCode nvarchar(250)
DECLARE @ProductName nvarchar(500)
DECLARE @OrderQty DECIMAL(18,0)
DECLARE @GrossValue DECIMAL(18,2)

DECLARE @DiscountPercent	 DECIMAL(18,2)
DECLARE @DiscountAmount	 DECIMAL(18,2)
DECLARE @UnitVatAmount	 DECIMAL(18,2)
DECLARE @TotalVatAmount	 DECIMAL(18,2)
DECLARE @NetAmount	 DECIMAL(18,2)
DECLARE @ISGiftProduct BIT
DECLARE @CampaignType nvarchar(500)
DECLARE @IsCampaignProduct  bit

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
SELECT R.OrderDetailId,REPLACE(R.ProductCode,' ','')ProductCode,R.ProductName,R.OrderQty,R.GrossValue,
DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount	,
CampaignName,	
OrderSenderType	,
OrderSenderCode,
OrderSenderName	,
ISGiftProduct,
CampaignType,
IsCampaignProduct 
FROM dbo.tblOrderListMaster M 
INNER JOIN dbo.tblOrderListDetail R ON R.OrderMasterID = M.OrderMasterID
WHERE  M.OrderMasterID=@OrderMasterID_In AND REPLACE(R.OrderCode,' ','')=@OrderCode
----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@OrderDetailId ,
@ProductCode, 
@ProductName,
@OrderQty, 
@GrossValue,
 @DiscountPercent,	
 @DiscountAmount,	 
 @UnitVatAmount	, 
 @TotalVatAmount,	 
 @NetAmount	, 
 @ISGiftProduct ,
 @CampaignType ,
 @IsCampaignProduct  

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @ProductId INT=0



IF EXISTS(SELECT * FROM dbo.tblProduct WHERE ProductCode=@ProductCode)	
BEGIN

SELECT @ProductId=ProductId FROM dbo.tblProduct WHERE ProductCode=@ProductCode


INSERT into tblOrderDetail (
	ProductId,ProductCode,ProductName,Quantity,TradePrice,TotalTradePrice,OrderId,OrderListDetailId,
	DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount	,

ISGiftProduct	,

CampaignType,IsCampaignProduct
) VALUES
(
@ProductId,@ProductCode,@ProductName,@OrderQty,(@GrossValue/@OrderQty),@GrossValue,@OrderId,@OrderDetailId,
 @DiscountPercent,	
 @DiscountAmount,	 
 @UnitVatAmount	, 
 @TotalVatAmount,	 
 @NetAmount	, 
 @ISGiftProduct ,
 @CampaignType ,
 @IsCampaignProduct 
)
END


 
FETCH NEXT FROM @MyCursor
INTO 
@OrderDetailId ,
@ProductCode, 
@ProductName,
@OrderQty, 
@GrossValue,
 @DiscountPercent,	
 @DiscountAmount,	 
 @UnitVatAmount	, 
 @TotalVatAmount,	 
 @NetAmount	, 
 @ISGiftProduct ,
 @CampaignType ,
 @IsCampaignProduct  
END
CLOSE @MyCursor
DEALLOCATE @MyCursor




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
 @OrderSenderName

END
CLOSE @MyCursor_Master
DEALLOCATE @MyCursor_Master

--UPDATE tblOrder 
--SET TerritoryCode = i.AreaCode
--FROM (
--    SELECT AreaCode ,CustomerCode
--    FROM tblCustMaster) i
--WHERE 
--    i.CustomerCode = tblOrder.CustomerCode
--	and tblOrder.TerritoryCode is null

END
