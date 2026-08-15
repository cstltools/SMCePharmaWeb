# Testing

## Automated tests: none

There is no MSTest/NUnit/xUnit project in `Solution.sln`, and no test-specific `.csproj` anywhere in the repository. `docs/CI-CD-README.md` (part of the documented-but-unimplemented CI pipeline, see [`deployment.md`](deployment.md)) explicitly designs around this absence: its build workflow "discovers test projects" by grepping `.csproj` files for MSTest/NUnit/xUnit package references and **degrades gracefully** (skips the test step) if none are found.

## What actually verifies behavior

**Corrected this revision — one root-level `.ps1` script now exists.** `test_adjustment_amount_allocation.ps1` was added in commit `9be1a9c` (2026-08-15, the same commit that fixed `AdjustmentAmount()`'s credit-allocation bug in `InvoiceCreationForCustomerByOrder.aspx.cs`) — confirmed via `git status`/`ls *.ps1` at the repo root. It's a different shape from the DB-connected scripts described below: a pure arithmetic self-check with **no `SqlConnection`/database dependency at all**. It re-implements the sequential MIN-based allocation algorithm (`Allocate-Adjustment`) and asserts it against four worked examples from the business-requirement spec, throwing on mismatch (`Assert-Equal`) — run it directly with `./test_adjustment_amount_allocation.ps1`.

Beyond that one script, the DB-connected scripts this section originally described are still absent: they were present at the initial import (`88e052d`) but were deleted by commit `ddd28c0` ("Point CustPayment flow and DB config at local dev DB; clean up scratch scripts"), which also removed `docker-compose*.yml`, and have not been restored since. `deploy/scripts/*.ps1` (Web Deploy/backup/rollback/smoke-test scripts, see [`deployment.md`](deployment.md)) are unrelated to this and still exist, but they're deploy tooling, not stored-proc verification.

The pattern those deleted scripts followed is still the documented approach for verifying stored-proc-backed changes end-to-end (as opposed to the pure-logic, no-DB style of the current script above), and is worth recreating on demand rather than treated as gone for good: a standalone PowerShell script that opens a real `SqlConnection` against a live SQL Server instance and exercises stored procedures directly, end-to-end, printing results to the console. Not part of any build step — run manually.

The clearest former example, `test_crud_invoice_not_binding.ps1` (deleted, recoverable via `git show ddd28c0~1:test_crud_invoice_not_binding.ps1` if needed as a starting template), followed this shape:

```powershell
$connStr = "Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;..."
# 1. Find/derive a test customer via sp_GetCustomerAutoComplete
# 2. Insert via sp_InsertInvoiceNotBinding
# 3. List via sp_GetInvoiceNotBindingList
# 4. GetById via sp_GetInvoiceNotBindingById
# 5. Update via sp_UpdateInvoiceNotBinding
# 6. Re-fetch and print the updated row
# 7. Delete via sp_DeleteInvoiceNotBinding
```

Other now-deleted root-level scripts served narrower verification/operational purposes rather than full CRUD cycles: `check_sp.ps1`, `get_sp.ps1`, `get_cols.ps1`, `get_cust_cols.ps1`, `get_menu.ps1` (schema/definition introspection), `run_customer_invoice_limit.ps1`, `run_sales_return_script.ps1`, `update_sp_reject.ps1` (apply a specific script and presumably eyeball the result). All are still recoverable from git history (`ddd28c0~1`) if a similar check is needed again.

## Implications for changes

- **Point test scripts at a dev/staging database, never production** — they perform real inserts/updates/deletes.
- There is no regression safety net. A change to a shared helper (e.g. one of the four `DataAccessManager*` classes, or `ClsPrimaryKeyFind`) has no automated coverage; manual verification through the UI or a targeted script is the only option currently available.
- If a task specifically calls for adding test coverage, there is no existing test project to extend — one would need to be created from scratch, which is a larger decision than a typical code change (framework choice, project wiring into a Website-model solution) and should be raised explicitly rather than assumed.

## UI-level testing

**Not Found** — no Selenium/Playwright/UI-automation project, config, or script found anywhere in the repository.

## Load/performance testing

**Not Found** — no load-testing scripts, JMeter/k6 configs, or performance benchmarks found.
