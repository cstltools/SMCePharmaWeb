-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_DCStockOutInfo] 

 @DcId NVARCHAR(50),
 @ProductCode NVARCHAR(50),
 @Code NVARCHAR(500),
 @ProductName NVARCHAR(50),
 @DCStoreId INT,
 @StockOutQty DECIMAL(18,2),
 @StockOutReason NVARCHAR(MAX),
 @StockOutType NVARCHAR(MAX),
 @EntryBy NVARCHAR(50),
 @EntryDate DATETIME,
 @StockOutDate DATETIME 

AS
BEGIN

	DECLARE @UP DECIMAL(18,2)
	DECLARE @StockOutValue DECIMAL(18,2)
	SELECT @UP = UnitPrice FROM dbo.tblUnitPrice WHERE ProductCode = @ProductCode AND IsActive = 1
	SELECT @StockOutValue = @StockOutQty * ISNULL(@UP,0)
	

	--Insert into Stock Out

	INSERT INTO	tblDirectStockOut (StockOutCode,[DCId],[ProductCode],[ProductName],[StockOutDate],[DCStoreId],[StockOutQty],[StockOutType],[StockOutValue],[StockOutReason],[EntryBy],[EntryDate]) 
	VALUES (@Code,@DcId,@ProductCode,@ProductName,@StockOutDate,@DCStoreId,@StockOutQty,@StockOutType,@StockOutValue,@StockOutReason,@EntryBy,@EntryDate)

	-- Update DC Store Info

	DECLARE @CurentStock DECIMAL(18,2)
	DECLARE @NewStock DECIMAL(18,2)
	
	SELECT @CurentStock = StockQty FROM dbo.tblDCStore WHERE DCStoreId = @DCStoreId
	SELECT @NewStock = @CurentStock - ISNULL(@StockOutQty,0)

	UPDATE dbo.tblDCStore SET StockQty = @NewStock WHERE DCStoreId = @DCStoreId

	
END


