# Deployment

## Build

`Solution.Web` is registered in `Solution.sln` as an **AspNetCompiler Website project** (`Project("{E24C65DC-...}") = "Solution.Web"`), not a Web Application Project — there is no `Solution.Web.csproj`. MSBuild drives `aspnet_compiler` through `AspNetCompiler.*` properties embedded directly in the `.sln` file (`Debug.AspNetCompiler.PhysicalPath`, `.TargetPath = "PrecompiledWeb\Solution.Web\"`, etc.), producing a precompiled site under `PrecompiledWeb\Solution.Web`.

```powershell
nuget restore Solution.sln
msbuild Solution.sln /p:Configuration=Release
```

Package restore is classic `packages.config` (`Solution.Web/packages.config` targets `net40`; the four library `.csproj`s target `v4.8` — a version mismatch, not necessarily a build blocker but worth knowing about).

Because this is a Website project, **XDT config transforms (`Web.Release.config`) do not apply** — `aspnet_compiler.exe` doesn't support them. Per-environment configuration is instead applied by editing the built `Web.config` directly after compilation.

## Documented CI/CD pipeline (not implemented)

`docs/CI-CD-README.md`, `docs/IIS-DEPLOYMENT-GUIDE.md`, `docs/ROLLBACK-PROCEDURE.md`, `docs/GITHUB-SECRETS.md`, `docs/BRANCH-PROTECTION.md`, and five scripts under `deploy/scripts/` (`Backup-CurrentSite.ps1`, `Set-WebConfigValues.ps1`, `Deploy-WebDeploy.ps1`, `Rollback-WebDeploy.ps1`, `Test-Smoke.ps1`) together describe a complete GitHub Actions pipeline:

- `ci-build-test.yml` (reusable): checkout → setup MSBuild → NuGet restore → build → discover/run tests if present → package `PrecompiledWeb\Solution.Web` as a zip artifact.
- `development.yml`: build+test only, on `develop`/`feature/**` pushes and PRs.
- `staging.yml`: build+test, then backup current site → inject config values → deploy via Web Deploy (`msdeploy`) → smoke test → automatic rollback on failure.
- `production.yml`: same shape, gated to version tags (`v*.*.*`) or manual dispatch with typed confirmation, plus a GitHub Environment manual-approval gate.
- `rollback.yml`: standalone manual rollback.

**This `.github/workflows/` directory does not exist in the repository.** The documentation and supporting scripts are written and internally consistent; the workflow YAML that would actually trigger them on GitHub Actions is the missing piece. Treat the docs as a design spec, not a description of a working pipeline, until that directory is added.

Deployment target per the docs: on-prem/private IIS servers reachable only from **self-hosted runners** (`runs-on: [self-hosted, windows, staging|production]`) via Web Deploy 3.6 (`msdeploy.axd` over TCP 8172), since GitHub-hosted runners have no network path to servers like `NASA-PC` or the other internal IPs referenced in commented-out connection strings.

Per `docs/CI-CD-README.md`'s own setup checklist: rotating the plaintext `sa` credentials currently committed in `Solution.Web/Web.config` into GitHub Secrets is listed as a required step before this pipeline should be trusted — see [`security.md`](security.md).

## Docker (local/dev)

**Currently missing from the working tree.** `docker-compose.yml` and `docker-compose.prod.yml` are
tracked by git but do not exist on disk in this checkout as of this pass (confirmed via `git status`
showing them as locally deleted, alongside ~45 other root-level `.sql`/`.ps1`/`.txt` files) — the
description below is reconstructed from git history / what the tracked files were expected to
contain, not verified against a file currently present. If you need to restore them, `git checkout
-- docker-compose.yml docker-compose.prod.yml` will bring back the last-committed version; confirm
with whoever deleted them first, since a large simultaneous deletion of root scripts is unusual and
may be intentional cleanup rather than an accident.

Both files, when present, define a two-service stack:

- `sqlserver`: `mcr.microsoft.com/mssql/server:2019-latest`, `SA_PASSWORD` from `MSSQL_SA_PASSWORD` env var (default `Password123!` in the dev file), volume-persisted.
- `web`: built from the repo's `Dockerfile` (`mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019`, **Windows containers only**), copies `./Solution.Web` into `/inetpub/wwwroot`, exposes port 80.

`docker-compose.yml` maps the web service to host port 8080 and starts from an **empty** SQL Server container — no schema/seed script runs automatically (see [`database.md`](database.md)). `docker-compose.prod.yml` maps to host port 80 and requires the `MSSQL_SA_PASSWORD`/`DB_NAME` env vars to be supplied (no defaults) — a `.env` file following `.env.example`'s shape is the expected mechanism, though nothing in the repo automates provisioning that file.

This Docker path is separate from, and not obviously wired into, the IIS/Web Deploy pipeline described above — **Not Found**: no evidence either feeds the other.

## Manual IIS setup (per `docs/IIS-DEPLOYMENT-GUIDE.md`)

One-time per target server: install IIS + ASP.NET 4.8 feature, install Web Deploy 3.6 (client + Web Management Service), create a dedicated least-privilege deployment Windows account, open TCP 8172 to the runner's IP only, create the IIS site with `New-Item -Path "IIS:\Sites\..."`, and exclude runtime data folders (`App_Data`, `PrescriptionImages`, `ExcelFiles`, `APK_File`) from being wiped on each deploy via Web Deploy's `DoNotDeleteRule`.

## Rollback

Per `docs/ROLLBACK-PROCEDURE.md` (design-stage, same caveat as above): `Backup-CurrentSite.ps1` snapshots the live site before each deploy; `Test-Smoke.ps1` requests `Login.aspx` post-deploy and triggers `Rollback-WebDeploy.ps1` automatically on failure; `rollback.yml` provides a standalone manual trigger for a later-discovered issue.
