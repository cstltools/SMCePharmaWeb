-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ImportApiData] --- exec sp_ImportApiData_NewOperation
AS
BEGIN
	DECLARE @checkcount INT =0

SELECT @checkcount=COUNT(OrderMasterID) FROM dbo.tblOrderListMaster WHERE GenerateOrder=0
IF(@checkcount=0)
BEGIN
IF EXISTS (SELECT * FROM SystemTest..OrderListDetail WHERE IsImport=0 )
BEGIN
DECLARE @OrderMasterID INT
SELECT @OrderMasterID=ISNULL(MAX(OrderMasterID),0)+1 FROM tblOrderListMaster

INSERT INTO dbo.tblOrderListMaster
        ( OrderMasterID ,
          ManufacId ,
          DocumentDate ,
          GenerateOrder ,
          EntryBy ,
          EntryDate,
		  IsApiData
        )
VALUES  ( @OrderMasterID , -- OrderMasterID - int
          1 , -- ManufacId - int
          CONVERT(NVARCHAR(11),GETDATE(),106) , -- DocumentDate - datetime
          0 , -- GenerateOrder - bit
          N'admin' , -- EntryBy - nvarchar(max)
          GETDATE(),  -- EntryDate - datetime
		  1
        )

		
	
       DECLARE	@OrderDetailIdMIN INT=0,@OrderDetailIdMAX INT=0

	   SELECT @OrderDetailIdMIN=MIN(OrderDetailId),@OrderDetailIdMAX=MAX(OrderDetailId) 
              FROM SystemTest..OrderListDetail WHERE IsImport=0


			  INSERT INTO dbo.tblOrderListDetail
        ( OrderMasterID ,
          SalesCentre ,
          SalesCentreName ,
          MIOCode ,
          MIOName ,
          TerritoryCode ,
          FECode ,
          DZSMCode ,
          CustomerID ,
          CustomerName ,
          ProductCode ,
          ProductName ,
          OrderQty ,
          GrossValue ,
          OrderCode ,
          SubmissionDate,
		  OrderDetailIdApi,

		  DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount,
CampaignName	,
OrderSenderType,
OrderSenderCode	,
OrderSenderName	,
ISGiftProduct,
CampaignType,
IsCampaignProduct,
Address	,
CellNo,	
ConPerson,	
MarketCode,	
MarketName,	
TerritoryName,	
FEName,	
DZSMName,	
FixedCustomer,	
ProgramType	,
CustomerStation,	
Division,	
District,	
Thana,	
Upazila,CustomerType,IsSpDis		
        )
		SELECT 
		@OrderMasterID ,
       REPLACE(SalesCentre,' ','')SalesCentre ,
       REPLACE(SalesCentreName,' ','') SalesCentreName,
       REPLACE(MIOCode,' ','') MIOCode,
       REPLACE(MIOName,' ','')MIOName ,
       REPLACE(TerritoryCode,' ','')TerritoryCode ,
       REPLACE(FECode,' ','') FECode,
       REPLACE(DZSMCode,' ','') DZSMCode,
       REPLACE(CustomerID,' ','')CustomerID ,
       CustomerName ,
       REPLACE(ProductCode,' ','')ProductCode ,
       REPLACE(ProductName,' ','') ProductName,
       OrderQty ,
       GrossValue ,
       REPLACE(OrderCode,' ','')OrderCode ,
       SubmissionDate,OrderDetailId ,
	     DiscountPercent	,
DiscountAmount	,
UnitVatAmount	,
TotalVatAmount	,
NetAmount,
CampaignName	,
OrderSenderType,
OrderSenderCode	,
OrderSenderName	,
ISGiftProduct	,
CampaignType,
IsCampaignProduct,
Address	,
CellNo,	
ConPerson,	
MarketCode,	
MarketName,	
TerritoryName,	
FEName,	
DZSMName,	
FixedCustomer,	
ProgramType	,
CustomerStation,	
Division,	
District,	
Thana,	
Upazila,CustomerType,IsSpDis	
FROM SystemTest..OrderListDetail WITH (NOLOCK) 
 WHERE IsImport=0 AND OrderDetailId BETWEEN @OrderDetailIdMIN AND @OrderDetailIdMAX

	   ----



	   UPDATE  SystemTest..OrderListDetail SET IsImport=1 WHERE OrderDetailId BETWEEN @OrderDetailIdMIN AND @OrderDetailIdMAX



		--EXEC sp_OrderGenerationFromUploadOrder @OrderMasterID,1
		END
		END
        
END
