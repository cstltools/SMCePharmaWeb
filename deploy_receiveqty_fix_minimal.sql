/*
    MINIMAL deploy - fixes ONLY the confirmed quantity mis-assignment (Problem 3).

    Symptom: when one SAP challan carries more than one detail line for the SAME product+batch,
    sp_SAP_StockInTransfer's ProductCode+BatchNo join is ambiguous, so tblStockInTransfar.Quantity
    (and therefore tblDCStore) gets a sibling line's quantity - swapped between the two lines, or
    the same value duplicated onto both.
    Confirmed live: challan 4500039476, MNS07 batch 004/26 received as 2400 + 2400 when SAP
    posted 2400 + 1680 -> 720 units of phantom stock at Kushtia DC.

    Deliberately EXCLUDED from this script: sp_SAP_WhStockInMaster's duplicate-shipment
    fingerprint check (Problem 2). That one BLOCKS challans it suspects are re-posts of an
    already-received shipment - a real behaviour change that can hold up a legitimate delivery.
    It is a separate bug and needs ops sign-off. Use deploy_receiveqty_fix.sql for the full set.

    Scope of what this changes:
      - tblRequsitionChild   : one new nullable column, no existing row touched
      - sp_SAP_STODetails    : also writes that column (2 lines)
      - sp_SAP_StockInTransfer: prefers the new column in its join, falls back to the old
                               ProductCode+BatchNo match for rows created before this deploy,
                               so nothing already in flight changes behaviour

    This stops NEW corruption only. Rows already written wrong stay wrong - run
    fix_stockintransfar_qty_mismatch.sql (report first) to find and repair those.

    TAKE A BACKUP FIRST.
*/
SET NOCOUNT ON;
GO

-- 1. Link column: the real 1:1 key between a ReqChildId and the detail row it came from.
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('dbo.tblRequsitionChild') AND name = 'WHStockInDetailID')
BEGIN
    ALTER TABLE dbo.tblRequsitionChild ADD WHStockInDetailID INT NULL;
    PRINT 'Added tblRequsitionChild.WHStockInDetailID';
END
ELSE PRINT 'tblRequsitionChild.WHStockInDetailID already present - skipped';
GO

-- 2. sp_SAP_STODetails
IF OBJECT_ID('dbo.sp_SAP_STODetails') IS NULL EXEC('CREATE PROCEDURE dbo.sp_SAP_STODetails AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [dbo].[sp_SAP_STODetails] --- exec sp_StockInMIGOtoCentralStore 1
	
	@WHMasterInId INT,
	@ReqMasterId INT

AS
BEGIN

	DECLARE @ReceiveIdMAX INT = 0


    DECLARE @WHStockInDetailID INT
	DECLARE @ProductCode NVARCHAR(MAX)
	DECLARE @ProductName NVARCHAR(MAX)
	DECLARE @PackSize NVARCHAR(MAX)
	DECLARE @Batch NVARCHAR(MAX)
	DECLARE @Qty INT
	DECLARE @ExpDate DATETIME
	DECLARE @MfgDate DATETIME
	DECLARE @ChallanNo NVARCHAR(MAX)
	DECLARE @ChallanDate DATETIME
	DECLARE @Price DECIMAL(18,2)
	DECLARE @VAT DECIMAL(18,2)
	DECLARE @ComUnitId INT
	DECLARE @ComUnitCode NVARCHAR(MAX)
	DECLARE @ComUnitName NVARCHAR(MAX)

	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
		
	SELECT WHStockInDetailID,ProductCode,ProductName ,PackSize,Batch,Qty,ExpDate,MfgDate,ChallanNo,ChallanDate,Price,VAT,UT.ComUnitId,UT.ComUnitCode,UT.ComUnitName  FROM tblWHStockInDetail AS D
	LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
	LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
	LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM ON UPPER(RTRIM(LTRIM(M.ChallanNo))) =  UPPER(RTRIM(LTRIM(SM.challan_code)))
	LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
	WHERE M.WHStockInMasterID =  @WHMasterInId

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ComUnitId,@ComUnitCode,@ComUnitName     
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SELECT @ReceiveIdMAX = (ISNULL(MAX(ReqChildId),0)+1) FROM tblRequsitionChild

	-- WHStockInDetailID is threaded through so sp_SAP_StockInTransfer can pair this
	-- ReqChildId back to the exact tblWHStockInDetail row it came from, instead of
	-- re-deriving the match via ProductCode+BatchNo (ambiguous when more than one
	-- detail row shares the same product+batch - see docs/ReceiveQty_Permanent_Fix_Plan.md
	-- Problem 3). This cursor already iterates tblWHStockInDetail one row at a time,
	-- so @WHStockInDetailID is already the correct 1:1 source for this new row.
	INSERT INTO [dbo].[tblRequsitionChild]
           (ReqChildId
           ,ProductCode
           ,ProductName
           ,PackSize
           ,ReqQty
           ,ReqId,BatchNO
           ,WHStockInDetailID)
     VALUES
           (@ReceiveIdMAX
           ,@ProductCode
           ,@ProductName
           ,@PackSize
           ,@Qty
           ,@ReqMasterId,@Batch
           ,@WHStockInDetailID)
	
	 
	FETCH NEXT FROM @MyCursor
	INTO @WHStockInDetailID,@ProductCode,@ProductName ,@PackSize,@Batch,@Qty,@ExpDate,@MfgDate,@ChallanNo,@ChallanDate,@Price,@VAT,@ComUnitId,@ComUnitCode,@ComUnitName   
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor
	
	-- Return Req Id
	RETURN @ReceiveIdMAX


END
GO
PRINT 'Altered sp_SAP_STODetails';
GO

-- 3. sp_SAP_StockInTransfer
IF OBJECT_ID('dbo.sp_SAP_StockInTransfer') IS NULL EXEC('CREATE PROCEDURE dbo.sp_SAP_StockInTransfer AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [dbo].[sp_SAP_StockInTransfer]  --- exec sp_StockInMIGOtoCentralStore 1
    @WHStockInMasterID INT,
    @ReqId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReceiveIdMAX INT = 0;

    DECLARE @ReqChildId INT;
    DECLARE @ProductCode NVARCHAR(MAX);
    DECLARE @ProductName NVARCHAR(MAX);
    DECLARE @PackSize NVARCHAR(MAX);
    DECLARE @Batch NVARCHAR(MAX);
    DECLARE @Qty INT;
    DECLARE @ExpDate DATETIME;
    DECLARE @MfgDate DATETIME;
    DECLARE @Price DECIMAL(18,2);
    DECLARE @VAT DECIMAL(18,2);
    DECLARE @ReceiveDate DATETIME;
    DECLARE @ReceiveId INT;
    DECLARE @IsIssue NVARCHAR(50);

    -- Serializes repeated/concurrent executions of this procedure for the SAME @ReqId so
    -- the "already in tblStockInTransfar?" check below and the inserts that follow it act
    -- as one atomic unit. A prior duplicate submission for the same ReqId (confirmed for
    -- ANM01/batch 004-24 under ReqId 6295 - see docs/ReceiveQty_RootCause_Analysis.md) was
    -- able to insert every ReqChildId twice because two overlapping executions both read
    -- the NOT IN check before either had committed. Scoped per @ReqId (not global) so
    -- unrelated Requisitions still process fully in parallel - this only blocks a second
    -- call from racing a first call that targets the identical @ReqId.
    -- LockOwner='Transaction' releases automatically on COMMIT or ROLLBACK, so there is no
    -- separate release step to forget on any exit path.
    --
    -- This does NOT protect against the same physical SAP shipment being synced under a
    -- DIFFERENT ChalanNo/@ReqId (see docs/ReceiveQty_RootCause_Analysis.md root cause #1,
    -- CRITICAL, still open) - by the time this procedure runs, that duplicate ReqId chain
    -- already exists, created several procedures earlier, and this procedure has no field
    -- available to it that reliably identifies "this ReqId is secretly the same shipment
    -- as that other ReqId" without risking false positives against legitimate repeat
    -- shipments of the same product/batch.
    DECLARE @LockResource NVARCHAR(255) = N'sp_SAP_StockInTransfer_ReqId_' + CONVERT(NVARCHAR(20), @ReqId);
    DECLARE @LockResult INT;

    DECLARE @MyCursor CURSOR;

    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC @LockResult = sp_getapplock
            @Resource = @LockResource,
            @LockMode = 'Exclusive',
            @LockOwner = 'Transaction',
            @LockTimeout = 15000;

        IF @LockResult < 0
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('sp_SAP_StockInTransfer: could not acquire the per-ReqId lock for ReqId=%d (sp_getapplock result=%d). Another synchronization for this requisition is already in progress.', 16, 1, @ReqId, @LockResult);
            RETURN -1;
        END

        SET @MyCursor = CURSOR FAST_FORWARD
        FOR
        WITH CTE AS
        (
            SELECT
                ReqChildId,
                PD.ProductCode,
                PD.ProductName,
                PD.PackSize,
                Batch,
                Qty,
                D.ExpDate,
                D.MfgDate,
                Price,
                VAT,
                CS.ReceiveDate,
                ReceiveId,
                IsIssue,
                ROW_NUMBER() OVER (PARTITION BY RD.ReqChildId ORDER BY RD.ReqChildId) AS rn
            FROM tblWHStockInDetail AS D
            LEFT JOIN tblCentralStore AS CS ON D.WHStockInDetailID = CS.MigoDetailID
            LEFT JOIN tblWHStockInMaster AS M ON D.WHStockInMasterID = M.WHStockInMasterID
            LEFT JOIN tblProduct AS PD ON D.ProductId = PD.ProductId
            LEFT JOIN SAP_API_Data..tblSAP_StockMovementMaster AS SM
                   ON UPPER(RTRIM(LTRIM(M.ChallanNo))) = UPPER(RTRIM(LTRIM(SM.challan_code)))
            LEFT JOIN tblCompanyUnit AS UT ON Sm.to_plant_code = UT.SAP_Code
            -- WHStockInDetailID (populated by sp_SAP_STODetails going forward) is the real
            -- 1:1 key between a ReqChildId and the exact detail row it was created from.
            -- Prefer it whenever present; only fall back to the old ProductCode+BatchNo
            -- match (ambiguous when >1 detail row shares the same product+batch - see
            -- docs/ReceiveQty_Permanent_Fix_Plan.md Problem 3) for legacy ReqChildId rows
            -- created before this column existed, so already-in-flight data isn't disturbed.
            LEFT JOIN tblRequsitionChild AS RD
                   ON (RD.WHStockInDetailID IS NOT NULL AND RD.WHStockInDetailID = D.WHStockInDetailID)
                   OR (RD.WHStockInDetailID IS NULL AND PD.ProductCode = RD.ProductCode AND RD.BatchNO = CS.BatchNO)
            WHERE
                RD.ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar WHERE ReqChildId IS NOT NULL)
                AND M.WHStockInMasterID = @WHStockInMasterID
                AND ReqId = @ReqId
        )
        SELECT
            ReqChildId,
            ProductCode,
            ProductName,
            PackSize,
            Batch,
            Qty,
            ExpDate,
            MfgDate,
            Price,
            VAT,
            ReceiveDate,
            ReceiveId,
            IsIssue
        FROM CTE
        WHERE rn = 1;

        OPEN @MyCursor;

        FETCH NEXT FROM @MyCursor
        INTO @ReqChildId, @ProductCode, @ProductName, @PackSize, @Batch, @Qty, @ExpDate, @MfgDate,
             @Price, @VAT, @ReceiveDate, @ReceiveId, @IsIssue;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @ReceiveIdMAX = (ISNULL(MAX(StockInTransfarId), 0) + 1)
            FROM tblStockInTransfar;

            INSERT INTO [dbo].[tblStockInTransfar]
            (
                StockInTransfarId,
                ReqId,
                ReqChildId,
                ProductCode,
                ProductName,
                PackSize,
                BatchNo,
                Quantity,
                PickingQty,
                UnitPrice,
                PriceAmount,
                VATAmount,
                TotalPriceAmount,
                ExpDate,
                ReceiveDate,
                IsIssue,
                ReceiveId,
                MfgDate
            )
            VALUES
            (
                @ReceiveIdMAX,
                @ReqId,
                @ReqChildId,
                @ProductCode,
                @ProductName,
                @PackSize,
                @Batch,
                @Qty,
                @Qty,
                @Price,
                @Qty * @Price,
                @Qty * @Vat,
                (@Qty * @Price) + (@Qty * @Vat),
                @ExpDate,
                @ReceiveDate,
                @IsIssue,
                @ReceiveId,
                @MfgDate
            );

            FETCH NEXT FROM @MyCursor
            INTO @ReqChildId, @ProductCode, @ProductName, @PackSize, @Batch, @Qty, @ExpDate, @MfgDate,
                 @Price, @VAT, @ReceiveDate, @ReceiveId, @IsIssue;
        END

        CLOSE @MyCursor;
        DEALLOCATE @MyCursor;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('variable', '@MyCursor') >= 0
            CLOSE @MyCursor;
        IF CURSOR_STATUS('variable', '@MyCursor') >= -1
            DEALLOCATE @MyCursor;
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH

    RETURN @ReceiveIdMAX;
END
GO
PRINT 'Altered sp_SAP_StockInTransfer';
GO