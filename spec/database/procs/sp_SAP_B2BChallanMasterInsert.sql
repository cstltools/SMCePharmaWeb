CREATE PROCEDURE [dbo].[sp_SAP_B2BChallanMasterInsert] 

	@ChallanNo NVARCHAR(500)
	
AS
BEGIN
	
		DECLARE @ReceiveIdMAX INT = 0

		-- Rules
		-- If there is No Unit Price Declare then no data will process (Need Validation)

		DECLARE @FromComUnitId INT
		DECLARE @FromUnitCode NVARCHAR(50)
		DECLARE @FromUnitName NVARCHAR(500)
		DECLARE @FromUnitAddress NVARCHAR(MAX)
		DECLARE @ToUnitCode NVARCHAR(50)
		DECLARE @ToUnitName NVARCHAR(500)
		DECLARE @ToUnitAddress NVARCHAR(MAX)
		DECLARE @TotalValue DECIMAL(18, 2);
		DECLARE @TotalVat DECIMAL(18, 2);
		DECLARE @GrandTotal DECIMAL(18, 2);
		DECLARE @ChallanDate DATETIME;

		-- Declare the cursor
		DECLARE @MyCursor CURSOR;
		
		-- Open the cursor
		SET @MyCursor = CURSOR FAST_FORWARD FOR

		SELECT challan_date,FUNT.ComUnitCode FromUnitCode, FUNT.ComUnitName AS FromUnitName, FUNT.Address AS FromUnitAddress, 
		TUNT.ComUnitCode ToUnitCode, TUNT.ComUnitName AS ToUnitName, TUNT.Address AS ToUnitAddress,
		SUM(D.quantity*UP.UnitPrice) AS TotalValue, ISNULL(SUM(quantity * ISNULL(VATAmountPerUnit, 1)), 0) AS TotalVat,
		SUM(D.quantity*UP.UnitPrice)  +   ISNULL(SUM(quantity * ISNULL(VATAmountPerUnit, 1)), 0) AS GrandTotal,FUNT.ComUnitId AS FromComUnitId
		FROM SAP_API_Data..tblSAP_StockMovementMaster AS M
		LEFT JOIN tblCompanyUnit AS FUNT ON M.from_plant_code = FUNT.SAP_Code
		LEFT JOIN tblCompanyUnit AS TUNT ON M.to_plant_code = TUNT.SAP_Code
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON M.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD ON  SUBSTRING(D.product_code, 13, LEN(D.product_code))  = PD.SAP_Code
		LEFT JOIN tblUnitPrice AS UP ON PD.ProductId = UP.ProductId
		WHERE UP.IsActive = 1 
		AND challan_code NOT IN (SELECT ChallanNo FROM tblWHStockInMaster WHERE ChallanNo IS NOT NULL) 
		AND UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))
		GROUP BY challan_date,FUNT.ComUnitCode, FUNT.ComUnitName, FUNT.Address, 
		TUNT.ComUnitCode, TUNT.ComUnitName, TUNT.Address,FUNT.ComUnitId HAVING ISNULL(SUM(quantity), 0) > 0

		OPEN @MyCursor;
		
		-- Fetch the first row from the cursor
		FETCH NEXT FROM @MyCursor 
		INTO @ChallanDate,@FromUnitCode,@FromUnitName,@FromUnitAddress,@ToUnitCode,@ToUnitName,@ToUnitAddress ,@TotalValue, @TotalVat, @GrandTotal,@FromComUnitId;

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SELECT @ReceiveIdMAX = (ISNULL(MAX(ChalanId),0)+1) FROM tblChalanInfo
		    
			INSERT INTO [dbo].[tblChalanInfo]
				(ChalanId
				,ChalanDate
				,ChalanNo
				,TrackNo
				,DriverName
				,FromComUnitCode
				,FromComUnitName
				,FromComUnitAddress
				,ToComUnitCode
				,ToComUnitName
				,ToComUnitAddress
				,TotalValue
				,TotalVat
				,GrandTotal
				,ManufacId
				,IsDeliver
				,FromComUnitId
				,Note)
			VALUES
				(@ReceiveIdMAX--<ChalanId, int,>
				,GETDATE() --<ChalanDate, date,>
				,@ChallanNo --<ChalanNo, nvarchar(max),>
				,''--<TrackNo, nvarchar(max),>
				,''--<DriverName, nvarchar(max),>
				,@FromUnitCode--<FromComUnitCode, nvarchar(max),>
				,@FromUnitName--<FromComUnitName, nvarchar(max),>
				,@FromUnitAddress--<FromComUnitAddress, nvarchar(max),>
				,@ToUnitCode--<ToComUnitCode, nvarchar(max),>
				,@ToUnitName--<ToComUnitName, nvarchar(max),>
				,@ToUnitAddress--<ToComUnitAddress, nvarchar(max),>
				,@TotalValue--<TotalValue, decimal(18,2),>
				,@TotalVat--<TotalVat, decimal(18,2),>
				,@GrandTotal--<GrandTotal, decimal(18,2),>
				,1--<ManufacId, int,>
				,'False'--<IsDeliver, nvarchar(50),>
				,@FromComUnitId--<FromComUnitId, int,>
				,'From SAP'--<Note, nchar(10),>
				)


		    -- Fetch the next row from the cursor
		    FETCH NEXT FROM @MyCursor 
			INTO @ChallanDate,@FromUnitCode,@FromUnitName,@FromUnitAddress,@ToUnitCode,@ToUnitName,@ToUnitAddress ,@TotalValue, @TotalVat, @GrandTotal,@FromComUnitId;
		END;

		-- Close and deallocate the cursor
		CLOSE @MyCursor;
		DEALLOCATE @MyCursor;


		-- Return the result
		RETURN @ReceiveIdMAX;


	
END