# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

ePharma — a distribution/inventory management system for a pharma company (customers, invoices,
stock/warehouse transfers, doctor/field-force visits, target setup, approvals). Legacy **ASP.NET
Web Forms** app on **.NET Framework 4.8**, backed by **MS SQL Server** (mostly via stored
procedures). A companion Flutter mobile app (`clickpharma_flutter`, referenced in `.agents/AGENTS.md`)
lives outside this repo and talks to the `.asmx`/`.ashx` endpoints here.

## Solution structure

`Solution.sln` has 5 projects, three-tier:

- **`Solution.Web`** — the UI. An **AspNetCompiler Website project**, not a Web Application
  Project: there is no `Solution.Web.csproj` (see `website.publishproj` instead). This matters for
  builds/deploys — no MSBuild `Web.*.config` XDT transforms apply to it; per-environment config is
  injected by editing the built `Web.config` directly (`deploy/scripts/Set-WebConfigValues.ps1`).
  Pages are organized by feature into `*_UI` folders (`Approval_UI`, `DoctorMaster_UI`,
  `MasterSetup_UI`, `SInventory_UI`, `SubDepot_UI`, `Target_UI`, `DWSP`, `Dashboard_UI`, etc.) as
  WebForms `.aspx`/`.aspx.cs` code-behind pairs. Cross-cutting request handlers are `.ashx`
  (`PictureHandler.ashx`, `SignatureHandler.ashx`) and `.asmx`-style `[WebService]` classes in
  `App_Code/` (e.g. `SInventoryWebService.cs`) — these are what the Flutter app and jQuery
  autocomplete widgets call.
- **`Library.DAO`** — plain data-holder classes (entities/view models), organized by module
  (`SInventory_Entities`, `DoctorModule_DAO`, `MasterSetup_DAO`, `UserRoleDAO`, ...). No logic.
- **`Library.DAL`** — data access, organized to mirror `DAO`'s module folders. Most DAL classes
  build ADO.NET `SqlCommand`s that call stored procedures; connection setup goes through
  `Library.DAL/DataManager/DataAccessManager*.cs` / `DataBase.cs`. A few newer classes use
  **Dapper** directly (e.g. `SInventoryWebService.cs`) instead.
- **`Library.BLL`** — business logic, called from `Solution.Web` code-behind. Older BLL classes are
  thin pass-throughs to the matching DAL class. Newer ones follow a
  `Service` → `Repository` (in `Library.DAL`) → `Model`/`ViewModel` (in `Library.DAO`) shape instead
  of the old BLL/DAL/DAO split — see `Library.BLL/MasterSetup_BLL/CustomerInvoiceLimitService.cs` as
  the reference example, including its inline validation style (return a string error message
  instead of throwing).
- **`Library.CrystalReports`** — Crystal Reports report definitions/logic, surfaced through
  `Solution.Web/Reports*` and `crystalreportviewers13`.

A large amount of business logic lives in **stored procedures** in the SQL Server database itself,
not in C#. The many loose `sp_*.sql` / `sp*.txt` / `*_utf8.txt` files and `alter_*.sql` /
`update_sps_*.sql` scripts at the repo root are working copies of stored procedure source used when
iterating on procs outside SSMS — they are not applied automatically by any build step.

## Database access — hardcoded, environment-specific credentials

There is no environment-variable-driven DB config despite `.env.example`/`docker-compose*.yml`
existing. Connection details are hardcoded in multiple places and you will find **different**
servers/passwords in each depending on when it was last pointed somewhere:

- `Solution.Web/web.config` → `connectionStrings` → `SolutionConnectionStringSSIDB` (used by
  ADO.NET/Dapper code that reads `ConfigurationManager.ConnectionStrings`).
- `Library.DAL/DataManager/SqlUserAccess.cs` → `DataSource`/`UserName`/`PassWord` static fields
  (used by the older DataAccessManager-based DAL code; also has `BASE_URL` for REST calls to a
  separate API host). Many prior server/credential combos are left commented out above the active
  one — check which block is actually uncommented before assuming which DB you're pointed at.
  `LiveServer` toggles between environments in some call sites.
  `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` is an older, simpler version of the same idea.
- The root `*.ps1` scripts (`runsql.ps1`, `run_customer_invoice_limit.ps1`,
  `test_crud_invoice_not_binding.ps1`, `backup_db.ps1`, etc.) each embed their own connection
  string literal, again not necessarily matching the two above.

When adding a new DAL class or script, match whichever connection source the sibling files in that
same folder already use — don't introduce a fourth pattern.

## Build

This is a Windows-only, MSBuild/Visual Studio build — there's no cross-platform CLI build.

```powershell
nuget restore Solution.sln
msbuild Solution.sln /p:Configuration=Release
```

MSBuild's `AspNetCompiler` step (driven by `Solution.sln`'s embedded `AspNetCompiler.*` properties
on the `Solution.Web` entry) produces the precompiled site under `PrecompiledWeb\Solution.Web`.
Package restore is classic `packages.config`-style (pre-`PackageReference`), matching the `net40`
target listed in `Solution.Web/packages.config` even though the library projects target v4.8.

## Testing

There is no automated test project (no MSTest/NUnit/xUnit `.csproj` in the solution) — CI is
documented to "degrade gracefully" and skip the test step if none is found
(`docs/CI-CD-README.md`). In practice, verification happens through standalone PowerShell scripts
that connect straight to a real SQL Server instance, exercise stored procedures end-to-end (insert
→ list → get → update → delete), and print pass/fail to the console —
`test_crud_invoice_not_binding.ps1` is the template to follow for testing new stored-proc-backed
features:

```powershell
./test_crud_invoice_not_binding.ps1
```

Point it at a dev/staging database, not production — these scripts execute real
inserts/updates/deletes.

## CI/CD and deploy — docs describe a pipeline that isn't wired up yet

`docs/CI-CD-README.md`, `docs/IIS-DEPLOYMENT-GUIDE.md`, `docs/ROLLBACK-PROCEDURE.md`,
`docs/GITHUB-SECRETS.md`, and `docs/BRANCH-PROTECTION.md`, plus `deploy/scripts/*.ps1`
(`Backup-CurrentSite.ps1`, `Deploy-WebDeploy.ps1`, `Rollback-WebDeploy.ps1`,
`Set-WebConfigValues.ps1`, `Test-Smoke.ps1`), describe a full GitHub Actions pipeline
(`.github/workflows/ci-build-test.yml`, `development.yml`, `staging.yml`, `production.yml`,
`rollback.yml`) targeting self-hosted runners with IIS/Web Deploy. **That `.github/workflows`
directory does not exist in this repo** — read those docs as the intended design, not as a
description of what currently runs. If asked to wire up CI, the workflow files are the missing
piece; the supporting scripts and docs are already written.

Local/dev deploy also exists as a Docker path: `docker-compose.yml` builds `Dockerfile`
(`mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019`, Windows containers
only) and runs it alongside a `mssql/server:2019` container.

## Conventions

- Preserve existing function signatures and UI element IDs — WebForms code-behind binds to markup
  by ID, and other code/stored procs may already depend on existing method signatures.
- Prefer stored procedures over inline SQL for new data access, consistent with the rest of the
  codebase — but Dapper against raw SQL is an accepted pattern in newer code
  (`SInventoryWebService.cs`, `CustomerInvoiceLimitService.cs`'s repository) when a stored proc
  would be overkill.
- Auth is ASP.NET Forms Authentication with in-process session state (`web.config`:
  `authentication mode="Forms"`, `sessionState mode="InProc"`); several DAL/service calls read
  identifiers like `ComUnitId` straight out of `Session`, so code exercised outside a real request
  (e.g. a console/PowerShell test) won't have that context available.
