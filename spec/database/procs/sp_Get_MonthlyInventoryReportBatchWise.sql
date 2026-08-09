-- Corrected 2026-08-09 to match the LIVE deployed definition (dumped via
-- OBJECT_DEFINITION on the dev DB) after the MonthlyInventoryReportBatchWise.aspx report page work
-- found this file had drifted from what's actually running:
--   - The @ProTypId NVARCHAR(MAX) parameter documented below is NOT present on the live proc - it's
--     commented out there. The live proc takes exactly 3 params: @fromDate, @toDate, @CiD.
--   - Consequently there is no caller-supplied product-type filter; the live WHERE clause hardcodes
--     P.ProductGroupId = COALESCE(NULLIF(1, 0), P.ProductGroupId) (i.e. always ProductGroupId = 1)
--     instead of using COALESCE(NULLIF(@ProTypId, 0), ...) against a parameter.
--   - The live "IssuedToSales" SELECT expression only subtracts tblD.DelQty (not tblDRT.DelQty /
--     tblDRTsub.DelQty like the ClosingStock calc a few lines below does) - kept as-is, not "fixed",
--     since this file documents what's deployed, not a redesign.
-- Any caller of this proc (see Library.DAL/SInventory_DAL/TotalSummaryDAL.cs
-- LoadMonthlyInventoryReportBatchWise) must pass exactly @fromDate/@toDate/@CiD.

CREATE PROCEDURE [dbo].[sp_Get_MonthlyInventoryReportBatchWise]
    @fromDate  DATETIME,
    @toDate    DATETIME,
    @CiD       NVARCHAR(MAX)
    --@ProTypId  NVARCHAR(MAX)
AS
BEGIN

SELECT
    ISNULL(tblBookforDeliveryQty.BookforDeliveryQty, 0)                            AS BookforDeliveryQty,
    ISNULL(tblreturn.ReturnQty, 0) + ISNULL(tbl2ndrtn.Quantity, 0)                 AS ReturnQty,
    ISNULL((SELECT ComUnitName FROM tblCompanyUnit WHERE ComUnitId = @CiD), '')     AS ComUnitName,
    CONVERT(VARCHAR, @fromDate, 6)                                                  AS fromDate,
    CONVERT(VARCHAR, @toDate,   6)                                                  AS toDate,
    P.ProductCode,
    P.ProductName,
    P.PackSize                                                                      AS BaseUnit,
    tbldcstr.BatchNo,                                                               -- BatchNo exposed per row
    ( ISNULL(vTblOB.Quantity,     0) + ISNULL(vTblOBfreez.Quantity, 0) )           AS OpeningStock,
    ISNULL(vTblStoReceive.TotalStockReceiveQty,      0)                             AS ReceiveFromCentralWarehouse,
    ISNULL(vTblChallanReceive.TotalStockReceiveQty,  0)                             AS ReceiveFromAreaOfficeInterTransfer,
    ISNULL(vTblStockReceive.TotalStockReceiveQty,    0)
        + ISNULL(vTblOB.Quantity,        0)
        + ISNULL(vTblSubdeportReturn.qty2, 0)
        + ISNULL(vTblOBfreez.Quantity,   0)                                         AS TotalReceived,
    ( ISNULL(vTblsales.Sales, 0)
        - ( ISNULL(tblD.DelQty,      0)
          ) )                                        AS IssuedToSales,
    ( ISNULL(vTblProductBonus.Sales, 0)
        - ISNULL(tblreturnBonus.DelQty,    0) )
        - ISNULL(tblreturnBonusold.DelQty, 0)                                      AS IssuedToProductBonus,
    ISNULL(vTblChallan.Challan,           0)                                        AS IssuedToAreaOfficeInterTransfer,
    0                                                                               AS IssuedToDamageAndOthers,
    ISNULL(vTblFreez2.Freeze,             0)                                        AS Blocked,
    /* -- Closing Stock -- */
    (
        ( ISNULL(vTblOB.Quantity,          0)
        + ISNULL(vTblOBfreez.Quantity,     0)
        + ISNULL(vTblStoReceive.TotalStockReceiveQty,     0)
        + ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0) )
      - ( ISNULL(vTblsales.Sales, 0)
            - ( ISNULL(tblD.DelQty,      0)
              + ISNULL(tblDRT.DelQty,    0)
              + ISNULL(tblDRTsub.DelQty, 0) ) )
      - ( ISNULL(vTblProductBonus.Sales, 0)
            - ( ISNULL(tblreturnBonus.DelQty,    0)
              + ISNULL(tblreturnBonusold.DelQty,  0) ) )
      - ISNULL(vTblDirectStockOut.StockOutQty, 0)
      - ISNULL(vTblChallan.Challan,            0)
      - ISNULL(vTblChallantoWH.qty,            0)
      + ISNULL(tblreturn.ReturnQty,            0)
    ) + ISNULL(tbl2ndrtn.Quantity, 0)                                               AS ClosingStock,
    ISNULL(vTblChallantoWH.qty,          0)                                         AS WHReturn,
    ISNULL(vTblSubdeportTransfer.qty1,   0)                                         AS SubdepoTransfer,
    ISNULL(vTblSubdeportReturn.qty2,     0)                                         AS Subdeporeturn,
    ISNULL(vTblDirectStockOut.StockOutQty, 0)                                       AS StockOutQty

FROM dbo.tblProduct P WITH (NOLOCK)

-- ====================================================================
-- BatchNo ANCHOR - one row per (ProductCode, BatchNo)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
    GROUP BY ProductCode, BatchNo
) tbldcstr ON tbldcstr.ProductCode = P.ProductCode


-- ====================================================================
-- OPENING BALANCE
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Quantity
    FROM     dbo.tblDCStore_OpeningBalance WITH (NOLOCK)
    WHERE    ComUnitId            = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    DCOpeningBalanceDate = '31-july-2026'
    GROUP BY ProductCode, BatchNo
) vTblOB ON vTblOB.ProductCode = P.ProductCode
        AND vTblOB.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- OPENING BALANCE (FREEZE)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Quantity
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    Opening   = @fromDate
    GROUP BY ProductCode, BatchNo
) vTblOBfreez ON vTblOBfreez.ProductCode = P.ProductCode
             AND vTblOBfreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUB-INVOICE RETURN  (SalesDisDB_SMC)
-- NOTE: cross-database reference to SalesDisDB_SMC (the legacy DB) - that database does not exist
-- on the local dev SQL instance used for this repo's dev testing (only SalesDisDB_SMC_NEWDB does),
-- so this proc fails with "Invalid object name 'SalesDisDB_SMC..tblSubInvoiceMaster'" there. Not a
-- caller bug - confirmed via direct sqlcmd EXEC with valid parameters.
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,

             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblSubInvoiceMaster  I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblSubInvoiceDetail  ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId

    WHERE    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode
) tblDRTsub ON tblDRTsub.ProductCode = P.ProductCode



-- ====================================================================
-- RECEIVE FROM CENTRAL WAREHOUSE
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId        = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    SChalanDetailsId IS NULL
      AND    ChalanDetailsId  IS NULL
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblStoReceive ON vTblStoReceive.ProductCode = P.ProductCode
                AND vTblStoReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RECEIVE FROM AREA OFFICE (INTER TRANSFER)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    ChalanDetailsId IS NOT NULL
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode
                    AND vTblChallanReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- TOTAL STOCK RECEIVE  (used in TotalReceived formula)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(TotalQuantity) AS TotalStockReceiveQty
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode
                  AND vTblStockReceive.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SALES  (Issued to Sales)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS Sales
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 0
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) vTblsales ON vTblsales.ProductCode = P.ProductCode
           AND vTblsales.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- DELIVERY RETURN  (tblD - current DB)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     dbo.tblInvoice       I  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblD ON tblD.ProductCode = P.ProductCode
      AND tblD.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- BOOK FOR DELIVERY
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS BookforDeliveryQty
    FROM     dbo.tblInvoice       I
    JOIN     dbo.tblInvoiceDetail ID ON I.InvoiceId = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.DelivaryInvoiceNo IS NULL
      AND    I.UpdateDate        IS NULL
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) tblBookforDeliveryQty ON tblBookforDeliveryQty.ProductCode = P.ProductCode
                       AND tblBookforDeliveryQty.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- PRODUCT BONUS  (Gift)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.TotalQuantity) AS Sales
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 1
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) vTblProductBonus ON vTblProductBonus.ProductCode = P.ProductCode
                  AND vTblProductBonus.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RETURN BONUS  (Gift return - current DB)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))                         AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     dbo.tblInvoice       I  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 1
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturnBonus ON tblreturnBonus.ProductCode = P.ProductCode
               AND tblreturnBonus.BatchNo       = tbldcstr.BatchNo


-- ====================================================================
-- RETURN BONUS OLD  (Gift return - SalesDisDB_SMC)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.TotalQuantity) - SUM(ID.DeliveryQuantity))                         AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblInvoice       I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore                  ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 1
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturnBonusold ON tblreturnBonusold.ProductCode = P.ProductCode
                   AND tblreturnBonusold.BatchNo       = tbldcstr.BatchNo


-- ====================================================================
-- ISSUED TO AREA OFFICE  (Inter Transfer Challan)
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS Challan
    FROM     dbo.tblChalanDetail CD WITH (NOLOCK)
    JOIN     dbo.tblChalanInfo   CI ON CI.ChalanId = CD.ChalanId
    WHERE    CI.FromComUnitId = COALESCE(NULLIF(@CiD, 0), CI.FromComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblChallan ON vTblChallan.ProductCode = P.ProductCode
             AND vTblChallan.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- FREEZE  (date range - vTblFreez, kept for reference)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo,
             (SUM(StockQty) + SUM(DamageQty)) AS Freeze
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblFreez ON vTblFreez.ProductCode = P.ProductCode
           AND vTblFreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- BLOCKED STOCK
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo,
             (SUM(StockQty) + SUM(DamageQty)) AS Freeze
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
      AND    StockCondition  = 'Blocked'
      AND    ReceiveDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) vTblFreez2 ON vTblFreez2.ProductCode = P.ProductCode
            AND vTblFreez2.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- CURRENT STOCK  (reference only - not used in SELECT)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS Closingstock
    FROM     dbo.tblDCStore WITH (NOLOCK)
    WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
    GROUP BY ProductCode, BatchNo
) currentStock ON currentStock.ProductCode = P.ProductCode
              AND currentStock.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- WH RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty
    FROM     dbo.tblDepotToWHChalanInfo   CI WITH (NOLOCK)
    JOIN     dbo.tblDepotToWHChalanDetail CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit           CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblChallantoWH ON vTblChallantoWH.ProductCode = P.ProductCode
                 AND vTblChallantoWH.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUBDEPO TRANSFER
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty1
    FROM     dbo.tblSubDepotChalanInfo   CI WITH (NOLOCK)
    JOIN     dbo.tblSubDepotChalanDetail CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit          CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblSubdeportTransfer ON vTblSubdeportTransfer.ProductCode = P.ProductCode
                       AND vTblSubdeportTransfer.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- SUBDEPO RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   CD.ProductCode, CD.BatchNo, SUM(CD.Quantity) AS qty2
    FROM     dbo.tblSubDepotChalanReturnInfo    CI WITH (NOLOCK)
    JOIN     dbo.tblSubDepotChalanRetuenDetail  CD ON CI.SChalanId = CD.SChalanId
    JOIN     dbo.tblCompanyUnit                 CU ON CI.FromComUnitCode = CU.ComUnitCode
    WHERE    CI.IsDeliver = 'True'
      AND    CU.ComUnitId = COALESCE(NULLIF(@CiD, 0), CU.ComUnitId)
      AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
    GROUP BY CD.ProductCode, CD.BatchNo
) vTblSubdeportReturn ON vTblSubdeportReturn.ProductCode = P.ProductCode
                     AND vTblSubdeportReturn.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- DIRECT STOCK OUT / ADJUSTMENT VOUCHER
-- ====================================================================
LEFT JOIN (
    SELECT   DD.ProductCode, DD.BatchNo, SUM(DD.StackOutQty) AS StockOutQty
    FROM     dbo.tblDeStockOutMaster  DM WITH (NOLOCK)
    JOIN     dbo.tblDeStockOutDetails DD ON DM.DcStockOutMasterId = DD.DcStockOutMasterId
    JOIN     dbo.tblCompanyUnit       CU ON DM.ComUnitId          = CU.ComUnitId
    WHERE    DM.ComUnitId = COALESCE(NULLIF(@CiD, 0), DM.ComUnitId)
      AND    DM.ApprovedDate BETWEEN @fromDate AND @toDate
    GROUP BY DD.ProductCode, DD.BatchNo
) vTblDirectStockOut ON vTblDirectStockOut.ProductCode = P.ProductCode
                    AND vTblDirectStockOut.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- FREEZE STOCK  (tblfreez - date range, no ComUnitId filter - kept as original)
-- ====================================================================
LEFT JOIN (
    SELECT   ProductCode, BatchNo, SUM(StockQty) AS StockQty
    FROM     dbo.tblDCStoreFreeze WITH (NOLOCK)
    WHERE    StockRcvDate BETWEEN @fromDate AND @toDate
    GROUP BY ProductCode, BatchNo
) tblfreez ON tblfreez.ProductCode = P.ProductCode
          AND tblfreez.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- OLD DELIVERY RETURN  (SalesDisDB_SMC - tblDRT)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             (SUM(ID.Quantity) - SUM(ID.DeliveryQuantity))                              AS DelQty,
             ( (SUM(ID.NetAmount) - SUM(ID.TotalPriceVatAmount))
               - SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount) )            AS SumofNetReturnAmount,
             COUNT(DISTINCT I.DelivaryInvoiceNo)                                         AS NumberofReturnInvoice,
             SUM(ID.TotalPriceVatAmount) - SUM(ID.DeliveryTotalPriceVatAmount)           AS TotalPriceVatAmount
    FROM     SalesDisDB_SMC..tblInvoice       I  WITH (NOLOCK)
    JOIN     SalesDisDB_SMC..tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId
    LEFT JOIN dbo.tblDCStore                  ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct   = 0
      AND    ID.DeliveryStatus IN ('Reject', 'Partial')
      AND    I.UpdateDate  BETWEEN @fromDate AND @toDate
      AND    I.TpGrandTotal     > 0
    GROUP BY ID.ProductCode, ds.BatchNo
) tblDRT ON tblDRT.ProductCode = P.ProductCode
        AND tblDRT.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- 2ND RETURN
-- ====================================================================
LEFT JOIN (
    SELECT   ivD.ProductCode,
             ds.BatchNo,
             SUM(ISNULL(IDR.PreviousQuantity,    0))
           - SUM(ISNULL(IDR.sndReturnQuantity,   0)) AS Quantity
    FROM     dbo.tblInvoice             iv  WITH (NOLOCK)
    JOIN     dbo.tblInvoiceDetail       ivD WITH (NOLOCK) ON iv.InvoiceId       = ivD.InvoiceId
    LEFT JOIN dbo.tblDCStore            ds  WITH (NOLOCK) ON ds.DCStoreId       = ivD.DCStoreId
    JOIN     dbo.tblInvoiceDetailReturn IDR              ON IDR.InvoiceDetailId = ivD.InvoiceDetailId
    WHERE    IDR.PreviousQuantity  <> IDR.sndReturnQuantity
      AND    iv.SndReturnPaymentDate BETWEEN @fromDate AND @toDate
      AND    iv.ComUnitId = COALESCE(NULLIF(@CiD, 0), iv.ComUnitId)
    GROUP BY ivD.ProductCode, ds.BatchNo
) tbl2ndrtn ON tbl2ndrtn.ProductCode = P.ProductCode
           AND tbl2ndrtn.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- INVOICE ACTUAL QTY
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode, ds.BatchNo, SUM(ID.Quantity) AS InvActualQty
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.ComUnitId    = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    ID.ISGiftProduct = 0
      AND    I.InvoiceDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) TblInvActual ON TblInvActual.ProductCode = P.ProductCode
              AND TblInvActual.BatchNo      = tbldcstr.BatchNo


-- ====================================================================
-- RETURN QTY  (tblreturn)
-- ====================================================================
LEFT JOIN (
    SELECT   ID.ProductCode,
             ds.BatchNo,
             SUM(ID.DeliveryQuantity) - SUM(ID.PaymentQuantity) AS ReturnQty
    FROM     dbo.tblInvoiceDetail ID WITH (NOLOCK)
    JOIN     dbo.tblInvoice       I  ON I.InvoiceId  = ID.InvoiceId
    LEFT JOIN dbo.tblDCStore      ds WITH (NOLOCK) ON ds.DCStoreId = ID.DCStoreId
    WHERE    I.PaymentInvoiceNo IS NOT NULL
      AND    ID.DeliveryQuantity <> ID.PaymentQuantity
      AND    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
      AND    I.PaymentDate BETWEEN @fromDate AND @toDate
    GROUP BY ID.ProductCode, ds.BatchNo
) tblreturn ON tblreturn.ProductCode = P.ProductCode
           AND tblreturn.BatchNo      = tbldcstr.BatchNo

-- ====================================================================
-- WHERE / ORDER
-- ====================================================================
WHERE  P.ProductGroupId = COALESCE(NULLIF(1, 0), P.ProductGroupId) and tbldcstr.BatchNo is not null and

 (( ISNULL(vTblsales.Sales, 0)
        - ( ISNULL(tblD.DelQty,      0)
          + ISNULL(tblDRT.DelQty,    0)
          + ISNULL(tblDRTsub.DelQty, 0) ) )  ) >  (ISNULL(vTblStockReceive.TotalStockReceiveQty,    0) + (  ISNULL(tblreturn.ReturnQty, 0) + ISNULL(tbl2ndrtn.Quantity, 0)   ))
        + ISNULL(vTblOB.Quantity,        0)
        + ISNULL(vTblSubdeportReturn.qty2, 0)
        + ISNULL(vTblOBfreez.Quantity,   0)



ORDER BY P.ProductName, tbldcstr.BatchNo

END
