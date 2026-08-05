
CREATE PROCEDURE [dbo].[sp_SAP_WhStockInMaster] 

	@ChallanNo NVARCHAR(500)
	
AS
BEGIN
	
	DECLARE @Result INT;

		-- Rules
		-- If there is No Unit Price Declare then no data will process (Need Validation)

		DECLARE @TotalQuantity DECIMAL(18, 2);
		DECLARE @TotalVat DECIMAL(18, 2);
		DECLARE @TotalValue DECIMAL(18, 2);
		DECLARE @ChallanDate DATETIME;

		-- Declare the cursor
		DECLARE @MyCursor CURSOR;
		
		-- Open the cursor
		SET @MyCursor = CURSOR FAST_FORWARD FOR

		SELECT challan_date, ISNULL(SUM(quantity), 0) AS TotalQuantity, ISNULL(SUM(quantity * ISNULL(VATAmountPerUnit, 1)), 0) AS TotalVat,
		       SUM(D.quantity*UP.UnitPrice)  +   ISNULL(SUM(quantity * ISNULL(VATAmountPerUnit, 1)), 0) AS TotalValue
		FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD ON SUBSTRING(D.product_code, 13, LEN(D.product_code)) = PD.SAP_Code
		inner JOIN tblUnitPrice AS UP ON PD.ProductId = UP.ProductId
		WHERE UP.IsActive = 1  
		AND challan_code NOT IN (SELECT ChallanNo FROM tblWHStockInMaster WHERE ChallanNo IS NOT NULL) 
		AND UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))
		GROUP BY challan_date HAVING ISNULL(SUM(quantity), 0) > 0


		

		OPEN @MyCursor;
		
		-- Fetch the first row from the cursor
		FETCH NEXT FROM @MyCursor INTO @ChallanDate, @TotalQuantity, @TotalVat, @TotalValue;

		WHILE @@FETCH_STATUS = 0
		BEGIN
		    -- Insert Master
		    DECLARE @WHStockInCode NVARCHAR(MAX) = '';
		    DECLARE @WHStockInId INT = '';
		    DECLARE @ProCount INT = 0;

		    -- Generate a new WHStockInCode
		    SELECT @ProCount = ISNULL(MAX(WHStockInMasterID), 0) + 1 FROM tblWHStockInMaster;
		    DECLARE @length INT = LEN(CONVERT(NVARCHAR(MAX), @ProCount));
		    
		    -- Format WHStockInCode
		    SET @WHStockInCode = 'WHS-' + RIGHT('000000' + CONVERT(NVARCHAR(MAX), @ProCount), 6);

			--print @WHStockInCode
		    
		    -- Generate WHStockInId
		    SELECT @WHStockInId = ISNULL(MAX(WHStockInMasterID), 0) + 1 FROM tblWHStockInMaster;

		    -- Insert into tblWHStockInMaster
		    INSERT INTO [dbo].[tblWHStockInMaster]
		    (
		        WHStockInMasterID,
		        WHStockInCode,
		        ManufacId,
		        WHStockInDate,
		        TotalQuantity,
		        TotalVat,
		        TotalValue,
		        ChallanNo,
		        ChallanDate,
		        Remarks,
		        Status,
		        EntryBy,
		        EntryDate,
		        SupplierId
		    )
		    VALUES
		    (
		        @WHStockInId,
		        @WHStockInCode,
		        1,
		        GETDATE(),
		        @TotalQuantity,
		        @TotalVat,
		        @TotalValue,
		        @ChallanNo,
		        @ChallanDate,
		        'From SAP',
		        'Posted',
		        'Auto Posting',
		        GETDATE(),
		        1
		    );

		    -- Set @Result to the last inserted identity value
		    SELECT @Result = ISNULL(MAX(WHStockInMasterID), 0) FROM tblWHStockInMaster

		    -- Fetch the next row from the cursor
		    FETCH NEXT FROM @MyCursor INTO @ChallanDate, @TotalQuantity, @TotalVat, @TotalValue;
		END;

		-- Close and deallocate the cursor
		CLOSE @MyCursor;
		DEALLOCATE @MyCursor;


		-- Return the result
		RETURN @Result;



	--DECLARE @IsFromWH BIT = 0
	--SELECT @IsFromWH = ISNULL(is_from_wharehouse,0) FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

	----PRINT @IsFromWH

	---- For STO

	--IF(@IsFromWH = 1)
	--BEGIN
		
		

	--END

	
END