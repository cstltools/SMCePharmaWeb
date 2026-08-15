# Required GitHub Secrets & Variables

Configure these under **Settings → Environments** for `staging` and
`production` respectively (environment-scoped secrets, not repo-level, so
staging credentials can never leak into a production run or vice versa).

## Secrets (per environment: staging / production)

| Secret | Example | Used by |
|---|---|---|
| `STAGING_SERVER_HOST` / `PRODUCTION_SERVER_HOST` | `iis-staging.internal.local` | Deploy, Rollback |
| `STAGING_IIS_SITE_NAME` / `PRODUCTION_IIS_SITE_NAME` | `ePharma-Staging` | Backup, Deploy, Rollback |
| `STAGING_DEPLOY_USER` / `PRODUCTION_DEPLOY_USER` | `DEPLOY\svc-webdeploy` | Deploy, Rollback |
| `STAGING_DEPLOY_PASSWORD` / `PRODUCTION_DEPLOY_PASSWORD` | *(strong, rotated password)* | Deploy, Rollback |
| `STAGING_BACKUP_PATH` / `PRODUCTION_BACKUP_PATH` | `D:\Backups\ePharma\Staging` | Backup, Rollback |
| `STAGING_DB_CONNECTION_STRING` / `PRODUCTION_DB_CONNECTION_STRING` | full ADO.NET connection string | Set-WebConfigValues |
| `STAGING_APP_SETTINGS_JSON` / `PRODUCTION_APP_SETTINGS_JSON` | `{"Environment":"Staging"}` | Set-WebConfigValues |

## Variables (non-secret, per environment)

| Variable | Example | Used by |
|---|---|---|
| `STAGING_SITE_URL` / `PRODUCTION_SITE_URL` | `https://staging.epharma.example.com` | Smoke test, environment URL link in Actions UI |

## Setting them up

```
Settings → Environments → New environment → "staging"
  - Add environment secrets listed above
  - Add environment variable STAGING_SITE_URL
  - (optional) Required reviewers - recommended even for staging if it's shared

Settings → Environments → New environment → "production"
  - Add environment secrets listed above
  - Add environment variable PRODUCTION_SITE_URL
  - Required reviewers: add at least 1-2 people who must approve every
    production deploy - THIS is what enforces "Manual approval before
    Production deployment"
  - Optionally restrict to protected branches / tags only (Deployment branches
    and tags → Selected branches and tags → pattern "v*.*.*")
```

## Never store in Web.config or the repo

The committed `Web.config` in the repo currently has plaintext SQL
credentials — and not only in the commented-out `connectionStrings` history
(a dozen-plus prior servers, all with plaintext `sa` passwords): the single
**active, uncommented** entry also carries a plaintext `sa` password for its
current target server. These should be removed from git history and
rotated, since anyone with repo read access can see them. Going forward,
only the GitHub Secrets above should carry real credentials; `Web.config` in
source control should contain placeholder/dev values only.
