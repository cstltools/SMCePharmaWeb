# IIS Deployment Guide

This pipeline deploys a **precompiled ASP.NET Web Site project** (`Solution.Web`,
built via `AspNetCompiler` — not a Web Application Project) to IIS using
**Web Deploy (msdeploy)**. The four class-library projects (`Library.DAL`,
`Library.BLL`, `Library.DAO`, `Library.CrystalReports`) target .NET Framework
4.8; `Solution.Web/packages.config` itself targets `net40` (a version
mismatch worth knowing about, not necessarily a build blocker) — see
[`deployment.md`](deployment.md). This is one-time setup per server.

## 1. Prerequisites on each target IIS server (Staging / Production)

1. **IIS** with the ASP.NET 4.8 feature enabled (covers the `net40`/`v4.8`
   mix above — the 4.5–4.8 in-place CLR update services both).
2. **Web Deploy 3.6** installed (enables both the client `msdeploy.exe` and,
   if the server IS the deploy target, the **Web Management Service (WMSvc)**):
   - Download: https://www.iis.net/downloads/microsoft/web-deploy
   - During install, check "Complete" (includes remote agent service).
3. Enable and start the **Web Management Service**:
   ```powershell
   Set-Service WMSVC -StartupType Automatic
   Start-Service WMSVC
   ```
   Confirm it's listening on TCP **8172** (the port used by
   `deploy/scripts/Deploy-WebDeploy.ps1` and `Rollback-WebDeploy.ps1`).
4. Create a **dedicated deployment Windows account** (e.g.
   `DEPLOY\svc-webdeploy`) with:
   - IIS Manager Permissions on the target site only
     (IIS Manager → site → IIS Manager Permissions → Allow User).
   - NOT a full local administrator — least privilege.
5. **Firewall**: allow inbound TCP 8172 from the self-hosted runner's IP only.

## 2. Create the IIS site (one-time, manual)

```powershell
Import-Module WebAdministration
New-Item -Path "IIS:\Sites\ePharma-Staging" -PhysicalPath "D:\Sites\ePharma-Staging" -Bindings @{protocol="https";bindingInformation="*:443:staging.epharma.example.com"}
```

Repeat for Production with its own site name/binding/path. The site names you
choose here are the values you'll put in `STAGING_IIS_SITE_NAME` /
`PRODUCTION_IIS_SITE_NAME` secrets.

Runtime data folders that already live under `Solution.Web/` (`App_Data`,
`PrescriptionImages`, `ExcelFiles`, `APK_File`, etc.) should be excluded from
being wiped on each deploy — that's what `-enableRule:DoNotDeleteRule` in
`Deploy-WebDeploy.ps1` protects. If you need per-folder exclusions instead,
switch to `-skip:objectName=dirPath,absolutePath=<pattern>`.

## 3. Self-hosted runner (required — see below)

GitHub-hosted `windows-latest` runners are ephemeral cloud VMs with **no
network path** to an on-prem/private IIS server. The `deploy` jobs in
`staging.yml` / `production.yml` therefore target a **self-hosted runner**:

```yaml
runs-on: [self-hosted, windows, staging]     # or: production
```

Register one Windows runner per environment (can be the IIS box itself, or a
jump host with network access to it and Web Deploy client installed):

```powershell
# On the runner machine, from a repo Settings > Actions > Runners > New runner
./config.cmd --url https://github.com/<org>/<repo> --token <token> --labels self-hosted,windows,staging
./run.cmd
```

Install on that runner: PowerShell 7+ (or use Windows PowerShell, already
present), and the Web Deploy 3.6 **client** (same installer as above).

## 4. How a deploy actually flows

1. `ci-build-test.yml` builds `Solution.sln` in Release, producing
   `PrecompiledWeb\Solution.Web`, zipped as `site-package.zip`.
2. `Backup-CurrentSite.ps1` snapshots the live site on the target server.
3. `Set-WebConfigValues.ps1` edits `Web.config` inside the artifact to inject
   the environment's connection string / app settings (see note below on why
   this replaces XDT transforms).
4. `Deploy-WebDeploy.ps1` runs `msdeploy -verb:sync` from the runner to the
   target server's WMSvc endpoint (`https://<server>:8172/msdeploy.axd`).
5. `Test-Smoke.ps1` requests `Login.aspx` and fails the job if it's not
   healthy — which triggers `Rollback-WebDeploy.ps1` automatically.

## 5. Why config values are injected via XML edit, not Web.config transforms

`Solution.Web` is referenced in `Solution.sln` as an **AspNetCompiler
website project** (`Project("{E24C65DC-...}") = "Solution.Web"`), not a
`Microsoft.WebApplication.targets`-based Web Application Project. XDT
transforms (`Web.Release.config`, etc.) are a WAP/MSBuild feature and are not
applied by `aspnet_compiler.exe`. Editing the built artifact's `Web.config`
directly (as `Set-WebConfigValues.ps1` does) is the standard equivalent for
this project type, and keeps the source `Web.config` in git free of any
per-environment values.
