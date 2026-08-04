<#
.SYNOPSIS
  Applies environment-specific values (connection string, app settings) to
  Web.config INSIDE the build artifact zip, before it is deployed.

  This is a Web SITE project (AspNetCompiler-based), not a Web Application
  Project, so the standard Web.Debug.config / Web.Release.config XML
  Document Transform (XDT) mechanism used by MSBuild-based WAPs is not
  available here. Value substitution via XML editing is the standard
  equivalent for Website projects and for MSDeploy "parameterization" style
  deployments.

.PARAMETER PackagePath
  Path to the site-package.zip produced by the build workflow.

.PARAMETER ConnectionString
  Full connection string value to set for the
  "SolutionConnectionStringSSIDB" entry in Web.config.

.PARAMETER AppSettingsJson
  JSON object string of appSettings key/value overrides, e.g.
  '{"Environment":"Staging","ApiBaseUrl":"https://staging-api.example.com"}'.
  Keys that already exist in Web.config are updated in place; unrecognized
  keys are ignored with a warning (fix Web.config if a setting is missing).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$PackagePath,
    [Parameter(Mandatory = $true)][string]$ConnectionString,
    [string]$AppSettingsJson = "{}"
)

$ErrorActionPreference = "Stop"

$workDir = Join-Path ([System.IO.Path]::GetTempPath()) ("webconfig-edit-" + [Guid]::NewGuid())
New-Item -ItemType Directory -Path $workDir -Force | Out-Null

try {
    Write-Host "Extracting package to apply configuration..."
    Expand-Archive -Path $PackagePath -DestinationPath $workDir -Force

    $webConfigPath = Join-Path $workDir "Web.config"
    if (-not (Test-Path $webConfigPath)) {
        throw "Web.config not found in package at '$webConfigPath'."
    }

    [xml]$xml = Get-Content $webConfigPath -Raw

    # --- Connection string ---
    $connNode = $xml.configuration.connectionStrings.add |
        Where-Object { $_.name -eq "SolutionConnectionStringSSIDB" }
    if ($connNode) {
        $connNode.connectionString = $ConnectionString
        Write-Host "Updated connection string 'SolutionConnectionStringSSIDB'."
    } else {
        Write-Warning "connectionStrings entry 'SolutionConnectionStringSSIDB' not found - skipped."
    }

    # --- App settings ---
    $appSettings = $AppSettingsJson | ConvertFrom-Json
    foreach ($prop in $appSettings.PSObject.Properties) {
        $node = $xml.configuration.appSettings.add |
            Where-Object { $_.key -eq $prop.Name }
        if ($node) {
            $node.value = [string]$prop.Value
            Write-Host "Updated appSettings key '$($prop.Name)'."
        } else {
            Write-Warning "appSettings key '$($prop.Name)' not found in Web.config - skipped."
        }
    }

    $xml.Save($webConfigPath)

    Write-Host "Repackaging..."
    Remove-Item $PackagePath -Force
    Compress-Archive -Path (Join-Path $workDir '*') -DestinationPath $PackagePath -Force
}
finally {
    Remove-Item -Recurse -Force $workDir -ErrorAction SilentlyContinue
}

Write-Host "Configuration applied to $PackagePath"
