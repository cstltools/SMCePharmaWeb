
CREATE PROCEDURE [dbo].[sp_SAP_WhStockInDetails] 

	@MasterId INT,
	@ChallanNo NVARCHAR(500)
	
AS
BEGIN
	
	-- Insert Details

		DECLARE @ProductId INT
		DECLARE @Batch NVARCHAR(500)
		DECLARE @ExpDate DATETIME;
		DECLARE @MfgDate DATETIME
		DECLARE @Qty INT
		DECLARE @Price DECIMAL(18,2)
		DECLARE @VAT DECIMAL(18,2)
		DECLARE @TotalAmount DECIMAL(18,2)

		-- Declare the cursor
		DECLARE @MyCursor2 CURSOR;
		
		-- Open the cursor
		SET @MyCursor2 = CURSOR FAST_FORWARD FOR

		SELECT PD.ProductId,batch_no,expiry_date,manufacturer_date, quantity,ISNULL(UnitPrice,1) UnitPrice,ISNULL(VATAmountPerUnit,1) VAT,
		       (quantity * ISNULL(UnitPrice,1)) + (quantity*ISNULL(VATAmountPerUnit,1)) TotalAmount
		FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD ON  SUBSTRING(D.product_code, 13, LEN(D.product_code))  = PD.SAP_Code
		inner JOIN tblUnitPrice AS UP ON PD.ProductId = UP.ProductId
		WHERE ISNULL(quantity, 0) > 0 AND UP.IsActive = 1 AND 
		UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))


		OPEN @MyCursor2;
		
		-- Fetch the first row from the cursor
		FETCH NEXT FROM @MyCursor2 
		INTO @ProductId
		       ,@Batch
		       ,@ExpDate
		       ,@MfgDate
		       ,@Qty
		       ,@Price
		       ,@VAT
		       ,@TotalAmount

		WHILE @@FETCH_STATUS = 0
		BEGIN
		    
			INSERT INTO [dbo].[tblWHStockInDetail]
		       (WHStockInMasterID
		       ,ProductId
		       ,Batch
		       ,ExpDate
		       ,MfgDate
		       ,Qty
		       ,Price
		       ,VAT
		       ,TotalAmount)
		 VALUES
		       (@MasterId
		       ,@ProductId
		       ,@Batch
		       ,@ExpDate
		       ,@MfgDate
		       ,@Qty
		       ,@Price
		       ,@VAT
		       ,@TotalAmount)

		    -- Fetch the next row from the cursor
		    FETCH NEXT FROM @MyCursor2 
			INTO @ProductId
		       ,@Batch
		       ,@ExpDate
		       ,@MfgDate
		       ,@Qty
		       ,@Price
		       ,@VAT
		       ,@TotalAmount
		END;

		-- Close and deallocate the cursor

		CLOSE @MyCursor2;
		DEALLOCATE @MyCursor2;




	--DECLARE @IsFromWH BIT = 0
	--SELECT @IsFromWH = ISNULL(is_from_wharehouse,0) FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

	----PRINT @IsFromWH

	---- For STO

	--IF(@IsFromWH = 1)
	--BEGIN
		
		

	--END

	
END          