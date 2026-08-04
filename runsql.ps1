$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$sql = Get-Content 'd:\Tools\param_ePharmaWeb\alter_menu.sql' -Raw
# Remove GO from SQL text
$sql = $sql -replace '\bGO\b', ''

$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$cmd.ExecuteNonQuery()
$conn.Close()
Write-Host 'Stored Procedure/Function updated successfully.'
