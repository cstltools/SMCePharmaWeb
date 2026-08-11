# Architecture

## Layered design

Solution.sln has five projects arranged as a classic four-layer stack:

```
Solution.Web (UI, Web Forms)
      │  new PanalBLL(), new *Service(), ...
      ▼
Library.BLL (business logic)
      │  new PanalClsDAL(), new *Repository(), ...
      ▼
Library.DAL (data access)  ──▶  Library.DAL/DataManager (connection/command plumbing)
      │
      ▼
Library.DAO (entities / models / view models — no logic)

Library.CrystalReports — typed DataSets consumed by report-viewer pages, parallel to the above
```

Every arrow is a `new SomeConcreteType()` call — see [Dependency injection](#dependency-injection).

## Two coexisting coding eras

**Legacy (majority of the codebase):** UI code-behind → `*BLL` class → `*DAL` class → raw ADO.NET `SqlCommand`/`SqlDataReader` → `DataTable` returned all the way back to the page, bound directly to a GridView/DropDownList. Example: `Login.aspx.cs` → `PanalBLL.Login()` → `PanalClsDAL` → `DataTable`.

**Newer (isolated, recent files):** UI code-behind → `*Service` class (validates, returns a string message) → `*Repository` class (Dapper, parameterized SQL or stored procedure, typed model in/out) → `Library.DAO` `Model`/`ViewModel`. Example: `Library.BLL/MasterSetup_BLL/CustomerInvoiceLimitService.cs` → `Library.DAL/MasterSetup_DAL/CustomerInvoiceLimitRepository.cs` → `CustomerInvoiceLimitModel`/`ViewModel`.

There is no shared interface or base class between the two eras, and no migration in progress — new work should match whichever style the module it's touching already uses.

## Project responsibilities

| Project | Contains | Representative evidence |
|---|---|---|
| `Solution.Web` | ~700 `.aspx`/`.aspx.cs` pages across ~25 feature `*_UI` folders, 3 master pages, one SOAP-ish web service, 3 HTTP handlers, Crystal Report viewer pages | `Solution.sln` (Website project entry) |
| `Library.DAO` | Plain entity/DTO classes, grouped by module (`SInventory_Entities`, `DoctorModule_DAO`, `MasterSetup_DAO`, `UserRoleDAO`, ...) | 208 files across `Library.DAO/` |
| `Library.DAL` | Data access classes mirroring `Library.DAO`'s module folders, plus `DataManager/` (connection/command plumbing, plus the unused `EncryptDecrypt.cs`) and `InternalCls/` (shared helpers: primary-key generation, number-to-words) | `Library.DAL.csproj` |
| `Library.BLL` | Business logic, called from `Solution.Web` code-behind | `Library.BLL.csproj` |
| `Library.CrystalReports` | 58 report shapes, each a typed `DataSet` definition (`.xsd`/`.xsc`/`.xss` trio, 172 files) plus a generated `.cs` partial class (124 files), plus 40 `.rpt` report definitions — 339 files total | `Library.CrystalReports/` |

## Request flow example (legacy path)

1. Browser posts `Login.aspx`.
2. `Login.aspx.cs` constructs `new PanalBLL()` inline and calls `.Login(loginName, passwordText)`.
3. `PanalBLL` calls into `Library.DAL/PanalCls/PanalClsDAL.cs`, which builds a SQL string (not a stored procedure) and compares the password column directly — see [`docs/security.md`](security.md).
4. A `DataTable` comes back; `Login.aspx.cs` reads ~14 columns off row 0 by name and writes them into ~14 separate `Session[...]` keys.
5. Every subsequent page that uses one of the three master pages checks `Session["UserId"]` in the master page's own `Page_Load` and redirects to `Login.aspx` if absent.

## Request flow example (newer path)

1. A code-behind (e.g. under `MasterSetup_UI`) constructs `new CustomerInvoiceLimitService()`.
2. The service validates the incoming `Model` (required fields, business limits) and, if valid, calls its `CustomerInvoiceLimitRepository`.
3. The repository opens a connection via `DataAccessManager_daaw`, binds `SqlParameter`s, and executes a named stored procedure (e.g. `sp_InsertCustomerInvoiceLimit`).
4. The service returns a `string` — `"Success"` or a specific error sentence — which the page displays directly.

## Approval subsystem (cross-cutting)

A significant part of the business logic lives in a **multi-level, role-sequenced approval system**, not confined to any one module:

- `Library.DAO/UserRoleDAO/ApprovalMapMaster.cs` models, per menu (`MenuId`) and originating role (`FromRoleId`), an ordered list of approver roles (`ApprovalMapDetail.ToRoleId` + `.Order`).
- `Library.DAL/UserRoleDAL/ApprovalMapDAL.cs` loads/saves this routing table via `sp_GET_ApprovalMapLoad` / `sp_Save_ApprovalMapMaster` / `sp_Save_ApprovalMapDetail`.
- Every `Approval_UI` page (Customer, DA Claim, DCP/CVP, DCR, Doctor, Doctor/Customer Transfer, Expense, Leave, Mileage, Order, RX, Tour Plan) follows the same shape: a grid of pending records, each carrying a `ToRoleTypeId`/`Step`; the Approve/Reject buttons are only enabled when `Session["RoleTypeId"]` matches the record's current-step approver role, and approving writes the next step forward via a dedicated `sp_*AppLog` stored procedure. See [`docs/business-flow.md`](business-flow.md) for the full catalog.

## Stored-procedure-driven business logic — a worked example

CLAUDE.md notes that "a large amount of business logic lives in stored procedures... not in C#."
[`docs/ReceiveQty_RootCause_Analysis.md`](ReceiveQty_RootCause_Analysis.md) is a fully-verified,
end-to-end trace of exactly that, from an external system through five chained stored procedures to
a WebForms page: `SAP_API_Data.tblSAP_StockMovementMaster`/`tblSAP_StockMovementDetail` (external
SAP staging tables, see [`docs/database.md`](database.md)) → `sp_SAP_StockReceive` (orchestrator) →
`sp_SAP_WhStockInMaster`/`sp_SAP_WhStockInDetails` → `sp_SAP_STOMaster`/`sp_SAP_STODetails` →
`sp_SAP_StockInTransfer` → `tblStockInTransfar` → `SInventory_UI/ReceiveProductByChalanByDC.aspx`,
which simply binds `Eval("Quantity")` straight from that last table. Worth reading in full as a
reference for how far a "just displays a DataTable" WebForms page's real logic actually reaches
upstream — and as the source of the concurrency example below.

## Concurrency / locking pattern (cross-cutting)

No app-wide locking convention exists — `sp_getapplock` is not a documented house style, just a fix
applied at one call site so far. Most write paths that need a "check nothing conflicting already
exists, then write" guard rely on a plain SQL check (a `NOT IN`/`WHERE NOT EXISTS` before the
`INSERT`) with no lock and no backing uniqueness constraint, which is only safe if that code path
never runs twice concurrently for the same input:

- **Confirmed bug + fix**: `dadtlsDelivaryInvoiceDetailsCreation_DA.aspx.cs`'s `saveButton_Click`
  (`Solution.Web/SInventory_UI/`) guards a duplicate-submit recheck with a Session-owned
  `sp_getapplock`. The lock was being released *before* `transaction.Commit()` instead of after,
  which — under this database's `READ_COMMITTED_SNAPSHOT=ON` setting — opened a real window for a
  second concurrent session to acquire the lock, pass the same duplicate recheck against
  not-yet-committed data, and double-apply an additive stock-return update. Fixed by moving the
  `sp_releaseapplock` call to run only after `transaction.Commit()`/`Rollback()` has resolved, on
  every path (success, duplicate-detected, exception). The pattern to follow for any similar
  check-then-write path in this codebase: acquire the app lock inside the transaction, do the
  recheck + writes, commit or roll back, *then* release the lock — never before.
- **Same bug class, still open**: `sp_SAP_StockInTransfer`'s duplicate-row guard
  (`WHERE ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar ...)`) has no lock,
  no transaction-scoped guard, and no uniqueness constraint on `tblStockInTransfar(ReqChildId)`
  behind it — documented as root cause #2 in
  [`docs/ReceiveQty_RootCause_Analysis.md`](ReceiveQty_RootCause_Analysis.md) §15-16. Treat any other
  "check, then insert" path in this codebase as suspect until verified, rather than assuming the fix
  above generalizes.

## Dependency injection

None. No IoC container is referenced anywhere in the solution. Every BLL/DAL/Service/Repository class is a concrete type with no interface, constructed inline with `new` at the point of use. See [`docs/coding-standard.md`](coding-standard.md) and [`.claude/coding-rules.md`](../.claude/coding-rules.md).

## Repository pattern

Functionally, every `*DAL` class already acts as a repository (sole point of contact with a table/proc group), but only two classes in the whole solution are literally named/shaped as the textbook pattern: `CustomerInvoiceLimitRepository` (`Library.DAL/MasterSetup_DAL/`) and `ArchiveDbConnectRepository` (`Solution.Web/App_Code/`, a small Dapper-based helper that lists backup-job history from `dbo.tblArcDBConnect` and triggers a SQL Agent job via `sp_start_job`). No generic `IRepository<T>` or unit-of-work abstraction exists.

## Reporting

Two independent mechanisms — see [`docs/api.md`](api.md) is unrelated; reporting detail lives in [`spec/reports.md`](../spec/reports.md):

- **Crystal Reports**: `.rpt` files loaded via `CrystalDecisions.CrystalReports.Engine.ReportDocument`, fed an in-memory `DataSet` built from BLL/DAL calls, rendered through the `CrystalDecisions.Web.CrystalReportViewer` control.
- **GridView + Excel export**: plain ASP.NET `GridView` bound to a `DataTable`, with manual C# aggregation for footer totals, exported via ClosedXML/EPPlus/OpenXML.

## Integration surface

No REST/Web API framework (no `ApiController`, no `WebApiConfig`) exists in this repo. The integration surface is:

- `SInventoryWebService.asmx` (`Solution.Web/App_Code/SInventoryWebService.cs`) — a `[WebService]`/`[ScriptService]` class, ~20 methods, almost all typeahead/autocomplete queries for jQuery widgets.
- Three `.ashx` generic handlers for binary/file I/O (`PictureHandler.ashx`, `SignatureHandler.ashx`, `SInventory_UI/HandlerDocCV.ashx`).
- **459 inline `[WebMethod]` page methods across 116 `.aspx.cs` files** — the actual bulk of the AJAX
  surface, previously undercounted in this document. See [`spec/api-spec.md`](../spec/api-spec.md)
  for the full catalog.
- An outbound call to the third-party `ipapi.co` geolocation API on every login, from `Solution.Web/App_Code/UserSessionTrackingManager.cs`.

The Flutter mobile companion app (referenced but not present in this repo) most plausibly talks to
the `sp_Webapi*`/`sp_SalesAPI*`-backed procedures (~350 stored procedures, cataloged in
[`spec/database-spec.md`](../spec/database-spec.md)) rather than the `BASE_URL` constant in
`Library.DAL/DataManager/SqlUserAccess.cs`, which is now confirmed **dead code** — zero call sites
anywhere in the repo. See [`docs/database.md`](database.md) and
[`spec/integrations.md`](../spec/integrations.md) §4a.
