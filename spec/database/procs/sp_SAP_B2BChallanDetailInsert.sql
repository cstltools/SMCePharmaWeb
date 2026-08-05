CREATE PROCEDURE [dbo].[sp_SAP_B2BChallanDetailInsert] 

	@MasterId INT,
	@ChallanNo NVARCHAR(500)
	
AS
BEGIN
	
	DECLARE @ReceiveIdMAX INT

	-- Insert Details

		DECLARE @ProductId INT
		DECLARE @ProductCode NVARCHAR(500)
		DECLARE @ProductName NVARCHAR(500)
		DECLARE @Batch NVARCHAR(500)
		DECLARE @ExpDate DATETIME;
		DECLARE @MfgDate DATETIME
		DECLARE @Qty INT
		DECLARE @Price DECIMAL(18,2)
		DECLARE @VAT DECIMAL(18,2)
		DECLARE @TotalAmount DECIMAL(18,2)
		DECLARE @ComUnitId INT

		-- Declare the cursor
		DECLARE @MyCursor2 CURSOR;
		
		-- Open the cursor
		SET @MyCursor2 = CURSOR FAST_FORWARD FOR

		SELECT PD.ProductId,PD.ProductCode,PD.ProductName,batch_no,expiry_date,manufacturer_date, quantity,ISNULL(UnitPrice,1) UnitPrice,ISNULL(VATAmountPerUnit,1) VAT,
		       (quantity * ISNULL(UnitPrice,1)) + (quantity*ISNULL(VATAmountPerUnit,1)) TotalAmount,FUNT.ComUnitId
		FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN tblCompanyUnit AS FUNT ON M.from_plant_code = FUNT.SAP_Code
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD ON  SUBSTRING(D.product_code, 13, LEN(D.product_code))  = PD.SAP_Code
		LEFT JOIN tblUnitPrice AS UP ON PD.ProductId = UP.ProductId
		WHERE ISNULL(quantity, 0) > 0 AND UP.IsActive = 1 AND 
		UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))


		OPEN @MyCursor2;
		
		-- Fetch the first row from the cursor
		FETCH NEXT FROM @MyCursor2 
		INTO @ProductId,@ProductCode,@ProductName
		       ,@Batch
		       ,@ExpDate
		       ,@MfgDate
		       ,@Qty
		       ,@Price
		       ,@VAT
		       ,@TotalAmount,@ComUnitId

		WHILE @@FETCH_STATUS = 0
		BEGIN

		DECLARE @StockQuantity INT = 0
		DECLARE @AdjustmentQuantity INT = @Qty

		-- Stock Manage

		WHILE(@AdjustmentQuantity > 0)
		BEGIN

			DECLARE @DCStoreId INT = 0;

			SELECT TOP 1 @StockQuantity = StockQty, @DCStoreId = DCStoreId FROM tblDCStore 
			WHERE StockQty > 0 AND ComUnitId = @ComUnitId AND ProductCode = @ProductCode
			ORDER BY ExpDate

			IF(@StockQuantity > 0)
			BEGIN

					IF(@StockQuantity > @AdjustmentQuantity) 
					BEGIN
						UPDATE tblDCStore SET StockQty = @StockQuantity - @AdjustmentQuantity WHERE DCStoreId = @DCStoreId
						SET @AdjustmentQuantity = 0
					END

					ELSE IF((@StockQuantity < @AdjustmentQuantity) OR (@StockQuantity = @AdjustmentQuantity))
					BEGIN
						UPDATE tblDCStore SET StockQty = 0 WHERE DCStoreId = @DCStoreId
						SET @AdjustmentQuantity = @AdjustmentQuantity - @StockQuantity
					END

					-- Insert 

					SELECT @ReceiveIdMAX = (ISNULL(MAX(ChalanDetailsId),0)+1) FROM tblChalanDetail
		    
					 INSERT INTO [dbo].[tblChalanDetail]
					   (ChalanDetailsId
					   ,ProductCode
					   ,ProductName
					   ,Quantity
					   ,BatchNo
					   ,UnitPrice
					   ,Value
					   ,Vat
					   ,ValueWVat
					   ,ChalanId
					   ,DCStoreId)
					VALUES
					   (@ReceiveIdMAX--<ChalanDetailsId, int,>
					   ,@ProductCode--<ProductCode, nvarchar(50),>
					   ,@ProductName--<ProductName, nvarchar(50),>
					   ,@Qty--<Quantity, decimal(18,0),>
					   ,@Batch--<BatchNo, nvarchar(50),>
					   ,@Price--<UnitPrice, decimal(18,2),>
					   ,@Qty * @Price --<Value, decimal(18,2),>
					   ,@VAT--<Vat, decimal(18,2),>
					   ,@TotalAmount--<ValueWVat, decimal(18,2),>
					   ,@MasterId--<ChalanId, int,>
					   ,@DCStoreId--<DCStoreId, int,>
					   )

			END

		END

		    -- Fetch the next row from the cursor
		    FETCH NEXT FROM @MyCursor2 
			INTO @ProductId,@ProductCode,@ProductName
		       ,@Batch
		       ,@ExpDate
		       ,@MfgDate
		       ,@Qty
		       ,@Price
		       ,@VAT
		       ,@TotalAmount,@ComUnitId
		END;

		-- Close and deallocate the cursor

		CLOSE @MyCursor2;
		DEALLOCATE @MyCursor2;


	
END