$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$sql = "SELECT OBJECT_DEFINITION(OBJECT_ID('sp_DeliveryInvoiceCreationList_DA'))"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$definition = $cmd.ExecuteScalar()
Write-Host $definition
$conn.Close()
