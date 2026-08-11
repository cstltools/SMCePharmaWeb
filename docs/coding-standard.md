# Coding Standard

This describes the conventions actually present in the codebase (observed, not prescribed) — see [`.claude/coding-rules.md`](../.claude/coding-rules.md) for the AI/developer-facing action-oriented version of the same material.

## Naming

- **`a`-prefixed instance references**: `aPanalBll`, `aReportDal`, `aDal`, `aTableLogin`, `aDataTableMenu`, `aClsPrimaryKeyFind` — the dominant convention across legacy code, meaning roughly "an instance of." Present in `Login.aspx.cs`, `PanalBLL.cs`, `MainMasterPage.master.cs`, and the large majority of `*_UI` code-behind files.
- **Class suffixes**: `BLL`/`Bll` for business-logic classes, `DAL`/`Dal`/`DAO`/`Dao` for data-access/entity classes — capitalization of the suffix is inconsistent between files (e.g. `PanalBLL` vs. `SubDepotStockAdjustmentsVoucherBll`), not standardized project-wide.
- **Newer files** (the `CustomerInvoiceLimitService`/`Repository` slice) drop the `a`-prefix in favor of plain camelCase (`repository`, `seedDataDal`) — this is the newer idiom's convention, distinguishable at a glance from legacy files.
- **Database objects**: tables prefixed `tbl` (`tblCustMaster`, `tblInvoice`), stored procedures prefixed `sp_` and often further prefixed by subsystem (`sp_webapi_*` for approval-log saves, `sp_web_*` for some claim saves, `sp_UD_*` for update operations).

## Structure

- Module folders repeat identically across `Solution.Web` (`*_UI`), `Library.BLL` (`*_BLL`), `Library.DAL` (`*_DAL`), and `Library.DAO` (`*_DAO`/`*_Entities`) — e.g. `SInventory_UI` ↔ `SInventory_BLL` ↔ `SInventory_DAL` ↔ `SInventory_Entities`. When adding a feature to an existing module, follow its established folder name across all four projects rather than inventing a new one.
- `Library.DAL/DataManager/` holds shared plumbing (four connection/command-execution variants, encryption helper, database-name constants) used across all module DAL folders.
- `Library.DAL/InternalCls/` holds cross-cutting utilities: `ClsPrimaryKeyFind` (computes next primary-key value via `MAX()+1` rather than IDENTITY columns, in at least some tables), `ClsCommonInternalDAL`, `clsNum2Word` (converts a decimal amount to English words in Crore/Lac/Taka/Paisa denominations, for printed documents). (`EncryptDecrypt` — unused, see [`docs/security.md`](security.md) — lives in `Library.DAL/DataManager/`, not here.)

## Data access style

- Legacy: build a `SqlCommand`, execute via one of `Library.DAL/DataManager/DataAccessManager*.cs`, return a `DataTable` all the way up to the page.
- Newer: Dapper `IDbConnection` extension methods (`.Query<T>`, `.Execute`, `.ExecuteScalar<T>`) against a named stored procedure, mapped to a typed `Model`.
- **Parameterization is inconsistent.** Most legacy DAL classes use `SqlParameter` correctly. A substantial minority build SQL by direct string concatenation of variables (session values, IDs, even a `keyword.Replace("'", "''")` manual-escaping attempt in `CustomerInvoiceLimitRepository.cs:191`) — see the full catalog in [`docs/security.md`](security.md). New code must parameterize; do not extend the concatenation pattern.

## Validation style

- Legacy UI-layer validation: a private `Validation()`/similar method on the code-behind checks each required control's `.Text` for empty string and calls a `showMessageBox("Please Input X!!")` helper, returning `false` to abort the save (e.g. `SInventory_UI/AccountSettings.aspx.cs`, `SubDepot_UI/SubdepotInfoEntry.aspx.cs`).
- Newer BLL-layer validation: a `Service` method checks each rule at the top and returns immediately with a specific message string on failure (`if (model.CustomerId <= 0) return "Customer is required.";`), falling through to `"Success"`/the repository call at the end.
- Duplicate-record checks follow one of two idioms: a dedicated `Has<Field>Name(...)` DAL method issuing a `SELECT TOP 1 ... WHERE X = @X` (e.g. `AreaDAL.HasAreaName`), or an in-memory `List<T>.Exists(x => ...)` scan after loading the full list (`CustomerInvoiceLimitService`). Both appear across the codebase; neither has fully displaced the other.
- **At least one duplicate check is silently ignored** rather than surfaced: `Library.BLL/SInventory_BLL/dadtlsCustPaymentBLL.cs` finds an existing record via `Existence(...)`, does nothing in the empty `if` block, and still returns `true` — the caller cannot tell the save was skipped. Don't copy this pattern.

## Error handling style

- Legacy: liberal empty `try { } catch { }` / `catch (Exception ex) { }` blocks around conversions and optional reads — a deliberate (if blunt) way of tolerating an unset session value or a malformed column on first load. Do not assume every catch block is dead code; some suppress expected, benign failures.
- Newer `Service` classes: catch `SqlException` specifically when its `.Number == 50000` (a `RAISERROR`-raised custom error from a stored procedure) and surface `.Message` directly to the caller; other exceptions are re-thrown after a `finally` closes the connection.
- **Swallowed exception + ignored bool return, compounding into a misleading downstream error**: `DataAccessManager.SqlConnectionOpen` caught `SqlException` and returned `false` with no rethrow, but its callers (e.g. `PanalClsDAL.Login`) never check that return value before calling a `Get*`/`Save*` method on the same instance — so a real connection failure surfaces as `InvalidOperationException("Connection is not open.")` instead of the actual `SqlException`. See `docs/database.md`'s "Data access plumbing" section for the current (temporary, unresolved as of 2026-08-06) diagnostic fix. Don't add a new call path with this shape: either check the bool, or let the exception propagate — not both silently.

## Comments

- Sparse in legacy code; English where present. Some of the newest files (`Library.DAL/DataManager/DataAccessManager.cs`) mix in Bengali-language comments, indicating recent maintenance alongside the original codebase's authorship.

## What's explicitly absent

- No `.editorconfig`, no StyleCop/analyzer configuration, no code-formatting tool config found anywhere in the repo — **Not Found**. There is no automated enforcement of any of the above; it is convention observed by reading the code, not a configured rule set.
