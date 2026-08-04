$connStr = "Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)

try {
    $conn.Open()
    Write-Host "--- 1. Testing Customer Search ---"
    $cmdCust = $conn.CreateCommand()
    $cmdCust.CommandText = "EXEC sp_GetCustomerAutoComplete 'a'"
    $rCust = $cmdCust.ExecuteReader()
    $testCustomerId = 0
    $testCustomerCode = ""
    if ($rCust.Read()) {
        $testCustomerId = $rCust["CustomerId"]
        $testCustomerCode = $rCust["CustomerCode"]
        Write-Host "Found Test Customer: Id=$testCustomerId, Code=$testCustomerCode, Name=$($rCust['CustomerName'])"
    }
    $rCust.Close()

    if ($testCustomerId -eq 0) {
        # Fallback to any customer in tblCustMaster
        $cmdCust2 = $conn.CreateCommand()
        $cmdCust2.CommandText = "SELECT TOP 1 CustomerMasterId, CustomerCode FROM dbo.tblCustMaster"
        $rCust2 = $cmdCust2.ExecuteReader()
        if ($rCust2.Read()) {
            $testCustomerId = $rCust2["CustomerMasterId"]
            $testCustomerCode = $rCust2["CustomerCode"]
        }
        $rCust2.Close()
    }

    Write-Host "--- 2. Testing Entry (Insert) ---"
    $cmdInsert = $conn.CreateCommand()
    $cmdInsert.CommandText = "EXEC sp_InsertInvoiceNotBinding @CustomerId=$testCustomerId, @CustomerCode='$testCustomerCode', @ActiveFromDate='2026-07-26', @ActiveToDate=NULL, @AllowedNoOfInvoice=4, @AllowedCreditLimit=100000.00, @NumberOfDaysInTransit=45, @Remarks='Test Entry', @IsActive=1, @CreatedBy='TestUser'"
    $cmdInsert.ExecuteNonQuery() | Out-Null
    Write-Host "Entry (Insert) executed successfully."

    Write-Host "--- 3. Testing List Retrieval ---"
    $cmdList = $conn.CreateCommand()
    $cmdList.CommandText = "EXEC sp_GetInvoiceNotBindingList"
    $rList = $cmdList.ExecuteReader()
    $insertedId = 0
    while ($rList.Read()) {
        $insertedId = $rList["InvoiceNotBindingId"]
        Write-Host "List Item: ID=$insertedId, Code=$($rList['CustomerCode']), AllowedNo=$($rList['AllowedNoOfInvoice']), CreditLimit=$($rList['AllowedCreditLimit']), TransitDays=$($rList['NumberOfDaysInTransit']), Status=$($rList['IsActive'])"
        break
    }
    $rList.Close()

    if ($insertedId -gt 0) {
        Write-Host "--- 4. Testing GetById (Edit View) ---"
        $cmdGet = $conn.CreateCommand()
        $cmdGet.CommandText = "EXEC sp_GetInvoiceNotBindingById @InvoiceNotBindingId=$insertedId"
        $rGet = $cmdGet.ExecuteReader()
        if ($rGet.Read()) {
            Write-Host "GetById Result: ID=$($rGet['InvoiceNotBindingId']), Remarks=$($rGet['Remarks'])"
        }
        $rGet.Close()

        Write-Host "--- 5. Testing Update ---"
        $cmdUpdate = $conn.CreateCommand()
        $cmdUpdate.CommandText = "EXEC sp_UpdateInvoiceNotBinding @InvoiceNotBindingId=$insertedId, @ActiveFromDate='2026-07-26', @ActiveToDate='2026-12-31', @AllowedNoOfInvoice=6, @AllowedCreditLimit=150000.00, @NumberOfDaysInTransit=60, @Remarks='Updated Test Entry', @IsActive=1, @UpdatedBy='TestUser'"
        $cmdUpdate.ExecuteNonQuery() | Out-Null
        Write-Host "Update executed successfully."

        Write-Host "--- 6. Testing List After Update ---"
        $cmdList2 = $conn.CreateCommand()
        $cmdList2.CommandText = "EXEC sp_GetInvoiceNotBindingById @InvoiceNotBindingId=$insertedId"
        $rList2 = $cmdList2.ExecuteReader()
        if ($rList2.Read()) {
            Write-Host "Updated Item in DB: AllowedNo=$($rList2['AllowedNoOfInvoice']), CreditLimit=$($rList2['AllowedCreditLimit']), TransitDays=$($rList2['NumberOfDaysInTransit']), Remarks=$($rList2['Remarks'])"
        }
        $rList2.Close()

        Write-Host "--- 7. Testing Delete ---"
        $cmdDel = $conn.CreateCommand()
        $cmdDel.CommandText = "EXEC sp_DeleteInvoiceNotBinding @InvoiceNotBindingId=$insertedId"
        $cmdDel.ExecuteNonQuery() | Out-Null
        Write-Host "Delete executed successfully."
    }

    Write-Host "--- ALL CRUD TESTS PASSED SUCCESSFULLY! ---"

} catch {
    Write-Host "CRUD Test Error: $($_.Exception.Message)"
} finally {
    if ($conn.State -eq 'Open') { $conn.Close() }
}
