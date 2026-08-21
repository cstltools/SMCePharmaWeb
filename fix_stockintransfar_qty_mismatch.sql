/*
    Problem 3 diagnostic + repair - tblStockInTransfar.Quantity picked up a sibling line's
    quantity instead of its own. See docs/ReceiveQty_Permanent_Fix_Plan.md Problem 3.

    Root cause: sp_SAP_StockInTransfer's CTE joined tblWHStockInDetail to tblRequsitionChild
    on ProductCode + BatchNo only. When one SAP challan carries more than one detail line for
    the SAME product+batch, that join is a cross product and ROW_NUMBER() picks an arbitrary
    partner, so a ReqChildId can be stamped with the wrong line's quantity - either swapped
    between the two lines (net zero, but per-batch wrong) or the same value duplicated onto
    both (net over-receipt).

    Confirmed live example - challan 4500039476, MNS07 batch 004/26:
        SAP posted        2400 + 1680  = 4080
        tblDCStore got    2400 + 2400  = 4800   (+720 phantom stock)

    tblRequsitionChild.ReqQty is NOT affected: sp_SAP_STODetails writes it 1:1 from a cursor
    over tblWHStockInDetail, one row at a time. So ReqQty is the trustworthy value to repair
    from, and "ST.Quantity <> RC.ReqQty" is the detection rule.

    SCOPE - IMPORTANT. Only SAP auto-posted requisitions (tblRequisition.EntryBy='Auto Posting')
    are in scope. For manual CLN-* requisitions, ReqQty is the quantity REQUESTED and
    tblStockInTransfar.Quantity is the quantity actually ISSUED - a difference there is normal
    business data, not this bug. On the dev copy the unscoped rule matched 4,864 rows across
    1,635 requisitions, of which only 82 rows / 31 requisitions were actually SAP-posted.
    Do not widen this filter.

    USAGE
        1. Run as-is (@Apply = 0). Read the three reports.
        2. Take a backup.
        3. Set @Apply = 1 AND set @ChallanNo to one specific challan. The write path
           deliberately refuses to run across every challan at once.
*/

SET NOCOUNT ON;

DECLARE @Apply     BIT            = 0;     -- 0 = report only, 1 = repair
DECLARE @ChallanNo NVARCHAR(500)  = NULL;  -- NULL = report all; required (non-NULL) to repair

-- =====================================================================================
-- 1. Is the permanent fix deployed on this server? If not, new challans keep breaking.
-- =====================================================================================
SELECT 'fix_deployed' AS Report,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns
                      WHERE object_id = OBJECT_ID('dbo.tblRequsitionChild') AND name = 'WHStockInDetailID')
         THEN 'YES - link column present'
         ELSE 'NO  - run deploy_receiveqty_fix.sql, otherwise this corruption recurs'
    END AS LinkColumn,
    (SELECT CONVERT(VARCHAR(19), modify_date, 120) FROM sys.procedures WHERE name = 'sp_SAP_StockInTransfer') AS sp_StockInTransfer_modified,
    (SELECT CONVERT(VARCHAR(19), modify_date, 120) FROM sys.procedures WHERE name = 'sp_SAP_STODetails')      AS sp_STODetails_modified;

-- =====================================================================================
-- 2. Affected rows
-- =====================================================================================
SELECT
    R.IssueChalanNo,
    ST.ReqId,
    ST.StockInTransfarId,
    ST.ReqChildId,
    ST.ProductCode,
    ST.BatchNo,
    RC.ReqQty                       AS CorrectQty,
    ST.Quantity                     AS StoredQty,
    ST.Quantity - RC.ReqQty         AS Diff,
    ST.IsTransfared,
    DS.DCStoreId,
    DS.TotalQuantity                AS DCStore_TotalQty,
    DS.StockQty                     AS DCStore_StockQty,
    DS.TotalQuantity - DS.StockQty  AS AlreadyIssued
INTO #Mismatch
FROM tblStockInTransfar ST
INNER JOIN tblRequsitionChild RC ON RC.ReqChildId = ST.ReqChildId
INNER JOIN tblRequisition     R  ON R.ReqId       = ST.ReqId
LEFT  JOIN tblDCStore         DS ON DS.StockInTransfarId = ST.StockInTransfarId
WHERE ST.Quantity <> RC.ReqQty
  AND R.EntryBy = 'Auto Posting'
  AND (@ChallanNo IS NULL OR R.IssueChalanNo = @ChallanNo);

SELECT 'mismatched_rows' AS Report, * FROM #Mismatch ORDER BY ReqId, StockInTransfarId;

-- Net zero per challan = the two lines swapped, total stock is right but each batch line is wrong.
-- Net non-zero = the challan really holds more (or less) stock than SAP shipped.
SELECT 'per_challan' AS Report,
       IssueChalanNo, ReqId,
       COUNT(*)        AS Rows_,
       SUM(Diff)       AS NetDiff,
       CASE WHEN SUM(Diff) = 0 THEN 'swapped between lines (total OK)'
            ELSE 'REAL over/under receipt' END AS Kind
FROM #Mismatch
GROUP BY IssueChalanNo, ReqId
ORDER BY ABS(SUM(Diff)) DESC, ReqId;

SELECT 'summary' AS Report,
       COUNT(*)                      AS Rows_,
       COUNT(DISTINCT ReqId)         AS Requisitions,
       SUM(Diff)                     AS NetUnitsOff,
       SUM(ABS(Diff))                AS AbsUnitsOff,
       SUM(CASE WHEN AlreadyIssued > 0 THEN 1 ELSE 0 END) AS RowsAlreadyPartlyIssued
FROM #Mismatch;

-- =====================================================================================
-- 3. Repair. One challan at a time, only the rows section 2 listed.
--    StockQty moves by the same delta as TotalQuantity, so whatever has already been issued
--    off the row stays accounted for: StockQty = CorrectQty - AlreadyIssued.
--    A row where that would go negative is reported and skipped - more has been issued than
--    the shipment really contained, which needs a human decision, not an UPDATE.
-- =====================================================================================
IF @Apply = 1 AND @ChallanNo IS NULL
BEGIN
    RAISERROR('Refusing to repair every challan at once. Set @ChallanNo to one specific challan.', 16, 1);
END
ELSE IF @Apply = 1
BEGIN
    SELECT 'SKIPPED_would_go_negative' AS Report, *
    FROM #Mismatch
    WHERE DCStoreId IS NOT NULL AND (CorrectQty - AlreadyIssued) < 0;

    BEGIN TRAN;

    UPDATE DS
    SET DS.TotalQuantity = M.CorrectQty,
        DS.StockQty      = M.CorrectQty - M.AlreadyIssued
    FROM tblDCStore DS
    INNER JOIN #Mismatch M ON M.DCStoreId = DS.DCStoreId
    WHERE (M.CorrectQty - M.AlreadyIssued) >= 0;

    UPDATE ST
    SET ST.Quantity         = M.CorrectQty,
        ST.PickingQty       = M.CorrectQty,
        ST.PriceAmount      = M.CorrectQty * ST.UnitPrice,
        ST.VATAmount        = M.CorrectQty * (CASE WHEN ST.Quantity = 0 THEN 0 ELSE ST.VATAmount / ST.Quantity END),
        ST.TotalPriceAmount = (M.CorrectQty * ST.UnitPrice)
                            + (M.CorrectQty * (CASE WHEN ST.Quantity = 0 THEN 0 ELSE ST.VATAmount / ST.Quantity END))
    FROM tblStockInTransfar ST
    INNER JOIN #Mismatch M ON M.StockInTransfarId = ST.StockInTransfarId
    WHERE M.DCStoreId IS NULL OR (M.CorrectQty - M.AlreadyIssued) >= 0;

    COMMIT TRAN;

    SELECT 'after_repair' AS Report,
           ST.StockInTransfarId, ST.ProductCode, ST.BatchNo,
           RC.ReqQty        AS CorrectQty,
           ST.Quantity      AS StoredQty,
           DS.TotalQuantity AS DCStore_TotalQty,
           DS.StockQty      AS DCStore_StockQty
    FROM #Mismatch M
    INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = M.StockInTransfarId
    INNER JOIN tblRequsitionChild RC ON RC.ReqChildId = ST.ReqChildId
    LEFT  JOIN tblDCStore         DS ON DS.DCStoreId  = M.DCStoreId
    ORDER BY ST.StockInTransfarId;
END

DROP TABLE #Mismatch;
