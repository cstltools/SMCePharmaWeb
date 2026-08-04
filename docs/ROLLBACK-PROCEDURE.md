# Rollback Procedure

## Automatic rollback

Both `staging.yml` and `production.yml` run `deploy/scripts/Test-Smoke.ps1`
immediately after deploy. If it fails (site doesn't return HTTP 200 within
~1 minute), the workflow's `Automatic rollback on failure` step runs
`Rollback-WebDeploy.ps1`, which restores the backup `Backup-CurrentSite.ps1`
took immediately before that deploy. No human action needed for this path —
check the failed workflow run's logs to see what triggered it.

## Manual rollback (bad release discovered later)

If a release passes smoke tests but is later found to be broken:

1. Go to **Actions → Manual Rollback → Run workflow**.
2. Choose the environment (`staging` or `production`).
3. Leave **backup-name** blank to restore the most recent backup, or supply
   a specific filename (see step 4) to restore an older one.
4. To list available backups, RDP/PSRemote into the target server and run:
   ```powershell
   Get-ChildItem "<BackupRoot>" -Filter "backup-*.zip" | Sort-Object LastWriteTime -Descending
   ```
   `<BackupRoot>` is the value of `STAGING_BACKUP_PATH` /
   `PRODUCTION_BACKUP_PATH` secrets.
5. For **production**, the rollback job still requires approval from the
   `production` environment's required reviewers, same as a forward deploy.

## After any rollback

1. Do **not** re-trigger the same tag/branch until the underlying issue is
   fixed — rolling back only restores files, it does not revert the branch
   or delete the bad tag.
2. Investigate using the failed run's build/test/smoke-test logs.
3. Fix, re-tag (production) or re-push (staging), and re-run the normal
   deploy workflow.
4. Backups are retained as the last 10 per environment
   (`Backup-CurrentSite.ps1` prunes older ones automatically) — don't rely
   on rolling back more than 10 releases without a manual off-box copy.

## Database changes

This pipeline only rolls back **application files**, not the database. If a
release included schema changes or destructive data migrations, rollback
also requires a corresponding down-migration or restore from a DB backup —
plan and test that alongside any release that touches the schema.
