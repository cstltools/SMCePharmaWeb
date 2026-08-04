<#
.SYNOPSIS
  Minimal post-deploy health check: requests the site's login page and fails
  the pipeline (triggering automatic rollback) if it doesn't return HTTP 200
  within a reasonable time. Extend this with real smoke-test URLs/checks
  specific to the application as they're identified.

.PARAMETER Url
  Base site URL, e.g. https://staging.epharma.example.com
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Url,
    [int]$MaxAttempts = 6,
    [int]$DelaySeconds = 10
)

$ErrorActionPreference = "Stop"
$target = "$($Url.TrimEnd('/'))/Login.aspx"

for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
    try {
        Write-Host "Smoke test attempt $attempt/$MaxAttempts -> $target"
        $response = Invoke-WebRequest -Uri $target -UseBasicParsing -TimeoutSec 30
        if ($response.StatusCode -eq 200) {
            Write-Host "Smoke test passed (HTTP 200)."
            exit 0
        }
        Write-Warning "Unexpected status code: $($response.StatusCode)"
    }
    catch {
        Write-Warning "Smoke test attempt $attempt failed: $($_.Exception.Message)"
    }

    if ($attempt -lt $MaxAttempts) {
        Start-Sleep -Seconds $DelaySeconds
    }
}

throw "Smoke test failed after $MaxAttempts attempts against $target"
