# Modules

Every top-level feature folder under `Solution.Web`, with page counts (`.aspx` files) and purpose inferred from folder contents. Module folders repeat the same name pattern across `Library.BLL`/`Library.DAL`/`Library.DAO` (e.g. `SInventory_UI` ↔ `SInventory_BLL` ↔ `SInventory_DAL` ↔ `SInventory_Entities`) — see [`docs/coding-standard.md`](../docs/coding-standard.md).

| Module folder | Pages | Purpose |
|---|---|---|
| `Approval_UI` | 12 | Central multi-workflow approval inbox — customer, DA claim, doctor, doctor visit plan (DCP/CVP), DCR, expense, leave, mileage, order, RX, tour plan, and doctor/customer-transfer approvals. See [`workflow.md`](workflow.md). |
| `SInventory_UI` | 320 | The core ERP module: master data (product, customer, area/region/zone, pricing), order-to-cash (order, invoice, delivery, proforma, sales return), stock/warehouse operations, and the majority of sales/collection/receivables reports. |
| `SubDepot_UI` | 19 | Sub-depot channel — mirrors `SInventory_UI`'s stock transfer, invoicing, and payment logic for the sub-depot distribution channel. |
| `MasterSetup_UI` | 44 | System-wide master data: customers, doctors, DA/employee setup, campaigns, program types, route/territory-depot mapping, order tracking. |
| `DoctorModule_UI` | 102 | Field-force/HR master data and operations for the sales-rep hierarchy (NSM/RSM/ASM/DZSM/MIO/AM — see [`../knowledge/glossary.md`](../knowledge/glossary.md)): leave, expense/mileage claims, tour planning, training, attendance, prescriptions, org-structure setup. Largest single module by page count after `SInventory_UI`. |
| `DoctorMaster_UI` | 16 | Doctor-related lookup/master tables: chamber type, category, degree, designation, speciality, patient type, prescription type, special days. |
| `DoctorVisit_UI` | 7 | Doctor call/visit planning, DCR (daily call report) entry, approval, and reporting. |
| `DWSP` | 10 | Sales-target setup ("Doctor-Wise Sales Programme" or similar — exact expansion **Not Found** in code) at national, zone, territory, and area level. |
| `Target_UI` | 5 | Monthly and product-wise sales target entry/viewing. |
| `Dashboard_UI` | 3 | Admin dashboards and doctor-visit monitoring landing pages. |
| `Reports_UI` | 16 (+3 `.ascx` shared controls) | Field-force/doctor-programme reports: DCR/DCP/CVR/RX monthly reports, expense, leave balance, org chart, target achievement, tour plan. None of these pages use the Crystal Report viewer, despite the folder name — see [`reports.md`](reports.md). |
| `SInventory_RPTVIEW` | 94 | Dedicated Crystal Reports viewer folder for essentially all sales/stock/finance reports. See [`reports.md`](reports.md) for the full report-to-`.rpt` mapping. |
| `TransferUI` | 13 | Master-data transfer/import/approval workflows — customer, doctor, market, territory, zone, and sub-territory transfers and imports. |
| `UserPermission` | 2 | Role/user permission and approval-step-mapping administration (`ApprovalMapMaster` maintenance UI). |
| `UserProfile_UI` | 2 | End-user profile and password change. |
| `UserTracking` | 1 | User activity/login tracking list, reading `dbo.tblUserSessionTracking` (populated by `UserSessionTrackingManager`, see [`docs/api.md`](../docs/api.md)). |
| `CommonUI` | 7 | Shared shell pages: default/home page, admin menu panel, template/tab/accordion demo pages, the user-permission page. |
| `LeaveProcess_UI` | 4 | Employee leave application entry and yearly leave processing. |
| `Money_Receipt_UI` | 1 | Batch-wise collection/money receipt report. |
| `NoticeBoard_UI` | 4 | Company notice-board setup, records, and detail viewing. |
| `PromoAlloc` | 6 | Promotional (free-goods) quantity allocation by group/MIO tagging. |
| `SettingPanel_UI` | 2 | Archive-database-connection administration (triggers a SQL Agent backup job, see [`docs/api.md`](../docs/api.md)) and user-settings panel. |
| `Thana_UI` | 5 | Bangladesh administrative-geography master (division/district/thana) setup. |
| `eProgram_UI` | 1 | Provider-dropout request list for a retail-outlet/provider loyalty ("e-Program") scheme — shares its DAL class with `SAP_Integration`, implying dropout events flow through the same SAP staging pipeline. |
| `SAP_Integration` | 4 | Internal reconciliation screens over SAP staging tables (deposit codes, stock-receive challans) — **not** a live SOAP/REST call to an SAP server; a "DIC" (Distributor-in-Charge)-scoped variant exists for two of the four pages. |
| `VerticalAsset` | 0 (static assets) | Front-end theme library (Bootstrap admin template, DataTables, icons, jsPDF) — no server pages of its own. |

## Cross-cutting (not a feature module, but touches every page)

- `MasterPages/` — 3 master pages (`MasterPage.master`, `MainMasterPage.master`, `NewMasterPage.master`), each independently implementing the session-based auth gate and per-user menu rendering. See [`docs/security.md`](../docs/security.md).
- `App_Code/` — the SOAP-ish web service, two file handlers' shared logic host, session-tracking manager, and the archive-DB-connect repository. See [`docs/api.md`](../docs/api.md).

## Module → layer mapping quick reference

| UI folder | BLL folder | DAL folder | DAO folder |
|---|---|---|---|
| `SInventory_UI` | `SInventory_BLL` | `SInventory_DAL` | `SInventory_Entities` |
| `SubDepot_UI` | `SubDepot_BLL` | `SubDepot_DAL` (+ `SubDepotChalanDAL`, `SubDepotChalanReturnDAL`) | `SubDepot_DAO` |
| `MasterSetup_UI` | `MasterSetup_BLL` | `MasterSetup_DAL` | `MasterSetup_DAO` |
| `DoctorModule_UI` | (spread across several `*_BLL` folders) | `DoctorModule_DAL` | `DoctorModule_DAO` |
| `DoctorMaster_UI` | — | `DoctorMaster_DAL` | `DoctorMaster_Dao` |
| `DoctorVisit_UI` | — | `DoctorVisit_DAL` | — |
| `DWSP` | — | `DWSP_DAL` | `DWSP_DAO` |
| `Approval_UI` / `UserPermission` | `Panal_BLL` (menu/login), various | `UserRoleDAL`, `PanalCls`, `Panal_DAL` | `UserRoleDAO`, `Panal_Entities` |
| `TransferUI` | — | `Transfer_DAL` | — |
| `Thana_UI` | — | `Thana_DAL` | — |
| `SAP_Integration` / `eProgram_UI` | — | `SAP_IntegrationDAL` | — |

Not every UI folder has a same-named BLL folder — several legacy pages call DAL classes directly.

## Live menu structure (from `tblMainMenuNew`, ground truth for what a logged-in user actually sees)

The code-folder inventory above is the *implementation* view. This is the *business* view — the
actual menu tree served to users, pulled directly from the `tblMainMenuNew` table (327 rows — up
from 326 since SL=2048, the Monthly Inventory Report (Batch Wise) row, was added — re-verified live
this revision; 34 top-level categories, corrected this revision from a prior undercount of 33 that
didn't match this same document's own 34 `###` section headings below) in the live database. See
[`database-spec.md`](database-spec.md) for the
table's full schema. Per-role visibility is a separate layer on top of this tree (`tblMenuRole`/
`tblMenuDistribution` — see [`MainMenu2`](database/functions/MainMenu2.sql) for how the two combine
into the rendered `<ul>`); this listing is the full unfiltered tree, not what any single role sees.

### Dashboard

- Main Dashboard — `../Dashboard_UI/AdminDashboard.aspx`
- Depot Dashboard — `../Dashboard_UI/DashboardOne.aspx`
- **Dashboard 3**

### User Authintication

- User List — `../DoctorModule_UI/UserRecords.aspx`
- User Authintication — `../UserPermission/UserPermission.aspx`
- Approval Setup — `../UserPermission/ApprovalStepMap.aspx`
- App Monitoring View — `../DoctorModule_UI/AppMonitoringList.aspx`
- Basic info update setting — `../SettingPanel_UI/UserSettingPanelSetup.aspx`

### Master Setup

- Financial Year — `../DoctorModule_UI/FinancialYearView.aspx`
- Designation — `../DoctorModule_UI/DesignationView.aspx`
- Department — `../DoctorModule_UI/DepartmentView.aspx`
- Employee Information — `../MasterSetup_UI/EmployeeRecords.aspx`

### Material Management

- Product Line — `../DoctorModule_UI/ProductLineView.aspx`
- Generic Group — `../DoctorModule_UI/GenericGroupView.aspx`
- Manufacturer List — `../SInventory_UI/ManufacturerView.aspx`
- Pack Size — `../SInventory_UI/PackSizeView.aspx`
- Product Brand List — `../SInventory_UI/ProductSQView.aspx`
- Product Category — `../SInventory_UI/ProCategoryView.aspx`
- Product Type — `../SInventory_UI/ProTypeView.aspx`
- Shipping Carton List — `../SInventory_UI/ShippingCartonSizeView.aspx`
- Therapeutic Group List — `../DoctorModule_UI/TharapeuticGroupView.aspx`
- Product List — `../SInventory_UI/ProductView.aspx`
- Unit Price List — `../SInventory_UI/ProUnitPriceView.aspx`
- Quoted Price — `../MasterSetup_UI/QuotedPriceView.aspx`
- UOM — `../SInventory_UI/StockUOMView.aspx`

### Market Structure

- Division List — `../Thana_UI/Division_View.aspx`
- District List — `../Thana_UI/District_View.aspx`
- Thana List — `../Thana_UI/Thana_View.aspx`
- Region Setup — `../DoctorModule_UI/GroupSetupView.aspx`
- Zone Setup — `../DoctorModule_UI/ZoneRecords.aspx`
- Area Setup — `../DoctorModule_UI/AreaRecords.aspx`
- Territory Setup — `../DoctorModule_UI/TerritoryRecords.aspx`
- Sub-Territory Setup — `../DoctorModule_UI/SubTerritoryRecords.aspx`
- Market Setup — `../DoctorModule_UI/MarketRecords.aspx`
- Market Transfer — `../TransferUI/Market_Transfer.aspx`

### Depot Setup

- DA Entry — `../MasterSetup_UI/DAList.aspx`
- **Depot Entry**
- **Sub Depot Entry**
- Territory Wise Route Setup — `../MasterSetup_UI/TerritoryWiseDepotSetup.aspx`
- Distribution Route Setup — `../MasterSetup_UI/RouteInformationList.aspx`

### Field Force Setup

- NSM Setup — `../DoctorModule_UI/NSMHeadRecords.aspx`
- NSM Setup — `../DoctorModule_UI/NSMHeadRecords.aspx`
- Region Head Setup — `../DoctorModule_UI/NSMRecords.aspx`
- DZSM Setup — `/DoctorModule_UI/DZSMRecords.aspx`
- AM Setup — `/DoctorModule_UI/AMRecords.aspx`
- MIO Setup — `/DoctorModule_UI/MioRecords.aspx`

### Customer Information

- Customer Type — `../MasterSetup_UI/CustomerTypeView.aspx`
- Station Type — `../MasterSetup_UI/StationTypeView.aspx`
- Provider Type — `../MasterSetup_UI/ProgramTypeView.aspx`
- Customer List — `../MasterSetup_UI/CustomerView.aspx`
- Pharma Platform — `../masterSetup_UI/SMCTypeView.aspx`
- Change Program Type — `../MasterSetup_UI/CustomerChangeProgramType.aspx`
- Customer Pending List — `../MasterSetup_UI/CustomerListPending.aspx`

### Doctor Information

- Doctor List — `../MasterSetup_UI/DoctorView.aspx`
- Degree Entry — `/DoctorMaster_UI/DoctorDegreeView.aspx`
- Category Entry — `/DoctorMaster_UI/DoctorCategoryView.aspx`
- Speciality Entry — `/DoctorMaster_UI/DoctorSpecialityView.aspx`
- Chamber Type Entry — `/DoctorMaster_UI/ChamberTypeView.aspx`
- Patient Type Entry — `/DoctorMaster_UI/PatientTypeView.aspx`
- Speical Day Entry — `/DoctorMaster_UI/SpecialDayView.aspx`
- Designation Entry — `/DoctorMaster_UI/DoctorDesignationView.aspx`

### Attendance Information

- Shift List — `../DoctorModule_UI/ShiftInfoList.aspx`
- Attendance List — `../DoctorModule_UI/AttendanceInfoList.aspx`
- Attendance Report — `../DoctorModule_UI/AttendanceInfoReport.aspx`

### Leave Management

- Leave Information — `../DoctorModule_UI/LeaveView.aspx`
- Holiday Information — `../DoctorModule_UI/HolidayView.aspx`
- Yearly Leave Process — `../LeaveProcess_UI/YearlyLeaveProcess.aspx`
- Leave Applications — `../LeaveProcess_UI/LeaveApplications.aspx`
- Yearly Leave Report — `../Reports_UI/Employee_YearlyLeaveBalanceRpt.aspx`
- Leave Config — `../DoctorModule_UI/LeaveConfigList.aspx`

### Tour Plan

- Tour Plan Information — `../DoctorModule_UI/TourPlannedUserList.aspx`
- Tour Type Entry — `../DoctorModule_UI/TourTypeRecords.aspx`
- Tour Purpose Entry — `../DoctorModule_UI/TourPurposeRecords.aspx`
- Other Visit Configuration — `../DoctorModule_UI/TourPurposeOtherSetup.aspx`
- Tour Type Setup — `../MasterSetup_UI/TourSetupForEmployeeList.aspx`
- Tour Plan Summary Report — `../Reports_UI/TourPlanSummaryReport.aspx`
- Tour plan Report — `../Reports_UI/TourPlanReportNew.aspx`

### Doctor Visit

- Doctor Call Plan List — `../DoctorVisit_UI/DoctorVisit.aspx`
- DCR Information — `../DoctorVisit_UI/DCRList.aspx`
- Doctors Requirement — `../SInventory_UI/DoctorInvoiceCreationByOrder.aspx`
- Doctor Call Report — `../Reports_UI/DcrDoctoriseMonthlypt.aspx`
- Customer Visit Report — `../Reports_UI/CVRDoctoriseMonthlypt.aspx`
- DCP Report — `../Reports_UI/DcpDoctoriseMonthlypt.aspx`
- Doctor Visit Count Report — `../DoctorVisit_UI/DoctorVisitReport.aspx`

### Prescription

- Prescription �Type — `../DoctorModule_UI/PrescriptionTypeView.aspx`
- Prescription List — `../DoctorModule_UI/PrescriptionView.aspx`
- RX Report — `../Reports_UI/RXDoctoriseMonthlypt.aspx`

### Field Expense

- Allowances Information — `../DoctorModule_UI/MonthlyAllowanceView.aspx`
- DA Claim List — `../DoctorModule_UI/TADAClaimView.aspx`
- DA Market Rules Config — `../DoctorModule_UI/TADAMarketRuleConfigurationView.aspx`
- Transport Information — `../DoctorModule_UI/TransportView.aspx`
- Mileage List — `../DoctorModule_UI/MileageClaimView.aspx`
- Expense Type — `../DoctorModule_UI/ExpenseTypeView.aspx`
- Expense Claim — `../DoctorModule_UI/ExpenseClaimView.aspx`
- Employee Monthly Expense — `../Reports_UI/EmpMonthlyExpenseRptMultiple.aspx`

### Target & Achivement

- Monthly Target List — `../SInventory_UI/TargetExcelUploadList.aspx`
- Product Wise Sales Target — `../Target_UI/ProductWiseTargetList.aspx`

### Location

- User Wise Location — `../UserTracking/UserTrackingList.aspx`

### Notice

- Notice Declaretion — `../NoticeBoard_UI/NoticeRecords.aspx`

### Training Information

- Training List — `../DoctorModule_UI/TrainningView.aspx`

### Order Information

- Order Tracking — `../MasterSetup_UI/OrderTrackingList.aspx`
- Campaign Setup — `../MasterSetup_UI/CampaignView.aspx`
- Update Route Info — `../MasterSetup_UI/OrderDCChange.aspx`
- Invoice Maximum Value Setup — `../MasterSetup_UI/CustomerInvoiceLimit.aspx`
- Order Summary Report — `../MasterSetup_UI/OrderTrackingSummary.aspx`
- Order Place Permission — `../Reports_UI/OrderPermission.aspx`

### Wharehouse Management

- Stock Transfer Order — `../SInventory_UI/OrderRequisitionCreation.aspx`
- Challan Generation — `../SInventory_UI/CreatePickingOnWareHouse.aspx`
- Stock Receive — `../SInventory_UI/WarehouseStockIn.aspx`
- Freeze Stock Release — `../SInventory_UI/OtherStockAction.aspx`
- Stock Condition Freeze — `../SInventory_UI/WhStockConditionFreeze.aspx`
- Challan Report — `../SInventory_UI/ChallanReportList.aspx`
- WH Stock Out — `../SInventory_UI/WHStockInList.aspx`
- WH Stock Report — `../SInventory_UI/WHStockInReportList.aspx`
- WH Stock Information — `../SInventory_UI/WhStockMonitoringReport.aspx`
- WH Freeze Stock — `../SInventory_UI/WhStockConditionFreeze.aspx`
- WH Freeze Stock Release — `../SInventory_UI/WhFreezeStockRelease.aspx`
- WH Sample Stock Conversion — `../SInventory_UI/SampleStockforWarehouse.aspx`
- Stock Transfer Order WH — `../SInventory_UI/StockTransferOrder.aspx`
- Stock Adjustment — `../SInventory_UI/WHStockAdjustmentView.aspx`

### Sales Center Operation

- Stock Receive By DC — `../SInventory_UI/StockReceiveByDC.aspx`
- Invoice Creation — `../SInventory_UI/InvoiceCreationByOrder.aspx`
- SC Picking Generate — `../SInventory_UI/SCPickingGenerate.aspx`
- **WH Stock Return**
- Manual Order Creation — `../SInventory_UI/ManualOrderCreation.aspx`
- **Stock Adjustment**
- Invoice Return — `../SInventory_UI/SalesReturnList.aspx`
- Invoice Print — `../SInventory_UI/ProformaPrintList.aspx`
- Deposit Slip List — `../SInventory_UI/DepositSlipExcelUpload.aspx`
- Depot Stock Adjustments(DSAV) — `../SInventory_UI/DepotStockAdjustmentsVoucher.aspx`
- DC Sample Stock Conversion — `../SInventory_UI/SampleTypeConvertion.aspx`
- Delivery Invoice Excel Upload — `../SInventory_UI/DeliveryExcelUpload.aspx`
- Deposit Slip Entry — `../SInventory_UI/CompanyWiseBranch.aspx`
- B2B Stock Receive — `../SInventory_UI/TransferStockReceiveByDC.aspx`
- DC To DC Stock Transfer — `../SInventory_UI/B2BTransferView.aspx`
- Stock Conversion List — `../SInventory_UI/SampleTypeConventionView.aspx`
- Stock  Receive from Subdeport — `../SInventory_UI/SubDeportTransferStockReceiveByDC.aspx`
- Depot Stock Adjustments Voucher List — `../SInventory_UI/DepotStockAdjustmentsVoucherView.aspx`
- Sales Return — `../SInventory_UI/SalesReturn.aspx`
- Adjustment Type List — `../SInventory_UI/AdjustmentTypeView.aspx`
- Inactive Order — `../SInventory_UI/OrderDeleteorEdit.aspx`
- Stock Condition Freeze — `../SInventory_UI/StockConditionFreeze.aspx`
- Conditional Purpose Settings — `../SInventory_UI/ConditionalPurposeSetting.aspx`
- Stock Transfer DC to Warehouse — `../SInventory_UI/DepoToWhTransferView.aspx`
- Stock Receive WH — `../SInventory_UI/StockRcvByWH.aspx`

### Approval Operation

- Attendance Approval List — `../DoctorModule_UI/AttendanceListApproval.aspx`
- Customer Approval List — `../Approval_UI/CustomerApproveList.aspx`
- Doctor Approval List — `../Approval_UI/DoctorApprovalList.aspx`
- WH Stock Receive Approval — `../SInventory_UI/WarehouseStockInApproval.aspx`
- Expense Approval List — `../Approval_UI/ExpenseApprovalList.aspx`
- Tour Plan Approval List — `../Approval_UI/TourPlanApproval.aspx`
- Mileage Approval List — `../Approval_UI/MillageApprovalList.aspx`
- DA Claim Approval List — `../Approval_UI/DAApprovalList.aspx`
- Doctor Visit Plan Approval — `../Approval_UI/DCPCVPApproval.aspx`
- Prescription  Approval List — `../Approval_UI/RXApprovalList.aspx`
- Order Approval List — `../Approval_UI/OrderApproveList.aspx`
- Order Payment Approval — `../Approval_UI/OrderPaymentApprovalList.aspx` (added 2026-08-20, `SL = 383`; AM/DZSM/NSM payment-approval worklist for credit-blocked orders — see `spec/workflow.md` §4a)
- DCR Approval List — `../Approval_UI/DCRApprovalList.aspx`
- Leave Approval List — `../Approval_UI/LeaveApproveList.aspx`
- Market Structure Approval List — `../TransferUI/MarketStructure_TransferApprove.aspx`
- DSAV Approval — `../SInventory_UI/DcStockOutApproval.aspx`
- DWSP Approval — `../SInventory_UI/DcStockOutApproval.aspx`
- Stock Receive From SAP — `../SAP_Integration/SAP_IntrigationPointDIC.aspx`

**Live pages not present in this menu table (found by direct source analysis, this revision):**
`Solution.Web/DoctorModule_UI/TourPlannedApprovalList.aspx` and
`Solution.Web/DoctorModule_UI/VisitPlannedApprovalList.aspx` are real, DAL/proc-backed pages (calling
`sp_ApproveTourPlanInformation`/`sp_ApproveVisitPlanInformation` respectively — a **separate, legacy
bulk-approve mechanism** from the chain-based `Approval_UI/TourPlanApproval.aspx`/`DCPCVPApproval.aspx`
listed above) that do not appear anywhere in `tblMainMenuNew`. Since this menu table is this
document's stated ground truth for navigation, their absence here is expected/correct — but they are
genuinely reachable (by direct URL, or by a link from another page not traced in this pass) and
functionally live, so do not read "not in the menu" as "doesn't exist." See
[`business-rules.md`](business-rules.md) §0.1 for the dual-approval-mechanism finding this relates to.

**Menu entries pointing to retired pages (found by direct source analysis, this revision):** five of
the `.aspx` paths listed in this document's own menu-tree transcription no longer exist as buildable
pages — only a `.aspx.exclude`/`.aspx.cs.exclude` pair remains on disk, with no live file of that
exact name anywhere in `Solution.Web`:

- `../SInventory_UI/BacktoReturnPage.aspx` — referenced by two separate menu rows that share the
  same (non-unique) `SL`: "Process Inventory Balance" (Process section) and "Back to Return" (Sales
  confirmation Info section) — corrected this revision from an earlier mistranscription that showed
  "Process Inventory Balance" listed twice under Process and dropped the "Back to Return" row
  entirely
- `../SInventory_UI/InvoiceCreationByOrder.aspx` ("Invoice Creation", Sales Center Operation section)
  — a differently-named page, `InvoiceCreationByOrder_daaw.aspx`, is the live file that appears to
  have replaced it; confirmed this revision that the menu row itself was never repointed to it
- `../SInventory_UI/LoadingSummary.aspx` ("Delivery confirmation", Sales confirmation Info section —
  distinct from the live `LoadingSummary_DA.aspx` already listed separately under Sales Assistant
  Approval Process)
- `../SInventory_UI/DeliveryExcelUpload.aspx` ("Delivery Invoice Excel Upload", Sales Center Operation
  section) — `DeliveryExcelUploadOldData.aspx` is the only live file with a related name
- `../SInventory_UI/SalesReturnList_new.aspx` ("Second Time Return", Sales confirmation Info section)

**Confirmed this revision** with a fresh `tblMainMenuNew` read against the live dev DB: all five rows
are still present verbatim (`InvoiceCreationByOrder.aspx` at SL=324, `DeliveryExcelUpload.aspx` at
SL=342, `LoadingSummary.aspx` at SL=20275, `SalesReturnList_new.aspx` at SL=3029016,
`BacktoReturnPage.aspx` at SL=3029014) — the database was never repointed to the live replacement
files; these are genuinely stale leftovers still served as-is, i.e. a live 404/compile-error menu
link for any user who clicks them. One incidental data-quality finding surfaced while confirming
this: `BacktoReturnPage.aspx`'s two menu rows ("Back to Return" under parent 7000 and "Process
Inventory Balance" under parent 7000021) share the identical `SL` value 3029014 — consistent with
`SL` being a plain, non-`IDENTITY` int as noted elsewhere in this repo (see
[`database/menu/MonthlyInventoryReportBatchWise_menu.sql`](database/menu/MonthlyInventoryReportBatchWise_menu.sql)),
so collisions across different parents are apparently possible and this appears to be one. This repo
also has many more `.exclude`-suffixed file
pairs than the two documented in [`business-rules.md`](business-rules.md) §"Inactive files" and the
eight in [`reports.md`](reports.md) — most of the others are superseded backup copies coexisting
alongside a same-purpose live file under a different name (e.g. `MarketRecords.aspx.exclude` next to
the live `MarketRecords.aspx`, `RXDoctoriseMonthlypt.aspx.exclude` next to the live
`RXDoctoriseMonthlypt.aspx`) and don't affect any menu entry above.

### Reports

- Stock Report — `../SInventory_UI/DCStockReport.aspx`
- Invoice Report — `../SInventory_UI/ProformaReport.aspx`
- Allocation Opening Closing Report — `../Reports_UI/SampleStockAllocationRpt.aspx`
- Sales Confirmation Report — `../SInventory_UI/SalesConfirmationReport_New.aspx`
- Invoice TopSheet Report — `../SInventory_UI/TopSheetGenerate.aspx`
- Receivable Report — `../SInventory_UI/InTransitReport.aspx`
- Monthly Inventory Report (DC) — `../SInventory_UI/MonthlyInventoryReport.aspx`
- Delivery Return/Rejection Report — `../SInventory_UI/DeliveryReturnReport_new.aspx`
- Customer Ledger Report — `../SInventory_UI/CustomerLedgerReportNew.aspx`
- MIO Wise Receivable Report — `../SInventory_UI/MIOwiseInTransitReport.aspx`
- Order Delete Report — `../SInventory_UI/AuditReportOne.aspx`
- Sales Rejection Report — `../SInventory_UI/SalesRejecionReport.aspx`
- Pharma Sales, Collection & Deposition Statement Report — `../SInventory_UI/DepositSlipReport.aspx`
- Territory wise Sales Report — `../SInventory_UI/TerritoryWiseSalesReport.aspx`
- Monthly Inventory Report (Batch Wise) — `../SInventory_UI/MonthlyInventoryReportBatchWise.aspx` (added 2026-08-09)
- Monthly Inventory Report (WH) — `../SInventory_UI/MonthlyWarehouseReportCW.aspx`
- Organogram Report — `../Reports_UI/OrganogramReport.aspx`
- SMC Family Doctor Report — `../Reports_UI/DoctorInfoReport.aspx`
- STO and Order Report — `../SInventory_UI/MIGOReport.aspx`
- Monitoring Report — `../SInventory_UI/MonitoringReport.aspx`
- Target Achievement Report — `../Reports_UI/TargetAChivementReport.aspx`
- Target Achievement Report New — `../Reports_UI/TargetAChivementReportNew.aspx`
- Full Payment Report — `../SInventory_UI/DeliveryPaymentReport.aspx`
- Sales and Collection Reports (Acc) — `../SInventory_UI/Sales_Collection_Reports_Acc.aspx`
- 6/10 Project Monitoring Report — `../Dashboard_UI/DoctorVisitMonitoring.aspx`
- DA Collection Report — `../SInventory_UI/DACollectionReport.aspx`
- Dynamic Sales Summary Report — `../SInventory_UI/DynamicSalesReport.aspx`

### Promo Material Mangement

- Promo Group list — `../PromoAlloc/PromoGroupList.aspx`
- MIO Tagging Entry — `../PromoAlloc/PromoMIOTag.aspx`
- Group Wise Product Allocation MIO — `../PromoAlloc/GroupWisePromoQtyView.aspx`

### DWSP Information

- National Target List — `../DWSP/NationalTargetSetupView.aspx`
- Zone Wise Target List — `../DWSP/ZoneWiseTargetSetupView.aspx`
- Area Wise Target List — `../DWSP/AreaWiseTargetSetupView.aspx`
- Territory Wise Target List — `../DWSP/TerritoryTargetSetupView.aspx`
- DWSP Report — `../reports_UI/DWSPMonthlyRpt.aspx`

### MIS Reports

- Business Summary — `../SInventory_UI/RptBussinessSummary_Loading.aspx`
- Provider Wise Sales Summary — `../SInventory_UI/FinalsalesReport.aspx`
- Product wise Sales Summary — `../SInventory_UI/TotalSummaryNew.aspx`
- Day Wise Net Sales Report — `../SInventory_UI/RptBussinessSummary_DayWise.aspx` (added 2026-08-15;
  see [`database/menu/RptBussinessSummary_DayWise_menu.sql`](database/menu/RptBussinessSummary_DayWise_menu.sql)
  and [`reports.md`](reports.md) for the full 6-section breakdown)

### Hierarchy Setting

- Customer/Doctor Transfer — `../MasterSetup_UI/Customer_Doctor_Transfer.aspx`
- Sub-Territory Transfer — `../TransferUI/SubTerritory_Transfer.aspx`
- Territory Transfer — `../TransferUI/Territory_Transfer.aspx`
- Area Transfer — `../TransferUI/Area_Transfer.aspx`
- Zone Transfer — `/TransferUI/Zone_Transfer.aspx`
- Customer Updation — `../TransferUI/CustomerImport.aspx`
- Market Creation — `../TransferUI/MarketInfoImport.aspx`
- Doctor Updation — `../TransferUI/DoctorImport.aspx`

### Sales confirmation Info

- Receivable Report — `../SInventory_UI/NewReceiveableReport.aspx`
- Pending Sales Confirmation Report — `../SInventory_UI/PendingSalesConfirmationReport.aspx`
- Delivery confirmation — `../SInventory_UI/LoadingSummary.aspx`
- Return — `../SInventory_UI/DelivaryInvoiceCreationAfterSalesConfirm.aspx`
- Sales confirmation Report — `../SInventory_UI/SalesConfirmationReport_New.aspx`
- Receivable Report — `../SInventory_UI/NewReceiveableReport.aspx`
- Back to Return — `../SInventory_UI/BacktoReturnPage.aspx`
- Money Receipt Report — `../SInventory_UI/MoneyReceiptAfterPayment.aspx`
- Sales Rejection Report — `../SInventory_UI/SalesRejectionReport.aspx`
- Sales Return Report — `../SInventory_UI/SalesReturnReport.aspx`
- Monthly Inventory Report — `../SInventory_UI/MonthlyInventoryReport.aspx`
- Customer Payment — `../SInventory_UI/CustomerPayment.aspx`
- Customer Payment Report — `../SInventory_UI/SC_CustomerPaymentReport.aspx`
- Customer Payment Delete — `../SInventory_UI/CustomerPaymentDelete.aspx`
- Second Time Return — `../SInventory_UI/SalesReturnList_new.aspx`

### SAP Integration

- Sales Confirmation Report (SAP) — `../SInventory_UI/DeliveryPaymentReportNew.aspx`
- SAP Integration Point — `../SAP_Integration/SAP_IntrigationPoint.aspx`
- Sales Return Report (SAP) — `../SInventory_UI/SalesReturnReportSAP.aspx`
- Deposit Transfer to�Sap — `http://103.244.247.179:184/`
- SAP Dashboard — `../SInventory_UI/SAPDashboard.aspx`

### Archive Intrigration

- Delete Table Data — `../DoctorModule_UI/FinancialYearDeleteTableEntry.aspx`
- Archive DB Connect Setup — `../SettingPanel_UI/ArchiveDbConnect.aspx`
- Data Archive — `http://103.244.247.179:205/`

### eProgram Integration

- Dropout Request List — `../eProgram_UI/ProviderDropoutRequestList.aspx`

### Process

- Process Inventory Balance — `../SInventory_UI/BacktoReturnPage.aspx`
- Pending Sales Opening — `../SInventory_UI/PendingSalesOpening.aspx`

### Sales Assistant Approval Process

- Tourplan List — `../SInventory_UI/DAClaim_DICApprovalListByRoute.aspx`
- Tourplan List — `../SInventory_UI/DAClaim_DICApprovalListByRoute.aspx`
- Delivery Confirmation — `../SInventory_UI/LoadingSummary_DA.aspx`
- Payment Collection — `../SInventory_UI/CustomerPayment_DA.aspx`
- Expiry Return — `../SInventory_UI/ExpiryReturn_DAList.aspx`
- Tour Plan Approval — `../SInventory_UI/DAClaim_DICApprovalList.aspx`
- Sales Return — `../SInventory_UI/DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx`
- DA Claim List — `../DoctorModule_UI/SalesAssistantDAClaimList.aspx`
- Expense Claim List — `../SInventory_UI/DAExpenseClaimList.aspx`
- Expense Claim Approval — `../SInventory_UI/DAExpenseClaimApprovalList.aspx`
- Monthly Expense Summary — `../SInventory_UI/DAExpenseSummaryReport.aspx`
- DA Amount Claim Config — `../SInventory_UI/SalesAssistantDAAmountClaimConfig.aspx`
- mobile allowance — `../SInventory_UI/MonthlyAllowances.aspx`
- Ledger Reports — `../SInventory_UI/DACustomerLedger.aspx`

