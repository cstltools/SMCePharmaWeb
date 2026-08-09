# Reports

This catalog covers every report screen in the system, organized by business area. For the
underlying rendering mechanics (Crystal Reports vs. GridView/Excel plumbing, `.rpt` file mapping,
viewer-page architecture) see the technical appendix at the bottom.

**How to read each entry**: *Shows* — what the report displays. *Filters* — the parameters a user
sets before running it. *Output* — Crystal Report (print/PDF-style layout), on-screen grid, or
grid-to-Excel export. *Powered by* — the view/proc/table doing the real work, where traceable from
code (full source for every named view/proc is in [`spec/database/`](database/)).

---

## 1. Sales & Invoice reports

The largest report group — most live as Crystal-viewer pages under `SInventory_RPTVIEW`, sharing a
common pattern: BLL/DAL builds a `DataSet`, a `CrystalReportViewer` renders it against a `.rpt`
template.

| Report | Shows | Filters | Output | Powered by |
|---|---|---|---|---|
| All Sales Report (`AllSalesreportViewer`, `FinalSalesViewer`, `MIOProductSalesreportViewer`) | Confirmed sales (delivered/invoiced quantity and value), at overall, MIO, and product-wise granularity | Date range, zone/area/territory, MIO, product | Crystal (`crpAllSalesReport.rpt`) | Sales BLL/DAL over `tblInvoice`/`tblInvoiceDetail` |
| All Sales Return Report (`AllSalesReturnreportViewer`, `SalesReturnViewer`) | Products/quantities returned from customers against invoices | Date range, zone/area/territory | Crystal (`crpAllSalesReturnReport.rpt`) | Return BLL/DAL |
| Company / Region / Zone / District / Commercial-Unit Sales (`CompanySalesReportViewer`, `RegionSalesReportViewer`, `ZoneSalesReportViewer`, `DistrictSalesReportViewer`, `ComUnitSalesReportViewer`) | Sales rolled up at successive geography levels | Date range, respective geography level | Crystal (`rptCompanySales.rpt`/`rptRegionSales.rpt`/`rptZoneSales.rpt`/`rptDistrictWiseSales.rpt`/`rptComUnitSales.rpt`) | Sales BLL/DAL |
| Customer Sales Report (`CustomerSalesReportViewer`) | Per-customer sales history | Customer, date range | Crystal (`rptCustomerSales.rpt`) | Sales BLL/DAL |
| Fixed Customer Sales Report (`FixedCustomerSalesReportViewer`) | Sales against a fixed/contracted customer list | Date range, customer | Crystal (`rptFixedSales.rpt`) | Sales BLL/DAL |
| Product-wise National Sales / Sales Trend (`ProductWiseNationalSalesReportViewer`, `SalesTrendReportViewer`) | Product-level sales trend across periods | Date range, product/brand | Excel export (`crpSalesTrendExcelReport.rpt`) | `sp_RPT_MIS_ProductWiseSalesReport` (per-brand delivered TP/VAT/gross with invoice/return/collection breakdown) |
| MIA-wise Sales (`MiaWiseSalesReportViewer`) | Sales by Market Information Area | Date range, MIA | Crystal (`rptMiaWiseSales.rpt`) | `View_MIAWiseSalesReport` |
| Day-Wise Business / Sales Comparison (`DayWiseBusinessReportViewer`, `SalesComparisoneReportViewer`) | Day-by-day sales, compared across periods | Date range(s) | Excel export (`crpDayWiseBusinessExcelReport.rpt`) | Sales BLL/DAL |
| Employee-wise Product Sales (`EmployeewiseProductSalesReportViewer`) | Sales broken down by MIO/rep and product | Date range, employee | Crystal (`crpEmployeewiseProductSales.rpt`) | Sales BLL/DAL |
| Business Summary (`BusinessSummaryViewer`, `BusinessSummaryViewer2`-`5`) | Consolidated business KPIs (order/invoice/sales/return/collection amounts) for a period — 5 layout variants (overall, branch, marketwise) | Date range, type (SC/other), zone/area/territory | Crystal (`crpBusinessSummary.rpt`, `rptBranchSales.rpt`, `rptMarketwiseBusinessSummary.rpt`) | `sp_RPT_MIS_BusinessSummary`/`sp_RPT_BusinessSummaryMISReport` family (also `sp_BusinessSummaryMISReport_*` variants: All, Zone, Loading, TT) and `View_BusinessSummary` |
| MIS Business Summary — Accounts variant | Same business summary metrics filtered for accounts/finance view | Date range, type, geography | Proc-driven grid | `sp_RPT_MIS_BusinessSummary_Acc` |
| MIO-wise Business Summary | Business summary rolled up per MIO (rep) | Date range, MIO | Grid | `sp_RPT_MIOWiseBusinessSummary` |
| Proforma Report / Proforma & Sales Report (`ProformaReportViewer`, `InvoicewiseDetailssalesReport`, `ProformaandSalesreportViewer`, `ProformaReportPrintViewer`) | Proforma invoices, optionally paired against realized sales | Order/proforma no., date range | Crystal (`rptProformaReport.rpt`, `ProformaandsalesReport.rpt`) | `View_ProformaInvoiceReportList`, Order/Invoice BLL |
| Invoice Report / Invoicewise Detail Sales | Line-level invoice detail for a customer or invoice range | Invoice no./customer, date range | Crystal (`rptInvoiceForCustomer.rpt`) | Invoice BLL/DAL |
| Return Invoice Report (`ReturnInvoiceReportViewer`, `ReturnInvoiceReportViewer2`) | Invoices with returned items and return amounts | Invoice/date range | Crystal (`rptReturnInvoiceForCustomer.rpt`) | `View_Return_BIReport` (return TP/VAT/gross by invoice, joined to product/company/HO stock) |
| Delivery Return Report | Deliveries subsequently returned | Date range | Crystal (`crpDeliveryReturnReport.rpt`) | Delivery/Return BLL |
| Sales Rejection Report (`SalesRejectionReportViewer`, and `SInventory_UI/SalesRejectionReport` grid variant) | Orders/deliveries rejected at confirmation or delivery stage, with rejection reason | Date range, zone/area/territory | Crystal (`rptSalesRejection.rpt`) or grid+Excel | `sp_RPT_SalesReturnStatusByDate` family, Order/Delivery BLL |
| Delete Invoice / Delete Order Report (`DeleteInvoiceReportViewer`, `DeleteOrderReportViewer`) | Audit trail of deleted invoices/orders | Date range | Crystal (`crpDeleteInvoiceReport.rpt`, `crpDelOrderReport.rpt`) | Order/Invoice BLL (soft-delete audit) |
| Order Details Report / Order Info | Order-level detail (items, quantities, amounts, status) | Order no./date range | Crystal (`rptOrderDetails.rpt`) | `View_OrderInfo_BIReport`, Order BLL |
| Discount Report (`DiscountReportViewer`) | Discounts applied on orders/invoices | Date range | Crystal (`rptSpecialDiscount.rpt`) | Order/Invoice BLL |
| GP Sales Report (`SInventory_UI/GpSalesReport`) | Sales with gross-profit calculation | Date range, geography | Grid + Excel export | Sales BLL/DAL |
| Dynamic Sales Report (`SInventory_UI/DynamicSalesReport`) | Ad-hoc/configurable sales breakdown | User-selected dimensions, date range | Grid + Excel export | Sales BLL/DAL |
| Territory-Wise Sales Report (`SInventory_UI/TerritoryWiseSalesReport`) | Sales rolled up by territory | Date range, territory | Grid + Excel export | Sales BLL/DAL |
| Product Coverage Report | Which customers/territories carry which products (distribution breadth) | Date range, product/brand | Crystal/grid | `View_ProductCoverage_BIReport` |
| Product-wise Sales (BI) | Product-level sales aggregation feeding BI dashboards | Date range, product | View-driven (external BI consumption) | `View_ProductWiseSales_BIReport` |

## 2. Collection / Payment / Accounts-Receivable reports

| Report | Shows | Filters | Output | Powered by |
|---|---|---|---|---|
| Customer Payment / Customer Payment Due (`CustomerPaymentViewer`) | Amounts due per customer | Customer, date range | Crystal (`rptCustomerPaymentDue.rpt`) | Payment BLL/DAL |
| Customer Ledger (`CustomerLedgerViewer`) | Running debit/credit ledger per customer | Customer, date range | Crystal (`crpCustomerLedger.rpt`) | Payment/Invoice BLL |
| Money Receipt (`MoneyReceiptViewer2`, `MoneyReceiptViewerForAfterPayment`, and grid variants `SInventory_UI/MoneyReceipt`, `MoneyReceiptAfterPayment`) | Printable money-receipt document for a customer payment, before/after adjustment | Receipt/customer no. | Crystal (`rptMoneyReceipt.rpt`) or grid | `tblCustPayDetail`-based payment BLL |
| Batch-Wise Collection Report (`Money_Receipt_UI/BatchWiseCollectionReport.aspx.cs`, viewer `BatchWiseCollectionReportViewer`) | Collections grouped by collection batch, with a running total footer computed client-side over the grid | Batch/date range | Crystal (`crpBatchWiseCollectionReport.rpt`) and an on-screen grid version | `Library.BLL.SInventory_BLL`/`SInventory_DAL` payment batch query |
| SC Customer Payment / SC Payment Report (`SInventory_UI/SC_CustomerPaymentReport`, `SC_PaymentReport`) | Sub-Center/Sub-Commercial customer payment detail | Date range, customer | Grid + Excel export | Payment BLL/DAL |
| Delivery Payment Report (`SInventory_UI/DeliveryPaymentReport`, `DeliveryPaymentReportNew`, `DHB_DeliveryPaymentReport`) | Payments tied to specific deliveries (standard, revised, and DHB-channel variants) | Date range, DC/channel | Grid + Excel export | Delivery/Payment BLL |
| Accounts Receivable report | Outstanding receivable per zone (delivered value minus paid value, only zones with balance > 10) | none (whole-book snapshot); consumed for BI | View-driven | `View_AccountsReceivable_BIReport` — sums `tblInvoiceDetail` delivery amounts minus `tblCustPayDetail` payments, grouped by zone, filtered to non-zero balances |
| Customer Aging report | Same receivable-balance calculation as above, aged by zone | none; BI consumption | View-driven | `View_CustomerAging_BIReport` (identical logic to the Accounts Receivable view, distinct name for the aging-focused BI dashboard) |
| Sales / Collection Due report | Sales vs. amounts still due for collection | Date range, geography | View-driven (BI) | `View_SalesCollectionDue_BIReport` |
| MIO-wise Receivable Report | Outstanding receivable per MIO/rep | MIO, date range | Grid | `sp_RPT_MIS_RptMIOWiseReceiveableReport` |

## 3. Stock / Inventory reports

Mostly Crystal-viewer pages over the depot/warehouse stock BLL; several dynamic-`.rpt`-path pages
could not be traced to a literal `.rpt` filename (noted in the technical appendix).

| Report | Shows | Filters | Output | Powered by |
|---|---|---|---|---|
| DC Stock / Sub-Depot Stock Report (`DCStockReportViewer`, `SubDeportStockReportViewer`) | Current stock at a distribution center/sub-depot | DC/sub-depot, product | Crystal (`rptDCStock.rpt`) | Stock BLL/DAL |
| DC-wise Country Stock (`DCwiseCounrtyStockReportViewer`) | Stock broken down by DC within a country/region | DC, product | Crystal (`rptDCwiseCountryStock.rpt`) | Stock BLL/DAL |
| All Product Country Stock (`AllProductCountryStockReportViewer`) | Full product stock position, country-wide | Product/category | Crystal (`rptAllProductCountryStock.rpt`) | Stock BLL/DAL |
| Country Stock Report | National stock summary | Product, date | Crystal (`rptCountryStock.rpt`) | Stock BLL/DAL |
| CW (Central Warehouse) Monthly Inventory Report | Month-end inventory position at the central warehouse | Month/year | Crystal (`crpCWMonthlyInventoryReport.rpt`) | Inventory BLL/DAL |
| Area-Wise Monthly Sales/Inventory Report (`AreaWiseMonthlySalesReportViewer`, `SubdeportAreaWiseMonthlySalesReportViewer`) | Monthly stock movement/sales by area | Month/year, area | Crystal (`rptAreaWiseMonthlyInventoryReport.rpt`, `SubdeportAreaWiseMonthlyInventoryReport.rpt`) | Inventory BLL/DAL |
| DC Opening Stock Report | Opening stock balance at a DC for a period | DC, period | Crystal (`crpDcOpeningStockReport.rpt`) | Stock BLL/DAL |
| DC Stock-Out Report | Stock-out events at DC level | DC, date range | Crystal (`crpDcStockOut.rpt`) | Stock BLL/DAL |
| Sub-Depot Stock-Out Report | Stock-out at sub-depot level | Sub-depot, date range | Crystal (`crpSubDepotStockOut.rpt`) | Stock BLL/DAL |
| Distribution Center Stock Monitoring Report | Ongoing stock-level monitoring for DCs, flags low/critical stock | DC, product | Excel export (`crpDCStockMonitoringExcelReport.rpt`) | Stock BLL/DAL |
| Warehouse Stock Monitoring Report | Same monitoring pattern at warehouse level | Warehouse, product | Crystal (`crpWhStockMonitoring.rpt`) | Stock BLL/DAL |
| Warehouse Opening Stock Report | Opening stock at warehouse | Warehouse, period | Crystal (`WarehouseOpeningStockReport.rpt`) | Stock BLL/DAL |
| WH Stock-In Report | Stock received into warehouse | Warehouse, date range | Crystal (`crpWHStockIn.rpt`) | Stock receiving BLL/DAL |
| WH Stock Adjustment List | Manual stock adjustments made at warehouse | Date range | Crystal (`crpWhStockAdjustmentListInfo.rpt`) | Stock adjustment BLL/DAL |
| Product Trade Price / Product Cost Price (`ProductTreadPriceViewer`, `ProductCostPriceViewer`) | Current trade price and cost price per product | Product/category | Crystal (`rptProductTradePrice.rpt`) / Crystal (dynamic path) | Product/pricing BLL |
| Customer Master Report / Cust Ver-Unver Excel (`CustVerUnverExcelViewer`, `CustomerMasterViewer`) | Customer master list, split verified vs. unverified | Region/status | Crystal (`crpCustomerMaster.rpt`) | Customer BLL/DAL |
| Historical Report (`HistoricalReportViewer`) | Historical stock/sales snapshot for a past period | Period | Crystal (`crpHistoricalReport.rpt`) | Historical/archive BLL |
| MIGO Report (`MIGOReportViewer`) | Goods movement/receipt (MIGO) detail | Date range | Crystal (`crpMigoDetailsReport.rpt`) | MIGO/receiving BLL |
| Challan Report / DC-to-WH Challan / DC-to-DC Challan / DC-to-Subdepot Challan (`ChallanReportViewer`, `DcToWHChalanReportViewer`, `DcToDcChalanReportViewer`, `DcToSubdepotChalanReportViewer`) | Delivery challans (goods-transfer documents) between depots/warehouse | Challan no./date range | Crystal (`crpChallan.rpt`, `crpDCToWhChalan.rpt`) or dynamic-path Crystal | Challan BLL/DAL |
| Stock Transfer Order Report | Inter-location stock transfer orders | Transfer order no./date range | Crystal (`rptStockTransfarOrder.rpt`) | Stock transfer BLL/DAL |
| DC/Warehouse Picking Report, Market-wise Picking (`DCPickingReportViewer`, `WareHousePickingReportViewer`, `MarketwisePicking`, `SubdeportMarketwisePicking`) | Picking lists for order fulfillment, by DC/warehouse/market | DC/warehouse/market, date | Crystal (`rptPickingForWarehouse.rpt`, `rptMarketwisePicking.rpt`) | Picking BLL/DAL |
| Top Sheet Report / Sub-Depot Top Sheet (`TopSheetReportViewer`, `SubdeportTopSheetReportViewer`) | Delivery "top sheet" — the cover manifest for a delivery run | DC/route, date | Crystal (`rptTopSheet.rpt`) | Delivery BLL/DAL |
| Loading Report (`SInventory_UI/LoadingReport`, viewer `LoadingReportViewer`) | Goods loaded for dispatch on a given run | Date, vehicle/route | Crystal (`rptLoadingReport.rpt`) or grid+Excel | Loading/dispatch BLL |
| In-Transit Report (`InTransitReportViewer`, `AgingInTransitReportViewer`, `MIOwiseInTransitReportViewer`, `SInventory_UI/InTransitReport`) | Goods currently in transit between locations, with an aging variant and MIO-wise breakdown | Date range, DC/MIO | Crystal (`INTransitReport.rpt`) | Transit/logistics BLL |
| Stock Receive Report / Transfer Stock Receive Report | Stock received at destination against a transfer | Date range, DC | Crystal (dynamic path) | Stock transfer BLL/DAL |
| Monthly Inventory Report (Batch Wise) (`SInventory_UI/MonthlyInventoryReportBatchWise.aspx`, added 2026-08-09) | Batch-wise opening/received/issued/closing stock movement per product, one row per (product, batch) | Sales Center (required), From Date (required, fixed minimum/default 31-Jul-2026 — the proc's opening-balance join is hardcoded to that snapshot date), To Date (required, ≥ From Date) | GridView + Excel export (Mechanism B) | `TotalSummaryBLL.LoadMonthlyInventoryReportBatchWise` → `sp_Get_MonthlyInventoryReportBatchWise` (`@fromDate`, `@toDate`, `@CiD` only — see `spec/database/procs/`, no product-type parameter despite the DC-level "Monthly Inventory Report (DC)" and this page sharing a "Reports" menu group) |

## 4. Field-force / Visit / Doctor-programme reports (`Reports_UI`)

Unlike the Crystal-viewer reports above, all 16 `Reports_UI` screens render a plain ASP.NET
`GridView` (no `CrystalReportViewer`) bound to a `DataTable` from BLL/DAL, with a
`btnExportToExcel_Click` handler that renders the grid to an Excel file where present. Several share
the doctor/customer-visit filter shape (zone/area/territory tree-picker, program type, pharma
platform, approval status) via three reused `.ascx` tree controls (`IVMarketSTForZoneReport`,
`IVMarketStructureMarket`, `IVMasterStructureForDoctorReport`).

| Report | Shows | Filters | Output | Powered by |
|---|---|---|---|---|
| CVR — Customer Visit Report (`CVRDoctoriseMonthlypt.aspx`) | Monthly customer-visit records per doctor/customer, doctor-wise | Approval status, program type, pharma platform, MIO, brand, zone/area/territory (zone/area required — see [`business-rules.md`](business-rules.md)) | Grid | `View_CVR` (distinct visit rows from `tbl_DCRInfo` joined to `tblCustMaster`) + `DynamicPivotDoctorWiseCVR` for the pivoted doctor×period cross-tab variant |
| DCP Report (`DcpDoctoriseMonthlypt.aspx`) | Doctor Call Plan — planned doctor visits, doctor-wise, with approval workflow status | Approval status, program type, pharma platform | Grid, Excel export (partially commented out in current code) | `View_DCP` (from `tbl_DoctorTourPlanMaster`/`Detail`) + `DynamicPivotDoctorWiseDCP`/`DynamicPivotUserWiseDCP` pivot variants |
| DCR Report — Doctor Call Report (`DcrDoctoriseMonthlypt.aspx`) | Actual doctor-call outcomes vs. plan, doctor-wise | Approval status, program type, pharma platform, MIO, brand, zone/area/territory | Grid | `View_DCR` + `DynamicPivotDoctorWiseDCR`/`DynamicPivotUserWiseDCR`/`DynamicPivotBrandWiseDCR` pivot variants, `sp_Rpt_DCRInfo_ById`, `sp_Rpt_ZonewiseDoctorWeek`/`AreawiseDoctorWeek`/`DoctorwiseDoctorWeek`/`MIOwiseDoctorWeek` weekly rollups |
| RX Report (`RXDoctoriseMonthlypt.aspx`) | Prescription (Rx) counts per doctor, brand and product-wise, with per-MIO breakdown | Program type, MIO, product, pharma platform, approval status | Grid | `DynamicPivotDoctorWiseRX`/`DynamicPivotBrandWiseRX`/`DynamicPivotProductdWiseRX`/`DynamicPivotUserWiseRX` (and `_New` variants) pivot procs |
| DWSP Monthly Report (`DWSPMonthlyRpt.aspx`) | Doctor Weekly/monthly Sales Programme activity, aggregated by generic/FCB/campaign category per week-of-month (columns largely dormant per commented-out footer code) | Month, year, approval status, zone/area/territory | Grid | `DynamicPivotDWSP`, `DWSP_DAL.GetDWSPMonthlyList_Mew` |
| Doctor Info Report (`DoctorInfoReport.aspx`) | Doctor master/profile detail; a second tab gives MIO-wise summary of visit counts, DCR/DCP totals, weekly repeat/no-Rx/Rx visit breakdown with grid footer totals | Date range, MIO, zone/area/territory | Grid (two views: detail + MIO-wise summary) | `sp_RPT_DoctorInfoReport`, `sp_RPT_DoctorInfo_Details`, `sp_RPT_DoctorInfo_DOCWise`, `sp_RPT_DoctorInfo_MIOWise` |
| Employee Monthly Expense Report (`EmpMonthlyExpenseRpt.aspx`) | One employee's monthly expense claim lines | Employee, month, year | Grid, Excel export | `sp_RPT_MonthlyExpense`, `EmployeeInformationDAL.GetMonthlyExpenseList` |
| Employee Monthly Expense Report (Multiple) (`EmpMonthlyExpenseRptMultiple.aspx`) | Same expense data across multiple selected employees at once (checkbox multi-select), used to batch-export | Employee status, month, year, checkbox employee selection | Grid, Excel export (selected rows only) | `EmployeeInformationDAL.GetEmployeeInformationListForReport` |
| Yearly Leave Balance Report (`Employee_YearlyLeaveBalanceRpt.aspx`) | Employee leave balance and usage summary for a fiscal year | MIO, fiscal year | Grid (detail + summary sub-views) | Leave BLL/DAL filtered by `FiscalYear`/`EmployeeInfoId` |
| Order Permission (`OrderPermission.aspx`) | Which employees are permitted to place orders on behalf of which territory, with editable permission grid | Zone; per-row required: assigned employee, from/to date (validated inline, highlighted red if missing) | Editable grid (not export-only — this screen both reports and edits `tblOrderPermission`) | Order-permission BLL/DAL over `tblOrderPermission` |
| Organogram Report (`OrganogramReport.aspx`) | Reporting hierarchy / org chart of field-force employees | (none captured beyond row command drill-down) | Grid | Employee/org-structure BLL |
| Sample Stock Allocation Report (`SampleStockAllocationRpt.aspx`) | Opening/closing balance of free drug samples allocated to each MIO for a month | MIO, year, month | Grid | `Reports_DAL.GetSampleStockRptList` |
| Target Achievement Report (`TargetAChivementReport.aspx`, and `TargetAChivementReportNew.aspx` — a newer 3-tab zone/area/territory layout) | Sales value achieved vs. target, by zone/area/territory, with a percentage-achievement column | Year (and geography tab in the "New" version) | Grid, Excel export (per zone/area/territory tab in "New" version) | `View_TargetvsAchivement_BIReport` (sums `tblTerritoryDataMigration` target values vs. delivered-invoice sales per territory/month) and `vw_TargetvsAchievement_BIReport`/`View_TargetvsAchivment_2023to2024` (year-specific variants) |
| Tour Plan Report (`TourPlanReportNew.aspx`) | Planned field-visit tour dates per employee for a month, plus a balance-of-plan-vs-actual sub-table | Employee, month, year | Grid, Excel export | `EmployeeInformationDAL.GetTourPlanReport__`/`GetTourPlanReportBal` |
| Tour Plan Summary Report (`TourPlanSummaryReport.aspx`) | Roll-up of tour plan completion across employees/roles | Month, year, employee, user role | Grid, Excel export (checkbox-selected rows) | `EmployeeInformationDAL.GetTourPlanSummaryReportReport` |

## 5. Target / Achievement reports

(Primary screens are cataloged in §4; this section notes the supporting BI views/procs used for
target-vs-achievement analysis beyond the `Reports_UI` screens.)

- `View_TargetvsAchivement_BIReport` / `vw_TargetvsAchievement_BIReport` — zone-and-month target
  value (from `tblTerritoryDataMigration`) vs. realized sales value (delivered invoice lines,
  status Full/Partial), the core dataset behind both Target Achievement report screens and BI
  dashboards.
- `View_TargetvsAchivment_2023to2024` — a frozen year-specific snapshot of the same calculation,
  kept for historical comparison rather than live use.
- `View_Sales_BIReport` — customer-type/month/year breakdown of order, invoice, and delivered-sales
  quantity/amount side by side (order→invoice→sales funnel), consumed by BI rather than a
  `Reports_UI` page directly.

## 6. Doctor / Prescription reports

(Primary screens — CVR, DCP, DCR, RX, DWSP, Doctor Info — are cataloged in §4, since they live in
`Reports_UI` and share its GridView/Excel mechanism. This section is a cross-reference by report
type for readers coming from a doctor-programme angle.)

| Programme | Screen | Core question it answers |
|---|---|---|
| CVR (Customer Visit Report) | `CVRDoctoriseMonthlypt.aspx` | Which customers/doctors were visited this month, by whom? |
| DCP (Doctor Call Plan) | `DcpDoctoriseMonthlypt.aspx` | Which doctor visits are planned, and what's their approval status? |
| DCR (Doctor Call Report) | `DcrDoctoriseMonthlypt.aspx` | Which planned calls were actually made, and what happened? |
| RX (Prescription) | `RXDoctoriseMonthlypt.aspx` | How many prescriptions did each doctor generate, by brand/product? |
| DWSP (Doctor Weekly/Sales Programme) | `DWSPMonthlyRpt.aspx` | Weekly activity rollup by category (generic/FCB/campaign) |
| Doctor Info | `DoctorInfoReport.aspx` | Doctor master profile + MIO-wise visit-count summary |
| Doctor Visit Monitoring | `Dashboard_UI/DoctorVisitMonitoring.aspx` | Dashboard widget (not a standalone report) — see §7 |

## 7. Dashboards (related, not full reports)

`Dashboard_UI` holds 3 screens that feed chart/KPI widgets rather than produce printable/exportable
reports:

- `AdminDashboard.aspx` — the main KPI dashboard. Backed by `Library.DAL.ChartDAL`, exposing ~15
  page-method endpoints (see [`api-spec.md`](api-spec.md)'s `Dashboard_UI` section for the full
  list) called via AJAX to populate chart widgets — order counts, delivery/rejection amounts,
  DCR/RX totals, attendance, customer coverage, leave totals.
- `DashboardOne.aspx` — a second/alternate dashboard landing page (thin code-behind; layout-only).
- `DoctorVisitMonitoring.aspx` ("6/10 Project Monitoring Report") — a `GridView`-based
  approval-monitoring screen for doctor-visit records pending review, filtered by date range,
  group, zone/area/territory; not exported, used operationally to drive approvals
  (`GetDoctorVisitMonitoringApprovalList`).

## 8. Sub-Depot report-generation screens

These `SubDepot_UI` screens don't render a report directly — each builds a candidate list in a
grid, lets the user pick rows, then generates/redirects into the Crystal-viewer report for printing.

| Screen | Purpose | Generates |
|---|---|---|
| `SubDepotProformaList.aspx` | Lists proforma invoices pending at a sub-depot for review/selection | Feeds Sub-Depot proforma printing; redirects back to itself after action |
| `TopSheetGenerate.aspx` | Builds the delivery top-sheet manifest (selects invoices/orders to bundle into one delivery run) | Feeds `TopSheetReportViewer`/`SubdeportTopSheetReportViewer` (`rptTopSheet.rpt`) |
| `DelivaryTopSheetGenerate.aspx` | Same top-sheet generation, delivery-return variant | Feeds `DelivaryTopSheetInvoiceReturnViewer`/`SubDeportDelivaryTopSheetInvoiceReturnViewer` (`rptDelivaryTopSheet.rpt`) |
| `SCPickingGenerate.aspx` | Builds a Sub-Center picking list (selects orders to pick/fulfill) | Feeds the picking-report Crystal viewers (`rptMarketwisePicking.rpt`/`rptPickingForWarehouse.rpt` family); redirects back to itself after action |

Required-field validation on these screens (must-select-employee, must-set-date-range, etc.) is
cataloged in [`business-rules.md`](business-rules.md).

---

## Technical appendix — rendering mechanisms

Two independent reporting mechanisms are used, chosen per-report rather than by a documented rule.

### Mechanism A — Crystal Reports (`SInventory_RPTVIEW`, 94 viewer pages)

Each page loads a `CrystalDecisions.CrystalReports.Engine.ReportDocument`, sets its
`.ReportSource` to a `CrystalDecisions.Web.CrystalReportViewer` control, and feeds it an in-memory
`DataSet` built from BLL/DAL calls (worked example:
`SInventory_RPTVIEW/DCStockReceiveReportViewer.aspx.cs`). `.rpt` files live under
`Solution.Web/Reports/CrystalReports/`; typed `DataSet` shapes live under
`Library.CrystalReports/*_DS/`. The `.rpt` source templates themselves live in
`Library.CrystalReports/SInventory_RPT/` (41 files, mapped to viewers throughout the tables above).

93 of the 94 Crystal-viewer pages are in `SInventory_RPTVIEW`; one
(`TransferStockReceiveReportViewer.aspx`) is in `SInventory_UI`.

The following viewer pages resolve their `.rpt` path dynamically at runtime rather than as a
literal string, so the specific file is not traceable by static grep: `AllProductCountryStockReportViewer`,
`ComUnitSalesReportViewer`, `CompanySalesReportViewer`, `CountryStockReportViewer`, `CurrentStockRpt`,
`CustomerSalesReportViewer`, `DCPickingReportViewer`, `DCwiseCounrtyStockReportViewer`,
`DcToDcChalanReportViewer`, `DcToSubdepotChalanReportViewer`, `DiscountReportViewer`,
`DistrictSalesReportViewer`, `InvoicePrintingList`, `InvoiceReturnViewer`, `MiaWiseSalesReportViewer`,
`ProductCostPriceViewer`, `RegionSalesReportViewer`, `StockReceiveReportViewer`,
`SubDeportTransferStockReceiveReportViewer`, `TopSheetAndPickingslipHtmlViewer_daaw`,
`ZoneSalesReportViewer`, and `SInventory_UI/TransferStockReceiveReportViewer`.

8 further Crystal-viewer pages exist but are retired, kept as disabled `.aspx.exclude`/
`.aspx.cs.exclude` pairs (not served): `AllSalesReport`, `DelivaryInvoiceCreation`,
`DelivaryInvoiceCreationForCustomerByOrder`, `InvoiceCreationByOrder`,
`InvoiceCreationForCustomer`, `InvoiceCreationForCustomerByOrder`, `MiaSalesReportViewer`,
`TransferStockReceiveReportViewer` (a second, retired copy distinct from the active `SInventory_UI`
one above).

### Mechanism B — GridView + direct Excel export

A `GridView` bound to a `DataTable`, with manual C# footer-row aggregation, exported via a
`RenderControl`-to-`Response.Write` HTML-to-Excel technique (not a binary XLSX library). Confirmed
usages, all in `SInventory_UI` with no Crystal-viewer counterpart: `TerritoryWiseSalesReport`,
`SalesRejectionReport`, `SalesConfirmationReport_New`, `SC_CustomerPaymentReport`,
`SC_PaymentReport`, `ProformaReport`, `MoneyReceipt`, `MoneyReceiptAfterPayment`, `LoadingReport`,
`GpSalesReport`, `DynamicSalesReport`, `DeliveryPaymentReport`, `DeliveryPaymentReportNew`,
`DZSMTotalSummary` (plus a stray uncompiled backup file, `"DZSMTotalSummary.aspx - Copy.cs"`),
`DHB_DeliveryPaymentReport`, `MonthlyInventoryReportBatchWise` (added 2026-08-09, modeled directly
on `DepositSlipReport`'s layout — itself the same mechanism though not listed above, an omission in
this pass rather than a different pattern).

All 16 `Reports_UI` field-force/doctor-programme reports (§4) also use this GridView pattern — a
`loadGridView` control bound to a DAL-returned `DataTable`, with `btnExportToExcel_Click` handlers
present on most (some, e.g. DWSP and DCP, have their Excel-export code currently commented out).

### BI-only views (no direct `Reports_UI`/`SInventory_UI` consumer found)

Several of the 58 cataloged database views exist purely for external BI-tool consumption (e.g.
Power BI) — grepping `Solution.Web` for their names finds no C# reference, meaning the web app
never queries them; they're read directly by the BI layer against the database:
`View_AccountsReceivable_BIReport`, `View_CustomerAging_BIReport`, `View_Sales_BIReport`,
`View_TargetvsAchivement_BIReport`, `View_OrderInfo_BIReport`, `View_ProductCoverage_BIReport`,
`View_ProductWiseSales_BIReport`, `View_Return_BIReport`, `View_SalesCollectionDue_BIReport`,
`View_MIAWiseSalesReport`, `View_BusinessSummary`, `View_CVR`, `View_DCP`, `View_DCR` (the latter
three share names with the `Reports_UI` doctor-programme screens but those screens query the
underlying tables/procs directly rather than through the view — the views appear to be a parallel
BI-facing copy of the same logic, not the screens' actual data source). `View_EpharmaSales2022April`/
`2023`/`2024` are year-pinned e-pharma channel sales snapshots, also BI-only.

### Report data source

All reports — Crystal or GridView — pull data through the normal BLL/DAL call chain or a dedicated
`sp_Rpt*`/`sp_RPT*`/`DynamicPivot*` stored procedure, not by the report engine querying the database
directly. The `DynamicPivot*` procs (24 total) build and `EXEC` a dynamic `PIVOT` SQL string to turn
doctor/user/product rows into a cross-tab (e.g. `DynamicPivotDoctorWiseCVR` pivots visit counts by a
caller-supplied column list for a given month/year) — this is how the CVR/DCP/DCR/RX/DWSP screens in
§4 produce their period-column layouts. Full source for every named proc/view is in
[`spec/database/`](database/).
