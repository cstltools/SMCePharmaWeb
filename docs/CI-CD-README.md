# CI/CD Pipeline — ePharma Web (Legacy ASP.NET Web Forms, .NET Framework 4.8)

## Folder structure

```
.github/
  workflows/
    ci-build-test.yml     Reusable: restore -> MSBuild build -> unit tests -> zip artifact
    development.yml        Trigger: push to develop/feature/**, PRs -> build+test only
    staging.yml             Trigger: push to staging -> build+test+deploy to Staging IIS
    production.yml          Trigger: tag v*.*.* or manual dispatch -> build+test+deploy to
                             Production IIS, gated by required-reviewer approval
    rollback.yml            Trigger: manual -> restore a prior backup to staging/production

deploy/
  scripts/
    Backup-CurrentSite.ps1     Zips the live IIS site content before a deploy overwrites it
    Set-WebConfigValues.ps1    Injects per-environment connection string / app settings
                                into Web.config inside the build artifact
    Deploy-WebDeploy.ps1        Syncs the artifact to IIS via msdeploy (Web Deploy)
    Rollback-WebDeploy.ps1      Restores a backup via msdeploy
    Test-Smoke.ps1               Post-deploy HTTP health check; failure triggers rollback
  config/                        (reserved for any future parameter templates)

docs/
  IIS-DEPLOYMENT-GUIDE.md   One-time IIS/Web Deploy/self-hosted-runner setup
  ROLLBACK-PROCEDURE.md     How automatic and manual rollback work
  GITHUB-SECRETS.md         Every secret/variable required, and where to set it
  BRANCH-PROTECTION.md      Branch + tag protection rules to configure
  CI-CD-README.md           This file
```

## Why this shape, given the actual codebase

- `Solution.Web` is an **AspNetCompiler Website project** (see its entry in
  `Solution.sln`), not a Web Application Project — so there's no
  `Solution.Web.csproj` and no MSBuild `Web.Release.config` XDT transform
  support. `ci-build-test.yml` builds the whole `.sln` with MSBuild (which
  invokes AspNetCompiler for the web project per the `.sln`'s embedded
  `AspNetCompiler.*` properties), and `Set-WebConfigValues.ps1` handles
  per-environment config values by editing the built `Web.config` directly —
  the standard substitute for Website projects.
- Target framework is `v4.8` (confirmed from the four library projects'
  `.csproj` files — `Solution.Web/packages.config` itself targets `net40`,
  a mismatch worth knowing about but not a build blocker), so the pipeline
  runs on `windows-latest`, which ships Visual Studio Build Tools with the
  legacy .NET Framework 4.x targeting packs preinstalled — no separate
  "install Build Tools" step needed.
- The IIS servers referenced in `Web.config`'s (commented-out) connection
  strings are on-prem/private hosts (`NASA-PC`, internal IPs) — **GitHub-hosted
  runners cannot reach them**, so all `deploy` jobs run on **self-hosted
  runners** registered with `staging`/`production` labels (see
  `IIS-DEPLOYMENT-GUIDE.md` §3).

## Step-by-step: what each workflow does and why

### `ci-build-test.yml` (reusable)
1. **Checkout** — full history pulled for consistency; not strictly required
   but avoids surprises if later steps need tags/commits.
2. **Setup MSBuild** (`microsoft/setup-msbuild`) — puts `msbuild.exe` for the
   installed VS Build Tools version on `PATH`.
3. **Setup NuGet CLI** — classic `packages.config`-style restore is used
   because these `.NET Framework` (4.8, with `Solution.Web` on `net40`)
   libraries predate `PackageReference`.
4. **Cache NuGet packages** — keyed on `packages.config` hash, to speed up
   repeat runs.
5. **NuGet restore** — `nuget restore Solution.sln`.
6. **MSBuild build** — builds `Solution.sln` in the given configuration;
   `UseWPP_CopyWebApplication` + the `.sln`'s `AspNetCompiler` metadata
   produce the precompiled site under `PrecompiledWeb\Solution.Web`.
7. **Discover test projects** — greps `.csproj` files for MSTest/NUnit/xUnit
   package references so the pipeline **degrades gracefully** if no test
   project exists yet (per the "if available" requirement) instead of
   failing the build.
8. **Run unit tests** — `vstest.console.exe` against any `*Tests.dll`,
   producing a `.trx` result file.
9. **Upload test results** — always attempted, ignored if no tests ran.
10. **Package precompiled site** — zips `PrecompiledWeb\Solution.Web` as the
    single build artifact carried between jobs/workflows.
11. **Upload build artifact** — retained 30 days, shared with the calling
    workflow's `deploy` job.

### `development.yml`
Build+test only, on `develop`/`feature/**` pushes and PRs into `develop`/
`main`. No IIS involved — this environment is for fast feedback, not a
persistent server in this pipeline (add a `deploy` job here later, pointed
at a Dev IIS box, following the same pattern as `staging.yml`, if one
exists).

### `staging.yml`
1. Calls `ci-build-test.yml` (Release config).
2. `deploy` job (self-hosted, `staging` label):
   - **Backup** current site.
   - **Apply config** (connection string / app settings) into the artifact.
   - **Deploy via Web Deploy**.
   - **Smoke test**.
   - **Automatic rollback** if any prior step failed.

### `production.yml`
Same shape as staging, plus:
- Triggers only on **version tags** (`v*.*.*`) or **manual dispatch with a
  typed confirmation** (`"deploy"`) — never on a plain push, to keep
  production releases deliberate.
- The `deploy` job uses the `production` **GitHub Environment**, which is
  where the **manual-approval gate** lives: configure required reviewers
  there (see `GITHUB-SECRETS.md`) and GitHub will pause the job until they
  approve, before any deploy step runs.

### `rollback.yml`
Standalone, manually triggered, for rolling back a release that passed
smoke tests but was later found broken. See `ROLLBACK-PROCEDURE.md`.

## Setup checklist

1. Read `docs/IIS-DEPLOYMENT-GUIDE.md` and provision Web Deploy + a
   self-hosted runner per environment.
2. Add all secrets/variables from `docs/GITHUB-SECRETS.md`.
3. Apply branch/tag protection from `docs/BRANCH-PROTECTION.md`.
4. Rotate the plaintext `sa` credentials currently committed in
   `Solution.Web/Web.config` — they should live only in GitHub Secrets going
   forward.
5. Push to `develop` to validate CI; push to `staging` to validate the full
   deploy+rollback path in a low-risk environment before trusting it for
   Production.
