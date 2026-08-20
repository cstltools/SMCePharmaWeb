# Monthly Inventory Report (Batch Wise) — SAP-sourced rewrite

**Date:** 2026-08-21
**Page:** `Solution.Web/SInventory_UI/MonthlyInventoryReportBatchWise.aspx` (see `spec/reports.md` §3)
**Proc:** `spec/database/procs/sp_Get_MonthlyInventoryReportBatchWise_SAP.sql` (new)
**Request:** replace the page's query, search panel and grid with a SAP-sourced batch-wise
opening/movement/closing report.

## What changed

The page previously ran `sp_Get_MonthlyInventoryReportBatchWise`, which derives every figure from
the local `tblInvoice`/`tblInvoiceDetail`/`tblDCStore_OpeningBalance` tables and returns ~20
columns. It now runs a new proc that takes opening stock, sales and returns from the **SAP**
sources instead:

| Column | Source |
| --- | --- |
| `Opening_Qty` | `Sap_Stock13thSepOpening` (÷ `tblConvQty.ConvertionQty`, plant matched on `tblCompanyUnit.SAP_Code`) |
| `Cwh_Receive` | `tblDCStore`, `ChalanDetailsId IS NULL`, within period |
| `B2B_Rcv` | `tblDCStore`, `ChalanDetailsId IS NOT NULL`, within period |
| `Sales_Qty` | `SAP_API_Data..tbl_DeliveryConfirmation_Sales` (plant matched on `tblCompanyUnit.Customer_Code`) |
| `Return_Qty` | `SAP_API_Data..tbl_Return` (same plant match) |
| `B2B_Transfer` | `tblChalanDetail` + `tblChalanInfo`, `FromComUnitId` = the DC |
| `Closing_Qty` | `(Opening + Cwh_Receive + B2B_Rcv + Return) - (Sales + B2B_Transfer)` |

Row grain is unchanged: one row per (ProductCode, BatchNo) anchored on `tblDCStore` for the
selected sales center, filtered to `ProductGroupId = 1`.

### Why a new proc instead of editing the old one

`sp_Get_MonthlyInventoryReportBatchWise` is still called by `RptBussinessSummary_DayWise.aspx` —
both its section-3 grid and `GetMiClosingChartData`, which reads that proc's `ClosingStock` column.
The column sets have nothing in common, so the old proc is left untouched and the new one lives
beside it.

## Deviations from the query as supplied

Four deliberate differences from the draft query this was built from:

1. **`@CiD` in the sales subquery.** The draft had `COALESCE(NULLIF(8, 0), I.ComUnitId)` — a
   hardcoded sales center left over from testing. Every DC would have shown Mymensingh's sales.
2. **`Cwh_Receive` excludes inter-transfer receives** (`ChalanDetailsId IS NULL`). The draft used
   the unfiltered `tblDCStore` receive total for `Cwh_Receive` and then added `B2B_Rcv` on top in
   the closing formula, so every inter-transfer receive was counted in both columns and twice in
   `Closing_Qty` (`B2B_Rcv` is by construction a strict subset of the unfiltered total).
3. **Dropped the `tblDCStore_OpeningBalance` join.** It was joined but never selected — opening
   comes from the SAP snapshot.
4. **Added `tbldcstr.BatchNo IS NOT NULL`**, matching the old proc, so products with no batch at
   the DC don't render as all-zero rows.

## Performance — LOB join keys

The first working version took **161s** for a single sales center. Cause: nearly every join key in
these tables is declared `NVARCHAR(MAX)` — `tblProduct.ProductCode`/`SAP_Code`,
`tblDCStore.ProductCode`/`BatchNo`, `tblConvQty.ProductCode`, `Sap_Stock13thSepOpening.*`, and the
`SAP_API_Data` columns. SQL Server cannot hash- or merge-join on LOB columns, so the optimizer fell
back to nested loops over the 1.9M-row `tbl_DeliveryConfirmation_Sales`.

Casting every key to `NVARCHAR(100)` inside the subqueries/CTE (and in their `GROUP BY`) brought
the same query to **0.7s**. No index changes were needed. This applies to any new report query over
these tables.

## UI

- **Filters:** Sales Center (required) · Product Code (optional, matches `ProductCode` **or**
  `SAP_Code`) · From Date · To Date.
- **From Date is pinned to 31-Jul-2026.** `Opening_Qty` comes from `Sap_Stock13thSepOpening`, a
  snapshot with no date column of its own — moving From Date forward keeps the same opening but
  drops the movements before it, so the closing would be wrong. The datepicker's `min` and
  `Validate()` both enforce it; To Date is free and defaults to today.
- **Grid:** Product Code · SAP Code · Product Name · Batch No · Opening Qty (`{0:N2}`) · CWH Receive
  · B2B Receive · Sales Qty · Return Qty · B2B Transfer · Closing Qty.
- **Closing Qty header** carries an info button (Bootstrap 5 popover, `data-bs-trigger="focus"`)
  showing the formula on click. Initialised in `pageLoad()` alongside select2/pickadate because the
  UpdatePanel rebuilds the header on every partial postback. Closing Qty is therefore a
  `TemplateField`; the Excel export resets that header cell's `Text` so the button markup doesn't
  leak into the sheet.
- **Sticky header:** `#MainGradeDiv th { position: sticky; top: 0; }` — `#MainGradeDiv` is already
  the 600px scroll container. Needs an explicit background (`#E5EEF1`, the same colour the Excel
  export uses) or rows show through, and `box-shadow: inset` to redraw the `table-bordered` borders
  that scroll out from under a sticky cell.

## Verification

Run against the dev DB (`127.0.0.1,57694` / `SalesDisDB_SMC_NEWDB`), Mymensingh DC (`@CiD = 8`):

| Run | Rows | Total Sales | Time |
| --- | --- | --- | --- |
| defaults (no dates passed) | 3336 | 36,907 | 1.0s |
| `@fromDate` 31-Jul → `@toDate` 21-Aug | 3336 | 36,907 | 0.7s |
| `@fromDate` 31-Jul → `@toDate` 05-Aug | 3336 | 10,042 | 0.6s |
| `+ @ProductCode = 'ANB03'` | 96 | 1,024 | 0.5s |

`Closing_Qty` reconciles against the formula on every one of the 3336 rows (0 mismatches).
Spot check — ANB03 / batch 003: 445 + 0 + 0 + 13 − 455 − 0 = **3**, matching the grid.

## Deploy

1. Run `spec/database/procs/sp_Get_MonthlyInventoryReportBatchWise_SAP.sql` (`CREATE OR ALTER`,
   safe to re-run). Nothing else in the database changes; the menu entry from
   `spec/database/menu/MonthlyInventoryReportBatchWise_menu.sql` is unchanged.
2. Deploy the rebuilt `Library.BLL.dll` / `Library.DAL.dll` — `LoadMonthlyInventoryReportBatchWiseSap`
   is new on both. A site running the old DLLs against the new `.aspx.cs` fails with
   `CS1501: No overload for method 'LoadMonthlyInventoryReportBatchWiseSap' takes 4 arguments`.
3. Deploy the two page files.
