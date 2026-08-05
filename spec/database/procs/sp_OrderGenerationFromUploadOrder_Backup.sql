-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OrderGenerationFromUploadOrder_Backup] --- exec sp_OrderGenerationFromUploadOrder 188,1
	@OrderMasterID_In INT,
	@IsApiData BIT=0
AS
BEGIN



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


DECLARE @MyCursor_Master CURSOR
SET @MyCursor_Master = CURSOR FAST_FORWARD
FOR
---------------
--SELECT DISTINCT M.ManufacId,R.OrderMasterID,REPLACE(R.OrderCode,' ','')OrderCode,R.SubmissionDate,REPLACE(R.SalesCentre,' ','')SalesCentre,R.SalesCentreName,R.MIOCode,R.MIOName,R.TerritoryCode,R.CustomerID,
--R.CustomerName FROM dbo.tblOrderListMaster M 
--INNER JOIN dbo.tblOrderListDetail R ON R.OrderMasterID = M.OrderMasterID
--WHERE M.GenerateOrder=0 AND M.OrderMasterID=@OrderMasterID_In

SELECT DISTINCT M.ManufacId,R.OrderMasterID,REPLACE(R.OrderCode,' ','')OrderCode,R.SubmissionDate,REPLACE(C.ComUnitCode,' ','')SalesCentre,C.ComUnitName SalesCentreName,R.MIOCode,R.MIOName,R.TerritoryCode,REPLACE(C.CustomerCode,' ','') CustomerID,
C.CustomerName FROM dbo.tblOrderListMaster M WITH (NOLOCK)
INNER JOIN dbo.tblOrderListDetail R WITH (NOLOCK) ON R.OrderMasterID = M.OrderMasterID
INNER JOIN dbo.View_CustomerMaster C WITH (NOLOCK) ON REPLACE(C.CustomerCode,' ','')=REPLACE(R.CustomerID,' ','')
WHERE M.OrderMasterID=@OrderMasterID_In
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
 @CustomerName

 
------
WHILE @@FETCH_STATUS = 0
BEGIN

IF	EXISTS(SELECT * FROM dbo.tblCustMaster WITH (NOLOCK) WHERE CustomerCode=@CustomerID and IsActive=1) --AND ComUnitCode=@SalesCentre) --AND AreaCode=@TerritoryCode )
--AND MiaCode=@MIOCode)
 BEGIN----------cond1

 IF NOT EXISTS (SELECT * FROM dbo.tblOrder WITH (NOLOCK) WHERE OrderCode=@OrderCode)
  BEGIN----------cond2

DECLARE @ComUnitId INT
SELECT @ComUnitId=ComUnitId FROM dbo.tblCompanyUnit WITH (NOLOCK) WHERE ComUnitCode=@SalesCentre

-----Temporary
SELECT @MIOCode=MiaCode,@MIOName=MiaName FROM dbo.View_CustomerMaster WITH (NOLOCK) WHERE CustomerCode=@CustomerID

---
INSERT INTO tblOrder (OrderCode,ComUnitId,ComUnitCode,ComUnitName,
MIOCode,MIOName,ManufacId,CustomerCode,
CustomerName,SubmissionDate,IsInvoice,TerritoryCode) VALUES
(@OrderCode,@ComUnitId,@SalesCentre,@SalesCentreName,@MIOCode,@MIOName,@ManufacID,@CustomerID,@CustomerName,@SubmissionDate,'False',@TerritoryCode)

SET @OrderId=SCOPE_IDENTITY()

-----------------------------------
DECLARE @OrderDetailId int
DECLARE @ProductCode nvarchar(250)
DECLARE @ProductName nvarchar(500)
DECLARE @OrderQty DECIMAL(18,0)
DECLARE @GrossValue DECIMAL(18,2)

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
SELECT R.OrderDetailId,REPLACE(R.ProductCode,' ','')ProductCode,R.ProductName,R.OrderQty,R.GrossValue FROM dbo.tblOrderListMaster M 
INNER JOIN dbo.tblOrderListDetail R ON R.OrderMasterID = M.OrderMasterID
WHERE M.GenerateOrder=0 AND M.OrderMasterID=@OrderMasterID_In AND REPLACE(R.OrderCode,' ','')=@OrderCode
----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@OrderDetailId ,
@ProductCode, 
@ProductName,
@OrderQty, 
@GrossValue

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @ProductId INT=0



IF EXISTS(SELECT * FROM dbo.tblProduct WHERE ProductCode=@ProductCode)	
BEGIN

SELECT @ProductId=ProductId FROM dbo.tblProduct WITH (NOLOCK) WHERE ProductCode=@ProductCode


INSERT into tblOrderDetail (
	ProductId,ProductCode,ProductName,Quantity,TradePrice,TotalTradePrice,OrderId,OrderListDetailId
) VALUES
(
@ProductId,@ProductCode,@ProductName,@OrderQty,(@GrossValue/@OrderQty),@GrossValue,@OrderId,@OrderDetailId
)
END


 
FETCH NEXT FROM @MyCursor
INTO 
@OrderDetailId ,
@ProductCode, 
@ProductName,
@OrderQty, 
@GrossValue
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
 @CustomerName

END
CLOSE @MyCursor_Master
DEALLOCATE @MyCursor_Master

UPDATE dbo.tblOrderListMaster SET GenerateOrder=1 WHERE OrderMasterID=@OrderMasterID_In

END
