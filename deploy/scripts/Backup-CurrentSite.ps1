<#
.SYNOPSIS
  Snapshots the currently-live IIS site content into a timestamped zip before
  a new deployment overwrites it, so Rollback-WebDeploy.ps1 has something to
  restore. Must run ON or WITH network access to the target IIS server
  (i.e. from the self-hosted runner registered against that environment).

.PARAMETER SiteName
  IIS site name (e.g. "ePharma-Staging"). Used to look up the site's physical
  path via the WebAdministration module.

.PARAMETER BackupRoot
  Folder where backup zips are stored. Keep this OUTSIDE the site's physical
  path. Recommended: a fixed local path such as D:\Backups\ePharma\<env>.

.PARAMETER Tag
  Optional label (e.g. a git tag) appended to the backup filename so a
  production backup can be tied back to the release it preceded.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$SiteName,
    [Parameter(Mandatory = $true)][string]$BackupRoot,
    [string]$Tag = ""
)

$ErrorActionPreference = "Stop"

Import-Module WebAdministration

$site = Get-Website -Name $SiteName
if (-not $site) {
    throw "IIS site '$SiteName' was not found on this server."
}

$physicalPath = $site.PhysicalPath
if (-not (Test-Path $physicalPath)) {
    throw "Physical path '$physicalPath' for site '$SiteName' does not exist."
}

if (-not (Test-Path $BackupRoot)) {
    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$suffix = if ($Tag) { "-$Tag" } else { "" }
$backupFile = Join-Path $BackupRoot "backup-$timestamp$suffix.zip"

Write-Host "Backing up '$physicalPath' -> '$backupFile'"
Compress-Archive -Path (Join-Path $physicalPath '*') -DestinationPath $backupFile -Force

# Record this as the most recent backup so Rollback-WebDeploy.ps1 can find it
# without needing the timestamp passed in explicitly.
$latestPointer = Join-Path $BackupRoot "LATEST.txt"
Set-Content -Path $latestPointer -Value (Split-Path $backupFile -Leaf) -NoNewline

# Retain the last 10 backups only, to bound disk usage.
Get-ChildItem -Path $BackupRoot -Filter "backup-*.zip" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip 10 |
    Remove-Item -Force

Write-Host "Backup complete: $backupFile"
