<#
.SYNOPSIS
  Deploys a precompiled site package to an IIS server using Web Deploy
  (msdeploy.exe), targeting an already-existing IIS site (created once,
  manually, per docs/IIS-DEPLOYMENT-GUIDE.md).

.PARAMETER PackagePath
  Path to site-package.zip (already configured by Set-WebConfigValues.ps1).

.PARAMETER ComputerName
  Target server's Web Deploy endpoint, e.g. "iis-staging.internal.local".

.PARAMETER SiteName
  IIS site name to sync content into.

.PARAMETER DeployUser / DeployPassword
  Credentials for the Web Management Service (WMSvc) on the target, or a
  Windows account with IIS deployment rights if using msdeploy's
  "winrm"/"wmsvc" providers. Store these ONLY in GitHub Secrets.

.NOTES
  Requires the Web Deploy 3.6 client to be installed on the runner
  (self-hosted Windows runner - install via
  https://www.iis.net/downloads/microsoft/web-deploy, or `choco install webdeploy`)
  and the Web Management Service to be enabled on the target IIS server.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$PackagePath,
    [Parameter(Mandatory = $true)][string]$ComputerName,
    [Parameter(Mandatory = $true)][string]$SiteName,
    [Parameter(Mandatory = $true)][string]$DeployUser,
    [Parameter(Mandatory = $true)][string]$DeployPassword
)

$ErrorActionPreference = "Stop"

$msdeploy = "${env:ProgramFiles}\IIS\Microsoft Web Deploy V3\msdeploy.exe"
if (-not (Test-Path $msdeploy)) {
    throw "msdeploy.exe not found at '$msdeploy'. Install the Web Deploy 3.6 client on this runner."
}

if (-not (Test-Path $PackagePath)) {
    throw "Package not found: $PackagePath"
}

# Extract to a staging folder - msdeploy's contentPath source works better
# against a folder than re-reading our own zip format.
$stagingDir = Join-Path ([System.IO.Path]::GetTempPath()) ("deploy-" + [Guid]::NewGuid())
New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null
Expand-Archive -Path $PackagePath -DestinationPath $stagingDir -Force

$destBaseOptions = "computerName=https://$ComputerName`:8172/msdeploy.axd,userName=$DeployUser,password=$DeployPassword,authType=Basic"

Write-Host "Deploying to IIS site '$SiteName' on '$ComputerName' ..."

& $msdeploy `
    -verb:sync `
    -source:contentPath="$stagingDir" `
    -dest:contentPath="$SiteName","$destBaseOptions" `
    -allowUntrusted `
    -enableRule:DoNotDeleteRule `
    -retryAttempts:3 `
    -retryInterval:5000

if ($LASTEXITCODE -ne 0) {
    throw "msdeploy sync failed with exit code $LASTEXITCODE"
}

Remove-Item -Recurse -Force $stagingDir -ErrorAction SilentlyContinue

Write-Host "Deployment to '$SiteName' completed successfully."
