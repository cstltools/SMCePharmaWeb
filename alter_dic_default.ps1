$connectionString = "Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"

$sqlQuery = @"
-- 1. Add Default Constraint and update existing records for tblSalesReturn_appLog
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') AND name = N'DICApprovalStatus')
BEGIN
    DECLARE @ConstraintName NVARCHAR(200);
    SELECT @ConstraintName = name FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') 
    AND parent_column_id = COLUMNPROPERTY(OBJECT_ID(N'dbo.tblSalesReturn_appLog'), N'DICApprovalStatus', 'ColumnId');
    
    IF @ConstraintName IS NOT NULL
        EXEC('ALTER TABLE dbo.tblSalesReturn_appLog DROP CONSTRAINT ' + @ConstraintName);

    ALTER TABLE dbo.tblSalesReturn_appLog ADD CONSTRAINT DF_tblSalesReturn_appLog_DICApprovalStatus DEFAULT 'Pending' FOR DICApprovalStatus;

    UPDATE dbo.tblSalesReturn_appLog 
    SET DICApprovalStatus = 'Pending' 
    WHERE DICApprovalStatus IS NULL OR DICApprovalStatus = 'Unchecked';
END

-- 2. Add Default Constraint and update existing records for tblSalesConfirmation_appLog
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tblSalesConfirmation_appLog') AND name = N'DICApprovalStatus')
BEGIN
    DECLARE @ConstraintName2 NVARCHAR(200);
    SELECT @ConstraintName2 = name FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'dbo.tblSalesConfirmation_appLog') 
    AND parent_column_id = COLUMNPROPERTY(OBJECT_ID(N'dbo.tblSalesConfirmation_appLog'), N'DICApprovalStatus', 'ColumnId');
    
    IF @ConstraintName2 IS NOT NULL
        EXEC('ALTER TABLE dbo.tblSalesConfirmation_appLog DROP CONSTRAINT ' + @ConstraintName2);

    ALTER TABLE dbo.tblSalesConfirmation_appLog ADD CONSTRAINT DF_tblSalesConfirmation_appLog_DICApprovalStatus DEFAULT 'Pending' FOR DICApprovalStatus;

    UPDATE dbo.tblSalesConfirmation_appLog 
    SET DICApprovalStatus = 'Pending' 
    WHERE DICApprovalStatus IS NULL OR DICApprovalStatus = 'Unchecked';
END
"@

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery
    $command.ExecuteNonQuery() | Out-Null
    Write-Host "DEFAULT 'Pending' set and existing records updated successfully."
}
catch {
    Write-Host "Error updating default constraint: $($_.Exception.Message)"
}
finally {
    if ($connection.State -eq 'Open') {
        $connection.Close()
    }
}
