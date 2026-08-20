-- SAP-sourced batch-wise monthly inventory report, backing
-- Solution.Web/SInventory_UI/MonthlyInventoryReportBatchWise.aspx.
--
-- Kept as a SEPARATE proc from sp_Get_MonthlyInventoryReportBatchWise: that one is still used by
-- RptBussinessSummary_DayWise.aspx (grid + GetMiClosingChartData, which reads its ClosingStock
-- column), and this one returns a completely different column set.
--
-- @fromDate defaults to 31-Jul-2026 and the UI keeps it there: Opening_Qty comes from the
-- Sap_Stock13thSepOpening snapshot, which has no date column of its own, so moving fromDate forward
-- keeps the same opening but drops the movements before it - the closing would then be wrong.
-- @toDate is the one the user picks; it defaults to today.
--
-- Every join key in these tables (tblProduct.ProductCode/SAP_Code, tblDCStore.ProductCode/BatchNo,
-- the SAP_API_Data columns, Sap_Stock13thSepOpening.*, tblConvQty.ProductCode) is declared
-- NVARCHAR(MAX). SQL Server cannot hash- or merge-join on LOB columns, so joining them directly
-- forces nested loops over the 1.9M-row SAP_API_Data..tbl_DeliveryConfirmation_Sales: the first
-- working version of this query took ~161s for a single sales center. Every key is therefore CAST
-- to NVARCHAR(100) inside the subqueries/CTE below - that is what makes the report usable.

CREATE OR ALTER PROCEDURE [dbo].[sp_Get_MonthlyInventoryReportBatchWise_SAP]
    @fromDate    DATE = '2026-07-31',      -- SAP opening snapshot date; see header
    @toDate      DATE = NULL,              -- NULL = today
    @CiD         NVARCHAR(MAX),
    @ProductCode NVARCHAR(MAX) = NULL      -- optional; matches ProductCode or SAP_Code
AS
BEGIN
    SET NOCOUNT ON;

    IF (@fromDate IS NULL) SET @fromDate = '2026-07-31';
    IF (@toDate   IS NULL) SET @toDate   = CAST(GETDATE() AS DATE);

    IF (LEN(ISNULL(@ProductCode, '')) = 0) SET @ProductCode = NULL;

    ;WITH Prod AS
    (
        SELECT   ProductCode = CAST(ProductCode AS NVARCHAR(100)),
                 SAP_Code    = CAST(SAP_Code    AS NVARCHAR(100)),
                 ProductName,
                 ProductGroupId
        FROM     dbo.tblProduct WITH (NOLOCK)
    )
    SELECT
        P.ProductCode,
        P.SAP_Code,
        P.ProductName,
        tbldcstr.BatchNo,

        ISNULL(vTblsapopening.Sales, 0)                    AS Opening_Qty,
        ISNULL(vTblStockReceive.TotalStockReceiveQty, 0)   AS Cwh_Receive,
        ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0) AS B2B_Rcv,
        ISNULL(vTblsales.Sales, 0)                         AS Sales_Qty,
        ISNULL(vTblRtn.Sales, 0)                           AS Return_Qty,
        ISNULL(vTblChallan.Challan, 0)                     AS B2B_Transfer,

        (   ISNULL(vTblsapopening.Sales, 0)
          + ISNULL(vTblStockReceive.TotalStockReceiveQty, 0)
          + ISNULL(vTblRtn.Sales, 0)
          + ISNULL(vTblChallanReceive.TotalStockReceiveQty, 0) )
      - (   ISNULL(vTblsales.Sales, 0)
          + ISNULL(vTblChallan.Challan, 0) )               AS Closing_Qty

    FROM Prod P

    /* =========================================================
       BATCH ANCHOR - one row per ProductCode + BatchNo
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode = CAST(ProductCode AS NVARCHAR(100)),
                 BatchNo     = CAST(BatchNo     AS NVARCHAR(100))
        FROM     dbo.tblDCStore WITH (NOLOCK)
        WHERE    ComUnitId = COALESCE(NULLIF(@CiD, 0), ComUnitId)
        GROUP BY CAST(ProductCode AS NVARCHAR(100)), CAST(BatchNo AS NVARCHAR(100))
    ) tbldcstr ON tbldcstr.ProductCode = P.ProductCode

    /* =========================================================
       OPENING (SAP 13-Sep opening snapshot, converted to base unit)
       ========================================================= */
    LEFT JOIN (
        SELECT   ID.Sap_Material,
                 ID.Sap_Batch,
                 Sales = SUM(ID.Sap_Stock) / COALESCE(NULLIF(CQ.ConvertionQty, 0), 1)
        FROM     (
                    SELECT   Sap_Material = CAST(Sap_Material AS NVARCHAR(100)),
                             Sap_Batch    = CAST(Sap_Batch    AS NVARCHAR(100)),
                             Sap_Plant    = CAST(Sap_Plant    AS NVARCHAR(100)),
                             Sap_Stock
                    FROM     dbo.Sap_Stock13thSepOpening WITH (NOLOCK)
                 ) ID
        LEFT JOIN Prod PO ON PO.SAP_Code = ID.Sap_Material
        LEFT JOIN (
            SELECT   ProductCode   = CAST(ProductCode AS NVARCHAR(100)),
                     ConvertionQty = MAX(ConvertionQty)
            FROM     dbo.tblConvQty WITH (NOLOCK)
            GROUP BY CAST(ProductCode AS NVARCHAR(100))
        ) CQ ON CQ.ProductCode = PO.ProductCode
        LEFT JOIN dbo.tblCompanyUnit I WITH (NOLOCK) ON I.SAP_Code = ID.Sap_Plant
        WHERE    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
        GROUP BY ID.Sap_Material, ID.Sap_Batch, CQ.ConvertionQty
    ) vTblsapopening ON vTblsapopening.Sap_Material = P.SAP_Code
                    AND vTblsapopening.Sap_Batch    = tbldcstr.BatchNo

    /* =========================================================
       SALES (SAP delivery confirmation)
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode = CAST(ID.ProductCode AS NVARCHAR(100)),
                 Batch       = CAST(ID.Batch       AS NVARCHAR(100)),
                 Sales       = SUM(ID.Quantity)
        FROM     SAP_API_Data..tbl_DeliveryConfirmation_Sales ID WITH (NOLOCK)
        LEFT JOIN dbo.tblCompanyUnit I WITH (NOLOCK) ON I.Customer_Code = CAST(ID.Plant AS NVARCHAR(100))
        WHERE    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
          AND    ID.SalesDocDate BETWEEN @fromDate AND @toDate
        GROUP BY CAST(ID.ProductCode AS NVARCHAR(100)), CAST(ID.Batch AS NVARCHAR(100))
    ) vTblsales ON vTblsales.ProductCode = P.SAP_Code
               AND vTblsales.Batch       = tbldcstr.BatchNo

    /* =========================================================
       RETURN (SAP)
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode = CAST(ID.ProductCode AS NVARCHAR(100)),
                 Batch       = CAST(ID.Batch       AS NVARCHAR(100)),
                 Sales       = SUM(ID.Quantity)
        FROM     SAP_API_Data..tbl_Return ID WITH (NOLOCK)
        LEFT JOIN dbo.tblCompanyUnit I WITH (NOLOCK) ON I.Customer_Code = CAST(ID.Plant AS NVARCHAR(100))
        WHERE    I.ComUnitId = COALESCE(NULLIF(@CiD, 0), I.ComUnitId)
          AND    ID.SalesDocDate BETWEEN @fromDate AND @toDate
        GROUP BY CAST(ID.ProductCode AS NVARCHAR(100)), CAST(ID.Batch AS NVARCHAR(100))
    ) vTblRtn ON vTblRtn.ProductCode = P.SAP_Code
             AND vTblRtn.Batch       = tbldcstr.BatchNo

    /* =========================================================
       RECEIVE FROM CENTRAL WAREHOUSE
       ChalanDetailsId IS NULL keeps this disjoint from B2B_Rcv below - without it the
       inter-transfer receives land in both columns and get counted twice in Closing_Qty.
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode          = CAST(ProductCode AS NVARCHAR(100)),
                 BatchNo              = CAST(BatchNo     AS NVARCHAR(100)),
                 TotalStockReceiveQty = SUM(TotalQuantity)
        FROM     dbo.tblDCStore WITH (NOLOCK)
        WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
          AND    ChalanDetailsId IS NULL
          AND    StockRcvDate BETWEEN @fromDate AND @toDate
        GROUP BY CAST(ProductCode AS NVARCHAR(100)), CAST(BatchNo AS NVARCHAR(100))
    ) vTblStockReceive ON vTblStockReceive.ProductCode = P.ProductCode
                      AND vTblStockReceive.BatchNo     = tbldcstr.BatchNo

    /* =========================================================
       RECEIVE FROM AREA OFFICE (INTER TRANSFER)
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode          = CAST(ProductCode AS NVARCHAR(100)),
                 BatchNo              = CAST(BatchNo     AS NVARCHAR(100)),
                 TotalStockReceiveQty = SUM(TotalQuantity)
        FROM     dbo.tblDCStore WITH (NOLOCK)
        WHERE    ComUnitId       = COALESCE(NULLIF(@CiD, 0), ComUnitId)
          AND    ChalanDetailsId IS NOT NULL
          AND    StockRcvDate BETWEEN @fromDate AND @toDate
        GROUP BY CAST(ProductCode AS NVARCHAR(100)), CAST(BatchNo AS NVARCHAR(100))
    ) vTblChallanReceive ON vTblChallanReceive.ProductCode = P.ProductCode
                        AND vTblChallanReceive.BatchNo     = tbldcstr.BatchNo

    /* =========================================================
       ISSUED TO AREA OFFICE (INTER TRANSFER CHALLAN)
       ========================================================= */
    LEFT JOIN (
        SELECT   ProductCode = CAST(CD.ProductCode AS NVARCHAR(100)),
                 BatchNo     = CAST(CD.BatchNo     AS NVARCHAR(100)),
                 Challan     = SUM(CD.Quantity)
        FROM     dbo.tblChalanDetail CD WITH (NOLOCK)
        JOIN     dbo.tblChalanInfo   CI ON CI.ChalanId = CD.ChalanId
        WHERE    CI.FromComUnitId = COALESCE(NULLIF(@CiD, 0), CI.FromComUnitId)
          AND    CI.ChalanDate BETWEEN @fromDate AND @toDate
        GROUP BY CAST(CD.ProductCode AS NVARCHAR(100)), CAST(CD.BatchNo AS NVARCHAR(100))
    ) vTblChallan ON vTblChallan.ProductCode = P.ProductCode
                 AND vTblChallan.BatchNo     = tbldcstr.BatchNo

    WHERE P.ProductGroupId = 1
      AND tbldcstr.BatchNo IS NOT NULL
      AND (@ProductCode IS NULL OR P.ProductCode = @ProductCode OR P.SAP_Code = @ProductCode)

    ORDER BY P.ProductCode, tbldcstr.BatchNo ASC;
END
