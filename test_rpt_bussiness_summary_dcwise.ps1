# Applies spec/database/procs/sp_RptBussinessSummary_DCWise.sql and verifies it against the
# per-day report it aggregates: for one DC, the DC wise month total must equal the sum of that
# DC's sp_RptBussinessSummary_DayWise rows for the same month.
#
# Same style as test_rollback_da_partial_sales_return.ps1: standalone, prints PASS/FAIL, no test
# framework. Point it at a dev/staging database. Read-only apart from the CREATE OR ALTER PROC.

$ErrorActionPreference = 'Stop'
$connectionString = 'Server=127.0.0.1,57694;Database=SalesDisDB_SMC_NEWDB;User ID=sa;Password=sa1234'

$year = 2026
$month = 8

$sql = Get-Content -Raw (Join-Path $PSScriptRoot 'spec/database/procs/sp_RptBussinessSummary_DCWise.sql')
$sql = $sql -replace 'CREATE PROCEDURE', 'CREATE OR ALTER PROCEDURE'

$conn = New-Object System.Data.SqlClient.SqlConnection $connectionString
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$cmd.CommandTimeout = 300
$cmd.ExecuteNonQuery() | Out-Null
Write-Host 'sp_RptBussinessSummary_DCWise applied'

function Invoke-Proc([string]$name, [hashtable]$params) {
    $c = $conn.CreateCommand()
    $c.CommandText = $name
    $c.CommandType = [System.Data.CommandType]::StoredProcedure
    $c.CommandTimeout = 300
    foreach ($k in $params.Keys) { $c.Parameters.AddWithValue($k, $params[$k]) | Out-Null }
    $dt = New-Object System.Data.DataTable
    (New-Object System.Data.SqlClient.SqlDataAdapter $c).Fill($dt) | Out-Null
    return , $dt
}

$sw = [Diagnostics.Stopwatch]::StartNew()
$dcWise = Invoke-Proc 'sp_RptBussinessSummary_DCWise' @{ '@Year' = $year; '@Month' = $month }
$sw.Stop()
Write-Host ("DC wise rows: {0} in {1:N1}s" -f $dcWise.Rows.Count, $sw.Elapsed.TotalSeconds)

$dcWise | Select-Object ComUnitName, JustSalesGrossAmt, SAPsendAmount |
    Format-Table -AutoSize | Out-String | Write-Host

Write-Host ("Grand total gross: {0:N2}" -f (($dcWise | Measure-Object JustSalesGrossAmt -Sum).Sum))

$dc = $dcWise | Where-Object { $_.JustSalesGrossAmt -ne 0 } | Select-Object -First 1
if (-not $dc) { Write-Host "FAIL: no DC with sales in $year-$month, nothing to cross-check"; $conn.Close(); exit 1 }

$dayWise = Invoke-Proc 'sp_RptBussinessSummary_DayWise' @{ '@ComUnitId' = $dc.ComUnitId; '@Year' = $year; '@Month' = $month }
$dayGross = [decimal](($dayWise | Measure-Object JustSalesGrossAmt -Sum).Sum)
$daySap = [decimal](($dayWise | Measure-Object SAPsendAmount -Sum).Sum)

Write-Host ("CHECK {0}: gross {1:N2} vs day wise {2:N2} | SAP {3:N2} vs day wise {4:N2}" -f `
    $dc.ComUnitName, [decimal]$dc.JustSalesGrossAmt, $dayGross, [decimal]$dc.SAPsendAmount, $daySap)

$ok = ([Math]::Round([decimal]$dc.JustSalesGrossAmt, 2) -eq [Math]::Round($dayGross, 2)) -and
      ([Math]::Round([decimal]$dc.SAPsendAmount, 2) -eq [Math]::Round($daySap, 2))

$conn.Close()
if ($ok) { Write-Host 'PASS' } else { Write-Host 'FAIL'; exit 1 }
