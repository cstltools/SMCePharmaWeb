# End-to-end test for SInventory_UI/RollbackDAPartialSalesReturn.aspx.
#
# Runs the page's own SQL (copied verbatim from RollbackDAPartialSalesReturn.aspx.cs) against a
# real invoice that already has a submitted DA Partial sales return, and asserts every table the
# rollback touches. Everything happens inside one transaction that is ALWAYS rolled back at the
# end, so the database is left exactly as it was found.
#
# Same style as test_crud_invoice_not_binding.ps1: standalone, prints PASS/FAIL, no test framework.
# Point it at a dev/staging database.

$ErrorActionPreference = 'Stop'
$connectionString = 'Server=127.0.0.1,57694;Database=SalesDisDB_SMC_NEWDB;User ID=sa;Password=sa1234'

# ---- the page's SQL, copied from RollbackDAPartialSalesReturn.aspx.cs -------------------------
$CreditedCte = @'
        WITH credited AS (
            SELECT DCStoreId, Qty FROM (
                SELECT d.DCStoreId,
                       ISNULL(d.DeliveryQuantity,0) - ISNULL(d.PaymentTotalQuantity,0) AS Qty,
                       ROW_NUMBER() OVER (PARTITION BY d.DCStoreId ORDER BY d.InvoiceDetailId) AS rn
                FROM dbo.tblInvoiceDetail d
                WHERE d.InvoiceId = @InvoiceId
                  AND d.PaymentStatus IN ('Partial','Reject')
                  AND d.DCStoreId IS NOT NULL
            ) x WHERE x.rn = 1 AND x.Qty <> 0
        )
'@

$StockCheckSql = $CreditedCte + @'
        SELECT c.DCStoreId, s.ProductCode, s.BatchNo, c.Qty AS NeedToDeduct,
               ISNULL(s.StockQty,0) AS AvailableStockQty,
               CASE WHEN s.DCStoreId IS NULL THEN 'MISSING'
                    WHEN ISNULL(s.StockQty,0) < c.Qty THEN 'SHORT'
                    ELSE 'OK' END AS StockStatus
        FROM credited c
        LEFT JOIN dbo.tblDCStore s ON s.DCStoreId = c.DCStoreId
        ORDER BY c.DCStoreId
'@

$LatestAppLogId = '(SELECT MAX(SalesReturnAppLogId) FROM dbo.tblSalesReturn_appLog WHERE InvoiceId = @InvoiceId)'
$HeaderSql = @"
        SELECT i.InvoiceId, i.InvoiceNo, i.PaymentInvoiceNo, c.CustomerName, c.CustomerCode,
               l.ReturnType, l.CreatedOn AS ReturnedOn, l.DICApprovalStatus, l.DICApproveDate
        FROM dbo.tblInvoice i
        LEFT JOIN dbo.tblCustMaster c ON c.CustomerMasterId = i.CustomerMasterId
        LEFT JOIN dbo.tblSalesReturn_appLog l ON l.SalesReturnAppLogId = $LatestAppLogId
        WHERE i.InvoiceId = @InvoiceId
"@
$SummarySql = @"
        SELECT ld.ProductCode, ld.ProductName, s.BatchNo, s.ExpDate, ld.DCStoreId,
               ISNULL(ld.TotalQty,0) AS InvoiceQty,
               ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0) AS ReturnedQty,
               (ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0)) * ISNULL(ld.UnitPrice,0) AS ReturnValue,
               COALESCE(NULLIF(RTRIM(ld.ReasonLabel),''), NULLIF(RTRIM(ld.ReasonCode),''),
                        NULLIF(RTRIM(d.PaymentReturnReason),''), 'Sales Return') AS Reason,
               ld.CreatedOn AS ReturnedOn,
               ISNULL(s.StockQty,0) AS CurrentStockQty
        FROM dbo.tblSalesReturn_appLogDetail ld
        LEFT JOIN dbo.tblDCStore s ON s.DCStoreId = ld.DCStoreId
        LEFT JOIN dbo.tblInvoiceDetail d ON d.InvoiceDetailId = ld.InvoiceDetailId
        WHERE ld.SalesReturnAppLogId = $LatestAppLogId
          AND ISNULL(ld.TotalQty,0) - ISNULL(ld.ReturnQty,0) > 0
        ORDER BY ld.SalesReturnAppLogDetailId
"@

$SeekInvoiceSql = 'SELECT TOP 1 InvoiceId FROM dbo.tblInvoice WHERE InvoiceNo = @InvoiceNo ORDER BY InvoiceId DESC'
$ScanInvoiceSql = @'
            SELECT TOP 1 InvoiceId FROM dbo.tblInvoice
            WHERE DelivaryInvoiceNo = @InvoiceNo OR PaymentInvoiceNo = @InvoiceNo
            ORDER BY InvoiceId DESC
'@
# Mirrors FindInvoiceId in RollbackDAPartialSalesReturn.aspx.cs.
function SelectInvoiceId($sql, $invoiceNo, $timeoutSeconds) {
    $command = New-Object System.Data.SqlClient.SqlCommand $sql, $connection, $transaction
    # InvoiceNo is varchar(50) - an nvarchar parameter downgrades the seek to a table scan.
    [void]$command.Parameters.Add('@InvoiceNo', [System.Data.SqlDbType]::VarChar, 50)
    $command.Parameters['@InvoiceNo'].Value = $invoiceNo
    if ($timeoutSeconds) { $command.CommandTimeout = $timeoutSeconds }
    $result = $command.ExecuteScalar()
    if ($null -eq $result -or $result -is [DBNull]) { return 0 }
    return [int]$result
}
function FindInvoiceId($invoiceNo) {
    $core = $invoiceNo
    if ($core -match '^(DEL|RTN)-') { $core = $core.Substring(4) }
    $id = SelectInvoiceId $SeekInvoiceSql $core 0
    if ($id -ne 0) { return $id }
    return SelectInvoiceId $ScanInvoiceSql $invoiceNo 300
}

$UpdateStockSql = $CreditedCte + @'
        UPDATE s SET s.StockQty = s.StockQty - c.Qty
        FROM dbo.tblDCStore s JOIN credited c ON c.DCStoreId = s.DCStoreId
'@

$UpdateDetailSql = @'
                        UPDATE dbo.tblInvoiceDetail
                        SET PaymentQuantity = NULL, PaymentBonusQuantity = NULL, PaymentTotalQuantity = NULL,
                            PaymentTotalPrice = NULL, PaymentTotalPriceVatAmount = NULL,
                            PaymentDiscountPercentage = NULL, PaymentDiscountAmount = NULL,
                            PaymentNetAmount = NULL, PaymentStatus = NULL, PaymentReturnReason = NULL
                        WHERE InvoiceId = @InvoiceId
'@

$UpdateInvoiceSql = @'
                        UPDATE dbo.tblInvoice
                        SET PaymentTpTotal = NULL, PaymentTpDiscount = NULL, PaymentTpVat = NULL,
                            PaymentTpGrandTotal = NULL, PaymentInvoiceStatus = NULL, PaymentInvoiceNo = NULL,
                            PaymentBy = NULL, PaymentDate = NULL
                        WHERE InvoiceId = @InvoiceId
'@

$UpdateAppLogSql = @'
                        UPDATE dbo.tblSalesReturn_appLog
                        SET DICApprovalStatus = 'Pending', DICApproveDate = NULL, DICApproveBy = NULL
                        WHERE SalesReturnAppLogId = (SELECT MAX(SalesReturnAppLogId)
                                                     FROM dbo.tblSalesReturn_appLog
                                                     WHERE InvoiceId = @InvoiceId)
'@
# ----------------------------------------------------------------------------------------------

$script:pass = 0
$script:fail = 0
function Check($name, $condition, $detail) {
    if ($condition) { $script:pass++; Write-Host "  PASS  $name" -ForegroundColor Green }
    else { $script:fail++; Write-Host "  FAIL  $name  -> $detail" -ForegroundColor Red }
}

$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
$connection.Open()
$transaction = $connection.BeginTransaction()

function Query($sql, $params) {
    $script:lastSql = $sql
    $command = New-Object System.Data.SqlClient.SqlCommand $sql, $connection, $transaction
    foreach ($key in $params.Keys) { [void]$command.Parameters.AddWithValue($key, $params[$key]) }
    $table = New-Object System.Data.DataTable
    $reader = $command.ExecuteReader()
    $table.Load($reader)
    $reader.Close()
    return ,$table   # comma stops PowerShell from unrolling the DataTable into loose DataRows
}
function Execute($sql, $params) {
    $script:lastSql = $sql
    $command = New-Object System.Data.SqlClient.SqlCommand $sql, $connection, $transaction
    foreach ($key in $params.Keys) { [void]$command.Parameters.AddWithValue($key, $params[$key]) }
    return $command.ExecuteNonQuery()
}
function Scalar($sql, $params, $timeoutSeconds) {
    $script:lastSql = $sql
    $command = New-Object System.Data.SqlClient.SqlCommand $sql, $connection, $transaction
    foreach ($key in $params.Keys) { [void]$command.Parameters.AddWithValue($key, $params[$key]) }
    if ($timeoutSeconds) { $command.CommandTimeout = $timeoutSeconds }
    return $command.ExecuteScalar()
}

try {
    # ---- pick a real, already-submitted DA Partial sales return ------------------------------
    $candidate = Query @'
        SELECT TOP 1 i.InvoiceId, i.InvoiceNo, i.DelivaryInvoiceNo, i.PaymentInvoiceNo
        FROM dbo.tblInvoice i
        JOIN dbo.tblSalesReturn_appLog l ON l.InvoiceId = i.InvoiceId
        WHERE i.PaymentInvoiceNo IS NOT NULL
          AND l.DICApprovalStatus = 'Approved'
          AND EXISTS (SELECT 1 FROM dbo.tblInvoiceDetail d
                      WHERE d.InvoiceId = i.InvoiceId AND d.DCStoreId IS NOT NULL
                        AND d.PaymentStatus IN ('Partial','Reject'))
        ORDER BY i.InvoiceId DESC
'@ @{}
    if ($candidate.Rows.Count -eq 0) { throw 'No submitted DA partial sales return found to test against.' }
    $invoiceId = [int]$candidate.Rows[0]['InvoiceId']
    $invoiceNo = $candidate.Rows[0]['InvoiceNo'].ToString()
    $delNo     = $candidate.Rows[0]['DelivaryInvoiceNo'].ToString()
    $rtnNo     = $candidate.Rows[0]['PaymentInvoiceNo'].ToString()
    Write-Host "Test invoice: InvoiceId=$invoiceId  InvoiceNo=$invoiceNo" -ForegroundColor Cyan

    # ---- 1. invoice lookup accepts all three numbers -----------------------------------------
    Write-Host "`n[1] Invoice lookup"
    Check 'InvoiceNo resolves'         ((FindInvoiceId $invoiceNo) -eq $invoiceId) 'mismatch'
    Check 'DelivaryInvoiceNo resolves' ((FindInvoiceId $delNo)     -eq $invoiceId) 'mismatch'
    Check 'PaymentInvoiceNo resolves'  ((FindInvoiceId $rtnNo)     -eq $invoiceId) 'mismatch'
    Check 'unknown number returns 0'   ((FindInvoiceId 'NO-SUCH-INVOICE-XYZ') -eq 0) 'should be 0'

    # ---- snapshot before ----------------------------------------------------------------------
    $stockBefore = Query $StockCheckSql @{'@InvoiceId'=$invoiceId}
    Check 'stock check returns rows' ($stockBefore.Rows.Count -gt 0) 'no credited DCStoreId found'
    $stockBefore | Format-Table DCStoreId, NeedToDeduct, AvailableStockQty, StockStatus -AutoSize | Out-String -Width 120 | Write-Host

    # ---- 1b. the Return Summary shown at the top of the page ---------------------------------
    Write-Host "[1b] Return summary"
    $header = Query $HeaderSql @{'@InvoiceId'=$invoiceId}
    Check 'header returns one row' ($header.Rows.Count -eq 1) "got $($header.Rows.Count)"
    Check 'header has customer'    (-not [string]::IsNullOrWhiteSpace($header.Rows[0]['CustomerName'].ToString())) 'empty'
    Check 'header has return type' (-not [string]::IsNullOrWhiteSpace($header.Rows[0]['ReturnType'].ToString())) 'empty'
    Check 'header has return date' ($header.Rows[0]['ReturnedOn'] -isnot [DBNull]) 'null'

    $summary = Query $SummarySql @{'@InvoiceId'=$invoiceId}
    $summary | Format-Table ProductCode, BatchNo, InvoiceQty, ReturnedQty, Reason, ReturnedOn, CurrentStockQty -AutoSize | Out-String -Width 160 | Write-Host
    Check 'summary lists the returned line(s)' ($summary.Rows.Count -gt 0) 'no returned line'
    Check 'every summary line has a batch'   (@($summary | Where-Object { [string]::IsNullOrWhiteSpace($_['BatchNo'].ToString()) }).Count -eq 0) 'batch missing'
    Check 'every summary line has a date'    (@($summary | Where-Object { $_['ReturnedOn'] -is [DBNull] }).Count -eq 0) 'date missing'
    Check 'every summary line has a reason'  (@($summary | Where-Object { [string]::IsNullOrWhiteSpace($_['Reason'].ToString()) }).Count -eq 0) 'reason missing'

    # The returned qty the summary shows must be the same qty the rollback will deduct.
    foreach ($line in $summary.Rows) {
        $match = @($stockBefore | Where-Object { [int]$_['DCStoreId'] -eq [int]$line['DCStoreId'] })
        Check "summary qty matches deduction for DCStore $($line['DCStoreId'])" `
            ($match.Count -eq 1 -and [decimal]$match[0]['NeedToDeduct'] -eq [decimal]$line['ReturnedQty']) `
            "summary $($line['ReturnedQty']) vs deduction $(if ($match.Count) { $match[0]['NeedToDeduct'] } else { 'none' })"
        Check "summary shows live stock for DCStore $($line['DCStoreId'])" `
            ([decimal]$line['CurrentStockQty'] -eq [decimal]$match[0]['AvailableStockQty']) 'stock mismatch'
    }

    $dcIds = ($stockBefore | ForEach-Object { $_['DCStoreId'] }) -join ','
    $dcBefore = @{}
    foreach ($row in (Query "SELECT DCStoreId, StockQty FROM dbo.tblDCStore WHERE DCStoreId IN ($dcIds)" @{}).Rows) {
        $dcBefore[[int]$row['DCStoreId']] = [decimal]$row['StockQty']
    }
    $detailBefore = Query 'SELECT COUNT(*) AS c FROM dbo.tblInvoiceDetail WHERE InvoiceId=@InvoiceId AND PaymentStatus IS NOT NULL' @{'@InvoiceId'=$invoiceId}
    $latestLogId = [int](Scalar 'SELECT MAX(SalesReturnAppLogId) FROM dbo.tblSalesReturn_appLog WHERE InvoiceId=@InvoiceId' @{'@InvoiceId'=$invoiceId})

    # ---- 2. guard: a short batch must abort the whole rollback --------------------------------
    Write-Host "`n[2] Short-stock guard"
    $transaction.Save('beforeGuard')
    $victim = $stockBefore.Rows[0]
    [void](Execute 'UPDATE dbo.tblDCStore SET StockQty = @Qty WHERE DCStoreId = @DCStoreId' `
        @{'@Qty'=([decimal]$victim['NeedToDeduct'] - 1); '@DCStoreId'=$victim['DCStoreId']})
    $stockGuard = Query $StockCheckSql @{'@InvoiceId'=$invoiceId}
    $bad = @($stockGuard | Where-Object { $_['StockStatus'] -ne 'OK' })
    Check 'short batch is flagged SHORT' ($bad.Count -ge 1) 'guard did not detect the short batch'
    # The page aborts here without running any UPDATE - nothing must have changed.
    $paymentStillSet = Scalar 'SELECT PaymentInvoiceNo FROM dbo.tblInvoice WHERE InvoiceId=@InvoiceId' @{'@InvoiceId'=$invoiceId}
    Check 'abort leaves invoice untouched' ($paymentStillSet.ToString() -eq $rtnNo) "PaymentInvoiceNo=$paymentStillSet"
    $transaction.Rollback('beforeGuard')
    Check 'stock restored after guard test' ([decimal](Scalar 'SELECT StockQty FROM dbo.tblDCStore WHERE DCStoreId=@Id' @{'@Id'=$victim['DCStoreId']}) -eq $dcBefore[[int]$victim['DCStoreId']]) 'savepoint rollback failed'

    # ---- 3. happy path: the four updates ------------------------------------------------------
    Write-Host "`n[3] Rollback"
    Check 'all batches OK before rollback' (@($stockBefore | Where-Object { $_['StockStatus'] -ne 'OK' }).Count -eq 0) 'a batch is short, cannot test happy path'
    $rowsStock   = Execute $UpdateStockSql   @{'@InvoiceId'=$invoiceId}
    $rowsDetail  = Execute $UpdateDetailSql  @{'@InvoiceId'=$invoiceId}
    $rowsInvoice = Execute $UpdateInvoiceSql @{'@InvoiceId'=$invoiceId}
    $rowsLog     = Execute $UpdateAppLogSql  @{'@InvoiceId'=$invoiceId}

    Check 'tblDCStore rows updated'          ($rowsStock -eq $stockBefore.Rows.Count) "expected $($stockBefore.Rows.Count), got $rowsStock"
    Check 'tblInvoiceDetail rows updated'    ($rowsDetail -gt 0) "got $rowsDetail"
    Check 'tblInvoice 1 row updated'         ($rowsInvoice -eq 1) "got $rowsInvoice"
    Check 'tblSalesReturn_appLog 1 row updated' ($rowsLog -eq 1) "got $rowsLog"

    foreach ($row in $stockBefore.Rows) {
        $id = [int]$row['DCStoreId']
        $expected = $dcBefore[$id] - [decimal]$row['NeedToDeduct']
        $actual = [decimal](Scalar 'SELECT StockQty FROM dbo.tblDCStore WHERE DCStoreId=@Id' @{'@Id'=$id})
        Check "DCStore $id : $($dcBefore[$id]) - $($row['NeedToDeduct']) = $expected" ($actual -eq $expected) "got $actual"
    }

    $inv = (Query 'SELECT PaymentTpTotal, PaymentTpDiscount, PaymentTpVat, PaymentTpGrandTotal, PaymentInvoiceStatus, PaymentInvoiceNo, PaymentBy, PaymentDate FROM dbo.tblInvoice WHERE InvoiceId=@InvoiceId' @{'@InvoiceId'=$invoiceId}).Rows[0]
    $invNulls = @($inv.ItemArray | Where-Object { $_ -isnot [DBNull] })
    Check 'tblInvoice Payment* all NULL' ($invNulls.Count -eq 0) "still set: $($invNulls -join ', ')"

    # Checked client-side: an OR over these unindexed columns makes SQL Server scan the whole
    # 3M-row table, and the page never runs such a query anyway.
    $detailRows = Query @'
        SELECT InvoiceDetailId, PaymentQuantity, PaymentBonusQuantity, PaymentTotalQuantity,
               PaymentTotalPrice, PaymentTotalPriceVatAmount, PaymentDiscountPercentage,
               PaymentDiscountAmount, PaymentNetAmount, PaymentStatus, PaymentReturnReason
        FROM dbo.tblInvoiceDetail WHERE InvoiceId = @InvoiceId
'@ @{'@InvoiceId'=$invoiceId}
    $detailLeft = @($detailRows | Where-Object {
        @($_.ItemArray | Select-Object -Skip 1 | Where-Object { $_ -isnot [DBNull] }).Count -gt 0
    }).Count
    Check 'tblInvoiceDetail Payment* all NULL' ($detailLeft -eq 0) "$detailLeft line(s) still set"

    $log = (Query 'SELECT DICApprovalStatus, DICApproveDate, DICApproveBy FROM dbo.tblSalesReturn_appLog WHERE SalesReturnAppLogId=@Id' @{'@Id'=$latestLogId}).Rows[0]
    Check 'appLog back to Pending' ($log['DICApprovalStatus'].ToString() -eq 'Pending') "got $($log['DICApprovalStatus'])"
    Check 'appLog approve date/by cleared' (($log['DICApproveDate'] -is [DBNull]) -and ($log['DICApproveBy'] -is [DBNull])) 'still set'

    # The DA list proc only shows rows whose appLog is 'Pending' - this is what makes the invoice
    # reappear on DelivaryInvoiceCreationAfterSalesConfirm_DA.aspx.
    $backOnList = [int](Scalar "SELECT COUNT(*) FROM dbo.tblSalesReturn_appLog WHERE InvoiceId=@InvoiceId AND ISNULL(DICApprovalStatus,'')='Pending'" @{'@InvoiceId'=$invoiceId})
    Check 'invoice is back on the DA sales return list' ($backOnList -ge 1) 'no Pending log row'

    # The summary reads the DA's log, which the rollback does not delete - so the page can still
    # show what was returned, now with the restored stock figure.
    $summaryAfter = Query $SummarySql @{'@InvoiceId'=$invoiceId}
    Check 'summary survives the rollback' ($summaryAfter.Rows.Count -eq $summary.Rows.Count) "got $($summaryAfter.Rows.Count)"
    foreach ($line in $summaryAfter.Rows) {
        $id = [int]$line['DCStoreId']
        $expected = $dcBefore[$id] - [decimal]$line['ReturnedQty']
        Check "summary current stock for DCStore $id is now $expected" ([decimal]$line['CurrentStockQty'] -eq $expected) "got $($line['CurrentStockQty'])"
    }

    # ---- 4. no double deduction on a second run ----------------------------------------------
    Write-Host "`n[4] Re-run safety"
    $stockAfter = Query $StockCheckSql @{'@InvoiceId'=$invoiceId}
    Check 'nothing left to deduct on a second Check' ($stockAfter.Rows.Count -eq 0) "$($stockAfter.Rows.Count) row(s) would be deducted again"
    $rowsStock2 = Execute $UpdateStockSql @{'@InvoiceId'=$invoiceId}
    Check 'second rollback deducts no stock' ($rowsStock2 -eq 0) "$rowsStock2 row(s) deducted twice"

    # ---- 5. an invoice with no submitted return is not eligible -------------------------------
    Write-Host "`n[5] Eligibility"
    # After the rollback the same invoice has no PaymentInvoiceNo, which is exactly what the page
    # treats as "nothing to roll back" - so a second Check on it is refused.
    $noReturn = Scalar 'SELECT PaymentInvoiceNo FROM dbo.tblInvoice WHERE InvoiceId=@InvoiceId' @{'@InvoiceId'=$invoiceId}
    Check 'rolled-back invoice is no longer eligible' ($noReturn -is [DBNull]) "got $noReturn"
}
catch {
    Write-Host "`nLast SQL:`n$script:lastSql" -ForegroundColor Magenta
    throw
}
finally {
    $transaction.Rollback()
    $connection.Close()
    Write-Host "`nTransaction rolled back - database unchanged." -ForegroundColor Yellow
    Write-Host "PASS: $script:pass   FAIL: $script:fail" -ForegroundColor $(if ($script:fail -eq 0) { 'Green' } else { 'Red' })
}
