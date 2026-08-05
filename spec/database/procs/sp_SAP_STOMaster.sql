
create PROCEDURE [dbo].[sp_SAP_STOMaster] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHMasterInId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0

	DECLARE @ChallanNo NVARCHAR(MAX)
	DECLARE @ChallanDate DATETIME
	DECLARE @ComUnitId INT
	DECLARE @ComUnitCode NVARCHAR(MAX)
	DECLARE @ComUnitName NVARCHAR(MAX)

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
		
	SELECT ChallanNo,ChallanDate,UT.ComUnitId,UT.ComUnitCode,UT.ComUnitName  FROM tblWHStockInMaster AS M
	LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) =  UPPER(RTRIM(LTRIM(SM.challan_code)))
	LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
	WHERE M.WHStockInMasterID = @WHMasterInId

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @ChallanNo,@ChallanDate,@ComUnitId,@ComUnitCode,@ComUnitName     
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SELECT @ReceiveIdMAX = (ISNULL(MAX(ReqId),0)+1) FROM tblRequisition

	 -- Insert Master

     DECLARE @ReqNo NVARCHAR(MAX) = '';
     DECLARE @WHStockInId INT = '';
     DECLARE @ProCount INT = 0;
     
     -- Generate a new Code

     SELECT @ProCount = ISNULL(MAX(ReqId), 0) + 1 FROM tblRequisition;
     DECLARE @length INT = LEN(CONVERT(NVARCHAR(MAX), @ProCount));
     
     -- Format Code
     SET @ReqNo = 'REQ-' + RIGHT('000000' + CONVERT(NVARCHAR(MAX), @ProCount), 7);

	 --PRINT @ReqNo

	INSERT INTO [dbo].[tblRequisition]
           (ReqId
           ,ReqNo
           ,ReqDate
           ,WarehouseId
           ,WearhouseName
           ,ComUnitId
           ,ComUnitCode
           ,ComUnitName
           ,ManufacId
           ,EntryBy
           ,EntryDate
           )
     VALUES
           (@ReceiveIdMAX
           ,@ReqNo
           ,GETDATE()
           ,1
           ,'Central  Wearhouse'
           ,@ComUnitId
           ,@ComUnitCode
           ,@ComUnitName
           ,1
           ,'Auto Posting'
           ,GETDATE())
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @ChallanNo,@ChallanDate,@ComUnitId,@ComUnitCode,@ComUnitName
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	

	-- Return Req Id

	RETURN @ReceiveIdMAX


END