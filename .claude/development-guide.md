# Development Guide

## Prerequisites

- Windows (the build is MSBuild/AspNetCompiler-based; there is no cross-platform CLI path — **Not Found** for any Linux/macOS build instructions).
- Visual Studio (2010-era `.sln` format) or MSBuild + NuGet CLI on PATH.
- .NET Framework 4.8 targeting pack (library projects) — `Solution.Web/packages.config` itself targets `net40`, a mismatch to be aware of, not necessarily a blocker.
- Access to a SQL Server 2019 instance with the `SalesDisDB_SMC_NEWDB` database (or an equivalent schema) restored — this repo does not contain a schema dump or seed script (see [`docs/database.md`](../docs/database.md)).

## Getting a database to point at

There is no seed/migration script in this repo. Options, in order of how well they're supported by what's actually here:

1. Restore a copy of the live/staging database (ask whoever owns the SQL Server instance referenced in `Library.DAL/DataManager/SqlUserAccess.cs`).
2. Use `docker-compose.yml`, which spins up a bare `mcr.microsoft.com/mssql/server:2019-latest` container — but this starts **empty**; no `.sql` file in this repo will fully populate it (the root `sp*.sql`/`alter_*.sql` files are stored-procedure definitions only, not a schema or seed data).

## Pointing the app at your database

Update **one of these**, matching whichever the code path you're working on actually reads (see [`docs/database.md`](../docs/database.md) for which files use which):

- `Solution.Web/web.config` → `connectionStrings/SolutionConnectionStringSSIDB`
- `Library.DAL/DataManager/SqlUserAccess.cs` → `DataSource`/`UserName`/`PassWord`
- `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` → `DataSource`/`UserId`/`Password`

Do not assume changing one updates the others — they are independent and already out of sync with each other in the checked-in state.

## Build

```powershell
nuget restore Solution.sln
msbuild Solution.sln /p:Configuration=Release
```

`Solution.Web` is an AspNetCompiler Website project (no `.csproj`); MSBuild drives `aspnet_compiler` via properties embedded in `Solution.sln`, producing `PrecompiledWeb\Solution.Web`. See [`docs/deployment.md`](../docs/deployment.md) for the full explanation and the IIS/Docker run paths.

## Running locally

Two documented paths:

1. **IIS** — deploy/point an IIS site at `Solution.Web` (or the precompiled output) directly; this is a classic ASP.NET Web Forms app, so F5-debugging from Visual Studio against IIS Express is the conventional flow for this project type (**Not Found**: no explicit `.vs`/launch-profile instructions checked into the repo confirming this — inferred from the project type).
2. **Docker** — `docker-compose up` using `docker-compose.yml` (dev) builds a Windows-container IIS image from `Dockerfile` and a `mssql/server:2019` container together. Requires Docker Desktop in Windows-container mode (Windows-only).

## Debugging tips specific to this codebase

- Every page under one of the three `MasterPages/*.master` files redirects to `Login.aspx` if `Session["UserId"]` is empty — if you're debugging a page directly (e.g. by URL) and get bounced to login unexpectedly, you likely have no active session, not a bug in the page itself.
- Many pages read `Session["ComUnitId"]`, `Session["UserType"]`, etc. without a null check and will throw a `NullReferenceException` if hit without going through `Login.aspx` first (see the pattern in `SInventoryWebService.cs`'s `GetSubDepotInvoiceNo`/`GetAllInvoice`/etc.). Always log in through the UI before exercising a page or web-service method directly.
- If a query behaves differently than expected, check which of the four `DataAccessManager*` classes (`DataAccessManager`, `DataAccessManagerAsync`, `DataAccessManagerOld`, `DataAccessManager_daaw`) the DAL class in question uses — they are not perfectly equivalent (e.g. only the `_daaw`/async-oriented one sets `Encrypt=True;TrustServerCertificate=True`, per [`docs/database.md`](../docs/database.md)).

## Testing changes

No automated test project exists. The established pattern is a standalone PowerShell script that opens a real SQL connection and exercises stored procedures end-to-end — see [`docs/testing.md`](../docs/testing.md) and use `test_crud_invoice_not_binding.ps1` as the template. Point any such script at a dev/staging database, never production.

## Where things live (quick index)

| Looking for... | Look in |
|---|---|
| A page's server-side logic | `Solution.Web/<Module>_UI/<Page>.aspx.cs` |
| Business rules/validation | `Library.BLL/<Module>_BLL/` |
| Raw data access / stored proc calls | `Library.DAL/<Module>_DAL/` |
| Entity/DTO field lists | `Library.DAO/<Module>_DAO/` or `_Entities/` |
| A Crystal Report's data shape | `Library.CrystalReports/<Module>_DS/` (typed DataSet), `.rpt` file under `Solution.Web/Reports/CrystalReports/` |
| Menu/permission grants | `Library.DAL/PanalCls/PanalClsDAL.cs`, `Solution.Web/CommonUI/UserPermission.aspx.cs` |
| Approval routing rules | `Library.DAO/UserRoleDAO/ApprovalMapMaster.cs`, `Library.DAL/UserRoleDAL/ApprovalMapDAL.cs` |
