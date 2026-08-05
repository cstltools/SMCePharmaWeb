-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_WingsSalesReport] 

 @parameter NVARCHAR(MAX),
 @fDate DATETIME,
 @tdate DATETIME

AS
BEGIN
	

	  DECLARE @Sales TABLE 
	(
	  CompanyId INT, 
	  ComUnitId INT,
	  CompanyCode NVARCHAR(500),
	  CompanyName NVARCHAR(500),
	  ComUnitName NVARCHAR(500),
	  InvoiceValue DECIMAL(18,2),
	  ActualSales DECIMAL(18,2),
	  InTransit DECIMAL(18,2),
	  Reject DECIMAL(18,2),
	  DDValue DECIMAL(18,2),
	  FromDate DATEtime,
	  ToDate DATEtime
	)


	DECLARE @CompanyId INT
	DECLARE @ComUnitId INT
	DECLARE @CompanyCode NVARCHAR(500)
	DECLARE @CompanyName NVARCHAR(500)
	DECLARE @ComUnitName NVARCHAR(500)
	DECLARE @ActualSales DECIMAL(18,2)
	DECLARE @InTransit DECIMAL(18,2)
	DECLARE @Reject DECIMAL(18,2)
	DECLARE @InvoiceValue DECIMAL(18,2) 
	DECLARE @DDValue DECIMAL(18,2)



	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	SELECT CI.CompanyId,CI.CompanyCode,CI.CompanyName,UNT.ComUnitId,UNT.ComUnitName FROM dbo.tblCompanyUnit AS UNT 
	INNER JOIN dbo.tblCompanyInfo AS CI ON CI.CompanyId = UNT.CompanyId 
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @CompanyId,@CompanyCode,@CompanyName,@ComUnitId,@ComUnitName
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		--PRINT CONVERT(NVARCHAR(max),@CompanyCode)
		--PRINT CONVERT(NVARCHAR(max),@CompanyName)
		--PRINT CONVERT(NVARCHAR(max),@ComUnitName)
		
		SELECT @InvoiceValue =  SUM(INVD.UnitPrice*INVD.Quantity) FROM dbo.tblInvoice AS INV   
		LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId  
		LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId  
		LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId   
		WHERE INV.InvoiceNo IS NOT NULL  AND INV.InvoiceDate BETWEEN @fDate AND @tdate AND INV.ComUnitId = @ComUnitId
		
	
		--PRINT CONVERT(NVARCHAR(max),@InvoiceValue)	
	
		SELECT @ActualSales = SUM(CASE WHEN INVD.DeliveryNetAmount > 0 THEN  INVD.DeliveryNetAmount  ELSE 0 END)
		FROM dbo.tblInvoice AS INV 
		LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
		LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
		LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
		WHERE INV.DeliveryInvoiceStatus IN ('Full','Partial') AND INVD.Quantity > 0  AND INV.InvoiceDate BETWEEN @fDate AND @tdate AND INV.ComUnitId = @ComUnitId
	
		--PRINT CONVERT(NVARCHAR(max),@ActualSales)	
	

		SELECT @Reject = SUM((((((INVD.UnitPrice*INVD.Quantity) - INVD.DelivarySpecialAmount))/INVD.Quantity)*(INVD.Quantity-INVD.DeliveryQuantity)) + ((INVD.DelivarySpecialAmount/INVD.Quantity)*(INVD.Quantity-INVD.DeliveryQuantity)))
		FROM dbo.tblInvoice AS INV 
		LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
		LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
		LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
		WHERE INV.DeliveryInvoiceStatus IN ('Reject','Partial') AND INVD.Quantity > 0 AND INV.InvoiceDate BETWEEN @fDate AND @tdate AND INV.ComUnitId = @ComUnitId
	
		--PRINT CONVERT(NVARCHAR(max),@Reject)	
	
		SELECT @InTransit = SUM(INVD.UnitPrice*INVD.Quantity)  FROM dbo.tblInvoice AS INV 
				LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
				LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
				LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId 
				WHERE INV.DeliveryInvoiceStatus IS NULL  AND INV.InvoiceDate BETWEEN @fDate AND @tdate  AND INV.ComUnitId = @ComUnitId
	
		--PRINT CONVERT(NVARCHAR(max),@InTransit)
		

		SELECT @DDValue = SUM((INVD.DelivarySpecialAmount / INVD.Quantity) * INVD.DeliveryQuantity) + SUM(DeliveryDiscountAmount)
		FROM dbo.tblInvoice AS INV 
		LEFT JOIN dbo.tblInvoiceDetail AS INVD ON INV.InvoiceId = INVD.InvoiceId
		LEFT JOIN dbo.tblCompanyUnit AS UNT ON INV.ComUnitId = UNT.ComUnitId
		LEFT JOIN dbo.tblCompanyInfo AS CI ON UNT.CompanyId = CI.CompanyId
		WHERE INV.DeliveryInvoiceStatus IN ('Full','Partial') AND INVD.Quantity > 0  AND INV.InvoiceDate BETWEEN @fDate AND @tdate AND INV.ComUnitId = @ComUnitId
		
		INSERT INTO @Sales
		(
		    CompanyId,
			ComUnitId,
		    CompanyCode,
		    CompanyName,
		    ComUnitName,
		    InvoiceValue,
		    ActualSales,
		    InTransit,
		    Reject,
			DDValue,
			FromDate,
			ToDate
		)
		VALUES
		(   @CompanyId,    -- CompanyId - int
			@ComUnitId,    -- CompanyId - int
		    @CompanyCode,  -- CompanyCode - nvarchar(500)
		    @CompanyName,  -- CompanyName - nvarchar(500)
		    @ComUnitName,  -- ComUnitName - nvarchar(500)
		    ISNULL(@InvoiceValue,0), -- InvoiceValue - decimal(18, 2)
		    ISNULL(@ActualSales,0), -- ActualSales - decimal(18, 2)
		    ISNULL(@InTransit,0), -- InTransit - decimal(18, 2)
		    ISNULL(@Reject,0),  -- Reject - decimal(18, 2)
			ISNULL(@DDValue,0),  -- Reject - decimal(18, 2)
			@fDate,
			@tdate
		)
			
	
	FETCH NEXT FROM @MyCursor
	INTO @CompanyId,@CompanyCode,@CompanyName,@ComUnitId,@ComUnitName
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor



	SELECT CompanyId,CompanyName,ComUnitName AS Depot,InvoiceValue,ActualSales,
		InTransit,Reject,DDValue,FromDate,ToDate FROM @Sales WHERE (ActualSales > 0 OR InTransit > 0 OR InvoiceValue > 0 OR Reject > 0 OR DDValue > 0) 


	



	--IF(@parameter = '')
	--BEGIN

	--	SET @Query = 'SELECT CompanyId,CompanyName,ComUnitName AS Depot,InvoiceValue,ActualSales,
	--	InTransit,Reject FROM ' + @Sales + ' WHERE (ActualSales > 0 OR InTransit > 0 OR InvoiceValue > 0 OR Reject > 0) ' 

	--END
	
	--IF(@parameter != '')
	--BEGIN

	--	SET @Query = 'SELECT CompanyId,CompanyName,ComUnitName AS Depot,InvoiceValue,ActualSales,
	--	InTransit,Reject FROM ' + @Sales + ' WHERE (ActualSales > 0 OR InTransit > 0 OR InvoiceValue > 0 OR Reject > 0) ' + @parameter
		
	--END

	--EXEC(@Query)

END


