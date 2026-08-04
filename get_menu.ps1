$connStr = 'Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;'
$sql = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.MainMenu2'))"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$reader = $cmd.ExecuteReader()
if ($reader.Read()) { 
    $reader.GetValue(0) | Out-File -FilePath d:\Tools\param_ePharmaWeb\menu_func.sql
}
$conn.Close()
