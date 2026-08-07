# SKILL.md — ePharma Distribution & Field-Force Management System

## 1. Skill identity and purpose

**Skill name:** `epharma-pharma-distribution-system`

**Scope:** This skill governs all analysis, design, implementation, testing, and maintenance work
on the ePharma web application — a pharmaceutical order-to-cash, warehouse/stock, and field-force
(medical representative) management system, built on **ASP.NET Web Forms / .NET Framework 4.8 /
MS SQL Server** (see `CLAUDE.md` at the repo root for the authoritative tech-stack summary). The
system is **not** a green-field design — it is a live, in-production legacy codebase with ~700
`.aspx` pages, 569 database tables, and 1,866 stored procedures. This skill exists to keep an AI
coding agent from re-designing, "modernizing," or contradicting the system that actually exists.

**Target users and business context:** A pharmaceutical distribution company's internal staff —
sales admins, warehouse/depot staff, field-force hierarchy (MIO → ASM/AM → DZSM → RSM → NSM),
delivery agents (DA), doctors' offices (as counterparties, not direct system users), sub-depot/
distributor channel partners, HR/finance staff, and system administrators. The business functions
covered: order-to-cash (order → invoice → delivery confirmation → payment collection → return),
warehouse/depot/sub-depot stock movement, doctor/customer master data and visit tracking (DCR/DCP/
RX/CVR), promotional campaigns, employee leave/expense/attendance, sales targets (DWSP), and a
role-sequenced multi-level approval engine that most of the above routes through.

**In scope:**
- All modules under `Solution.Web` (`SInventory_UI`, `MasterSetup_UI`, `DoctorModule_UI`,
  `DoctorMaster_UI`, `DoctorVisit_UI`, `SubDepot_UI`, `Approval_UI`, `DWSP`, `Target_UI`,
  `Reports_UI`, `LeaveProcess_UI`, `UserPermission`, `Dashboard_UI`, etc. — full inventory in
  [`spec/modules.md`](spec/modules.md)).
- The corresponding `Library.BLL` / `Library.DAL` / `Library.DAO` / `Library.CrystalReports`
  projects.
- The SQL Server database `SalesDisDB_SMC_NEWDB` (schema, procedures, views, functions — full
  catalog in [`spec/database-spec.md`](spec/database-spec.md) and
  [`spec/database-tables.md`](spec/database-tables.md)).
- The `.asmx`/`.ashx`/inline `[WebMethod]` API surface (catalog in
  [`spec/api-spec.md`](spec/api-spec.md)).

**Out of scope:**
- The Flutter mobile app (`clickpharma_flutter`) — referenced but not present in this repository.
  Do not modify its behavior by inference; if a change must be coordinated with it, say so and stop.
- The separate SAP integration process — this repo only contains staging-table reconciliation
  screens (`SAP_Integration/`, `eProgram_UI/`), not the SAP-side connector.
- Any CI/CD pipeline execution — `.github/workflows/` does not exist yet; the pipeline is
  documented-but-unimplemented (see `docs/deployment.md`, `docs/CI-CD-README.md`). Do not assume
  CI runs on your changes.
- Inventing a modern architecture (DI container, ORM, microservices, REST API layer) as a
  side effect of an unrelated task. Raise it explicitly; never introduce it silently.

**Criticality statement:** This system moves real pharmaceutical inventory, real money (invoices,
payments, credit limits), and real employee compensation (targets, incentives, expense
reimbursement, leave balances). **Pharmaceutical compliance, auditability, and data accuracy are
critical.** At the same time, this skill must be honest that the *current* codebase does **not**
fully deliver on those properties yet (see §11) — plaintext passwords, hardcoded credential
bypasses, and near-total absence of foreign-key constraints are documented, current facts (see
`docs/security.md`, [`spec/database-spec.md`](spec/database-spec.md)). Do not describe the system
as more secure or more auditable than it is. Improving these properties is welcome work, but must
be done as explicit, scoped, reviewed changes — never as an incidental rewrite.

---

## 2. Source of truth and rule precedence

When any two sources conflict, resolve in this **strict order**:

1. **[`spec/business-rules.md`](spec/business-rules.md)** — the exhaustive, file:line-cited catalog
   of business rules as actually implemented. This is the primary source of truth for this skill.
   Every rule cited below is drawn from it; do not weaken, contradict, or silently override any
   rule documented there.
2. **Existing database schema** — [`spec/database-tables.md`](spec/database-tables.md) (569 tables,
   live-pulled column definitions) and [`spec/database/`](spec/database/) (full source for every
   procedure/function/view). Only **3 real foreign-key constraints** exist in the entire schema —
   do not assume referential integrity the database itself does not enforce.
3. **Existing application code and API contracts** — the actual `.aspx.cs`/`Library.BLL`/
   `Library.DAL` implementation and the endpoints catalogued in
   [`spec/api-spec.md`](spec/api-spec.md).
4. **Existing tests** — there are none (no MSTest/NUnit/xUnit project in `Solution.sln`; see
   `docs/testing.md`). Where a PowerShell CRUD-verification script exists
   (`test_crud_invoice_not_binding.ps1` is the template), treat it as the closest thing to a test
   contract for that feature.
5. **This SKILL.md.**
6. **Assumptions** — must be explicitly labeled `**Assumption:**` in your plan/output and must be
   the least-preferred basis for any decision that touches money, inventory, or permissions.

**Before making any change**, inspect the existing code path end-to-end (UI → BLL/Service → DAL/
Repository → stored procedure/table) rather than guessing from a table name or method name alone —
this codebase has multiple near-duplicate implementations of the same concept (e.g. six
`GetCustomer*` autocomplete variants, three parallel campaign-setup files, two coding eras — legacy
`DataTable`-returning and newer `Service`/`Repository`/typed-model). Match whichever style the file
you are editing already uses (see `docs/coding-standard.md`); do not introduce a third style.

**Preserve unrelated user changes.** Never revert, reformat, or "clean up" code outside the direct
scope of the requested change, even if it looks inconsistent with the rest of the codebase — this
system's inconsistency (two coding eras, six autocomplete variants, hardcoded bypasses) is a known,
documented characteristic, not something to silently fix as a drive-by.

---

## 3. Domain glossary

Confidence levels reproduced from [`knowledge/glossary.md`](knowledge/glossary.md), which is the
authoritative glossary for this repo — **none of these acronyms are defined in code comments or
documentation**; expansions are inferred from context and industry convention.

| Term | Meaning in this system | Confidence |
|---|---|---|
| **Company / organization** | `tblCompanyInfo`/`tblCompanyUnit` — this app is effectively single-tenant per deployment; no evidence of multi-organization/multi-tenant data isolation was found. **Assumption**: treat as single-org unless a specific `OrgId`/tenant column is found on the table in question. |
| **Product / SKU** | `tblProduct`, with `tblManufacturer`, `tblProductCategories`, `tblProductSQ` (brand), `tblProTypeBLL` (type), `tblStockUOM` (unit of measure), `tblUnitPrice`. Pack size is a `ProductSQ`/pack-size master, not a computed field. | High |
| **Batch, expiry date** | Tracked at the stock-line level (`tblCentralStore` and related stock tables carry batch/expiry columns) — full column list per table is in `database-tables.md`. Batch/expiry is required on Sales Return line entry (`SalesReturn.aspx.cs:243,254`). | High |
| **Depot / Warehouse** | `tblDCStore` = Distribution Center store; separately, warehouse stock (`tblWHStockInDetail`, `WarehouseStockOut.aspx.cs`) and Central Store (`tblCentralStore`) are distinct stock-holding tiers. **DC** = Distribution Center/Depot (high confidence); **WH** = Warehouse (high confidence). | High |
| **Sub-depot** | A separate distribution channel, `SubDepot_UI`/`SubDepot_BLL`, mirroring the DC stock-transfer/invoicing/payment logic (`tblSubDepotStore`, `tblSubDepotStockOutMaster`). Treat as a parallel, not subordinate, channel to the DC channel. | High |
| **Distributor / Stockist** | Not a distinctly-named entity in this codebase — the closest concepts are **DC (Distribution Center)** and **Sub-Depot**, both internal company-operated stock points, not third-party distributor/stockist businesses in the classic FMCG sense. **Open question**: if the business model includes true third-party distributors/stockists, this codebase does not appear to model them as a separate entity — flag before assuming DC/Sub-Depot map 1:1 to "distributor." |
| **Retailer / Pharmacy / Chemist** | `tblCustMaster` (customer master) is the general counterparty entity; `tblCustomerType`/`tblCustCategory` classify it. "Chemist Type" appears as a Campaign-setup filter field. **Assumption**: pharmacies/retailers are modeled as `tblCustMaster` rows with a specific `CustomerType`, not a separate table. | Medium |
| **Doctor / Institution** | `tblDoctorMaster`, with `DoctorCategory`, `DoctorSpeciality`, `DoctorDesignation`, `ChamberType`, `PatientType` master data (`DoctorMaster_UI`). | High |
| **Territory hierarchy** | `Group → Region → Area → Territory → Sub-Territory → Market` (geo/sales hierarchy), separately `Division → District → Thana` (Bangladesh administrative geography, `Thana_UI`). Do not conflate the two hierarchies — they serve different purposes (sales org vs. government geography) and are joined, not nested, in queries like `sp_Get_MarketList`. | High |
| **Route** | `tblRouteInformationMaster`/`RouteInformationDADetail` — a delivery route assigned to a DA, distinct from the sales territory hierarchy above. | High |
| **MIO** | Medical Information Officer — field-rep role, territory-scoped (`MIOInfo.TerritoryId`). | Medium |
| **ASM / AM** | Area Sales Manager / Area Manager — appear as parallel/adjacent role names in the RSM/ASM/NSM hierarchy; **not confirmed to be the same role** — treat as distinct until proven otherwise. | Low-Medium |
| **RSM, NSM** | Regional Sales Manager, National Sales Manager. | Medium |
| **DZSM** | Zone Sales Manager (exact expansion of "DZ" unclear). | Low |
| **DA — overloaded term, two unrelated meanings in this codebase** | **(1)** Delivery Agent/Distribution Agent — the party who confirms delivery and collects payment (`DAApprovalList`, `DA_SalesConfirmStatus`/`DA_PaymentCollection`/`DA_SalesReturn` columns on `tblInvoice`, `tblDAInfo`). **(2)** "Daily Allowance" as in TA/DA (Travel Allowance/Daily Allowance), an HR expense-claim term (`TADAMarketRuleConfig`, `TADAClaimEdit.aspx.cs`). **Always disambiguate from context (sales/delivery vs. HR/claim) before using "DA" in code, comments, or communication with stakeholders — this is a real, confirmed source of confusion in the existing codebase, not a hypothetical risk.** | High (both meanings independently confirmed) |
| **DIC** | Distribution-In-Charge — a supervisory role that re-approves DA sales-confirmation/payment/return actions on top of the DA's own action (`sp_UpdateDICApprovalStatus[_SalesReturn]`, `DICApprovalStatus` column, `DICCompanyUnitId` session/role scoping). | Medium |
| **Supervisor / regional manager / area manager / admin** | See MIO/ASM/RSM/NSM/DZSM above; "Admin" in this codebase specifically means `Session["RoleTypeID"] == "2"` — the one role that bypasses most permission checks. | High (for "Admin" = role 2) |
| **Visit, call, route plan, tour plan** | Tour Plan (`TourPurposeOtherSetup`, `TourPlannedApprovalList`) is the planned schedule; a Doctor Visit / DCR is the record of what actually happened. `DoctorVisit_UI` and `DoctorModule_UI` both touch this concept — do not assume one folder owns it exclusively. | High |
| **DCR** | Daily Call Report — a field rep's record of an actual doctor visit. | Medium-High |
| **DCP** | Doctor Call Programme/Plan — the *planned* visit, as distinct from DCR's *actual* record. | Medium |
| **CVP / CVR** | Appears paired with DCP (`DCPCVPApproval.aspx`) and as a report family (`CVRDoctoriseMonthlypt`). **Not Found** — no confident expansion. Possibly "Call/Visit Plan"/"Call/Visit Report" by analogy, but speculative — do not present this as confirmed. |
| **RX** | Prescription. | High |
| **Sales order, invoice, delivery, return, credit note** | `tblOrder` → `tblInvoice` → delivery challan (`tblChalanInfo`/`ChalanDetail`) → `tblReturnInvoice`/`tblInvoiceDetailReturn` for returns. **There is no distinct "credit note" entity found** — sales returns and invoice-value adjustments appear to be handled via the return/reject procedures directly on `tblInvoice`, not a separate credit-note document. **Open question** if the business requires a formal credit-note artifact distinct from a return record. |
| **Stock transfer, adjustment, opening stock** | Multiple parallel implementations per channel: `StockTransferOrder`/`DepoToWHTransfer`/`NewStockTransferDcToDc` (SInventory), `StockOutSubDepot`/`StockTransferDcToSubDepot` (SubDepot) — see §5.B. "Opening stock" appears as a distinct financial-year-boundary concept (`IsOpeningBalanceExistsForFinancialYear`), not a generic per-product field. |
| **Damaged / expired / quarantined stock** | `WhStockConditionFreeze`/`WhFreezeStockRelease` ("Condition & Damage Stock") — a `StockCondition` value of `'Restricted'` gates a return-to-DC flow, with `'Available'` as the normal state (confirmed in `sp_SAP_WHStockInApprove`, [`spec/workflow.md`](spec/workflow.md) §3.3). No distinct "quarantine" state name was found beyond `'Restricted'`. |
| **Chalan / Challan** | Delivery document/waybill accompanying a shipment (`tblChalanInfo`/`ChalanDetail`). | High |
| **Target, achievement, incentive** | Target = `DWSP`/`Target_UI` (monthly and product-wise, by zone/area/territory). Achievement = compared via BI views (`View_TargetvsAchivement_BIReport`). **No incentive calculation/payout module was found in this codebase** — `spec/business-rules.md` and `spec/modules.md` do not document one. **This is an open question, not an assumption**: if incentive calculation exists, it is either undocumented, lives entirely in stored procedures not read in this pass, or does not exist in this system yet. |
| **Attendance, leave, expense** | `AttendanceInfoList`/`AttendanceListApproval`, `Leave`/`LeaveConfig`/`LeaveApproveList` + a parallel `LeaveProcess_UI`, `ExpenseClaim`/`ExpenseType`/`ExpenseApprovalList`. Two parallel leave-application code paths exist (see §6, Leave lifecycle) — do not assume there is one leave system. |
| **Primary sales, secondary sales, collection, outstanding balance** | **Not explicitly named as "primary"/"secondary" sales anywhere in the code or schema found in this pass.** The order→invoice→delivery→payment-collection chain (§5.C) is the closest analog to "primary sales" (company → DC/customer); no distinct "secondary sales" (distributor → retailer) concept was found, consistent with the Distributor/Stockist open question above. Collection = `tblCustPayDetail`/`CustomerPay`. Outstanding balance is computed in BI views (`View_AccountsReceivable_BIReport`: delivered value minus paid value, zone-grouped), not stored as a running balance column. |

**Do not silently upgrade a "Not Found"/"Low confidence" glossary entry to "High" without a citable
source** (a stakeholder confirmation, a database comment found later, external documentation). If
you learn a confirmed expansion, update `knowledge/glossary.md` and cite the source.

---

## 4. Roles, permissions, and data access

**Ground truth first: this system's actual authorization model is much weaker than the role table
below might imply if read as a specification.** Read this whole section, especially the "Actual
enforcement" column, before treating any role as a hard security boundary.

### 4.1 Roles as they exist in code today

The system's only real role primitive is a numeric/string `RoleTypeId` stored in `Session`, resolved
at login from `tblUser`/role tables. There is **no formal RBAC framework** (no permission-matrix
table read consistently across the app) — most access control is a **per-page, copy-pasted**
`if (Session["UserRoleID"] != "2") { ... }` check (`UserPersmissionValidation()` pattern, present on
most but not all pages — see §7's authorization checklist). Menu visibility
(`tblMainMenu`/`tblMainMenuNew`, granted **per user**, not per role, via
`Solution.Web/CommonUI/UserPermission.aspx`) is a UI convenience, **not** access control — any
authenticated user who knows or guesses a URL can request it directly.

| Role (as used in this skill) | Nearest real-code equivalent | What they can do (as *coded*, not as *intended*) | Actual enforcement |
|---|---|---|---|
| **Super admin** | `RoleTypeID == "2"` ("Admin") | Bypasses `UserPersmissionValidation()` entirely on every page that has the check; sees unfiltered menu (`UserId == 1` is a further, separate superuser bypass in menu rendering). | Real, consistently coded, but **coarse** — "Admin" is a single flag, not a scoped permission set. |
| **Organization admin** | Same as Super admin in this single-org codebase (see glossary §3, "Company/organization") | No distinct tier found. | **Assumption**: not distinguished from Super admin in current code. |
| **Sales admin** | No distinct role ID confirmed; likely maps to specific `RoleTypeId` values used for Order/Invoice approval chains (`MenuId` 381 for Order — see [`spec/workflow.md`](spec/workflow.md) §2) | Approves orders/invoices per the routing chain if their role matches the pending step's `ToRoleTypeId`. | Routing-table-driven (real), but the routing chain's actual seeded role IDs live only in the database, not this repo — **Not Found** which specific `RoleTypeId` values this maps to without querying `tblApprovalMapMaster`. |
| **Distribution/warehouse manager** | No distinct role confirmed; warehouse/DC/sub-depot stock-approval screens (`WarehouseStockInApproval`, `DcStockOutApproval`, `SubDepotStockOutApproval`) gate on the generic role/session pattern, some additionally on menu-assignment (`SubDepotStockOutApproval.aspx.cs:49-75`). | Approves stock-in/stock-out requests; approval **immediately mutates physical stock quantities** (see §6, Stock workflows) — there is no "review only" tier. | Real but coarse; **no confirmed role-to-warehouse/DC scoping** beyond DIC's `DICCompanyUnitId` session-based dropdown auto-lock pattern seen on several pages. |
| **Finance/accounts user** | No distinct role confirmed. Customer-payment, invoice-limit, and deposit-slip screens have no finance-specific role gate beyond the generic pattern. | — | **Open question**: no finance-specific authorization tier was found; invoice/payment screens appear to be gated the same coarse way as everything else. |
| **HR/admin user** | No distinct role confirmed. Leave/attendance/expense approval screens use the same generic pattern. | — | Same coarse pattern. |
| **Regional manager, area manager, field-force supervisor, field-force representative** | MIO/ASM/RSM/NSM/DZSM role IDs (exact numeric mapping **Not Found** in this repo — lives in DB seed data) | Their position in the `tblApprovalMapMaster` chain determines what they can approve; their `Session["RoleTypeId"]` scopes which zone/territory/employee rows they see in several screens (data-scoping via DAL query filters, e.g. `DWSP` target screens). | Real for routing/scoping, but **no confirmed enumeration** of exact role→hierarchy-level mapping without a database query. Treat any specific role-ID claim as an assumption unless verified against `tblApprovalMapMaster`/`tbl_UserRoleInfo`. |
| **Distributor user** | Not modeled as a distinct external-user role in this codebase (see glossary open question on Distributor/Stockist). | — | **Not Found** — if distributor-portal access is required, it does not appear to exist yet. |
| **Read-only/auditor user** | **Not Found.** No role in this codebase is coded as read-only; every role that can see a screen also has access to whatever write actions that screen exposes, gated only by the coarse role check. | — | **This is a real gap, not an assumption** — flag explicitly if a task requires a genuine read-only role; it must be built, not configured. |

### 4.2 Confirmed hardcoded bypasses — treat as security defects, not features

These exist in the current codebase and **must not be extended, copied into new code, or relied
upon as intended behavior**. They are documented here so an agent recognizes them instead of
"fixing" them silently (any removal is a security-relevant change — see §14, ask before touching):

- `Session["LoginName"] == "53323"` / `"51419"` — re-enables all form fields in
  `CustomerEntry.aspx.cs`/`CustomerView.aspx.cs` regardless of role.
- `Session["LoginName"] == "21900"` — bypasses the `"Restricted"` stock-condition gate in
  `SubDeportStockFreez.aspx.cs`.
- `ToRoleTypeId == "5"` or `EmpInfoId == "496"` — hardcoded final-approver bypass across at least 6
  `Approval_UI` pages (skips the normal "Verified" intermediate step straight to "Accepted").

### 4.3 Financial/audit visibility

**No confirmed distinction exists** in the current code between "can see compensation/incentive
data" and "can see everything else that role's pages expose." Since there is no confirmed incentive
module (§3) and no confirmed audit-log table (§11), this entire sub-requirement from the general
pharma-SaaS template does **not have a current implementation to describe** — treat any claim about
who can see financial/compensation/audit data as **Not Found**, and if a task requires restricting
it, that access-control layer must be designed and built, not assumed to already exist.

### 4.4 What every new backend endpoint/screen must do (regardless of gaps above)

- Check `Session["UserId"]`/`Session["RoleTypeId"]` (or the equivalent for the newer
  `Service`/`Repository` style) **on the server**, not only by hiding a button — this repo already
  has the opposite failure mode (buttons hidden, underlying action still reachable) in multiple
  confirmed places; do not add another instance.
- **Do not** add a new hardcoded login-name/employee-ID bypass under any circumstance. If a
  "super-approver" concept is genuinely required, it must be a data-driven role/flag, not a literal
  string compared against `Session["LoginName"]`.
- Row-level/territory scoping (where the feature needs it) must be enforced in the DAL/stored
  procedure query, not just in which rows the UI chooses to render.

---

## 5. Complete functional modules and operations

This section maps the requested generic module list onto what **actually exists** in this codebase.
Where a sub-capability from the general template has no confirmed implementation, it is marked
`Not Found` rather than described as if built.

### A. Organization and master data

- **Multi-organization**: not confirmed (§3). Single deployment, single `tblCompanyInfo`/
  `tblCompanyUnit` scope assumed.
- **Master data screens** follow a consistent **List + Add/Edit pattern** across dozens of `*_UI`
  folders (`*Entry.aspx` + `*View.aspx`, backed by matching `*BLL`/`*DAL`) — see
  [`spec/ui-spec.md`](spec/ui-spec.md). Covers: user, employee, territory (Group/Region/Area/
  Territory/Sub-Territory/Market), route, customer, doctor, product (+ manufacturer/category/brand/
  pack-size/UOM/unit-price), target, expense type, and campaign master data.
- **Import/export**: Excel import exists for ~16 screens (customer, payment, order list, market
  info, target, etc.) via `asp:FileUpload` — see [`spec/validation-rules.md`](spec/validation-rules.md)
  §3 for the confirmed, systemic weaknesses in this path (file saved **before** validation, no size
  limit, no filename sanitization). **Do not copy this pattern into new upload code.** Excel export
  exists via GridView-to-HTML/EPPlus/ClosedXML rendering (see §5.H).
- **Activation/deactivation**: the dominant pattern is an `IsActive` flag plus a
  `sp_check_Vali_MarketStructure`-style "in-use, can't deactivate" gate (present on ~6 confirmed
  master types — Designation, Department, Group, Zone, Area/Territory/SubTerritory/Market, Expense
  Type — **absent** on others, e.g. `RSMSetupDal.cs`'s `Inactive_*ById` methods call the status
  update directly with **no in-use check at all**). Check the specific entity's DAL class before
  assuming deactivation is safe.
- **Duplicate detection**: the dominant pattern is `Has<Field>Name`/`sp_check_<Entity>` — a
  name/code uniqueness check before insert. **Confirmed disabled or buggy on several entities** —
  see §7's validation checklist. **No merge capability exists anywhere in this codebase** — treat
  "merge duplicate records" as a feature to be built from scratch, not extended.

### B. Product, inventory, and warehouse

Three parallel stock tiers, each with its **own** transfer/adjustment/freeze-release/stock-out
screens rather than a shared engine — do not assume a change to one tier's logic applies to another:

1. **Central/Warehouse** (`SInventory_UI`): `WarehouseStockIn[Edit]`, `WarehouseStockInApproval`,
   `WarehouseStockOut`, `WhStockConditionFreeze`/`WhFreezeStockRelease`.
2. **DC (Distribution Center)** (`SInventory_UI`): `StockTransferOrder`, `DepoToWHTransfer`,
   `NewStockTransferDcToDc`, `OrderRequisitionCreation`/`IssueRequisitionProducts`,
   `DcStockOutApproval`.
3. **Sub-Depot** (`SubDepot_UI`): `StockOutSubDepot`, `StockTransferDcToSubDepot`,
   `StockTransferSubDepottoDc`, `SubDepotStockAdjustmentVoucher`, `SubDepotStockOutApproval`.

Confirmed rules (full citations in `spec/business-rules.md` §1/§4):
- **Negative-stock prevention** exists as a UI-level qty-vs-current-stock check on most screens
  (blocks by resetting the input field), but **enforcement strength varies**: some checks correctly
  block (Warehouse Stock Out, Sample conversions), one is a documented **weak-enforcement bug**
  (`SubDeportStockFreez.aspx.cs`, 4 occurrences — the "exceeded" branch and the "proceed with save"
  branch are sibling `if`s, not `if`/`else`, so the block is not structurally guaranteed), and one
  screen (`StockOutSubDepot.aspx.cs`) has **no server-side validation on the live save path at all**
  (`Validation()` exists but is dead code).
- **Stock-in approval physically moves stock inline**: `sp_SAP_WHStockInApprove` inserts new
  `tblCentralStore` rows on approval (idempotency-guarded against double-posting via
  `MigoDetailID`), and records the approver as the literal string `'Auto Approve'` regardless of who
  clicked approve — a confirmed audit gap (see [`spec/workflow.md`](spec/workflow.md) §3.3).
- **Stock-out approval physically decrements stock inline**: `sp_UD_DcStockOutApproval`/
  `sp_UD_SubDcStockOutApproval` cursor detail rows and decrement `StockQty` at approval time, not
  request time.
- **FEFO/FIFO**: **Not Found** as an enforced rule anywhere in the scanned code — batch/expiry is
  captured on stock lines but no code was found that picks the earliest-expiry batch automatically.
  Treat any FEFO/FIFO requirement as new functionality to design, not an existing rule to preserve.
- **Reorder level / low-stock alerts**: **Not Found** as an implemented feature (no threshold
  column or alert-generation code confirmed in this pass).
- **Stock ledger/reconciliation**: no single unified stock-ledger table was confirmed; each tier's
  stock table (`tblDCStore`, `tblCentralStore`, `tblSubDepotStore`, etc.) is its own ledger. Cross-
  tier reconciliation, if needed, must be built by joining these, not assumed to exist as a report.

### C. Sales and order management

The order-to-cash lifecycle (full state detail in [`spec/workflow.md`](spec/workflow.md) §4):

```
Order (tblOrder) → chain approval (Approval_UI/OrderApproveList, MenuId 381)
  → Invoice generated (tblInvoice, IsInvoice flag on tblOrder flips)
  → DA Sales Confirmation (tblInvoice.DA_SalesConfirmStatus) + DIC re-approval layer
  → Delivery Challan (tblChalanInfo/ChalanDetail)
  → Payment Collection (tblInvoice.DA_PaymentCollection + tblCustPayDetail/CustomerPay)
  → [optional] Sales Return (tblInvoice.DA_SalesReturn) + DIC re-approval
```

- **Customer onboarding**: `CustMasterEntry`/`CustMasterEdit` — long required-field chain (name,
  address, mobile, representative, region, DC, FE, area, MIO, market, category, code, contact).
  **Confirmed weaker on Edit than Entry** (Payment Type/Region checks commented out on Edit).
  Mobile number format is checked (11 digits); NID length check is present but **commented out**.
- **Price lists / territory-customer pricing**: `QuotedPriceSetup` (Description/Policy/date-range
  required); campaign-driven discounts/free-goods/schemes via the 6 near-duplicate
  `CampaignSetup*` screens (product/qty/amount rules vary by campaign type).
- **Credit limit / invoice-value gate**: **two parallel, not-obviously-unified implementations** —
  (1) `CustomerInvoiceLimitService` (the one cleanly-validated newer-style service in this
  codebase — default limit 50,000 if no customer-specific config exists, full checklist in §7), and
  (2) a separate UI-level check in `InvoiceGenerationRestricted.aspx.cs:436-439` (also a 50,000
  threshold, with an override checkbox) that is **not confirmed to call the same service**. **Do
  not assume these are the same gate** — verify the call chain before changing either one, and flag
  to stakeholders that a single invoice-value limit may currently be enforced twice, inconsistently,
  or bypassably depending on which screen is used.
- **Order status lifecycle**: `tblOrder.ActionStatus` — `NULL`/unset → `'1'` (Verified, mid-chain)
  → `'2'` (Accepted) or `'3'` (Rejected) → `'0'` (Posted, once converted to invoice). See
  [`spec/workflow.md`](spec/workflow.md) §1.3-§4 for the full state-advance algorithm, traced from
  the actual `sp_webapi_SaveOrderAppLog` stored procedure body.
- **Duplicate-order guards**: present on Invoice Creation (`"Order Information already Exists !!"`)
  but the equivalent check is **commented out (dead) on Sales Return** — a confirmed asymmetry, not
  a design choice to preserve if extending Sales Return.
- **Payment/collection**: `CustomerPayment.aspx.cs` enforces `(paid + previously paid) ≤ invoice
  amount`. Its own save path (`CustPaymentBLL.cs`/`CustPaymentDAL.cs`) was hardened 2026-08-06 —
  per-row save/failure is now tracked independently instead of one shared flag overwritten per
  loop iteration, real DAL insert results are propagated instead of discarding them and always
  returning `true`, and `CustPayId`/`CustPayDetailId` generation moved off the unlocked
  `ClsPrimaryKeyFind` `MAX()+1` pattern into a locked transaction (see §7/§8 below and
  `spec/business-rules.md`'s Customer Payment section for the full citation). A **separate,
  parallel implementation** used by other pages — `dadtlsCustPaymentBLL.cs` — still has the
  original **weak duplicate-payment guard** (existence-check branch is an empty block, always
  returns `true`, so a duplicate payment can silently fail to save with zero user feedback); this
  was **not** touched by the 2026-08-06 fix and remains open. `PaymentPartial.aspx.cs` and
  `CustomerPayment.aspx.cs`'s save path are now the two hardened references — a transactional,
  row-locked re-check inside the DB transaction — use one of them as the template if asked to
  harden a similar path elsewhere.
- **Credit note**: **Not Found** as a distinct entity (§3).

### D. Distribution management

As established in §3/§A, this codebase does not model third-party distributors/stockists as a
distinct entity — the closest structures are the **DC** and **Sub-Depot** channels (§B), both
internal. If a task requires true external-distributor onboarding, distributor-scoped stock,
distributor secondary-sales upload, or distributor performance reporting as **separate from**
DC/Sub-Depot, treat this as new functionality requiring explicit design, not an extension of an
existing distributor module — **none exists**.

### E. Field-force management

- **Employee profile/lifecycle**: `EmployeeSetup`/`EmployeeSetupEdit`/`EmployeeSetupForNewJoiner`
  (three near-identical files, same validation pattern — NID 17 digits, contact numbers 11 digits,
  duplicate employee-code check). Territory/reporting-manager assignment via `FieldForce.aspx.cs`'s
  RSM/ASM/MIO/NSM setup methods.
- **Route/tour plan**: `TourPurposeOtherSetup`/`TourPurposeSetup[New]` define tour purposes;
  `TourPlannedApprovalList`/`VisitPlannedApprovalList` approve planned visits — confirmed **bulk-
  approval bug**: when multiple rows are approved/rejected together, the result variable is
  overwritten each loop iteration, so only the **last** row's outcome is shown to the user; earlier
  rows' failures are silently swallowed. Do not copy this loop pattern into new bulk-action code.
- **Doctor/customer visits**: DCR (actual) vs. DCP (planned) — see glossary. `DoctorVisit_UI`'s
  `[WebMethod]`s are pure DAL passthroughs with **no inline visit-target/call-limit validation found
  in code-behind** — any such limit, if required, is either enforced in a stored procedure not read
  in this pass, or does not exist yet.
- **Check-in/check-out, GPS, photo**: **Not confirmed as implemented in this repo's scanned
  screens.** The Flutter mobile app (out of scope, §1) is the more likely home for field capture —
  do not assume this web codebase has a geolocation-capture UI unless you find it directly.
- **Offline-first sync**: **Not Found** in this repo — this is a web application; any offline
  behavior would live in the (out-of-scope) mobile app.
- **Attendance/leave**: `AttendanceInfoList`/`AttendanceListApproval` (approval step-advance logic:
  `Step = InStep+1`, `Status` = Accepted/Verified/Rejected, same `ToRoleTypeId=="5"` bypass pattern
  as Approval_UI). **Two parallel leave systems exist** — `DoctorModule_UI/Leave.aspx.cs`+
  `LeaveConfig.aspx.cs` (DAL passthrough, no day-quota/overlap validation found) **and** a separate
  `LeaveProcess_UI` (`LeaveApplicationEntry.aspx.cs` is an **empty stub** — all validation is
  client-side markup only; `LeaveApplicationCode.aspx.cs`'s `[WebMethod]`s have **no server-side
  validation**). The actual multi-step leave **approval chain** with a confirmed **balance-ledger
  side effect** (deduct on final Accept, refund on post-Accept Reject — with a confirmed ledger
  asymmetry, the refund is not logged the same way the deduction is) is documented in
  [`spec/workflow.md`](spec/workflow.md) §5 — that is the authoritative leave-approval reference,
  not either of the two UI entry points above.
- **Expense claims**: `ExpenseClaim`/`ExpenseType`/`ExpenseApprovalList` — receipt upload path not
  independently confirmed in this pass; approval follows the standard chain pattern.
- **Reporting family**: DCR/DCP/CVR/RX monthly reports in `Reports_UI`, each a plain GridView (no
  Crystal Report) with Excel export — see [`spec/reports.md`](spec/reports.md) §4/§6.

### F. Targets, performance, incentives

- **Target assignment**: `DWSP` (national/zone/area/territory level) and `Target_UI` (monthly,
  product-wise). DWSP's row-sum-vs-master-target check is a confirmed **"exceed" cap, not an
  equality enforcement** despite its message text (`"Amount must be equal with target amount"`) —
  a total *less than* the master target passes silently and is never forced to reconcile before
  save. Do not "fix" this by making it an equality check without confirming that's actually the
  desired business behavior first (raise it, don't silently change enforcement semantics).
- **Target Setup's own duplicate-period gate is inverted/weak**: `MonthlyTarget.aspx.cs` only
  proceeds with an update if **no** conflicting year/month record exists; if one does, it silently
  no-ops with no "already exists" message shown to the user.
- **Achievement**: computed via BI views (`View_TargetvsAchivement_BIReport` and year-pinned
  variants `View_TargetvsAchivment_2023to2024`), not a live application-layer calculation —
  achievement figures are as fresh as the view's underlying query, not real-time unless the view
  itself is queried live.
- **Primary vs. secondary sales logic**: **Not Found** (§3, §D).
- **Incentive slab/calculation/payout**: **Not Found anywhere in this codebase.** This is the most
  significant gap versus the general template's expectations — do not build incentive features on
  an assumed existing foundation; there is none.
- **Historical snapshots to prevent recalculation issues**: the year-pinned BI views
  (`View_EpharmaSales2022April`/`2023`/`2024`, `View_TargetvsAchivment_2023to2024`) are the closest
  existing pattern — a "clone a view per period" approach rather than a proper point-in-time
  snapshot table. If asked to add historical-snapshot protection to targets/achievement, this
  existing pattern is what you'd be extending or replacing, not a new mechanism to invent from
  nothing.

### G. HR and workflow approvals

All approval workflows in this system funnel through the **same generic routing engine** — see §6
for the full state-machine detail. Do not build a bespoke approval mechanism for a new entity type
without first checking whether it should plug into `tblApprovalMapMaster`/`tblApprovalMapDetail`
and the `sp_*SaveXAppLog` pattern instead.

- **Immutable approval history**: the append-only `tblXApprovalLog` tables (one per entity type)
  are the closest thing to this requirement — **but** the DA-side invoice reject procedures
  (`sp_RejectInvoiceDASalesConfirmStatus`/`PaymentCollection`/`SalesReturn`) are a **confirmed
  exception**: they hard-**delete** the app-log rows on reject rather than appending a rejected-
  status row, the only place in this system observed to do so. This means the invoice DA-track
  approval history is **not** fully immutable/auditable as currently implemented — flag this if a
  task touches DA sales-confirmation/payment/return rejection.
- **Delegation/escalation**: **Not Found** as a distinct feature — the hardcoded `ToRoleTypeId=="5"`
  / `EmpInfoId=="496"` bypass (§4.2) is the closest existing behavior, and it is a defect, not a
  designed escalation feature.

### H. Reports, dashboards, and exports

Full catalog in [`spec/reports.md`](spec/reports.md). Two independent, not-unified mechanisms:

- **Mechanism A — Crystal Reports**: 94 viewer pages under `SInventory_RPTVIEW`, `.rpt` templates
  in `Library.CrystalReports/`, fed an in-memory `DataSet`.
- **Mechanism B — GridView + Excel export**: plain `GridView` bound to a `DataTable`, manual C#
  footer-total aggregation, HTML-to-Excel rendering (not a binary XLSX library) for the 14
  `SInventory_UI` report screens and all 16 `Reports_UI` field-force reports.
- **BI-only views**: several of the 58 database views (`View_*_BIReport`) have **no confirmed
  application-layer consumer** — they exist purely for an external BI tool to query directly.
- **Timezone-aware date filtering**: **not independently confirmed** as a deliberate design in this
  pass — treat server/database local time as the operative timezone unless you find explicit
  timezone-conversion code, and flag if the business operates across timezones.
- **Access restriction for sensitive reports**: subject to the same coarse role-check gaps as
  everything else in §4 — do not assume a report is access-restricted just because it shows
  sensitive data; verify the specific page's gate.

### I. Notifications and alerts

- **Email**: real and partially active. Several `Campaign*.aspx.cs` files and a few Order/Transfer
  screens send via `smtp.gmail.com`, using a mix of hardcoded shared credentials, a weak hardcoded
  shared credential, and per-user session-stored Gmail app passwords (see
  [`spec/integrations.md`](spec/integrations.md) §2). **Do not add new notification credentials
  using any of these three patterns** — none of them is a template to follow; all are flagged
  security concerns. Some Campaign files have the send call commented out (inert).
- **SMS, push notifications**: **Not Found** in this codebase.
- **In-app notification center / preferences / retry-with-dedup**: **Not Found** as a generic
  system — individual screens show `showMessageBox(...)`-style alerts synchronously on the same
  request, not an async notification/alert pipeline.
- **Alert triggers (low stock, expiry, overdue payment, missed visit, target)**: **Not Found** as
  implemented alerting — the underlying data (stock levels, expiry dates, payment due, visit
  records, target vs. achievement) exists and could be queried for such alerts, but no
  scheduled/triggered alert-generation code was found in this pass.

---

## 6. Required workflow/state machines

The **generic approval-routing engine** (fully reverse-engineered from actual stored-procedure
bodies in [`spec/workflow.md`](spec/workflow.md) §1 — read that section before modifying any
approval-adjacent code) governs Sales Order, Customer/Doctor master changes, DA claims, DCP/CVP,
DCR, Expense claims, Leave, Mileage claims, RX, and Tour Plan. Do not treat these as 10 independent
mechanisms; they share one algorithm:

1. **Valid states** (varies slightly per entity, see [`spec/workflow.md`](spec/workflow.md) §2
   table for the exact set per entity): `(unset)` → `Verified` (mid-chain) → `Accepted` (chain
   complete) → `Rejected` (terminal, any step). Order additionally has a `Posted` (`'0'`) state
   reached after Accepted, once converted to an invoice.
2. **Allowed transitions**: forward-only along the `tblApprovalMapMaster`/`Detail` chain for the
   record's **originating submitter's role** (the chain is keyed off who *submitted*, not who is
   *currently* approving) — see [`spec/workflow.md`](spec/workflow.md) §1.3 for the exact algorithm.
   Reject is a terminal transition from any step; there is no resume-after-reject in the routing
   proc itself (some screens allow a fresh resubmission, which restarts the chain, e.g. the DA
   invoice-reject procs delete the log entirely).
3. **Who can trigger**: the role at the record's current `ToRoleTypeId` step — **or** the hardcoded
   bypass roles/employee (§4.2), which is a defect to be aware of, not a rule to design around.
4. **What becomes immutable after finalization**: **This is a genuine gap in the current system.**
   No confirmed "locked after Accepted" enforcement was found for most entities beyond the routing
   proc itself refusing to advance past the final step. `SubDepotStockAdjustmentVoucherView.aspx.cs`
   is the one confirmed exception — a voucher in `"Approved"` status **cannot be deleted**
   (properly enforced). Do not assume other entities have equivalent post-approval protection
   unless you find the specific check.
5. **Reversal/cancellation**: exists for the DA invoice sub-statuses only (§6.G above, via delete-
   and-resubmit, not a clean reversal) and for Leave (balance refund on post-Accept reject, with the
   confirmed ledger-logging asymmetry). No general-purpose reversal mechanism exists.
6. **Audit-log requirements**: append-only `tblXApprovalLog` per entity, **except** the DA invoice
   reject procedures which delete rather than append (§6.G) — flag any change to those three procs
   as audit-sensitive.

**Stock workflows** (§5.B) are a **different, simpler shape** — no routing chain, a single
`Status` column on the master record, and **approval directly and immediately mutates physical
stock quantities in the same stored-procedure call** (decrement on stock-out approval, insert-as-
received on stock-in approval). There is no "approved but not yet posted" intermediate state for
stock movements — approval *is* the posting event.

Entities from the general template not covered above:
- **Payment/collection**: no formal state machine found beyond the amount-reconciliation checks in
  §5.C; treated as a single-step recorded transaction, not a multi-state workflow.
- **User/employee lifecycle**: Active/Inactive via the `IsActive` flag pattern (§5.A), with
  inconsistent in-use-before-deactivate protection across entity types (§5.A) — there is no
  confirmed "offboarding" workflow beyond flipping this flag.

---

## 7. Business rules and validation

This is a **checklist of what the current system actually does**, organized by the template's
categories, so a new feature can be checked for consistency (or a gap can be knowingly, explicitly
closed rather than silently left inconsistent).

- **Mandatory fields**: enforced almost exclusively via code-behind `Validation()`-style methods
  checking `.Text == ""` and calling `showMessageBox(...)` — **not** via ASP.NET
  `RequiredFieldValidator` controls (only 4 files in the whole 700-page app use any ASP.NET
  validator control at all — see [`spec/validation-rules.md`](spec/validation-rules.md) §1). New
  required-field checks should follow the existing code-behind pattern for the file's coding era
  (legacy `Validation()` vs. newer `Service` early-return), not introduce ASP.NET validator
  controls as a third pattern.
- **Unique constraints**: `Has<Field>Name`/`sp_check_<Entity>` pattern (§5.A) — **confirm the
  specific entity's check is not one of the confirmed-disabled ones** (`UserBLL.cs` email/login/
  username uniqueness all commented out; `StockConditionFreezeBLL.cs` duplicate check commented
  out; `ExcelUpForOrderListBLL.cs` duplicate-company check commented out) before assuming
  uniqueness is enforced.
- **Date restrictions**: From/To date-order checks exist on some screens (`DAExpenseClaimList`:
  `"From Date cannot be greater than To Date!"`) but are **confirmed absent** on others where you
  might expect them (Training Setup has no From/To order check). Do not assume date-order
  validation exists on a screen without checking that specific screen.
- **Numeric precision/rounding, currency/tax handling**: no centralized money-formatting/rounding
  utility was confirmed; `decimal(18,2)` is the dominant SQL column type for money fields (see
  [`spec/database-tables.md`](spec/database-tables.md)) — match this precision in any new money
  column or calculation; do not introduce `float`/`double` for money.
- **Batch/expiry restrictions**: required on Sales Return line entry; no confirmed expiry-date-must-
  be-in-future (or similar) validation was found — treat as an open question if the business
  requires it.
- **Stock availability / negative-stock prevention**: see §5.B — **inconsistently enforced**, with
  one confirmed weak-enforcement bug (`SubDeportStockFreez.aspx.cs`) and one confirmed complete
  bypass (`StockOutSubDepot.aspx.cs`). Do not assume a stock-out screen you haven't personally
  checked correctly prevents negative stock.
- **Credit limit rules**: two parallel implementations, not confirmed unified (§5.C) — check both
  before modifying either.
- **Territory assignment restrictions**: role-based zone/territory dropdown scoping exists on
  target-setup screens (`Session["RoleTypeId"]`-driven) — this is **data-scoping** (which options
  appear in a dropdown), not a hard server-side block on submitting a value outside that scope;
  don't conflate the two when reasoning about what's actually enforced.
- **Customer/distributor status restrictions**: `IsActive`-flag pattern; no confirmed block on
  creating orders for an inactive customer was found in this pass — flag as an open question if
  this matters to the task at hand.
- **Duplicate visit / duplicate order prevention**: duplicate-order guard exists on Invoice
  Creation, confirmed **absent (dead code)** on Sales Return (§5.C). No duplicate-visit prevention
  was confirmed for DCR/DCP entry.
- **Backdated entry policy**: **Not Found** as an explicit rule anywhere scanned — no code was
  found rejecting a past-dated transaction entry. Treat as unconstrained unless proven otherwise.
- **Locked accounting period policy**: **Not Found** as a generic mechanism. The closest analog is
  the Financial-Year Archive/Delete screen's "only whitelisted tables deletable" gate
  (`FinancialYearDeleteTableEntry.aspx.cs`), which is about **data purge**, not period-locking
  against new transactions.
- **Deletion vs. soft-delete policy**: **inconsistent across the codebase.** Some entities use an
  `IsActive` soft-delete; some tables have literal `*Del`/`*DeleteArchive` variants (e.g.
  `tblOrderDel`, `tblOrderDeleteArchive`, `tblOrderDetailDel`, `tblOrderDetailDeleteArchive` — see
  [`spec/database-tables.md`](spec/database-tables.md)) implying a delete-then-archive pattern for
  at least Orders; other entities appear to support hard delete directly (e.g. several
  `DoctorMaster_UI` "Delete_*" `[WebMethod]`s, two of which are themselves confirmed disabled —
  `DoctorCategoryView.aspx.cs:39`, `PrescriptionTypeView.aspx.cs:44`). **Match the specific
  entity's existing pattern**; do not introduce hard-delete for an entity that currently uses
  soft-delete/archive, or vice versa, without an explicit decision.
- **Historical data preservation**: only as strong as the specific entity's pattern above — no
  system-wide guarantee. Financial-Year Archive/Delete is a **destructive** operation (`sp_Delete
  Archive*Data`) gated only by a whitelist of table names, with a confirmed **silent default-
  database fallback** if the target database name is blank (`ResolveDatabaseName` in
  `FinancialYearDeleteTableDAL.cs:141`) — treat any change to this screen as high-risk.
- **Concurrency / double-submission prevention**: **two confirmed properly-hardened examples** —
  `PaymentPartial.aspx.cs` (row-locked, transactional re-check), and, since 2026-08-06,
  `CustomerPayment.aspx.cs`'s save path (`CustPaymentDAL.cs`'s `SaveCustPayment`/`SaveCustDetail` —
  `CustPayId`/`CustPayDetailId` generated inside a `WITH (UPDLOCK, HOLDLOCK)`-guarded transaction
  instead of the unlocked `ClsPrimaryKeyFind` `MAX()+1` read). These are the **exception, not
  the rule** — most save paths in this codebase have no optimistic/pessimistic concurrency control
  and no double-submit guard beyond a client-side disabled-button pattern (not independently
  verified as present everywhere). If a task requires concurrency-safety, use one of these two
  patterns as the template, and do not assume other "duplicate check" code in this codebase is
  equivalently safe under concurrent requests — most are a pre-check query with a race window
  before the insert.
- **Idempotency**: confirmed present for stock-in posting (`sp_SAP_WHStockInApprove`'s
  `MigoDetailID`-based guard against double-posting) and for Order approval submission (duplicate-
  log-row count guard). **Not confirmed** as a general pattern elsewhere — do not assume any given
  save/approve action is idempotent under retry unless you've checked that specific proc.

---

## 8. Data model guidance

The live schema is fully catalogued — **use it directly rather than re-deriving entity lists**:

- **Full column-level schema for all 569 tables**: [`spec/database-tables.md`](spec/database-tables.md).
- **Full source for all 1,866 procedures / 41 functions / 58 views**:
  [`spec/database/`](spec/database/) (`procs/`, `functions/`, `views/` — one file per object).
- **Index/overview + object counts**: [`spec/database-spec.md`](spec/database-spec.md).

Key structural facts an agent must internalize before adding to or extending the schema:

- **Only 3 real foreign-key constraints exist across all 569 tables.** Every other relationship
  (customer↔invoice, product↔stock, employee↔territory, etc.) is enforced only in application/
  stored-procedure code, if at all. **Do not assume the database will catch an orphaned reference**
  — application-layer validation is the only safety net that currently exists for referential
  integrity, and it is confirmed inconsistent (§7).
- **Primary-key strategy is split, not uniform**: 473 of 569 tables have a PK constraint, 417 have
  an `IDENTITY` column. Roughly 150 tables have **no PK constraint at all**, and ~55 rely on
  `Library.DAL/InternalCls/ClsPrimaryKeyFind.cs`'s `SELECT MAX(column)+1` pattern (string-built
  table/column name — see `docs/security.md`) instead of `IDENTITY`, which is a **known
  concurrency/race-condition risk** under simultaneous writes. `tblCustomerPay`/`tblCustPayDetail`
  (via `CustPaymentDAL.cs`'s `SaveCustPayment`/`SaveCustDetail`) were moved off this shared
  unlocked helper on 2026-08-06, onto an inline `MAX()+1` read guarded by
  `WITH (UPDLOCK, HOLDLOCK)` inside the same transaction as the insert — a reference pattern if
  asked to harden another specific table's write path without a codebase-wide `ClsPrimaryKeyFind`
  rewrite (that class is still shared by ~53 other tables and was deliberately left unchanged —
  out of scope for a single-page fix). When adding a new table, prefer an `IDENTITY` primary key;
  do not introduce a new `MAX()+1` table unless matching an existing sibling table's established
  pattern exactly.
- **No tenant/organization-ownership column pattern was confirmed** — consistent with the single-
  org assumption in §3/§A. Do not add a speculative `OrgId`/`TenantId` column to new tables unless
  the task explicitly requires multi-tenancy; match the existing single-org shape.
- **No generic audit-log table was found.** `CreateBy`/`CreateDate`/`UpdateBy`/`UpdateDate`-style
  columns exist on many (not all) tables, stamped from `Session["UserId"]`/`LoginName`, but there
  is no before/after-value change-history table. If a task requires field-level audit history, this
  must be designed and built — there is no existing table to extend.
- **Money**: `decimal(18,2)` is standard (§7). **Quantity**: typically `int` or `decimal` depending
  on the table — check the specific column, some quantity fields are `decimal` to support fractional
  units. **Dates**: `datetime`, not `datetimeoffset` — no confirmed timezone-aware date storage
  anywhere in the schema; treat all stored dates/times as local/unzoned unless proven otherwise.
  **Geolocation**: no confirmed lat/long columns found in the tables scanned in this pass — if
  geolocation storage is required, it does not appear to exist yet in this schema.
- **Naming convention**: tables prefixed `tbl` (occasionally `Employee_*`/`tbl_*` for a minority of
  newer/HR tables); stored procedures prefixed `sp_`, further prefixed by rough purpose
  (`sp_Get*`/`sp_GET*` read, `sp_Save*`/`sp_Update*`/`sp_I_*`/`sp_UD_*` write, `sp_check*` existence/
  duplicate check, `sp_Delete*`/`sp_DEL*` delete, `sp_Webapi*`/`sp_SalesAPI*` mobile-facing,
  `sp_SAP*` SAP staging integration) — match the relevant prefix family when adding a new procedure
  for an existing entity, per [`spec/database-spec.md`](spec/database-spec.md)'s full grouped
  catalog.
- **Prefer stored procedures for new data access**, consistent with the rest of the codebase — but
  Dapper against parameterized raw SQL is an accepted pattern in newer code
  (`SInventoryWebService.cs`, `CustomerInvoiceLimitService.cs`'s repository) when a stored proc
  would be overkill (per `CLAUDE.md`). **Never build SQL by string concatenation of a variable** —
  this is a confirmed, extensive existing problem (44+ files, cataloged in `docs/security.md`), not
  a pattern to extend.

---

## 9. API and frontend implementation standards

This is a **Web Forms** application (`.aspx`/`.aspx.cs`, `.ascx`), not MVC/Razor/SPA — do not
introduce a competing UI framework as a side effect of a feature request.

- **API surface**: fragmented across one `.asmx` service (`SInventoryWebService`, ~20 autocomplete
  methods), three `.ashx` handlers, and **459 inline `[WebMethod]` page methods across 116 files**
  — see [`spec/api-spec.md`](spec/api-spec.md) for the full catalog. There is **no**
  `ApiController`/Web API framework, no consolidated request/response envelope (existing methods
  return raw `string[]`, delimited-string JSON blobs, `ResultInfo`, typed `List<ViewModel>`, or raw
  `dynamic` — pick whichever your target module already uses, do not invent a fifth shape). No
  pagination/filtering/sorting convention is standardized — check the target module's existing
  list-loading method for its pattern before adding a new one.
- **Server-side input validation is mandatory** — this codebase's actual failure mode is UI-only
  validation with no server enforcement (§7's "silent"/weak-enforcement findings, the confirmed-
  absent client-side JS validation catalogued in `spec/validation-rules.md` §2). **Never rely on
  client-side checks alone for anything that touches money, stock, or permissions.**
- **Consistent error shape**: no existing standard — match the target module's convention
  (`showMessageBox("...")` string alerts for legacy pages, a `ResultInfo`/service-return-string for
  newer ones).
- **Idempotency keys**: no existing convention found; for a new financial/inventory-mutating
  endpoint, follow `PaymentPartial.aspx.cs`'s transactional-recheck pattern (§7) rather than
  inventing an idempotency-key header scheme unless explicitly asked to.
- **UI states (loading/empty/error/offline/permission-denied)**: **no consistent existing pattern**
  — most legacy pages are synchronous full-postback with no distinct loading/empty state handling
  beyond a "No Data Found!!" message on empty grids. Add reasonable states for new work without
  assuming a design system exists to draw from (`docs/ui-spec.md`/`spec/ui-spec.md` confirm no
  component-library documentation exists in this repo).
- **Confirmation dialogs for irreversible actions**: inconsistent — present on some delete/approve
  actions, absent on others. Add one for any new destructive action; don't assume the pattern is
  already handled by a shared component (there isn't one confirmed).
- **Accessibility**: **Not Found** — no ARIA attributes or accessibility tooling confirmed anywhere
  in a sampled review. Do not claim accessibility compliance for new work without actually
  implementing and testing it; there's no existing baseline to inherit from.
- **Responsive/mobile web usability**: the admin theme is a Bootstrap-derived third-party template;
  field-force mobile usage is presumed to go through the separate Flutter app (out of scope), not
  this Web Forms UI — do not assume this codebase needs to be mobile-optimized as a web experience
  unless explicitly told field staff use the web UI directly on a phone.
- **No business-rule enforcement solely in the UI** — restated because this is the single most
  common defect category found in this codebase (§7); every new business rule must have its
  authoritative enforcement server-side, with UI-side checks as a convenience layer only.

---

## 10. Security, privacy, and compliance

**This section describes the current, confirmed state — not an aspirational target.** Read
`docs/security.md` in full before touching authentication, session, password, or SQL-construction
code; it is the authoritative, file:line-cited security findings document for this repo.

- **Authentication**: hand-rolled `Session[...]`-key scheme (~14 keys set in `Login.aspx.cs`), not
  ASP.NET Forms Authentication despite it being configured in `web.config` — no code calls
  `FormsAuthentication.SetAuthCookie` or reads `User.Identity`. **Passwords are stored and compared
  in plaintext** (`PanalClsDAL.cs`'s login query, `ChangePasswordDAL.cs`'s update). **Do not add new
  authentication logic without addressing that any new password field will be plaintext unless you
  explicitly implement hashing** — this is a known, standing defect, not a template to replicate for
  new work if the task is security-focused.
- **MFA**: **Not Found.**
- **RBAC/tenant isolation**: see §4 — coarse, per-page, copy-pasted, with confirmed hardcoded
  bypasses. No tenant isolation exists (single-org assumption, §3).
- **Encryption in transit**: no HTTPS-enforcement code (`RequireHttps`,
  `Request.IsSecureConnection`) found anywhere. **Encryption at rest**: `EncryptDecrypt.cs` exists
  but is **dead code** with hardcoded key material (pass-phrase, salt, and IV all literal strings)
  — do not wire it up as-is; if encryption-at-rest is required, it needs a proper key-management
  design, not activation of this existing class.
- **PII protection**: `Solution.Web/App_Code/UserSessionTrackingManager.cs` sends every user's
  resolved public IP to the third-party `ipapi.co` service on every login — an undocumented
  outbound PII flow, flag for any privacy/compliance review.
- **Employee GPS/location privacy**: no confirmed GPS-capture code exists in this web repo (§5.E) —
  if this requirement applies, it is likely a mobile-app (out-of-scope) concern; do not assume this
  codebase has location data to protect that it does not currently collect.
- **File upload validation**: confirmed **absent** on the Excel-import path (§5.A, §7) — files are
  saved to disk before any content/extension validation, with no size limit and no filename
  sanitization. `HandlerDocCV.ashx` (general file upload) similarly has **no auth check and no
  file-type/size validation**. **Any new file-upload feature must not copy these patterns** — add
  extension allow-listing, size limits, and filename sanitization from the start.
- **Rate limiting**: **Not Found** anywhere in the application layer.
- **Secure audit trail**: see §11 — largely absent as a generic mechanism.
- **Secrets in source**: **multiple confirmed instances** — hardcoded SQL Server credentials in
  `web.config` and `SqlUserAccess.cs` (with ~10+ prior combinations left commented rather than
  deleted), a dead-but-real SAP REST credential in `BankDepositSAP.aspx.cs`, and hardcoded/weak SMTP
  credentials in several Campaign/Transfer screens. **Do not add a new hardcoded credential under
  any circumstance** — this is the single most repeated defect category in this codebase; every
  instance found so far is flagged as a finding, never as a pattern to continue.
- **SQL injection surface**: string-concatenated SQL confirmed in 44+ `Library.DAL` files (full
  list in `docs/security.md` §4) — including the `SInventoryWebService.asmx` autocomplete methods,
  which concatenate `Session[...]` values directly into query text. **Always use parameterized
  queries (`SqlParameter` or Dapper's parameter binding) for any new or modified query** — never
  extend the concatenation pattern, even to match a neighboring file's existing style.
- **Least privilege**: the application connects to SQL Server as `sa` in the active connection
  string — no application-specific least-privilege database account is configured. Flag if asked to
  productionize deployment; do not silently "fix" this without raising it as a change (§14).
- **Data retention/archival/backup**: the Financial-Year Archive/Delete screen (§7) is the only
  confirmed retention-management feature, and it is a destructive-delete operation with a confirmed
  silent-fallback bug — not a safe, general-purpose archival mechanism to build on without review.
- **Compliance requirements** (pharma-specific regulatory regimes — e.g. controlled-substance
  tracking, GxP-style data-integrity rules): **Not confirmed as implemented or referenced anywhere
  in this codebase.** If a task requires a specific regulatory compliance behavior, treat it as
  **an open question requiring stakeholder confirmation of the operating country/regulatory
  regime** — do not assume any particular compliance framework is already satisfied by existing
  code.

---

## 11. Auditability and accounting integrity

**Honest baseline**: this system does **not** currently have a generic, immutable, before/after-
value audit-log mechanism. What exists:

- Per-entity approval-log tables (`tblXApprovalLog` family) — append-only **except** the three DA
  invoice-reject procedures, which delete rather than append (§6, §5.G) — a confirmed exception to
  flag on any related change.
- `CreateBy`/`CreateDate`/`UpdateBy`/`UpdateDate`-style columns on many (not all) tables, populated
  from session values — this records *who last touched a row and when*, not a change history of
  *what changed*. A second edit silently overwrites the first edit's values with no trace of the
  prior state.
- No before/after-value diff logging was found anywhere in the scanned code.

**Requirements for new work in this area** (per the general template, applied as forward guidance
since the baseline doesn't meet it):

- Any new financial, stock, pricing, target, or incentive-adjacent mutation should record actor
  (`Session["UserId"]`/`LoginName`), timestamp, and — where feasible — the prior value, not just the
  new one. Follow the `CreateBy`/`UpdateBy` column convention already used across the schema for the
  "who/when" part; the "what changed" part has no existing pattern to extend and must be designed.
- **No silent overwrite of a finalized (Accepted/Approved/Posted) record.** Where the routing engine
  or a stock-approval proc has already finalized a record, a correction must be a new record/
  reversal entry, not an in-place edit of the finalized row — this matches the *intent* behind the
  routing engine's design (chain terminates at Accepted) even though the current codebase does not
  uniformly enforce immutability after that point (§6). Do not add a "just edit the Accepted row"
  shortcut.
- If a task explicitly requires audit-trail capability, say so in your plan as new infrastructure
  being added, not as "using the existing audit system" — there isn't one to use.

---

## 12. Testing and quality gates

**Baseline**: `Solution.sln` has no MSTest/NUnit/xUnit project (`docs/testing.md`). Verification
today is entirely manual, or via standalone PowerShell scripts (`test_crud_invoice_not_binding.ps1`
is the template) that hit a real SQL Server instance directly.

- **Unit tests**: no existing framework to add to. If a task specifically calls for test coverage,
  raise the framework-choice decision explicitly (per `CLAUDE.md`/`docs/testing.md`) rather than
  silently picking one and wiring it into the Website-model solution.
- **Integration/API/authorization tests**: same gap — none exist. For any new endpoint, at minimum
  manually verify: the happy path, a rejected/failure path, and — critically, given §4's confirmed
  gaps — that an unauthorized role/session actually gets blocked, not just hidden from.
- **End-to-end tests**: none exist; UI-level testing tooling (Selenium/Playwright) is **Not Found**
  in the repo.
- **Edge cases to manually verify for any change touching the areas below** (these are not
  hypothetical — each corresponds to a confirmed weak spot in this specific codebase):
  - Concurrent stock changes — most stock-mutation paths have **no** concurrency guard (§7); if your
    change touches one, consider whether `PaymentPartial.aspx.cs`'s transactional-lock pattern
    should be applied.
  - Partial delivery/fulfillment — confirmed screens (`PaymentPartial`, delivery-status branching in
    `DelivaryInvoiceList.aspx.cs`) have their own quirks (e.g. the reject branch there is an
    unconditional `else`, fragile to new dropdown values) — test all three status paths explicitly,
    not just the happy one.
  - Expired/restricted batch handling — no FEFO/FIFO enforcement exists (§5.B); don't assume expiry
    is automatically respected in stock-out selection.
  - Credit-limit-exceeded — test both of the two parallel credit-limit code paths (§5.C) if your
    change touches either.
  - Duplicate/rapid-resubmit — test explicitly given how many "duplicate check" implementations in
    this codebase are pre-check-only with a race window, or outright disabled (§7).
  - Rejected-then-resubmitted approvals — test the specific entity's actual behavior; it varies
    (append-only log vs. delete-and-resubmit vs. balance-ledger side effects for Leave) per §6.
  - Bulk-action result reporting — the confirmed bulk-approval bug (§5.E) means "approve 5 rows,
    1 fails" can currently report success; verify any new/changed bulk-action code reports **per-
    row** results, not just the last one processed.
- **Regression tests on business-rule changes**: since there's no automated suite, any change to a
  rule documented in [`spec/business-rules.md`](spec/business-rules.md) must be manually re-verified
  against every citation for that rule in that document, and the document itself should be updated
  to reflect the new behavior (see §14).

**Before marking any work complete:**
- Run whatever typecheck/build step applies (`msbuild Solution.sln /p:Configuration=Release` per
  `CLAUDE.md`) — there is no separate lint/format tool configured in this repo
  (`docs/coding-standard.md` confirms no `.editorconfig`/StyleCop exists).
- Run any directly relevant PowerShell CRUD-verification script against a **dev/staging** database,
  never production (per `docs/testing.md` and `CLAUDE.md`).
- If you changed the database schema or a stored procedure, validate it executes cleanly and that
  its full source is (if this is meant to stay in sync with the documentation effort) reflected in
  [`spec/database/`](spec/database/) if that catalog is being maintained for this project.
- Manually smoke-test the affected workflow end-to-end through the UI where feasible.
- Re-read the specific `spec/business-rules.md` section(s) your change touches and confirm you have
  not silently weakened, removed, or contradicted a documented rule.
- Produce a summary of: files changed, assumptions made (explicitly labeled), risks introduced or
  left unaddressed, and any unresolved open questions — per §15's Definition of Done.

---

## 13. Agent execution workflow

Follow this sequence for any non-trivial change:

1. **Read** [`spec/business-rules.md`](spec/business-rules.md) for the module(s) involved, and open
   the actual `.aspx.cs`/`BLL`/`DAL`/proc files it cites — do not work from the summary alone.
2. **Identify** affected modules, roles (§4), data model (§8), API surface (§9), UI, and any
   existing tests/verification scripts (§12) — and identify which coding era (legacy vs. newer
   Service/Repository) the touched files belong to.
3. **State a concise implementation plan** before writing code, including explicit
   `**Assumption:**`/`**Open question:**` markers for anything not directly confirmed by source 1-4
   in §2's precedence order.
4. **Make the smallest safe, cohesive change** — do not refactor unrelated code, do not "fix" an
   unrelated documented defect as a drive-by (flag it instead, per §14).
5. **Add/update migrations carefully** — this repo has no formal migration framework; schema
   changes are applied directly. Given only 3 real FK constraints exist DB-wide and PK strategy is
   inconsistent (§8), be conservative: prefer additive changes (new nullable columns, new tables)
   over altering existing columns/keys, and never silently drop a column/table with existing data.
6. **Implement backend validation and authorization first** — before UI, given how many confirmed
   defects in this codebase are "validation only in the UI" or "authorization only hides a button."
7. **Implement UI and user-feedback states** matching the target module's existing pattern (§9).
8. **Add tests/verification** for happy path, failure path, and permission path — using the
   PowerShell-script template (§12) if no better mechanism is available for the touched area.
9. **Run verification** per §12's "before marking complete" checklist.
10. **Report** results, risks, and follow-up items — including any confirmed pre-existing defect you
    encountered but did not fix (name it, don't silently leave it undocumented either).

---

## 14. Change-management rules

- **Never make a destructive schema/data change** (drop column/table, hard-delete with no archive
  path, alter a column type on a table with existing rows) **without explicit approval** — call it
  out and wait, don't proceed and report after.
- **Never reset or revert unrelated user changes** — this repo's working tree may contain in-
  progress edits, including ones that look inconsistent with surrounding code; that inconsistency
  is often original to this codebase (§2), not something you introduced or need to fix.
- **Use additive, reviewed changes for schema modifications** given the absence of a migration
  framework (§13.5) — document the exact `ALTER`/`CREATE` statement(s) applied and where, since
  there's no migration history file tracking this automatically.
- **Preserve backward compatibility** for existing API/`[WebMethod]` signatures where at all
  possible — 459 of these exist across 116 files (§9), many with fragile, undocumented calling
  conventions (delimiter formats, positional params); a signature change can silently break a caller
  you haven't found.
- **Version/flag API changes** where a breaking change to a `[WebMethod]`/`.asmx` contract is
  unavoidable — since there's no existing versioning convention, propose one explicitly rather than
  silently breaking callers.
- **Update `spec/business-rules.md` and related `spec/`/`docs/` files when a documented rule
  changes** — this documentation set is actively maintained as a source of truth for this project;
  a rule change that isn't reflected there will mislead the next person (human or agent) who reads
  it.
- **Always ask for clarification** before proceeding when a decision materially affects: money
  (invoice limits, payment reconciliation, incentive-adjacent calculations), inventory (stock
  quantity mutation logic, especially the "approval = immediate stock movement" pattern in §6),
  compliance (any pharma regulatory question — §10), permissions (anything in §4, especially
  touching the hardcoded bypasses), or customer/doctor data (PII, credit terms, contact info).

---

## 15. Definition of done

A feature/change is complete only when **all** of the following hold:

- [ ] Every rule in [`spec/business-rules.md`](spec/business-rules.md) relevant to the touched
      area has been read, and the change does not contradict, weaken, or silently remove any of
      them (deliberate rule changes are explicitly called out, not silent).
- [ ] Permissions are correct **server-side** — the change does not rely on hiding a UI control as
      its only enforcement (§4, §9).
- [ ] All applicable validations from §7's checklist are implemented server-side, matching the
      target module's existing coding era/pattern.
- [ ] Whatever audit trail this system currently supports for the touched entity (append-only
      `tblXApprovalLog`, `CreateBy`/`UpdateBy` columns) is populated correctly; if the task requires
      audit capability beyond what exists, that gap is explicitly flagged, not silently left
      unaddressed or silently "solved" with a fake/partial mechanism.
- [ ] State transitions (if the entity has a lifecycle per §6) are correct: valid states only,
      transitions gated to the correct role/step, no unintended bypass of the routing chain.
- [ ] Inventory/financial integrity is protected: no new negative-stock possibility introduced, no
      new race condition on a money- or stock-mutating path without at least considering
      `PaymentPartial.aspx.cs`'s hardened pattern (§7, §12).
- [ ] UI states (loading/empty/error/permission-denied/confirmation-for-destructive-actions) are
      present and reasonable for the target module, even though no design system exists to inherit
      from (§9).
- [ ] Relevant verification has been run (build succeeds; any applicable PowerShell/manual
      smoke-test has been performed against a dev/staging database, never production) — per §12.
- [ ] Documentation is updated: [`spec/business-rules.md`](spec/business-rules.md) and any other
      `spec/`/`docs/` file whose content the change makes stale.
- [ ] No unrelated files were changed, reformatted, or "cleaned up."
- [ ] A summary was produced covering: files changed, explicit assumptions made, risks introduced or
      knowingly left unaddressed, and any unresolved open questions for a human to decide.
