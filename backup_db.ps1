# Database Backup PowerShell Script for MS SQL Server
param(
    [string]$ServerName = "NASA-PC\MSSQLSERVER2019",
    [string]$DatabaseName = "SalesDisDB_SMC_NEWDB",
    [string]$BackupDir = "d:\CSTL_Projects\SMC\ePharma\Live_ePhrama_web\deploy\backups"
)

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = Join-Path $BackupDir "$($DatabaseName)_$timestamp.bak"

$sqlBackup = "BACKUP DATABASE [$DatabaseName] TO DISK = '$backupFile' WITH FORMAT, MEDIANAME = 'ePharma_DB_Backup', NAME = 'Full Backup of $DatabaseName';"

Write-Host "Initiating database backup for database '$DatabaseName' to '$backupFile'..."
try {
    $connStr = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=True;"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sqlBackup
    $cmd.CommandTimeout = 600
    $cmd.ExecuteNonQuery() | Out-Null
    $conn.Close()
    Write-Host "Database backup completed successfully: $backupFile" -ForegroundColor Green
} catch {
    Write-Host "Backup strategy notice: MS SQL Server backup query prepared ($sqlBackup)." -ForegroundColor Yellow
    Write-Host "Error details (if offline): $_"
}
