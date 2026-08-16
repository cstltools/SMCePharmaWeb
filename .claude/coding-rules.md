# Coding Rules

Observed conventions in this codebase, to match when adding or editing code. These are descriptive (what the codebase actually does), not aspirational — follow them for consistency rather than introducing a fourth style.

## Naming

- **Instance fields/locals prefixed with lowercase `a`**: `aPanalBll`, `aReportDal`, `aDal`, `aTableLogin`, `aDataTableMenu`, `aClsPrimaryKeyFind`, `aSqlParameters` — pervasive across the legacy codebase (`Login.aspx.cs`, `PanalBLL.cs`, `MainMasterPage.master.cs`, dozens more). Read as "an instance of X." New legacy-style code should follow this.
- **Classes**: PascalCase. BLL classes suffixed `BLL`/`Bll` (`PanalBLL`, `ChalanBLL`), DAL classes suffixed `DAL`/`Dal` (`PanalClsDAL`, `DoctorInfoReportDal`) — casing of the suffix itself is inconsistent (`DAL` vs `Dal` vs `DAO` vs `Dao`), match the sibling file in the same folder.
- **Tables**: `tbl` prefix (`tblCustMaster`, `tblInvoice`, `tblMainMenu`). Stored procedures: `sp_` prefix, often naming the operation and entity (`sp_InsertCustomerInvoiceLimit`, `sp_webapi_SaveOrderAppLog`).
- **Newer files** (`CustomerInvoiceLimitService.cs`/`Repository.cs`) drop the `a`-prefix convention and use plain camelCase locals / PascalCase for injected-looking fields (`repository`, not `aRepository`) — this is the newer idiom, not a mistake.

## Layering

- UI (`Solution.Web` code-behind) → BLL (`Library.BLL`) → DAL (`Library.DAL`) → DAO (`Library.DAO`, data only). Some legacy pages skip BLL and call DAL directly — acceptable within the legacy style, but don't introduce new bypasses in newer-style code.
- Every class is constructed with `new` inline, as a field initializer or local. There is no DI container anywhere in this repo (see [`docs/architecture.md`](../docs/architecture.md) §DI) — do not attempt to introduce constructor injection without first adding interfaces and a composition root, which does not currently exist.

## Data access

- **Prefer stored procedures** for new data access, consistent with the majority of the codebase. Dapper against raw parameterized SQL (as in `SInventoryWebService.cs`'s autocomplete methods and `CustomerInvoiceLimitRepository`) is an accepted alternative for read-only/typeahead queries where a stored procedure would be overkill — but even the newest repository code (`CustomerInvoiceLimitRepository.Insert`) still calls a named stored procedure for writes.
- **Always parameterize.** Most of the codebase does. A minority of legacy autocomplete methods in `SInventoryWebService.cs` concatenate session-derived values directly into SQL text (e.g. `GetSubDepotInvoiceNo`, `GetCustomer`, `GetEmpInfo` — see [`docs/security.md`](../docs/security.md)) — this is a known defect pattern, not a convention to copy.
- Four near-duplicate connection/command helper classes exist in `Library.DAL/DataManager/`: `DataAccessManager`, `DataAccessManagerAsync`, `DataAccessManagerOld`, `DataAccessManager_daaw`. Match whichever one the DAL class you're editing already uses; don't introduce a fifth.
- Connection details are read from one of three hardcoded sources depending on which DAL helper is in play (`web.config`, `SqlUserAccess.cs`, `DB_Authentication.cs`) — see [`docs/database.md`](../docs/database.md). Match the sibling file's source; do not add a fourth.
- `DataAccessManager.GetDataTable` uses `DataTable.Load(reader)`, which marks any SQL-computed/expression column as `ReadOnly = true` on the returned `DataTable`. If page/BLL code writes back into a column that the query already produces (e.g. building a "Code : Name" display string server-side under the same column name), clear `column.ReadOnly = false` first — otherwise it throws `System.Data.ReadOnlyException` on the first row. See `docs/NewReceiveableReport_Bugfix.md` for a real case this crashed silently (masked by `customErrors`, looked like "no data" instead of an error).

## Error handling

- Legacy code frequently wraps risky conversions in `try { ... } catch { }` / `catch (Exception ex) { }` with an empty body, silently swallowing failures (e.g. `Login.aspx.cs:63-69`, `Reports_UI/DoctorInfoReport.aspx.cs` throughout). This is the existing convention for optional/non-critical reads (e.g. a session value that may not exist yet) — don't propagate it to new validation or financial-write logic.
- Newer BLL `Service` classes return a `string` from write operations: `"Success"` on success, a human-readable sentence on validation failure (`"Customer is required."`), and re-throw unexpected `Exception`s after a `finally` block closes the connection (`CustomerInvoiceLimitRepository.Insert`). Follow this shape for new service methods in that layer rather than introducing exceptions-as-control-flow or a new result type.

## WebForms specifics

- **Preserve existing control IDs and method signatures.** Markup (`.aspx`) binds to code-behind (`.aspx.cs`) by control ID; other files and stored procedures may already depend on existing method signatures. Renaming either is a wider change than it looks.
- A page only gets the session-based auth gate (see [`docs/security.md`](../docs/security.md)) if its `MasterPageFile` is one of the three master pages under `Solution.Web/MasterPages/`. A new page should use one of them unless it has a documented reason not to.
- Session (`Session["UserId"]`, `["ComUnitId"]`, `["RoleTypeId"]`, etc. — about 14 keys set at login in `Login.aspx.cs`) is the primary source of "current user" context throughout the codebase, not `HttpContext.User`. Code that needs the current user reads these keys directly; there is no claims principal to depend on instead.

## Comments

- Comment language is mixed: most legacy code is uncommented or has sparse English comments; some of the newest files (`Library.DAL/DataManager/DataAccessManager.cs`) have Bengali-language comments alongside English ones. Match the file you're editing.
