
CREATE PROCEDURE [dbo].[sp_SAP_RequisitionMasterUpdate] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHStockInMasterID INT,
	@ReqId INT

AS
BEGIN

	DECLARE @ChallanNo NVARCHAR(MAX)
	DECLARE @TotalVAT DECIMAL(18,2)
	DECLARE @TotalPrice DECIMAL(18,2)
	DECLARE @GrandTotalPrice DECIMAL(18,2)

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------

	SELECT ChallanNo,SUM(CS.TotalPrice) TotalPrice,SUM(CS.TotalVAT) TotalVAT,SUM(CS.TotalAmount) GrandTotalPrice FROM tblWHStockInDetail AS D
	LEFT JOIN tblCentralStore AS CS ON D.WHStockInDetailID = CS.MigoDetailID
	LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
	LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
	LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) =  UPPER(RTRIM(LTRIM(SM.challan_code)))
	LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
	LEFT JOIN tblRequsitionChild AS RD ON PD.ProductCode = RD.ProductCode
	WHERE M.WHStockInMasterID = @WHStockInMasterID AND ReqId = @ReqId
	GROUP BY ChallanNo

	--SELECT DISTINCT ReqChildId FROM tblStockInTransfar WHERE ReqChildId IS NOT NULL

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ChallanNo,@TotalPrice,@TotalVAT, @GrandTotalPrice   
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	UPDATE [dbo].[tblRequisition]
    SET [Submit] = 'OK'
      ,[SubmitDate] = GETDATE()
      ,[IssueChalanNo] = @ChallanNo
      ,[IssuChalanDate] = GETDATE()
      ,[TruckNo] = ''
      ,[DriverName] = ''
      ,[TotalPrice] = @TotalPrice
      ,[TotalVAT] = @TotalVAT
      ,[GrandTotalPrice] = @GrandTotalPrice
      ,[CreatePicking] = 'OK'
      ,[PickingNo] = @ChallanNo
      ,[PickingDate] = GETDATE()
    WHERE ReqId = @ReqId
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @ChallanNo,@TotalPrice,@TotalVAT, @GrandTotalPrice 
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
END