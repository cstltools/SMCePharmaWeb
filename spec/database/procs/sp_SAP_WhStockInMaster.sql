
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
