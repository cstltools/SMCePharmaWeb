$connectionString = "Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"
$sqlQuery = @"
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') AND name = N'DICApprovalStatus')
BEGIN
    ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApprovalStatus VARCHAR(50) CONSTRAINT DF_tblSalesReturn_appLog_DICApprovalStatus DEFAULT 'Pending';
END
ELSE
BEGIN
    DECLARE @ConstraintName NVARCHAR(200);
    SELECT @ConstraintName = name FROM sys.default_constraints 
    WHERE parent_object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') 
    AND parent_column_id = COLUMNPROPERTY(OBJECT_ID(N'dbo.tblSalesReturn_appLog'), N'DICApprovalStatus', 'ColumnId');
    
    IF @ConstraintName IS NOT NULL
        EXEC('ALTER TABLE dbo.tblSalesReturn_appLog DROP CONSTRAINT ' + @ConstraintName);

    ALTER TABLE dbo.tblSalesReturn_appLog ADD CONSTRAINT DF_tblSalesReturn_appLog_DICApprovalStatus DEFAULT 'Pending' FOR DICApprovalStatus;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') AND name = N'DICApproveDate')
BEGIN
    ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApproveDate DATETIME;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tblSalesReturn_appLog') AND name = N'DICApproveBy')
BEGIN
    ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApproveBy VARCHAR(50);
END
"@

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery
    $command.ExecuteNonQuery() | Out-Null
    Write-Host "Columns added successfully."
}
catch {
    Write-Host "Error adding columns: $($_.Exception.Message)"
}
finally {
    if ($connection.State -eq 'Open') {
        $connection.Close()
    }
}

$sqlQuery2 = @"
CREATE OR ALTER PROCEDURE [dbo].[sp_UpdateDICApprovalStatus_SalesReturn]
    @SalesReturnAppLogId VARCHAR(50),
    @DICApprovalStatus VARCHAR(50),
    @DICApproveDate DATETIME,
    @DICApproveBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tblSalesReturn_appLog
    SET 
        DICApprovalStatus = @DICApprovalStatus,
        DICApproveDate = @DICApproveDate,
        DICApproveBy = @DICApproveBy
    WHERE 
        SalesReturnAppLogId = @SalesReturnAppLogId;
END
"@

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery2
    $command.ExecuteNonQuery() | Out-Null
    Write-Host "SP created successfully."
}
catch {
    Write-Host "Error creating SP: $($_.Exception.Message)"
}
finally {
    if ($connection.State -eq 'Open') {
        $connection.Close()
    }
}
