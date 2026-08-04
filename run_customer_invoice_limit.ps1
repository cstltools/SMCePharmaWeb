$connStr = "Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"
$fileContent = Get-Content -Path "d:\CSTL_Projects\SMC\ePharma\Live_ePhrama_web\CustomerInvoiceLimit.sql" -Raw
$batches = $fileContent -split '(?m)^\s*GO\s*$'

try {
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    Write-Host "Connected to MS SQL Server successfully."

    foreach ($batch in $batches) {
        $trimmed = $batch.Trim()
        # Remove USE [SSIDB] if present so it targets SalesDisDB_SMC_NEWDB
        $trimmed = $trimmed -replace '(?i)USE\s*\[SSIDB\]', ''
        if ($trimmed.Trim() -ne "") {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $trimmed
            $cmd.ExecuteNonQuery() | Out-Null
        }
    }
    $conn.Close()
    Write-Host "SUCCESS: CustomerInvoiceLimit.sql executed and database updated!"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}
