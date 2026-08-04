$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$sql = "SELECT object_id FROM sys.procedures WHERE name = 'sp_Get_MoneyReceiptReportAfterPaymentListforDALedger'"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$reader = $cmd.ExecuteReader()
$found = $false
while ($reader.Read()) { 
    Write-Host "SP EXISTS! Object ID: " $reader.GetValue(0) 
    $found = $true
}
if (-not $found) {
    Write-Host "SP DOES NOT EXIST!"
}
$conn.Close()
