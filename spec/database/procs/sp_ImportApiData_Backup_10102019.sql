-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ImportApiData_Backup_10102019]--- exec sp_ImportApiData

AS
BEGIN
	



IF EXISTS (SELECT * FROM SystemTest..OrderListDetail WHERE IsImport=0)
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

		
	
       -- DECLARE	@OrderDetailIdMIN INT,@OrderDetailIdMAX INT


	DECLARE	@OrderDetailIdApi INT,
               @SalesCentre NVARCHAR(500),
               @SalesCentreName NVARCHAR(500),
               @MIOCode NVARCHAR(100),
               @MIOName NVARCHAR(100),
               @TerritoryCode NVARCHAR(100),
               @FECode NVARCHAR(100),
               @DZSMCode NVARCHAR(100),
               @CustomerID NVARCHAR(100),
               @CustomerName  NVARCHAR(MAX),
               @ProductCode NVARCHAR(100),
               @ProductName NVARCHAR(MAX),
               @OrderQty DECIMAL(18,0),
               @GrossValue DECIMAL(18,2),
               @OrderCode  NVARCHAR(MAX),
               @SubmissionDate DATETIME
               
		
		
		
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT OrderDetailId ,
       REPLACE(SalesCentre,' ','')SalesCentre ,
       SalesCentreName ,
       MIOCode ,
       MIOName ,
       TerritoryCode ,
       FECode ,
       DZSMCode ,
       REPLACE(CustomerID,' ','')CustomerID ,
       CustomerName ,
       REPLACE(ProductCode,' ','')ProductCode ,
       ProductName ,
       OrderQty ,
       GrossValue ,
       REPLACE(OrderCode,' ','')OrderCode ,
       SubmissionDate  FROM SystemTest..OrderListDetail WHERE IsImport=0 

OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @OrderDetailIdApi ,
               @SalesCentre ,
               @SalesCentreName,
               @MIOCode,
               @MIOName,
               @TerritoryCode,
               @FECode,
               @DZSMCode,
               @CustomerID ,
               @CustomerName  ,
               @ProductCode ,
               @ProductName,
               @OrderQty,
               @GrossValue,
               @OrderCode,
               @SubmissionDate

WHILE @@FETCH_STATUS = 0
BEGIN


if not exists (select * from tblOrderListDetail where OrderCode=@OrderCode and ProductCode=@ProductCode)
begin

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
		  OrderDetailIdApi
        )
VALUES  ( @OrderMasterID , -- OrderMasterID - int
          @SalesCentre , -- SalesCentre - nvarchar(max)
          @SalesCentreName , -- SalesCentreName - nvarchar(max)
          @MIOCode , -- MIOCode - nvarchar(500)
          @MIOName , -- MIOName - nvarchar(max)
          @TerritoryCode , -- TerritoryCode - nvarchar(max)
          @FECode , -- FECode - nvarchar(max)
          @DZSMCode , -- DZSMCode - nvarchar(max)
          @CustomerID , -- CustomerID - nvarchar(max)
          @CustomerName, -- CustomerName - nvarchar(max)
          @ProductCode, -- ProductCode - nvarchar(max)
          @ProductName, -- ProductName - nvarchar(max)
          @OrderQty , -- OrderQty - decimal
          @GrossValue , -- GrossValue - decimal
          @OrderCode , -- OrderCode - nvarchar(max)
          @SubmissionDate, -- SubmissionDate - datetime
		  @OrderDetailIdApi
        )
        UPDATE  SystemTest..OrderListDetail SET IsImport=1 WHERE OrderDetailId=@OrderDetailIdApi
 end
 else
 begin
 UPDATE  SystemTest..OrderListDetail SET IsImport=1,RejectReason='Duplicate' WHERE OrderDetailId=@OrderDetailIdApi
 end


FETCH NEXT FROM @MyCursor
INTO  @OrderDetailIdApi ,
               @SalesCentre ,
               @SalesCentreName,
               @MIOCode,
               @MIOName,
               @TerritoryCode,
               @FECode,
               @DZSMCode,
               @CustomerID ,
               @CustomerName  ,
               @ProductCode ,
               @ProductName,
               @OrderQty,
               @GrossValue,
               @OrderCode,
               @SubmissionDate
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


exec sp_OrderGenerationFromUploadOrder @OrderMasterID,1
		END
END
