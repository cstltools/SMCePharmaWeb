/*
    Deploy the ReceiveQty fix (docs/ReceiveQty_Permanent_Fix_Plan.md) to a server that does
    not have it yet. Generated from the dev DB, which is byte-in-sync with the
    spec/database/procs copies in this repo.

    Symptom this fixes: when one SAP challan carries more than one detail line for the SAME
    product+batch, sp_SAP_StockInTransfer's ProductCode+BatchNo join is ambiguous, so
    tblStockInTransfar.Quantity (and therefore tblDCStore) can get a sibling line's quantity -
    either swapped between the two lines, or the same value duplicated onto both.
    Confirmed live example: challan 4500039476, MNS07 batch 004/26 received as 2400 + 2400
    when SAP posted 2400 + 1680.

    Additive and reversible: one nullable column, one new table, three ALTER PROCEDUREs.
    No existing row is modified by this script - it only stops NEW occurrences.
    To repair rows already written wrong, run fix_stockintransfar_qty_mismatch.sql afterwards.

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

-- 2. Duplicate-shipment flag table used by sp_SAP_WhStockInMaster.
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'tblSAP_SuspectedDuplicateShipment')
BEGIN
    CREATE TABLE dbo.tblSAP_SuspectedDuplicateShipment
    (
        SuspectedDuplicateId     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        NewChallanNo             NVARCHAR(500)  NOT NULL,
        MatchedWHStockInMasterID INT            NOT NULL,
        MatchedChallanNo         NVARCHAR(500)  NULL,
        LineCount                INT            NOT NULL,
        DetectedDate             DATETIME       NOT NULL CONSTRAINT DF_SAPSuspDup_Detected DEFAULT (GETDATE()),
        Resolved                 BIT            NOT NULL CONSTRAINT DF_SAPSuspDup_Resolved DEFAULT (0),
        ResolvedBy               NVARCHAR(200)  NULL,
        ResolvedDate             DATETIME       NULL,
        ResolutionNote           NVARCHAR(1000) NULL
    );
    PRINT 'Created tblSAP_SuspectedDuplicateShipment';
END
ELSE PRINT 'tblSAP_SuspectedDuplicateShipment already present - skipped';
GO
-- 3. sp_SAP_STODetails
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

-- 4. sp_SAP_StockInTransfer
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

-- 5. sp_SAP_WhStockInMaster
IF OBJECT_ID('dbo.sp_SAP_WhStockInMaster') IS NULL EXEC('CREATE PROCEDURE dbo.sp_SAP_WhStockInMaster AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [dbo].[sp_SAP_WhStockInMaster]

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

		-- ==================================================================================
		-- Duplicate-SHIPMENT detection (Problem 2 - see docs/ReceiveQty_Permanent_Fix_Plan.md).
		--
		-- ChallanNo alone cannot identify a unique physical SAP shipment: SAP_API_Data has
		-- re-posted the SAME shipment under a re-issued/renumbered challan_code string more
		-- than once historically (confirmed: suffix variants like "..._Re"/"..._ReNew",
		-- prefix variants like "K..."/"100...", and plain sequential renumbering - no
		-- consistent string pattern exists to parse). No other SAP-native field survives a
		-- ChallanNo change either (truck_no/driver_name are empty or reused as non-identity
		-- markers on the confirmed duplicate records; to_plant_code is stable but shared by
		-- every shipment to that DC, far too coarse to be an identity).
		--
		-- The one signal that held up against all 8 confirmed real duplicate-shipment groups
		-- found in this dataset is the shipment's full line-item CONTENT: the exact multiset
		-- of (ProductId, Batch, Quantity) tuples. Two different ChalanNo values whose entire
		-- detail-line set matches exactly are, in every confirmed case, the same physical
		-- shipment re-synced under a different code - never a coincidence for >=3 lines.
		--
		-- This does not silently merge or block anything: a >=3-line exact match halts
		-- auto-creating a NEW tblWHStockInMaster row for @ChallanNo (so the whole downstream
		-- Requisition/StockInTransfer chain never fires for it) and logs the match to
		-- tblSAP_SuspectedDuplicateShipment for manual confirmation. A 1-2 line match is
		-- logged only, never blocked, because a small basket could plausibly repeat by
		-- legitimate coincidence - "legitimate multiple SAP movements must not be blocked."
		-- Marking a logged row Resolved=1 (with ResolutionNote) lets ops re-run this exact
		-- ChallanNo and have it proceed normally even though the same match is found again.
		-- ==================================================================================
		DECLARE @CandidateFingerprint NVARCHAR(MAX);
		DECLARE @CandidateLineCount INT;

		-- Quantity is normalized to a fixed DECIMAL(18,2) before stringifying on BOTH sides
		-- of the comparison below (here and in ExistingFingerprint) - SAP_API_Data.quantity
		-- and tblWHStockInDetail.Qty are both "decimal" but with different scale, so a bare
		-- CAST(...AS VARCHAR) renders the same value as "10.00" on one side and "10" on the
		-- other, silently breaking every match. Confirmed by a live test this session.
		SELECT
		    @CandidateFingerprint =
		        STRING_AGG(CAST(PD.ProductId AS VARCHAR(20)) + '|' + ISNULL(D.batch_no, '') + '|' + CAST(CAST(D.quantity AS DECIMAL(18,2)) AS VARCHAR(20)), ';')
		            WITHIN GROUP (ORDER BY PD.ProductId, D.batch_no, D.quantity),
		    @CandidateLineCount = COUNT(*)
		FROM SAP_API_Data..tblSAP_StockMovementMaster AS CM
		LEFT JOIN SAP_API_Data..tblSAP_StockMovementDetail AS D ON CM.StockMovementMasterId = D.StockMovementMasterId
		LEFT JOIN tblProduct AS PD ON SUBSTRING(D.product_code, 13, LEN(D.product_code)) = PD.SAP_Code
		INNER JOIN tblUnitPrice AS CUP ON PD.ProductId = CUP.ProductId
		WHERE CUP.IsActive = 1
		  AND ISNULL(D.quantity, 0) > 0
		  AND UPPER(RTRIM(LTRIM(CM.challan_code))) = UPPER(RTRIM(LTRIM(@ChallanNo)));

		DECLARE @MatchedWHStockInMasterID INT = NULL;
		DECLARE @MatchedChallanNo NVARCHAR(500) = NULL;
		DECLARE @AlreadyResolved BIT = 0;
		DECLARE @BlockNewMaster BIT = 0;

		IF @CandidateLineCount > 0 AND @CandidateFingerprint IS NOT NULL
		BEGIN
		    ;WITH ExistingFingerprint AS
		    (
		        SELECT
		            ED.WHStockInMasterID,
		            STRING_AGG(CAST(ED.ProductId AS VARCHAR(20)) + '|' + ISNULL(ED.Batch, '') + '|' + CAST(CAST(ED.Qty AS DECIMAL(18,2)) AS VARCHAR(20)), ';')
		                WITHIN GROUP (ORDER BY ED.ProductId, ED.Batch, ED.Qty) AS Fp,
		            COUNT(*) AS LineCount
		        FROM tblWHStockInDetail AS ED
		        INNER JOIN tblWHStockInMaster AS EM ON EM.WHStockInMasterID = ED.WHStockInMasterID
		        WHERE EM.WHStockInDate >= DATEADD(DAY, -90, GETDATE())
		          AND UPPER(RTRIM(LTRIM(ISNULL(EM.ChallanNo, '')))) <> UPPER(RTRIM(LTRIM(@ChallanNo)))
		        GROUP BY ED.WHStockInMasterID
		    )
		    SELECT TOP 1
		        @MatchedWHStockInMasterID = EF.WHStockInMasterID,
		        @MatchedChallanNo = EM2.ChallanNo
		    FROM ExistingFingerprint AS EF
		    INNER JOIN tblWHStockInMaster AS EM2 ON EM2.WHStockInMasterID = EF.WHStockInMasterID
		    WHERE EF.Fp = @CandidateFingerprint AND EF.LineCount = @CandidateLineCount
		    ORDER BY EM2.WHStockInMasterID DESC;

		    IF @MatchedWHStockInMasterID IS NOT NULL
		    BEGIN
		        SELECT TOP 1 @AlreadyResolved = 1
		        FROM tblSAP_SuspectedDuplicateShipment
		        WHERE UPPER(RTRIM(LTRIM(NewChallanNo))) = UPPER(RTRIM(LTRIM(@ChallanNo)))
		          AND MatchedWHStockInMasterID = @MatchedWHStockInMasterID
		          AND Resolved = 1;

		        IF @AlreadyResolved = 0
		        BEGIN
		            IF NOT EXISTS (
		                SELECT 1 FROM tblSAP_SuspectedDuplicateShipment
		                WHERE UPPER(RTRIM(LTRIM(NewChallanNo))) = UPPER(RTRIM(LTRIM(@ChallanNo)))
		                  AND MatchedWHStockInMasterID = @MatchedWHStockInMasterID
		            )
		            BEGIN
		                INSERT INTO dbo.tblSAP_SuspectedDuplicateShipment
		                    (NewChallanNo, MatchedWHStockInMasterID, MatchedChallanNo, LineCount)
		                VALUES
		                    (@ChallanNo, @MatchedWHStockInMasterID, @MatchedChallanNo, @CandidateLineCount);
		            END

		            IF @CandidateLineCount >= 3
		                SET @BlockNewMaster = 1;
		        END
		    END
		END
		-- ==================================================================================
		-- End duplicate-shipment detection.
		-- ==================================================================================

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
		    IF @BlockNewMaster = 0
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
		    END

		    -- Fetch the next row from the cursor
		    FETCH NEXT FROM @MyCursor INTO @ChallanDate, @TotalQuantity, @TotalVat, @TotalValue;
		END;

		-- Close and deallocate the cursor
		CLOSE @MyCursor;
		DEALLOCATE @MyCursor;


		-- Return the result: 0 (unchanged) when blocked as a suspected duplicate and no
		-- prior master existed for this exact ChalanNo, so sp_SAP_StockReceive's
		-- IF(@WHStockinMasterId > 0) guard correctly skips the rest of the chain.
		RETURN @Result;



	--DECLARE @IsFromWH BIT = 0
	--SELECT @IsFromWH = ISNULL(is_from_wharehouse,0) FROM SAP_API_Data..tblSAP_StockMovementMaster WHERE UPPER(RTRIM(LTRIM(challan_code))) =  UPPER(RTRIM(LTRIM(@ChallanNo)))

	----PRINT @IsFromWH

	---- For STO

	--IF(@IsFromWH = 1)
	--BEGIN



	--END


END
GO
PRINT 'Altered sp_SAP_WhStockInMaster';
GO

