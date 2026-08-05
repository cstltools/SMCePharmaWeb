# Business Rules

Exhaustive catalog of business rules enforced in code (BLL or code-behind), grounded in specific
files and line numbers. This supersedes the earlier "representative sample" version — every
`Library.BLL/**/*.cs` file and every `*_UI/**/*.aspx.cs` code-behind file with validation logic was
scanned. See [`validation-rules.md`](validation-rules.md) for the field-level validation catalog
and [`workflow.md`](workflow.md) for approval-routing rules in more detail.

**Legend:** "blocks" / "enforced" = the code returns/aborts before persistence. "weak enforcement" =
a message is shown but the save proceeds anyway, or the guard can be bypassed. "silent" = the
action is blocked but no message is shown to the user (CSS/focus only).

---

## 1. SInventory module (SInventory_UI, SInventory_BLL — largest module, 419 files)

### Warehouse Stock In
- `Solution.Web/SInventory_UI/WarehouseStockIn.aspx.cs:486` — Manufacturer required: `"Please Select Manufacturer !!!"`
- `Solution.Web/SInventory_UI/WarehouseStockIn.aspx.cs:493` — Supplier required: `"Please Select Supplier !!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInEdit.aspx.cs:396` — Manufacturer required on edit.

### Warehouse Stock In Approval
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:132` — At least one row selected: `"Please select at least one row!!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:145` — Operation must be selected: `"Please select an operation!!"`
- `Solution.Web/SInventory_UI/WarehouseStockInApproval.aspx.cs:72,188,217` — `Session["UserId"]`/`Session["LoginName"]` stamp the approving user.

### Warehouse Stock Out
- `Solution.Web/SInventory_UI/WarehouseStockOut.aspx.cs:846-849` — Out qty ≤ current stock qty, enforced by resetting field to `"0"`: `"Cannot be greater than Current Stock Qty !!"`
- `Solution.Web/SInventory_UI/WarehouseStockOut.aspx.cs:460` — Manufacturer required.

### Warehouse Stock Freeze / Release (Condition & Damage Stock)
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:84` — Stock condition required.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:90,254` — Return qty required.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:255-258` — Return qty ≤ current stock, enforced (textbox reset).
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:264` — Return qty > 0.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:273` — Return qty must be numeric.
- `Solution.Web/SInventory_UI/WhStockConditionFreeze.aspx.cs:314` — Warehouse required.
- `Solution.Web/SInventory_UI/WhFreezeStockRelease.aspx.cs:145,238,245,254,294` — Mirrored release-flow rules.
- **Weak/disabled enforcement**: `Library.BLL/SInventory_BLL/StockConditionFreezeBLL.cs:41-52` (`SaveforWH`) and `:60-72` (`SaveforDC`) — the duplicate-existence check and its `"Company Name already exist"` branch are commented out; save is unconditional.

### Stock Transfer (Requisition / DC-to-DC / Depot-to-Warehouse)
- `Solution.Web/SInventory_UI/StockTransferOrder.aspx.cs:452,459,466` — Manufacturer / Warehouse / Distribution Center required.
- `Solution.Web/SInventory_UI/StockTransferOrder.aspx.cs:820` — At least one product required.
- `Solution.Web/SInventory_UI/DepoToWHTransfer.aspx.cs:175,631` — Product & sales center required.
- `Solution.Web/SInventory_UI/DepoToWHTransfer.aspx.cs:369,374,379` — Manufacturer/from-unit/to-unit required.
- `Solution.Web/SInventory_UI/NewStockTransferDcToDc.aspx.cs:139,144,149` — Same manufacturer/from-unit/to-unit checks.
- `Solution.Web/SInventory_UI/OrderRequisitionCreation.aspx.cs:447,454,461,473,485,497` — Manufacturer/Warehouse/DC + per-line Req Qty/product required.
- `Solution.Web/SInventory_UI/IssueRequisitionProducts.aspx.cs:27` — Duplicate-challan guard: `"Challan Already Generated !!"`

### Stock Out Approval (DC / Sub-Depot)
- `Solution.Web/SInventory_UI/DcStockOutApproval.aspx.cs:129,143` — Row/operation selection required.
- `Solution.Web/SInventory_UI/DcStockOutApproval.aspx.cs:71,189,215` — `Session["UserId"]`/`Session["LoginName"]` gate approver.
- `Solution.Web/SInventory_UI/SubDepotStockOutApproval.aspx.cs:145,159,205,230,68` — Identical pattern.

### Sample / Warehouse Sample Stock Conversion
- `Solution.Web/SInventory_UI/SampleTypeConvertion.aspx.cs:181-189` — Stock-out qty ≤ main stock qty, enforced (clears input): `"Stock Out Qty. can't be more then Stock Quantity"`
- `Solution.Web/SInventory_UI/SampleTypeConvertion.aspx.cs:264-286` — Sales center/action/date/product required; ≥1 product line.
- `Solution.Web/SInventory_UI/SampleStockforWarehouse.aspx.cs:183-187` — Same stock-out ≤ stock guard.
- `Solution.Web/SInventory_UI/SampleStockforWarehouse.aspx.cs:260-282` — DC/action/date/product required.

### Invoice Creation (by Order)
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:208,213,219,238` — Order Number/Date, Payment Type, DA Name required.
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:224` — `"Invalid Receivable Amount!!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:1180` — Duplicate order guard: `"Order Information already Exists !!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:2234,2257` — Duplicate product row: `"Product Already Inserted!!!"`
- `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs:2469` — `InvalidOperationException` hard invariant for unique InvoiceId/InvoiceDetailId sequencing.
- `Solution.Web/SInventory_UI/InvoiceGenerationRestricted.aspx.cs:436-439` — **Invoice value approval-limit gate**: `grandTotal > 50000 && !chbOverrideLimit.Checked` blocks save unless an override checkbox is checked: `"Invoice value exceeds BDT 50,000. Authorized override required."` (This is a UI-level parallel to the DB-level `CustomerInvoiceLimitService` gate in §3 — the two are not obviously wired together; verify before assuming a single source of truth for invoice limits.)
- `Solution.Web/SInventory_UI/InvoiceGenerationRestricted.aspx.cs:339` — Duplicate product row guard.

### Payment Partial / Partial Dues
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:47,52,69,82` — Order Number/Date, valid data, Reason required.
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:2083` — Qty ≤ Total Quantity: `"Cannot be greater then Total Quantity"`
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:2116` — Qty ≤ Sales Confirmation Quantity.
- `Solution.Web/SInventory_UI/PaymentPartial.aspx.cs:969-978` — Pre-flight duplicate-invoice check, **plus** a row-locked, transactional re-check inside the DB transaction to defeat race conditions (rolls back + `"Already Exist!"` on concurrent submit) — the one properly hardened duplicate guard found in this pass.

### Customer Payment
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:201,215,226,254,259` — Invoice, Pay Amount, Collection By, Payment Type, DA Name required.
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:420-422` — **Weak**: a failed detail-row save sets `save=false` and shows `"Already Exist!"`, but rows already committed earlier in the same loop are not rolled back (potential partial-commit).
- `Solution.Web/SInventory_UI/CustomerPayment.aspx.cs:527-533` — `(mainamount+prevamount) > delamount` blocked (textbox reset to `"0"`): `"Cannot Be Greater then Invoice Quantity "`
- **Weak/disabled enforcement**: `Library.BLL/SInventory_BLL/dadtlsCustPaymentBLL.cs:88-102` (`SaveCustPayment`) — duplicate-existence check is an empty block; method always `return true` with no error surfaced. Duplicate payments can silently fail to save with no user feedback.

### Customer Master Entry / Edit
- `Solution.Web/SInventory_UI/CustMasterEntry.aspx.cs:102-194` — Long required-field chain (Name, Address, Mobile, Representative, Region, DC, FE, Area, MIO, Market, Category, Code, Address2, Contact No, City, Contact Person, etc).
- `Solution.Web/SInventory_UI/CustMasterEdit.aspx.cs:55-146` — Same chain for edit, but **Payment Type/Region checks are commented out** (`:76,81`) — weaker than the Entry form.

### Sales Return
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:193,199,213,220` — Order Number/Date, Customer, MIO Name required.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:243,254` — Expiry Date and Batch No required per line.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:675,710` — Qty selection required.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:1200` — Mandatory-field check.
- `Solution.Web/SInventory_UI/SalesReturn.aspx.cs:2273,2280` — Stock-existence and duplicate-product-row checks.
- **Dead validation**: `SalesReturn.aspx.cs:1195` — the duplicate-order guard (present in InvoiceCreation) is commented out here, so Sales Return has no equivalent duplicate-order protection.

### DA Expense Claim
- `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:191,212,226` — Sales Center, valid From/To dates required.
- `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:236` — `"From Date cannot be greater than To Date!"`
- `Solution.Web/SInventory_UI/DAExpenseClaimApprovalList.aspx.cs:68,75` — Row/ID validity.
- `Solution.Web/SInventory_UI/DAExpenseClaimApprovalList.aspx.cs:88` — Approval-state race guard: `"This DA expense claim was not updated. It may already be approved or disapproved."`

### DA Claim (DIC Approval)
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:89,96` — Invalid row/claim ID checks.
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:109` — Same approval-state race guard.
- `Solution.Web/SInventory_UI/DAClaim_DICApprovalList.aspx.cs:152,163` — Sales Center/Entry Date required.

### Stock Batch Update
- `Solution.Web/SInventory_UI/StockBatchUpdate.aspx.cs:130,136,142,150` — Batch No/MFG/EXP required per row; ≥1 row checked.

### Deposit Slip / Report
- `Solution.Web/SInventory_UI/DepositSlipReport.aspx.cs:72,77,346,372` — Date-format and date-range required before report.

### Master Data Duplicate-Name Checks (`Has<Field>Name` pattern — repeated across SInventory_BLL)
Each blocks save on name collision (`if (dal.HasXName(name)) return "X already exist"`):
- `Library.BLL/SInventory_BLL/AreaBLL.cs:31` — `"Area Name already exist"`
- `Library.BLL/SInventory_BLL/CustomerCategoryBLL.cs:30` — `"CustomerCategory Name already exist"`
- `Library.BLL/SInventory_BLL/DepartmentBLL.cs:30` — `"Department Name already exist"`
- `Library.BLL/SInventory_BLL/DistrictBLL.cs:31` — `"DistrictInfo Name already exist"`
- `Library.BLL/SInventory_BLL/ManufacturerBLL.cs:31` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/MarketInfoBLL.cs:31` — `"Company Name already exist"`
- `Library.BLL/SInventory_BLL/MIAInformationBLL.cs:30` — `"Employee Name already exist"`
- `Library.BLL/SInventory_BLL/PackSizeBLL.cs:32` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProductCategoriesBLL.cs:33` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProductSQBLL.cs:33` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/ProTypeBLL.cs:31` — `"Already Exist"`
- `Library.BLL/SInventory_BLL/RegionInfoBLL.cs:31` — `"Region Name already exist"`
- `Library.BLL/SInventory_BLL/ZoneInfoBLL.cs:33` — `"Zone Name is already exist"`

**Weak/disabled siblings of the above pattern:**
- `Library.BLL/SInventory_BLL/ExcelUpForOrderListBLL.cs:43` — duplicate-company check commented out; no dedup on Excel order import.
- `Library.BLL/SInventory_BLL/UserBLL.cs:46,51,56` — email/login-name/user-name uniqueness checks all commented out; no duplicate-account protection at BLL layer.
- `Library.BLL/SInventory_BLL/StockConditionFreezeBLL.cs:41-52,60-72` — see Warehouse Stock Freeze above.

---

## 2. DoctorModule_UI / DoctorMaster_UI / DoctorVisit_UI (128 files)

`DoctorMaster_UI` and `DoctorVisit_UI` code-behinds are thin pass-throughs to `Library.DAL.*` with
no inline validation — the duplicate/limit rules for those two areas are cataloged in §8 (DAL
layer). All substantive code-behind-level rules below are in `DoctorModule_UI`.

### Doctor Master / CRUD (DoctorMaster_UI)
- All Save/Delete methods are one-line DAL delegations stamped with `Session["UserId"]`, e.g. `Solution.Web/DoctorMaster_UI/DoctorCategory.aspx.cs:32`, `ChamberType.aspx.cs:31`, `DoctorDesignation.aspx.cs:33`, `DoctorSpeciality.aspx.cs:34`, `PatientType.aspx.cs:33`, `PrescriptionType.aspx.cs:34`, `SpecialDaySetup.aspx.cs:30`.
- **Disabled**: `DoctorCategoryView.aspx.cs:39` and `PrescriptionTypeView.aspx.cs:44` — delete calls are commented out; Delete is a no-op on these two screens.

### Market Structure Setup
- `Solution.Web/DoctorModule_UI/MarketSetup.aspx.cs:203-208` — ≥1 station-type user role required: `"please Add to List User Role Wise Station Type!"`
- `MarketSetup.aspx.cs:237-241,243-248,251-256` — Exactly one MIO, one AM, one DZSM required.
- `MarketSetup.aspx.cs:322,329-331` — Duplicate market: `"Already Exist!"`
- `MarketSetup.aspx.cs:336-338` — Deactivation blocked while referenced: `"Data cannot be deactivated!"`
- **Misleading message**: `MarketSetup.aspx.cs:342-345` — any unclassified save failure also shows `"Already Exist!"`.

### Tour Purpose / Tour Plan Setup
- `Solution.Web/DoctorModule_UI/TourPurposeOtherSetup.aspx.cs:161-165,167-171` — Role/Station type required (**silent** — focus only, no message).
- `TourPurposeOtherSetup.aspx.cs:173-185` — ≥1 of Territory/Area/Region/Group required: `"Please select at least one of Territory, Area, Region or Group"`
- `TourPurposeOtherSetup.aspx.cs:187-201` — Duplicate row in grid blocked: `"Already Exist in Table!"`
- `TourPurposeOtherSetup.aspx.cs:683-689` — Tour purpose required (**silent**).
- `TourPurposeOtherSetup.aspx.cs:695-700` — ≥1 market-structure row required.
- `TourPurposeOtherSetup.aspx.cs:641-651` — Row deletion blocked if child data exists: `"Can not be deleted!"`
- `TourPurposeOtherSetup.aspx.cs:785,792-794` — Duplicate on server save; `:797-800` deactivation-while-referenced block; `:802-805` misleading generic-failure `"Already Exist!"`.

### Tour Plan / Visit Plan Approval
- `Solution.Web/DoctorModule_UI/TourPlannedApprovalList.aspx.cs:69-74` — Approval action required: `"please fill out this field"`
- **Weak enforcement (bulk-result bug)**: `TourPlannedApprovalList.aspx.cs:88-117` and `VisitPlannedApprovalList.aspx.cs:74-118` — when multiple rows are selected, the result variable is reassigned every loop iteration, so only the **last** row's outcome determines the success/fail message shown; earlier rows' failures are silently swallowed.

### TADA / DA Claim
- `Solution.Web/SInventory_UI` *(cross-ref)* / `Solution.Web/DoctorModule_UI/TADAClaimEdit.aspx.cs:323-385` — Employee, TADA date, DA Amount, Tour type, Tour purpose, Market (unless purpose contains `"(Other Visit)"`) all required — **all silent** (tooltip/CSS only, no alert).
- `TADAClaimEdit.aspx.cs:428-442` — Save success/failure messages.
- `TADAClaimEdit.aspx.cs:455-463,748-755` — Tour-plan-must-exist-for-date check (via caught exception): `"Tour plan not Exists!"`

### Monthly Allowance
- `Solution.Web/DoctorModule_UI/MonthlyAllowance.aspx.cs:208-232` — Name/Value/Role required (silent).
- `MonthlyAllowance.aspx.cs:235-257` — ≥1 grid row selected: `"Please Select at least one row !"`
- `MonthlyAllowance.aspx.cs:306,313-315` — Deactivate-while-referenced block; `:319-321` duplicate; `:329` generic `"Operation Faild!"`.

### Expense Type / Expense Claim
- **No feedback at all**: `Solution.Web/DoctorModule_UI/ExpenseType.aspx.cs:263-275` — duplicate field name silently not added to the in-memory grid, zero user feedback.
- `ExpenseType.aspx.cs:648-651` — Row deletion blocked if in-use: `"Can not be deleted!"`
- `ExpenseType.aspx.cs:555,562-566` — Duplicate expense type; `:568-572` deactivate-while-referenced block.

### Sub-Territory Setup
- `Solution.Web/DoctorModule_UI/SubTerritorySetup.aspx.cs:172-206` — Area/Territory/Name/Activation date required (silent).
- `SubTerritorySetup.aspx.cs:124,131-133` — Duplicate; `:136-140` deactivate-while-referenced; `:142-146` misleading generic `"Already Exist!"`.

### Training Setup
- `Solution.Web/DoctorModule_UI/Trainning.aspx.cs:127-149` — Title/From-date/To-date required (silent).
- `Trainning.aspx.cs:152-157` — Market structure or user role required: `"please Add to List Market Structure or User Role!!"`
- `Trainning.aspx.cs:230,238` — Duplicate training entry. **No From/To date-order check found** — potential gap.

### Leave Config
- `Solution.Web/DoctorModule_UI/LeaveConfig.aspx.cs:554,563` — Duplicate leave config: `"Already Exist!"`
- `Solution.Web/DoctorModule_UI/Leave.aspx.cs:31` — pure DAL delegation, no inline day-quota/date-overlap check.

### Financial Year Archive / Delete (Data Management)
- `Solution.Web/DoctorModule_UI/FinancialYearDeleteTableEntry.aspx.cs:93-129` — Opening-balance-exists gate toggles Opening vs Delete button availability.
- `:155-175` — Process type, Financial Year, and valid FY date range required for Opening.
- `:200-214` — Delete/Archive mode, Financial Year, table (+ database if archive) required for Delete.
- `:238-249` — **Only whitelisted tables** (Order, Invoice, RX, DCR, TourPlan, Attendance, Expense) are actually deletable: `"Delete logic is configured only for Order, Invoice, RX, DCR, TourPlan, Attendance and Expense."`
- **Dormant guard**: `:228-232` — archive-database-availability check fully commented out.
- **Dropdown/logic mismatch**: `LoadDeleteTableList()` (`:70-86`) offers "Leave" and "Mileage Claim" as deletable, but `TryExecuteDeleteTableProcess` (`:318-450`) has no matching branch — selecting these silently falls into the generic failure message.

### User Setup
- `Solution.Web/DoctorModule_UI/UserSetup.aspx.cs:326-417` — User type, Employee (types 1/3), DA (types 6/7), Username, Login name, Password, User role, Activation date required (silent).
- **Disabled**: `:392-409` — IMEI-required-when-Mobile-Access rule fully commented out.
- `:530,547` — Duplicate user: `"Already Exist!"`

### Approval/Access-Control Gating (cross-cutting, DoctorModule_UI)
- Recurring `UserPersmissionValidation()` pattern: `if (Session["UserRoleID"].ToString() != "2")` looks up a permission row for the current page path; missing row → `Response.Redirect("../Dashboard_UI/DashboardOne.aspx")`. Role `"2"` (Admin) bypasses entirely. Seen in `AttendanceListApproval.aspx.cs:294-326`, `AppMonitoringList.aspx.cs:61-92`, `UserRecords.aspx.cs:45-70`, `TourPlannedApprovalList.aspx.cs`.
- **Weak enforcement**: in `AttendanceListApproval.aspx.cs:305-315`, `AppMonitoringList.aspx.cs`, `TourPlannedApprovalList.aspx.cs` — when a permission row *is* found, the code applying granted `RAdd`/`REdit` flags to button/column visibility is commented out, so any user who passes the page gate still sees full Add/Edit controls regardless of granted rights. Only `UserRecords.aspx.cs:56-65` still applies this correctly — inconsistent across pages.
- `AttendanceListApproval.aspx.cs:328-447` — approval step-advance logic (`Step = InStep+1`, `Status` = Accepted/Verified/Rejected based on `ToRoleTypeId=="5"`), failure shown as misleading `"Already Exist!"` (`:393,441`).

### Field-Force / Reference Setup (RSM/ASM/MIO/NSM, Router, Shift, Holiday, Group, Generic Group, Therapeutic Group, Department, Tour Type/Purpose, Product Line)
- No inline validation — single-line DAL delegations stamped with `Session["UserId"]`. Any duplicate/limit rules live entirely in `Library.DAL.DoctorModule_DAL`.

### Doctor Visit Planning (DoctorVisit_UI)
- `DoctorVisit.aspx.cs`, `DoctorPlanDetailsView.aspx.cs` — pure `[WebMethod]` DAL delegation, no inline visit-target/call-limit rules found in code-behind.
- `DoctorVisitApprovalList.aspx.cs` — empty `Page_Load`, fully client/JS-driven.

---

## 3. MasterSetup_UI / MasterSetup_BLL / Target_UI / Thana_UI

### Customer Invoice / Order Limit Setup (`Library.BLL/MasterSetup_BLL/CustomerInvoiceLimitService.cs`)
All checks below correctly `return` before persistence — no weak enforcement in this file.

| Rule | Location | Message |
|---|---|---|
| Customer required | `:14-17` | "Customer is required." |
| Max invoice value ≥ 1 | `:18-21` | "Maximum Invoice Value must be greater than 0." |
| Duplicate customer in Order Limit Setup | `:23-27` | "This customer already exists in Order Limit Setup." |
| Update requires valid id | `:34-37` | "Invalid record." |
| Delete requires valid id | `:48-51` | "Invalid record." |
| **Invoice-limit gate** (`ValidateInvoiceLimit`) | `:78-98` | active limit for `CustomerId`, default **50,000** if none active; `invoiceAmount > limit` → "Invoice amount exceeds the customer's maximum allowed invoice value." |
| ApplyType defaults to `"Customer"` if blank | `:101-106` | — |
| Customer Type required (ApplyType=CustomerType) | `:110-116` | "Customer Type is required." |
| Customer required (ApplyType≠CustomerType) | `:117-120` | "Customer is required." |
| Active From Date required | `:122-125,156-159` | "Active From Date is required." |
| Duplicate Invoice-Not-Binding entry | `:127-140` | per-ApplyType duplicate message |

Note: `InvoiceGenerationRestricted.aspx.cs:436-439` (§1) implements a *separate* UI-level 50,000 gate
with an override checkbox — not obviously the same code path as this service; treat as two rules
until traced to a single call site.

### Customer Master Data
- `Solution.Web/MasterSetup_UI/CustomerEntry.aspx.cs:299` — Non-Admin role gate disables most fields.
- **Hard-coded backdoor**: `CustomerEntry.aspx.cs:330` and `CustomerView.aspx.cs:320` — `Session["LoginName"] == "53323"` re-enables all fields regardless of role; `CustomerEntry.aspx.cs:70` has a second hard-coded login `"51419"`.
- `CustomerEntry.aspx.cs:747-759` — Mobile number must be 11 digits: `"Mobile NO must be 11 digits!"`
- **Disabled**: `CustomerEntry.aspx.cs:733-745` — NID length check commented out.
- `CustomerView.aspx.cs:299-320` — Permission gate (role≠2 without permission row → redirect to Dashboard), same backdoor login override.
- `CustomerListPending.aspx.cs:96-98`, `CustomerView.aspx.cs:159-161`, `CustomerChangeProgramType.aspx.cs:129-131` — DIC role auto-locks Distribution Center dropdown to `Session["DICCompanyUnitId"]`.
- `CustomerChangeProgramType.aspx.cs:263-304` — Program Type required: `"Please Select Program Type!"`; `:295` generic failure mislabeled `"Already Exist!"`.
- `Customer_Doctor_Transfer.aspx.cs:80-85,114-119` — Grid non-empty: `"Table can not be Empty!"`
- `Customer_Doctor_Transfer.aspx.cs:105-109,139-143` — ≥1 employee/doctor selected.
- `Customer_Doctor_Transfer.aspx.cs:148-154,277` — Market required.
- `OrderDCChange.aspx.cs:377-382,402-406` — Grid non-empty, ≥1 row selected.

### Doctor Master Data (MasterSetup_UI copies)
- `DoctorEntry.aspx.cs:228` — Non-Admin field-lock gate (no backdoor override here, unlike CustomerEntry).
- `DoctorEntry.aspx.cs:599` — Mobile 11-digit check.
- `DoctorView.aspx.cs:146-157` — Permission-gated redirect.

### Delivery Agent (DA) Setup
- `DASetup.aspx.cs:181-283` — Name/Depot/Phone/Emergency Contact/Active Date required.
- `DASetup.aspx.cs:200-211` — NID must be 17 digits.
- `DASetup.aspx.cs:226-274` — Phone/Emergency/Reference Contact must be 11 digits each.
- `DASetup.aspx.cs:322-330,362-369` — Duplicate save failure → `"Already Exist!"` (DAL-level dedup, correctly blocks).

### Route / Territory Setup
- `RouteInformationEntry.aspx.cs:613-697` — Depot, Route Name, DA list, Market list, Total Distance/Day, Route Type, TA/DA Amount, Route Day all required.
- `RouteInformationEntry.aspx.cs:704-733` — Duplicate market in list blocked: `"This Market is already exist in list!"`
- `TerritoryWiseDepotSetup.aspx.cs:191-227` — Area/Depot/Route required, ≥1 Territory selected.
- **Weak (silent abort)**: `TerritoryWiseDepotSetup.aspx.cs:252-253` — `if (routeId == 0) return;` aborts save with zero feedback.

### Employee Setup (EmployeeSetup / EmployeeSetupEdit / EmployeeSetupForNewJoiner — identical pattern x3)
- NID must be 17 digits; Employee/Reference/Emergency Contact No must be 11 digits each.
- **Duplicate Employee Code check**: `EmployeeSetup.aspx.cs:716-732` — `"Employee Code Already Exist in User!"`
- Login Name/Password/User Role required before account creation: `:735-755`.
- `EmployeeRecords.aspx.cs:38-58` — Permission gate, redirect to Dashboard if missing.

### Campaign Setup (6 near-duplicate variants: CampaignSetup, CampaignSetup_Mult, CampaignSetup_final, CampaignSetup_new, CampaignSetupPT, OLdCampaignSetup)
- Campaign Name/Chemist Type/Campaign Type/Product Line/From Date/To Date required in every variant.
- Campaign-type-conditional required fields (Product/Qty for type "1", Product/Amount/MaxAmount for "2", Amount for "3").
- Product Offer list and Market Structure/Customer list must be non-empty: `"please Add to List Product Offer"`, `"please Add to List Market Structure or Customer!"`
- **Duplicate customer-in-list check (`AddCustomerVali`)**, repeated in all 6 files: `"The customer already exists in the list!"`
- Autocomplete free-text format validation (`"Name | Id"` pipe format required): `"Input Correct Data !"`
- **Weak/disabled**: email-failure handling commented out in all 6 variants — if the notification email fails, no error is surfaced and the save is not rolled back.

### Quoted Price Setup
- `QuotedPriceSetup.aspx.cs:198-215` — Description/Policy/From/To Date required.
- `QuotedPriceSetup.aspx.cs:163-186` — Customer autocomplete format validation, **weak**: only clears the field/shows a message, doesn't itself block the Save button — the real gate depends on `hfCustomerId.Value` being empty at save time.
- `QuotedPriceSetup.aspx.cs:302` — ≥1 row selected for batch action.

### Order Tracking (view/list)
- DIC role dropdown auto-lock repeated across `OrderTrackingList.aspx.cs:133-135`, `OrderTrackingListDBH.aspx.cs:132-134`, `OrderTrackingSummary.aspx.cs:140-142`.
- `RouteInformationList.aspx.cs:45-52` — role `"5"` restricts route list to `Session["DICUnitId"]`.

### Target Setup (Target_UI)
- `MonthlyTarget.aspx.cs:33-46` — **Weak/inverted gate**: update only proceeds if no conflicting year/month record exists; if one does, the method silently no-ops with no "already exists" message.
- `ProductWiseTarget.aspx.cs:32-39` — Pure insert/update branch on ID, no duplicate/date checks.

### Thana / District / Division Setup (Thana_UI)
- All 5 files are thin `[WebMethod]` wrappers; no validation in this layer. Duplicate-name/required-field logic (if any) lives in `Library.DAL.ThanaDal` — out of scope for this pass.
- `District_Entry.aspx.cs:26`, `ThanaEntry.aspx.cs:26,36` — `Session["UserId"]` passed through with no null-check.

### DWSP (Target Setup UI, separate from Target_UI) — quota enforcement
Recurring "row-sum vs master target" rule across `AMDayWiseDWSPSetup.aspx.cs:525`, `AreaWiseTargetSetup.aspx.cs:476-521`, `AreaWiseTargetSetupView.aspx.cs:425,629`, `TerritoryTargetSetupView.aspx.cs:313,546`, `TerritoryWiseTargetSetup.aspx.cs:392`, `TerritoryWiseTargetSetupApps.aspx.cs:531`, `ZoneWiseTargetSetup.aspx.cs:371`, `ZoneWiseTargetSetupView.aspx.cs:284,446`:
- Condition: running per-row total compared against master `amount.Text` on every row edit; if it exceeds, row input is cleared: `"Amount must be equal with target amount"` — **misleading name**: this is actually an "exceed" cap, not an equality check — a total *less than* target passes silently and is never forced to match before save.
- Companion required-field guard on master target amount (`"Please Select Target Amount"`) is itself weak — shown but doesn't disable the row inputs.
- Role-based zone/employee scoping (`Session["RoleTypeId"]`) restricts selectable zone/territory dropdown options per role — data-scoping, not a hard block.
- **Weak (silent)**: `NationalTargetSetup.aspx.cs:181`, `NationalTargetSetupView.aspx.cs:144`, `ZoneWiseTargetSetupView.aspx.cs:476` — save silently no-ops if `Session["UserId"]` is null, no error shown.

---

## 4. SubDepot module (SubDepot_UI, SubDepot_BLL, 25 files)

### Stock Freeze / Stock Return (`SubDeportStockFreez.aspx.cs`)
- **Weak enforcement, confirmed 4x in one file** (`:271-274`, `:314-317`, `:390-394`, `:437-441`) — `"Return Quantity must be Less then Stock Qty"` is shown but the block is a sibling `if`, not an `else`/`return`; the actual save proceeds via a separate, non-exclusive `if (bigStore >= ReturnQty)` block with no shared flag or early exit. Currently self-correcting only because the two conditions happen to be complementary.
- **Hard-coded privileged-user bypass**: `Session["LoginName"] == "21900"` (`:310,432`) duplicates the entire return-processing logic and skips the `"Restricted"` stock-condition gate applied to all other users.
- Return Qty required in all four code paths: `"Insert Return Quantity !!"`

### Stock Transfer — DC ↔ Sub-Depot (`StockOutSubDepot.aspx.cs`, `StockTransferDcToSubDepot.aspx.cs`, `StockTransferSubDepottoDc.aspx.cs`)
- Chalan No/Date, Manufacturer, From/To Company Unit, ≥1 product line required (all three files, near-identical required-field sets): `"Please Insert chalanNo!!"`, `"Please Insert chalanDate!!"`, `"Please Select Manufacturer!!"`, `"Please Select fromComUnit!!"`, `"Please Select toComUnit!!"`, `"Please Add Product!!"`.
- Transfer Qty ≤ available Stock Qty, enforced (textbox cleared): `"Stock Out Qty. cantbe more then Stock Quantity"` / `"Transfer Qty. cantbe more then Stock Quantity"`.
- **Validation-bypass (stronger than weak enforcement)**: `StockOutSubDepot.aspx.cs:117-143` — the live save handler calls `SaveDataForSubDepoAdjust(...)` directly; the full `Validation()` method exists but is only invoked from a dead/commented-out legacy code block (`:144-228`) — **no validation runs on the live save path at all**. Contrast with `StockTransferDcToSubDepot.aspx.cs:325`, which correctly gates its save on `Validation()`.

### Stock Adjustment Voucher (`SubDepotStockAdjustmentVoucher.aspx.cs`)
- Distribution Center, Proforma Invoice Number, Stock Out Date, Reason, Product, ≥1 product row required — `Validation()` correctly gates the save here (`:283-325`).
- `SubDepotStockAdjustmentVoucherView.aspx.cs:47-50` — **Status/approval gate, properly enforced**: a voucher in `"Approved"` status cannot be deleted: `"Can not Delete Data!!!...."`

### Stock Out Approval (`SubDepotStockOutApproval.aspx.cs`)
- `:49-75` — Session-based menu authorization gate: page only loads data if `Session["UserId"]` is assigned to the resolved menu ID.
- `:132-168` — Operation must be selected: `"Please select an operation!!"`; `:145-162` ≥1 row checked: `"Please select at least one row!!!"`
- `:173-220` — Any non-`"Reject"` radio selection sets Status=`"Approved"`; `"Reject"` sets the selected reject-reason text as Status.

### Sub-Depot Customer Payment (`SubDeportCustomerPayment.aspx.cs`)
- Invoice selection, per-row Pay Amount, header Payment Amount, Payment Type, Payment Date required.
- `:186-201` — **Sum of per-row Pay Amounts must exactly equal header Payment Amount**: `"Total Invoice Payment Amount Must Be Equel To Payment Amount"`
- `:296-320` — Per-row Pay Amount (+ previously paid) ≤ invoice amount, enforced (textbox reset to `"0"`): `"Cannot Be Greater then Invoice Quantity "`

### Sub-Depot Invoice Creation
- `SubDepotInvoiceCreation.aspx.cs:55-84,194-204` — **Empty catch blocks** silently swallow invoice-generation and footer-total errors; no user feedback on failure.

### Delivery Invoice List (`DelivaryInvoiceList.aspx.cs`)
- `:93-118` — Status dropdown drives Full/Partial/Reject branching. **Fragile**: the reject branch is an unconditional `else` (no explicit `== "Reject"` check), so any future dropdown value that isn't exactly `"Partial"` or `"Full"` silently falls into Reject.

### Reports / Picking / Master Info
- `SubDepotProformaList.aspx.cs:77-99`, `TopSheetGenerate.aspx.cs:90,98`, `DelivaryTopSheetGenerate.aspx.cs:99,107,171` — All filter parameters required before report generation: `"Please Select all Parameters"`.
- `SCPickingGenerate.aspx.cs:108-125` — ≥1 invoice checked before generating picking report.
- `SubdepotInfoEntry.aspx.cs:73-102` — Sales Center Name, Address, Code, Mobile No, Distribution Center required.
- `SubdepotInfoEntry.aspx.cs:186-243` — Sub-Depot code prefix assigned via a hard-coded per-company-ID `if` ladder (e.g. `"BAR"`, `"BOG"`, `"CHA"`) rather than data-driven config.
- `SubDeportStockReport.aspx.cs:16-31`, `StockReceiveBySubDepot.aspx.cs:16-31` — Session-based login redirect gate; **unguarded `.ToString()`** on `Session["UserType"]` before the null/empty check (NRE risk on expired session).

### Inactive files
- `DelivaryInvoiceCreationForCustomerAuto.aspx.cs.exclude` and `ProformaInvoiceCreation.aspx.cs.exclude` are excluded from the build (`.exclude` suffix) — any rules inside are dormant, not enforced in production.

### Library.BLL/SubDepot_BLL
- All 6 files are pure DAO-calling wrappers with no inline validation. `Sub_InvoiceBLL.cs:736-738` (`LoadOrderExistsBll`) forwards existence-check row counts to callers with no enforcement of its own.

---

## 5. Approval_UI — approval routing (see also [`workflow.md`](workflow.md))

### Access control (repeated pattern across all list pages)
- `Solution.Web/Approval_UI/CustomerApproveList.aspx.cs:75-105` (`UserPersmissionValidation`), mirrored in `DAApprovalList.aspx.cs:246-278`, `DCPCVPApproval.aspx.cs:79-109`, `DoctorApprovalList.aspx.cs`, `ExpenseApprovalList.aspx.cs`, `LeaveApproveList.aspx.cs`, `MillageApprovalList.aspx.cs`, `OrderApproveList.aspx.cs`, `RXApprovalList.aspx.cs`: role≠`"2"` and no permission row → silent redirect to Dashboard.
- **Weak**: the inner per-role field-restriction block after a positive permission check is always empty/dead code — any user with page access gets full button visibility regardless of finer role rules.
- **Fragile**: `Session["RoleTypeName"]`/`["EmpInfoId"]`/`["RoleTypeId"]` read with no null-check on every page load; the whole `Page_Load` try/catch swallows resulting exceptions and silently redirects (expired-session users get no error message), e.g. `CustomerApproveList.aspx.cs:69-72`.

### Multi-step approval-routing gate (role-sequence enforcement)
Implemented identically in `CustomerApproveList.aspx.cs:423-453`, `DAApprovalList.aspx.cs:390-437`, `DCPCVPApproval.aspx.cs:417-448`, `DCRApprovalList.aspx.cs:339-369`, `DoctorApprovalList.aspx.cs:279+`, `ExpenseApprovalList.aspx.cs:445+`, `LeaveApproveList.aspx.cs:417+`, `MillageApprovalList.aspx.cs:393+`, `OrderApproveList.aspx.cs:293+`, `RXApprovalList.aspx.cs:411+`:
- Role IDs `"5"`, `"4"`, `"14"` see all rows as actionable. Otherwise, a row is only actionable if `hfToRoleTypeId` (the pending step's assigned role) matches the current user's role; else the row shows `"Waiting for Another Approver"` instead of action buttons.
- Approve/Reject: `Step = InStep + 1`, `Status = "Accepted"`/`"Rejected"`. **Bug**: `CustomerApproveList.aspx.cs:163-176,220-236` shows the **success** message even when `Res.isSuccess == false` (the correct `"Already Exist!"` failure branch is commented out). Other modules (`DAApprovalList.aspx.cs:188-192`, `DCPCVPApproval.aspx.cs:252-256`, `DCRApprovalList.aspx.cs:171-175`) handle this correctly.

### Multi-tier status escalation — hard-coded super-approver
`DAApprovalList.aspx.cs:138-151`, `ExpenseApprovalList.aspx.cs:191-201`, `LeaveApproveList.aspx.cs:195-205`, `MillageApprovalList.aspx.cs:175-185`, `OrderApproveList.aspx.cs:114-120`, `RXApprovalList.aspx.cs:169-175`:
```
if (ToRoleTypeId == "5") ApprovalStatus = "Accepted";
else if (EmpInfoId == "496") ApprovalStatus = "Accepted";
else ApprovalStatus = "Verified";
```
Role `5` **or** the specific hard-coded employee ID **`496`** gets final "Accepted" status directly, bypassing the normal "Verified" intermediate step required of every other approver. This magic-number bypass appears in 5+ files (also affects row-visibility logic, e.g. `DAApprovalList.aspx.cs:394`, `ExpenseApprovalList.aspx.cs:449`).

### Customer/Doctor transfer approval
- `DoctorCustomerTransferApproval.aspx.cs:168-201` — order-pending customers cannot be transferred: checkbox is programmatically unchecked, `"Order Pending!"`.
- `DoctorCustomerTransferApproval.aspx.cs:282-318` — operation selection required (`"Please select an operation!!"`), ≥1 row checked (silent).

---

## 6. Dashboard_UI, DWSP misc, eProgram_UI, LeaveProcess_UI, Money_Receipt_UI, NoticeBoard_UI, Reports_UI, SettingPanel_UI, UserProfile_UI

### Dashboard_UI
- `AdminDashboard.aspx.cs:37,48` — role≠`"2"` gate (same shape as Approval_UI pattern).
- `DoctorVisitMonitoring.aspx.cs:226-228` — unrecognized `type` param → `"Invalid type."` (defensive input guard, AJAX-style, not a UI block).

### eProgram_UI
- `ProviderDropoutRequestList.aspx:72` — client-side `"Invalid row id."` guard (markup JS, module's only validation; code-behind is otherwise a stub).

### LeaveProcess_UI
- `LeaveApplicationEntry.aspx.cs` is an **empty stub** — all leave-entry validation is client-side markup only (`"Please fill out of this field!"` tooltips, `:255-289`).
- `LeaveApplicationCode.aspx.cs:23-57` — `[WebMethod]`s (`SaveLeaveApplication`, `UpdateLeaveApplication`, `LeaveApplicationApprove`, `GetEmployeeLeaveBalance`) are thin DAL passthroughs with **no server-side validation** — all day-quota/date-range/approval-status enforcement (if any) lives in the DAL, not observed in this pass.
- `YearlyLeaveProcess.aspx.cs:24` — `Session["UserId"]` converted with no null-guard (throws if unauthenticated).
- `YearlyLeaveProcess.aspx:123,132` — mandatory-field messages commented out in markup (**disabled**).

### Money_Receipt_UI
- `BatchWiseCollectionReport.aspx.cs:42-94` — Delivery Man, Batch Creation Date, BatchNo required in sequence; invalid Customer Code lookup clears the field: `"Invalid Customer Info !!"`. All correctly enforced.

### NoticeBoard_UI
- `NoticeSetup.aspx` (markup) — Title, Announcement required; Details list and Image must be non-empty (`"Please!! Add Details list"`, `"Please!! Select Image"`); generic save-failure fallback.
- `SettingPanel_UI/ArchiveDbConnect.aspx:19` — documented (not code-enforced) idempotency: duplicate FY+DB name skips insert but still triggers the job.

### Reports_UI
- `OrderPermission.aspx.cs:191-216` — ≥1 employee checkbox selected: `"Please Select at least one employee!"`
- `CVRDoctoriseMonthlypt.aspx.cs:575,585` — Area/Zone required before report: `"Please Select Area!"` / `"Please Select Zone!"`
- All monthly-report pages read `Session["RoleTypeName"/"EmpInfoId"/"RoleTypeId"]` unguarded — same fragile pattern as Approval_UI.

### SettingPanel_UI
- `UserSettingPanelSetup.aspx.cs:74-96` — ≥1 row checked: `"Please Select Minimum One"`

### UserProfile_UI — password rules
`ChangePassword.aspx.cs`:
- `:111-118` — New password required.
- `:119-126` — Strength regex `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$` (12–20 chars, upper/lower/digit/special): `"Password is not strong enough"`
- `:127-134,158-169` — New password ≠ current password. **Security concern**: the comparison is a **direct plaintext string comparison** against the stored password (`GetUserCurrentPasswordDAL`), consistent with the plaintext-login finding in [`docs/security.md`](../docs/security.md).
- `:137-154` — Confirm-password required and must match; **mislabeled message**: mismatch shows tooltip `"please fill out this field"` instead of a mismatch-specific message.
- `:88-98` — `"Password update failed!"` / `"Password updated successfully!"`, sets `Session["IsPasswordChange"]`.

### Library.BLL (root) / Panal_BLL
- No root-level `.cs` files in `Library.BLL` (all classes live in subfolders).
- `Library.BLL/Panal_BLL/PanalBLL.cs` — pure menu/login/permission plumbing; `SaveMenuBll` (`:39-62`) has an implicit duplicate-prevention pattern (`CheckMenuSl` existence-check-then-insert) but no user-facing validation.

---

## 7. Order-to-cash stage rules (cross-module, from prior pass — not re-verified in this scan)

- An order converts to an invoice (`OrderInfoMaster.IsInvoice` flag); the exact gating condition (e.g. "only after order approval") is implied by approval-workflow ordering but was not traced to a single method.
- DA sales confirmation, payment collection, and sales return each have their own status column on `tblInvoice` (`DA_SalesConfirmStatus`, `DA_PaymentCollection`, `DA_SalesReturn`), independently rejectable via dedicated `sp_RejectInvoiceDA*.sql` procedures. A DIC re-approval layer (`sp_UpdateDICApprovalStatus[_SalesReturn].sql`) sits on top of the DA's own actions for those two stages.

---

## 8. DAL layer (Doctor/Thana modules) — closes the gap flagged in §2

`DoctorMaster_UI`, `DoctorVisit_UI`, `Thana_UI`, and most Field-Force reference-data screens in
`DoctorModule_UI` have thin code-behind with no inline validation (§2) — their rules live in
`Library.DAL/DoctorModule_DAL`, `DoctorMaster_DAL`, `DoctorVisit_DAL`, `Thana_DAL` (37 files, all
scanned). This is stored-procedure-calling ADO.NET throughout, so most "business logic" is a thin
C# wrapper around a `sp_check_*`/`sp_Save_*` call — real duplicate/limit logic mostly lives in the
stored procedures themselves, which are **not in this repo** for the vast majority of these procs.

### Recurring pattern (repeated near-identically across ~20 classes)
1. On edit (`Id > 0`): call `sp_check_<Entity>`; if it returns rows, set `isDuplicateCheck = true` and skip the update.
2. On deactivate (`IsActive == false`) within an edit: additionally call `sp_check_Vali_MarketStructure` with `@MasterId`/`@PageName="<Entity>"`; rows returned → `isValiCheck = true`, blocks deactivation ("in-use, can't deactivate").
3. On insert (`Id == 0`): call `sp_Save_*`; success inferred from `pk > 0` — C# has no visibility into *why* a proc returned 0 (could be duplicate, could be an unrelated failure).
4. Exceptions caught, connection closed, rethrown (or swallowed into a bare `throw;` in "get" methods).

### Confirmed rules with the duplicate-check proc + market-structure gate
- `Library.DAL/DoctorModule_DAL/DesignationDal.cs:17,36,45` — `sp_check_Designation` + gate `PageName="Designation"`.
- `Library.DAL/DoctorModule_DAL/DepartmentDal.cs:18,36,44` — `sp_check_Department` + gate `PageName="Dept"`.
- `Library.DAL/DoctorModule_DAL/GroupSetupDal.cs:62,85,94` — `sp_check_GroupInfo` + gate `PageName="Group"`.
- `Library.DAL/DoctorModule_DAL/ZoneSetupDAL.cs:97,126,134` — `sp_check_ZoneInfo` + gate `PageName="Zone"`.
- `Library.DAL/DoctorModule_DAL/Setup2DAL.cs:211` (Area), `:613` (Territory), `:722` (SubTerritory), `:1198` (Market) — each with matching `sp_check_*` + `PageName` gate.
- `Library.DAL/DoctorModule_DAL/SetupDAL_daaw.cs:4281,4319` — `sp_check_ExpenseType` + gate `PageName="ExpenseTypeName"`.

### Duplicate check only, no market-structure gate
- `HolidayDal.cs:45,67` (`sp_check_Holiday`), `LeaveDal.cs:18,37` (`sp_check_LeaveInfo`), `RouterSetup.cs:16,33` (`sp_check_RouterMaster`), `RSMSetupDal.cs` (ASM/UserRole/NSM/NSMHead/RSM/MIO — lines 48/122, 201, 374, 450, 1060, 1133/1207, each with its own `sp_check_*Info`), `AttendanceDAL.cs:18,47` (`sp_check_Employee_ShiftInfos`), `Setup2DAL.cs:1508` (`sp_check_DoctorDegree`) — and, identically, all nine `DoctorMaster_DAL` classes: `DoctorCategoryDal.cs:17,36`, `DoctorChamberDal.cs:19,38`, `DoctorDegreeDal.cs:28,53`, `DoctorDesignationDal.cs:47,66`, `DoctorSpecailDayDal.cs:19,37`, `DoctorSpecialityDal.cs:17,35`, `PatientTypeDal.cs:19,39`, `PrescriptionTypeDal.cs:65,85`.
- `RSMSetupDal.cs` — deactivation (`Inactive_ASMInfoById:928`, `Inactive_RSMInfoById:993`, `Inactive_MIOInfoById:1282`) calls `sp_Update_*ActiveStatus` directly with **no duplicate/in-use check at all** — inconsistent with the Setup2DAL/DoctorModule_DAL masters that gate deactivation.

### No duplicate-check proc at all (gap vs. sibling masters)
- `Library.DAL/DoctorModule_DAL/TourTypeDal.cs:159` (`SaveTourType`), `:414` (`SaveTourPurpose`) — straight update/insert, no `sp_check_*` call.
- `Library.DAL/DoctorVisit_DAL/DoctorVisitDAL.cs:193,382` — same gap, mirrored (`SaveTourType`/`SaveTourPurpose`).
- `Library.DAL/DoctorVisit_DAL/NoticeDal.cs:22` (`SaveNotice`) — no duplicate check; fans out unguarded per-row inserts to `sp_Save_Notice_MarketDetail`/`sp_Save_NoticeUserRoleDetail`.
- `Library.DAL/DoctorModule_DAL/Setup2DAL.cs:3713,3842` (`Save_Prescription`/`Save_ExpenseClaim`, duplicated in `SetupDAL.cs:4761,4876`) — no duplicate-check proc.
- `Library.DAL/DoctorModule_DAL/SeedDataDAL.cs:180` (`Save_TopSheetGenReportCodeInfo`) — plain insert-and-check-pk>0.

### Confirmed bugs
- **`Library.DAL/Thana_DAL/ThanaDal.cs:52`** — `SaveThanaInfo`'s duplicate-check call passes `thana.district_id` as the `@id` parameter to `sp_check_ThanaInfo` instead of `thana.ThanaId` — the duplicate check is keyed on the wrong column. `Save_DistictInfo:112` has the identical copy-paste bug against `sp_check_DistictInfo`. Neither method has a market-structure in-use gate either.
- **`Library.DAL/DoctorModule_DAL/ZoneSetupDAL.cs:216-231`** — `UpdateActiveStatus` builds parameters but the actual `UpdateData` proc call is commented out (`:231`); the method is a no-op that returns a default `ResultInfo` (`isSuccess` stays `false`) despite appearing to perform an update. `UpdateZoneInfo:251` is an unimplemented stub (`throw new NotImplementedException()`).
- **`Library.DAL/DoctorModule_DAL/GenericGroupDal.cs:68,82`** — sets `isValiCheck = true` on both the duplicate-hit branch and the insert-failure branch, where sibling classes use `isDuplicateCheck` — inconsistent flag usage; if the UI branches on flag type (as several `.aspx.cs` files in §2/§3 do), this class's failures may surface the wrong message.
- **`Library.DAL/DoctorModule_DAL/TherapueticGroupDal.cs:56-57,119-120`** — insert-success branch also sets `isValiCheck = true` alongside `isSuccess = true` — looks like copy-paste from the duplicate branch, likely unintentional.
- **`Library.DAL/DoctorModule_DAL/UserInfoDAL.cs:374-381,407-415`** — `SaveUserInfo` branches its duplicate-check proc on `UserTypeId == 6 || 7` (DA/DA-assistant) vs. all other types, using raw magic numbers `6`/`7` rather than named constants — same "type code as magic number" pattern as the `EmpInfoId=="496"` finding in §5.

### Notable side effects / risk flags (not "rules" but affect data integrity)
- `Setup2DAL.cs:1295` — `SaveMarket`, on reactivation, cascades the market's active state onto related customer records via `sp_Update_CustomerInfoForMarketData` — a cross-entity side effect triggered from what looks like a simple master-data save.
- `Setup2DAL.cs:1650-1653` and `Library.DAL/DoctorVisit_DAL/NoticeDal.cs:95-115,140-162` — image file writes (`File.WriteAllBytes`) with no path-traversal sanitization of the filename/id used to build the path; `Setup2DAL` swallows write failures in an empty `catch`, `NoticeDal` doesn't even catch them (raw exception propagates from an otherwise-successful save).
- `Library.DAL/DoctorModule_DAL/DepotWiseAreaSetupDal.cs:16-110` — client-side diffing of a many-to-many depot/area mapping via a linear `AllocatedOrNot` scan per incoming row (O(n·m)), not a stored-proc-side set operation — no dedup/limit guard beyond the scan itself.
- `Library.DAL/DoctorModule_DAL/UserInfoDAL.cs:98,169` — `IsOpeningBalanceExistsForFinancialYear` and `IsArchiveDatabaseAvailable` are genuine C#-level boolean gates (inline `COUNT(1)` SQL, not stored procs) backing the Financial-Year-Delete screen's rules in §2; `IsArchiveDatabaseAvailable` connects to the `"master"` database by literal string.
- `Library.DAL/DoctorModule_DAL/FinancialYearDeleteTableDAL.cs:141` — `ResolveDatabaseName` silently defaults a blank database name to `DataBase.SalesDB` on a **destructive delete** operation, with no confirmation that the caller intended the default.
- `Library.DAL/DoctorModule_DAL/HolidayDal.cs:40` and `SeedDataDAL.cs:242` — bypass the stored-proc convention entirely with inline ad-hoc SQL (`GetFinanCialyear`, `GetActiveDAList`).
- `Library.DAL/DoctorMaster_DAL/DoctorDegreeDal.cs:56,70` — reads `HttpContext.Current.Session["UserId"]` directly instead of taking it as a parameter like every sibling class in the folder — will `NullReferenceException` if ever called outside a live web request (e.g. a background job).
- `Library.DAL/DoctorMaster_DAL/DoctorInformationDal.cs` — despite the name, contains no doctor-master save/duplicate logic (3 lookup getters only) — actual doctor save logic lives in `Setup2DAL`/`SetupDAL` instead, a code-organization mismatch worth knowing about if searching for "where is Doctor Master saved."

### Not found in repo
Bodies of every `sp_check_*`, `sp_check_Vali_MarketStructure`, `sp_Save_*`, and `sp_Update_*`
procedure referenced above — all logic beyond the row-count/`pk>0` checks documented here lives in
SQL Server and could not be traced from this repo.

---

## What's explicitly not enforced

- **No page-level authorization beyond "is logged in," inconsistently applied even where menu permissions exist.** Menu visibility (per-user grants in `tblMainMenu`) is not a hard page-access check — see the repeated `UserPersmissionValidation`/permission-redirect pattern above, which exists on some pages but is dead/commented-out on others (e.g. Approval_UI's per-role field restriction, DoctorModule_UI's `RAdd`/`REdit` visibility). See [`docs/security.md`](../docs/security.md) and [`validation-rules.md`](validation-rules.md) §Authorization.
- **No password complexity rule for login** — only `ChangePassword.aspx.cs` enforces a strength regex; initial/admin-set passwords and the login comparison itself are plaintext with no visible complexity gate.
- **Several hard-coded user/employee bypasses embedded directly in code** (not config-driven): login name `"53323"` and `"51419"` (CustomerEntry/CustomerView field-lock bypass), login name `"21900"` (SubDeportStockFreez restricted-stock bypass), employee ID `"496"` (Approval_UI final-approval-status bypass). These are undocumented business rules that only exist as magic strings in `.aspx.cs` files.

## Rules defined only in the database (out of scope for this repo)

- Login credential verification happens via a direct plaintext SQL comparison, not a stored procedure — see [`docs/security.md`](../docs/security.md).
- Many "already exists"/limit-style checks likely also exist inside stored procedures whose T-SQL bodies are not fully checked into this repo (only a small number of `.sql`/`.txt` working copies exist at the repo root; the rest live only in the production database). Any rule not traceable to a `.sql` or `.cs` file in this repo is **Not Found**, not assumed absent — see §8 for the full list of `sp_check_*`/`sp_Save_*`/`sp_Update_*` procedures whose bodies are Not Found despite their C#-side callers being fully traced.
