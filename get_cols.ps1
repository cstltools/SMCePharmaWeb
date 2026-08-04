$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblOrderDetail'"
$reader = $cmd.ExecuteReader()
while ($reader.Read()) { 
    Write-Host "tblOrderDetail -> $($reader['COLUMN_NAME'])"
}
$conn.Close()


