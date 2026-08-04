$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$sql = Get-Content 'd:\CSTL_Projects\SMC\ePharma\Live_ePhrama_web\sp_RejectInvoiceDASalesReturn.sql' -Raw
$sql = $sql -replace '\bGO\b', ''

$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$cmd.ExecuteNonQuery() | Out-Null
$conn.Close()
Write-Host 'sp_RejectInvoiceDASalesReturn updated in DB successfully.'
