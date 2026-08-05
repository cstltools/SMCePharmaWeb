
CREATE PROCEDURE [dbo].[sp_SAP_RequisitionDetailUpdate] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHStockInMasterID INT,
	@ReqId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0

    DECLARE @ReqChildId INT
	DECLARE @ProductCode NVARCHAR(MAX)
	DECLARE @ProductName NVARCHAR(MAX)
	DECLARE @PackSize NVARCHAR(MAX)
	DECLARE @Batch NVARCHAR(MAX)
	DECLARE @Qty INT
	DECLARE @ExpDate DATETIME
	DECLARE @MfgDate DATETIME
	DECLARE @Price DECIMAL(18,2)
	DECLARE @VAT DECIMAL(18,2)
	DECLARE @ReceiveDate DATETIME
	DECLARE @ReceiveId INT
	DECLARE @IsIssue NVARCHAR(50)

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
		
	SELECT ReqChildId,PD.ProductCode,PD.ProductName,PD.PackSize,Batch,Qty,D.ExpDate,D.MfgDate,Price,VAT,CS.ReceiveDate,ReceiveId,IsIssue  FROM tblWHStockInDetail AS D
	LEFT JOIN tblCentralStore AS CS ON D.WHStockInDetailID = CS.MigoDetailID
	LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
	LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
	LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) =  UPPER(RTRIM(LTRIM(SM.challan_code)))
	LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
	LEFT JOIN tblRequsitionChild AS RD ON PD.ProductCode = RD.ProductCode
	WHERE M.WHStockInMasterID = @WHStockInMasterID AND ReqId = @ReqId

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ReqChildId,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@Price,@VAT,@ReceiveDate,@ReceiveId,@IsIssue     
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	UPDATE [dbo].[tblRequsitionChild]
	
	SET 
       IssueQty = @Qty --<IssueQty, decimal(18,0),>
      ,UnitPrice = @Price --<UnitPrice, decimal(18,2),>
      ,PriceAmount = @Qty * @Price --<PriceAmount, decimal(18,2),>
      ,VATAmount = @Qty * @VAT --<VATAmount, decimal(18,2),>
      ,TotalPrice = (@Qty * @Price) + (@Qty * @VAT) --<TotalPrice, decimal(18,2),>
      ,IsIssue = 'OK' --<IsIssue, nvarchar(max),>
      ,CaseQty = @Qty --<CaseQty, decimal(18,0),>
      ,MusakVATAmount = 0--<MusakVATAmount, decimal(18,2),>
      ,MusakTotalPrice = 0 --<MusakTotalPrice, decimal(18,2),>
      ,IsPicking = 'OK'--<IsPicking, nvarchar(max),>

     WHERE ReqChildId = @ReqChildId
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @ReqChildId,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@Price,@VAT,@ReceiveDate,@ReceiveId,@IsIssue 
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
	-- Return Req Id
	RETURN @ReceiveIdMAX


END