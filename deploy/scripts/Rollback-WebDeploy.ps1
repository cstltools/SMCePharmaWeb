<#
.SYNOPSIS
  Restores a previous backup (captured by Backup-CurrentSite.ps1) to the IIS
  site via Web Deploy, undoing a bad release.

.PARAMETER BackupName
  Specific backup zip filename to restore, e.g. "backup-20260731-140501.zip".
  If omitted, restores whatever backup-root's LATEST.txt points to (i.e. the
  snapshot taken immediately before the most recent deploy).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ComputerName,
    [Parameter(Mandatory = $true)][string]$SiteName,
    [Parameter(Mandatory = $true)][string]$DeployUser,
    [Parameter(Mandatory = $true)][string]$DeployPassword,
    [Parameter(Mandatory = $true)][string]$BackupRoot,
    [string]$BackupName = ""
)

$ErrorActionPreference = "Stop"

$msdeploy = "${env:ProgramFiles}\IIS\Microsoft Web Deploy V3\msdeploy.exe"
if (-not (Test-Path $msdeploy)) {
    throw "msdeploy.exe not found at '$msdeploy'. Install the Web Deploy 3.6 client on this runner."
}

if (-not $BackupName) {
    $latestPointer = Join-Path $BackupRoot "LATEST.txt"
    if (-not (Test-Path $latestPointer)) {
        throw "No -BackupName given and no LATEST.txt pointer found in '$BackupRoot'."
    }
    $BackupName = Get-Content $latestPointer -Raw
}

$backupZip = Join-Path $BackupRoot $BackupName
if (-not (Test-Path $backupZip)) {
    throw "Backup file not found: $backupZip"
}

Write-Host "Rolling back IIS site '$SiteName' on '$ComputerName' to backup '$BackupName' ..."

$stagingDir = Join-Path ([System.IO.Path]::GetTempPath()) ("rollback-" + [Guid]::NewGuid())
New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null
Expand-Archive -Path $backupZip -DestinationPath $stagingDir -Force

$destBaseOptions = "computerName=https://$ComputerName`:8172/msdeploy.axd,userName=$DeployUser,password=$DeployPassword,authType=Basic"

& $msdeploy `
    -verb:sync `
    -source:contentPath="$stagingDir" `
    -dest:contentPath="$SiteName","$destBaseOptions" `
    -allowUntrusted `
    -enableRule:DoNotDeleteRule `
    -retryAttempts:3 `
    -retryInterval:5000

if ($LASTEXITCODE -ne 0) {
    throw "Rollback msdeploy sync failed with exit code $LASTEXITCODE"
}

Remove-Item -Recurse -Force $stagingDir -ErrorAction SilentlyContinue

Write-Host "Rollback to '$BackupName' completed successfully."
Write-Host "IMPORTANT: investigate and fix the failed release before redeploying - this rollback does not modify the pipeline or artifact history."
