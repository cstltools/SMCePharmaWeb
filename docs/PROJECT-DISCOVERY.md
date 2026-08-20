# Project Discovery — ePharma (SMCePharmaWeb)

Written 2026-08-20, ahead of the Order Payment Approval implementation
(`spec/requirements.md`, Phases 1–7).

**The reverse-engineering this project asks for was already done and is checked in.** This
document is therefore an *index and a delta*, not a re-derivation: it says where each artifact
lives, what was re-verified against the live database during this pass, and what is genuinely
new. Re-generating `docs/database/table-inventory.md` when `spec/database-tables.md` already
holds 571 KB of live-extracted table definitions would create a second source of truth that
immediately starts drifting.

---

## 1. Where the existing discovery artifacts live

| Requirement phase | Asked for | Already exists at |
|---|---|---|
| 2 — All docs | Architecture / business flow / API / DB / deployment / security / coding standards / testing | `docs/architecture.md`, `docs/business-flow.md`, `docs/api.md`, `docs/database.md`, `docs/deployment.md`, `docs/security.md`, `docs/coding-standard.md`, `docs/testing.md`, `CLAUDE.md`, `.agents/AGENTS.md` |
| 3 — All specs | Functional / business rules / validation / workflow / modules / reports / integrations | `spec/functional-spec.md`, `spec/business-rules.md` (90 KB), `spec/validation-rules.md`, `spec/workflow.md`, `spec/modules.md`, `spec/reports.md`, `spec/integrations.md`, `spec/ui-spec.md`, `spec/api-spec.md` |
| 4 — Database | `database-overview` / `table-inventory` / `stored-procedure-inventory` / `database-relationships` / `database-business-rules` | `spec/database-spec.md` (275 KB — procs, views, functions, dependencies), `spec/database-tables.md` (571 KB — every table with columns/types/keys/indexes/row counts and its C# call sites), `spec/database/{procs,views,functions,tables,menu}/` (extracted source) |
| 5 — Architecture | `current-architecture.md` | `docs/architecture.md` + `CLAUDE.md` §"Solution structure" |
| 6 — Business flow | UI → service → repository → proc → DB traces | `spec/workflow.md` §4 (order-to-cash), `docs/business-flow.md` |
| 7 — Security | `current-security.md` | `docs/security.md`, `spec/business-rules.md` §0.1 and BR-DRB-\* findings |

Bug-fix and change notes from previous passes: `docs/BusinessSummary_2ndReturn_Fix.md`,
`docs/NewReceiveableReport_Bugfix.md`, `docs/ReceiveQty_RootCause_Analysis.md`,
`docs/ReceiveQty_Permanent_Fix_Plan.md`, `docs/StockOutReport_SqlConnectivity_Fix.md`.

## 2. Inventory (structure that matters for this requirement)

| Path | Purpose | Module | Impacted |
|---|---|---|---|
| `Solution.Web/` | WebForms UI. AspNetCompiler **website**, no `.csproj` — see `website.publishproj` | all | yes |
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx(.cs)` | **The live Invoice Creation page.** The menu row still points at the retired `InvoiceCreationByOrder.aspx` (`spec/modules.md`); this `_daaw` file is what actually serves | Sales Centre Operation | yes |
| `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx(.cs)` | Single-order invoice entry screen the grid navigates into | Sales Centre Operation | yes |
| `Solution.Web/Approval_UI/` | 13 existing approval worklists (`OrderApproveList`, `DCRApprovalList`, `LeaveApproveList`, …) — the conventions the new page follows | Approvals | yes (new page) |
| `Library.DAO/` | Plain entities/view models by module, no logic | all | yes |
| `Library.DAL/` | ADO.NET → stored procs via `DataManager/DataAccessManager*.cs`; a few newer classes use Dapper | all | yes |
| `Library.BLL/` | Business logic. Older classes are pass-throughs; newer ones use Service → Repository → Model (`MasterSetup_BLL/CustomerInvoiceLimitService.cs` is the reference) | all | yes |
| `Library.CrystalReports/` | Report definitions | Reporting | no |
| Root `*.sql`, `spec/database/**` | Working copies of proc source; **not applied by any build step** | DB | yes |
| Root `test_*.ps1` | The whole test suite: standalone PowerShell against a real SQL Server | QA | yes |

There is no automated test project and no `.github/workflows` directory — the CI/CD documents
under `docs/` describe an intended pipeline, not a running one (`CLAUDE.md`).

## 3. Verified fresh against the live database this pass

Connection: `127.0.0.1,57694` → `SalesDisDB_SMC_NEWDB` (the loopback + dynamic-port form; a
hostname or LAN IP produces SQL error 26 here).

- **Credit validation is already implemented** and drives the existing UI. Both
  `sp_LoadOrderListForOrderCreationbyTerri` (territory-wise) and
  `sp_LoadOrderListForOrderRouteDayWise` (route-wise) emit `IsMaxOutstandingExceeded` and
  `IsCreditPeriodExceeded`, computed from `tblInvoiceNotBinding` (customer-level rule wins over
  customer-type-level) with defaults 2 invoices / 45 days / 50,000. `orderGridView_RowDataBound`
  disables the checkbox and the **Go To Invoice >>** button when either flag is set. The new
  requirement therefore *extends* an existing gate rather than introducing one.
- **The org ladder is a real, populated structure**, not something to invent:
  `tblTerritory.AreaId → tblASMInfo` (AM), `tblArea.RegionId → tblRSMInfo` (DZSM — the table
  even carries a `DZSMSapCode` column), `tblRegion.GroupId → tblNSMInfo` (NSM). Spot-checked
  end to end on live orders; a sample order resolved to AM 827 / DZSM 598 / NSM 683.
- **Role type ids** in `tblRoleType`: AM = 2, DZSM = 3, NSM = 4, Admin = 5. A user's role type
  resolves as `tblUser.UserRoleID → tbl_UserRoleInfo.RoleTypeId`, which lets a stored procedure
  determine the caller's role from the session's `UserId` alone.
- **Existing approval infrastructure was assessed for reuse** (Phase 12/13):
  `tblApprovalLog` (1.06 M rows), `tblOrderApprovalLog` (1.10 M rows),
  `tblApprovalMapMaster`/`tblApprovalMapDetail`, `tblApprovalStepsNew`. Findings in
  `docs/impact-analysis/order-payment-approval-impact.md` §3.
- **Menu registration has no stored procedure.** Rows go into `tblMainMenuNew` + `tblMenuRole`
  by direct INSERT with a hand-picked `SL` (`SL` is a plain int, not IDENTITY), the convention
  already recorded in `spec/database/menu/*.sql`.
- **`DataAccessManager_daaw.GetDataSet` silently dropped every second result set** — a
  pre-existing defect in shared data-access code, found only by driving a page in a browser (a
  procedure returning 3 result sets yielded 2 tables). Fixed; it also repairs the DA Expense Claim
  list's details table. `spec/business-rules.md` §0.2.
- **Full-solution precompilation has a pre-existing break** unrelated to this work: three
  user controls share the class name `SInventory_UI_IVMarketStructureInvoSearch`
  (`SInventory_UI/IVMarketStructureInvoSearch.ascx.cs`,
  `SInventory_UI/IVMarketStructureInvoSearchReport.ascx.cs`,
  `MasterSetup_UI/IVMarketStructureInvoSearch.ascx.cs`), so `AspNetCompiler` fails with CS0433
  on the eight pages that consume them. The site still runs, because non-precompiled ASP.NET
  batches per directory. Logged in `docs/OPEN-QUESTIONS.md` — fixing it is a separate change.

## 4. Architecture, as the code actually does it

```
Browser (WebForms .aspx, Bootstrap 5, jQuery, SweetAlert)
  → code-behind (.aspx.cs, Session-based identity)
  → Library.BLL service / BLL pass-through
  → Library.DAL repository (SqlCommand → stored procedure)
  → SQL Server — where most business logic actually lives
```

- **Auth**: Forms Authentication, `sessionState mode="InProc"`. Login populates
  `Session["UserId" | "EmpInfoId" | "RoleTypeId" | "UserRoleID" | "ComUnitId" | …]`.
- **Authorization**: a session-exists check is universal; per-page role checks are opt-in and
  present on a minority of pages. Menu visibility is *not* authorization.
- **Data access**: `List<SqlParameter>` → `DataAccessManager_daaw.GetDataTable/GetDataSet/SaveData`.
  Validation failures come back as `RAISERROR(..., 16, 1)`, surfacing in C# as
  `SqlException.Number == 50000` — the pattern `CustomerInvoiceLimitRepository` already uses to
  turn a proc error into a user-facing string.
- **Connection strings** are hardcoded in three unrelated places (`Solution.Web/web.config`,
  `Library.DAL/DataManager/SqlUserAccess.cs`, and each root `*.ps1`), and they do not
  necessarily agree. Check which block is uncommented before assuming which database you are on.

## 5. Security posture relevant to this requirement

Pre-existing, unchanged by this work, and worth knowing before adding an approval workflow:

- Passwords are stored and compared in plaintext.
- Two `[WebMethod]` endpoints accept an unvalidated free-text `param` that reaches
  `EXEC(@Query)` — a confirmed SQL-injection and row-level-security bypass
  (`spec/business-rules.md` BR-DRB-10). Not touched by this change; still open.
- Several procs contain hardcoded employee ids that short-circuit hierarchy logic.

The design consequence, applied throughout the new work: **nothing role-shaped is accepted as a
procedure parameter.** The new procedures take `@ActionUserId` and resolve employee id and role
type from `tblUser`/`tbl_UserRoleInfo` themselves, so a forged parameter cannot buy a level.

## 6. What this discovery changed about the plan

1. No new credit-validation rule was written — the existing one is authoritative, and the new
   `dbo.fnOrderCreditValidation` re-expresses it per-order for the server-side gate.
2. No new hierarchy tables — `tblASMInfo` / `tblRSMInfo` / `tblNSMInfo` already carry the ladder.
3. No new page for invoice creation — `InvoiceCreationByOrder_daaw.aspx` was extended in place.
4. The three new tables named in `spec/requirements.md` Phase 12 *were* created, because the
   generic approval tables cannot express a payment schedule, a plan version, or the strict
   0–7 state machine. Justification in the impact analysis.
