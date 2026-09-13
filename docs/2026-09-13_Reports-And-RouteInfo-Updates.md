# 2026-09-13 — small batch: MIO summary, batch-wise report, route info, DA expense bill

**Date:** 2026-09-13

## What changed

- **MIO-wise Business Summary** (`SInventory_UI/MIOWiseBusinessSummary.aspx`) — added an "only
  active" checkbox. `sp_RPT_MIOWiseBusinessSummary` gains `@OnlyActive bit = 0`; when set, the
  result is filtered to `emp.EmployeeStatus = 'Active'` (replacing a previously commented-out
  `isActive=1` filter). Default is off (unfiltered), matching prior behavior.
  `TotalSummaryBLL`/`TotalSummaryDAL.LoadMIOWiseBusinessSummaryDAL` both gained a trailing
  `bool onlyActive` parameter.
- **Monthly Inventory Report (Batch Wise)** (`SInventory_UI/MonthlyInventoryReportBatchWise.aspx`)
  — added a "Show All Zero Value" checkbox (`AutoPostBack`). Unchecked (default) hides any row
  where all 7 quantity columns are zero; filtering is done in C# over the already-fetched
  `DataTable`, not in the proc.
- **Route Information List** (`MasterSetup_UI/RouteInformationList.aspx`) — grid gained Route
  Type, TA Amount, DA Amount and Route Day columns. `sp_Get_RouteInformationMasterList` now joins
  `tblRouteTypeInfo` for `RouteTypeName` and adds an `OUTER APPLY` over
  `tblRouteInformationWeekNameDetails`/`tblWeekNameInfo` for a comma-joined `RouteDayNames`,
  mirroring the existing `DANames` pattern.
- **DA Expense Bill — Day Wise** (`SInventory_RPTVIEW/DAExpenseDayWiseSummaryViewer.aspx`, new) —
  print-formatted expense bill view driven by query string (`daIds`, `FromDate`, `ToDate`,
  `fType=Print`), one section per DA, sourced from the existing `sp_Get_DAExpenseDayWiseSummary`
  (`@Mode='DayWise'`). No new stored proc.
- **Day Wise Net Sales Report** (`SInventory_UI/RptBussinessSummary_DayWise.aspx`) — sections 2
  (Negative Closing Stock), 4 (duplicate checks), 5 (VAT/TP mismatch) and 6 (Tour Plan Missing
  Serial) are temporarily disabled: their `Page_Load` calls are commented out and the
  `InvoiceDate` column was removed from the section-1 grid. Markup/code-behind for the disabled
  sections is left in place, not deleted.
- **Monthly Inventory Report** (`SInventory_DAL/InvoiceDAL.cs`,
  `sp_Get_MonthlyInventoryReport` caller) — `@CiD` is now passed as `DBNull.Value` instead of an
  empty string when no district is selected, so an all-districts run doesn't filter on `CiD = ''`.
- **Other Stock Action dropdowns** (`SInventory_DAL/OtherStockActionDAL.cs`,
  `LoadCompanyUnit`-style binder) — company-unit dropdown now gets a leading
  "--------Select---------" placeholder item, matching the convention used elsewhere.
- **Business Summary — Loading** (`SInventory_UI/RptBussinessSummary_Loading.aspx.cs`) — the
  Territory-wise grid (`Type == "TerritoryTran"`/`"TerritoryNONTran"`) now always drops rows where
  every KPI column (invoice count/amount, reject, sales, return, collection, receivable — TP and
  gross) is zero, filtered in C# over the fetched `DataTable` before binding/footer totals. Unlike
  the Batch-Wise report's zero-value toggle above, there's no checkbox here — zero rows are always
  hidden.

## Spec

`spec/database/procs/sp_Get_RouteInformationMasterList.sql` and
`sp_RPT_MIOWiseBusinessSummary.sql` updated to match; `spec/reports.md` and
`spec/database-spec.md` updated for the MIO-wise/Batch-Wise/DA-Expense-Bill entries above.

## Known loose ends (flagged, not fixed here)

- `Solution.Web/web.config` picked up a `debug="true"` compilation flag and a full
  whitespace/formatting rewrite (tabs → spaces, self-closed tags) alongside the intended changes —
  worth confirming that's deliberate before this reaches a shared environment.
- `Solution.Web/SInventory_UI/DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx.cs.txt` is an
  untracked `.txt` copy of a code-behind file (not wired into the site — `.txt`, not `.cs`);
  included in this commit as-is, but it reads like a scratch backup rather than a page meant to
  ship.
