# =====================================================================================
#  Order Payment Approval - end-to-end verification
#
#  Exercises the stored procedures the way Solution.Web does: request -> AM approve with
#  payment schedule -> DZSM approve -> NSM approve -> invoice allowed, plus the rejection,
#  re-submission, authorization, state-transition and payment-schedule-validation paths.
#
#  Follows the repo's existing test convention (test_crud_invoice_not_binding.ps1):
#  a standalone script against a real SQL Server, printing PASS/FAIL per case.
#
#  RUN AGAINST A DEV/STAGING DATABASE ONLY - it inserts and deletes real rows.
#  Usage:  ./test_order_payment_approval.ps1
# =====================================================================================

$connStr = "Data Source=127.0.0.1,57694;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"

$script:pass = 0
$script:fail = 0
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)

function Invoke-Scalar($sql) {
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $sql; $cmd.CommandTimeout = 300
    return $cmd.ExecuteScalar()
}

function Invoke-Table($sql) {
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $sql; $cmd.CommandTimeout = 300
    $da = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    $dt = New-Object System.Data.DataTable
    [void]$da.Fill($dt)
    # Comma operator: without it PowerShell enumerates the DataTable into DataRows and
    # the caller loses .Rows entirely.
    return ,$dt
}

function Invoke-NonQuery($sql) {
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $sql; $cmd.CommandTimeout = 300
    [void]$cmd.ExecuteNonQuery()
}

# Runs $sql and reports whether it succeeded or raised. $expect = 'ok' | 'error'.
function Assert-Sql($name, $sql, $expect, $expectedTextFragment) {
    try {
        Invoke-NonQuery $sql
        if ($expect -eq 'ok') {
            Write-Host "  PASS  $name" -ForegroundColor Green; $script:pass++
        } else {
            Write-Host "  FAIL  $name - expected an error, the call succeeded" -ForegroundColor Red; $script:fail++
        }
    } catch {
        $msg = $_.Exception.Message
        if ($expect -eq 'error') {
            if ($expectedTextFragment -and ($msg -notlike "*$expectedTextFragment*")) {
                Write-Host "  FAIL  $name - errored, but not with the expected reason: $msg" -ForegroundColor Red; $script:fail++
            } else {
                Write-Host "  PASS  $name  [$($msg.Split([char]13)[0])]" -ForegroundColor Green; $script:pass++
            }
        } else {
            Write-Host "  FAIL  $name - $msg" -ForegroundColor Red; $script:fail++
        }
    }
}

function Assert-Equal($name, $actual, $expected) {
    if ("$actual" -eq "$expected") {
        Write-Host "  PASS  $name (= $actual)" -ForegroundColor Green; $script:pass++
    } else {
        Write-Host "  FAIL  $name - expected '$expected', got '$actual'" -ForegroundColor Red; $script:fail++
    }
}

try {
    $conn.Open()
    Write-Host "Connected: $($conn.DataSource) / $($conn.Database)`n"

    # -------------------------------------------------------------------------------
    #  0. Find a credit-blocked order whose AM / DZSM / NSM all have login accounts
    # -------------------------------------------------------------------------------
    Write-Host "--- 0. Locating test data ---"

    $seed = Invoke-Table @"
SELECT TOP 1 o.OrderId, o.OrderCode, o.TerritoryId, cv.DueAmount,
       ch.AMEmpId, ch.DZSMEmpId, ch.NSMEmpId,
       uAM.UserId AS AMUser, uDZ.UserId AS DZUser, uNS.UserId AS NSUser
FROM tblOrder o WITH(NOLOCK)
CROSS APPLY dbo.fnOrderCreditValidation(o.OrderId) cv
CROSS APPLY dbo.fnOrderApproverChain(o.TerritoryId) ch
OUTER APPLY (SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID=u.UserRoleID
             WHERE u.EmpInfoId=ch.AMEmpId AND r.RoleTypeId=2) uAM
OUTER APPLY (SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID=u.UserRoleID
             WHERE u.EmpInfoId=ch.DZSMEmpId AND r.RoleTypeId=3) uDZ
OUTER APPLY (SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID=u.UserRoleID
             WHERE u.EmpInfoId=ch.NSMEmpId AND r.RoleTypeId=4) uNS
WHERE o.IsInvoice = 0 AND o.OrderType = 'Regular' AND o.IsPrepareforInvoice = 1
  AND o.ActionStatus = '2' AND o.IsSubDepo = 0
  AND (cv.IsMaxOutstandingExceeded = 1 OR cv.IsCreditPeriodExceeded = 1)
  AND cv.DueAmount > 0
  AND uAM.UserId IS NOT NULL AND uDZ.UserId IS NOT NULL AND uNS.UserId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM tblOrderPaymentApproval pa WHERE pa.OrderId = o.OrderId)
ORDER BY o.OrderId DESC
"@

    if ($seed.Rows.Count -eq 0) {
        Write-Host "No suitable credit-blocked order with a complete approver chain was found. Aborting." -ForegroundColor Yellow
        exit 1
    }

    $orderId = [int]$seed.Rows[0]["OrderId"]
    $orderCode = $seed.Rows[0]["OrderCode"]
    $due = [decimal]$seed.Rows[0]["DueAmount"]
    $amUser = [int]$seed.Rows[0]["AMUser"]
    $dzUser = [int]$seed.Rows[0]["DZUser"]
    $nsUser = [int]$seed.Rows[0]["NSUser"]

    # A requester (DIC / Admin style user) and an unrelated user for the negative cases.
    $requester = [int](Invoke-Scalar "SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID = u.UserRoleID WHERE r.RoleTypeId = 5 AND u.EmpInfoId IS NOT NULL ORDER BY u.UserId")
    $stranger = [int](Invoke-Scalar "SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID = u.UserRoleID WHERE r.RoleTypeId = 1 AND u.EmpInfoId IS NOT NULL ORDER BY u.UserId")

    Write-Host "  Order      : $orderId ($orderCode), Total Due = $due"
    Write-Host "  AM user    : $amUser"
    Write-Host "  DZSM user  : $dzUser"
    Write-Host "  NSM user   : $nsUser"
    Write-Host "  Requester  : $requester"
    Write-Host "  Stranger   : $stranger (MIO - authorized for no level)`n"

    $today = (Get-Date).ToString('yyyy-MM-dd')
    $d1 = (Get-Date).AddDays(7).ToString('yyyy-MM-dd')
    $d2 = (Get-Date).AddDays(21).ToString('yyyy-MM-dd')
    $yesterday = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
    $half = [math]::Round($due / 2, 2)
    $rest = $due - $half

    # -------------------------------------------------------------------------------
    #  1. Invoice gate before any request
    # -------------------------------------------------------------------------------
    Write-Host "--- 1. Invoice creation gate (credit blocked, no request yet) ---"
    $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId"
    Assert-Equal "Blocked order cannot create invoice" $gate.Rows[0]["CanCreate"] $false
    Assert-Equal "No approval request exists yet" $gate.Rows[0]["ApprovalStatus"] (-1)

    # -------------------------------------------------------------------------------
    #  2. Go for Approval
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 2. Go for Approval ---"
    Assert-Sql "Request created" "EXEC sp_OrderPaymentApproval_Request @OrderId = $orderId, @ActionUserId = $requester, @Remarks = N'Automated test'" 'ok'

    $approvalId = [int](Invoke-Scalar "SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId AND IsActive = 1")
    Write-Host "  Approval Id: $approvalId"

    Assert-Equal "Status is Pending AM Approval (0)" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 0
    Assert-Equal "Total due snapshotted" (Invoke-Scalar "SELECT TotalDueAmount FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") $due
    Assert-Equal "History has the Requested row" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalHistory WHERE OrderPaymentApprovalId = $approvalId AND ActionName = 'Requested'") 1

    Assert-Sql "Duplicate request rejected" "EXEC sp_OrderPaymentApproval_Request @OrderId = $orderId, @ActionUserId = $requester" 'error' 'already exists'

    # -------------------------------------------------------------------------------
    #  3. Authorization - nobody may act out of turn
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 3. Authorization / level bypass ---"
    Assert-Sql "DZSM cannot approve at the AM step" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $dzUser, @Action = N'Approve'" 'error' 'not authorized'
    Assert-Sql "NSM cannot approve at the AM step" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $nsUser, @Action = N'Approve'" 'error' 'not authorized'
    Assert-Sql "MIO cannot approve anything"       "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $stranger, @Action = N'Approve'" 'error' 'not authorized'
    Assert-Sql "Unknown action rejected"           "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $amUser, @Action = N'Promote'" 'error' 'Unknown action'
    Assert-Sql "Stranger cannot read the request (IDOR)" "EXEC sp_OrderPaymentApproval_GetDetail @OrderPaymentApprovalId = $approvalId, @ActionUserId = $stranger" 'error' 'not authorized'

    # -------------------------------------------------------------------------------
    #  4. Payment schedule validation (all server-side)
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 4. Payment schedule validation ---"
    $act = "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $amUser, @Action = N'Approve', @ScheduleXml = N'"

    Assert-Sql "AM approval without a schedule rejected" `
        "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $amUser, @Action = N'Approve'" 'error' 'Payment schedule is required'

    Assert-Sql "Past payment date rejected" `
        "$act<Schedule><Row Date=""$yesterday"" Amount=""$due"" /></Schedule>'" 'error' 'earlier than today'

    Assert-Sql "Zero payment amount rejected" `
        "$act<Schedule><Row Date=""$d1"" Amount=""0"" /></Schedule>'" 'error' 'greater than 0'

    Assert-Sql "Negative payment amount rejected" `
        "$act<Schedule><Row Date=""$d1"" Amount=""-10"" /></Schedule>'" 'error' 'greater than 0'

    Assert-Sql "Duplicate payment date rejected" `
        "$act<Schedule><Row Date=""$d1"" Amount=""$half"" /><Row Date=""$d1"" Amount=""$rest"" /></Schedule>'" 'error' 'Duplicate payment date'

    Assert-Sql "Schedule total not equal to total due rejected" `
        "$act<Schedule><Row Date=""$d1"" Amount=""1.00"" /></Schedule>'" 'error' 'must equal total due'

    Assert-Sql "Empty schedule rejected" `
        "$act<Schedule></Schedule>'" 'error' 'at least one instalment'

    Assert-Equal "Nothing was persisted by the rejected attempts" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 0
    Assert-Equal "No schedule rows written by rejected attempts" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalSchedule WHERE OrderPaymentApprovalId = $approvalId") 0

    # -------------------------------------------------------------------------------
    #  5. AM approval with a valid schedule
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 5. AM approval ---"
    Assert-Sql "AM approves with a valid 2-instalment schedule" `
        "$act<Schedule><Row Date=""$d1"" Amount=""$half"" /><Row Date=""$d2"" Amount=""$rest"" /></Schedule>'" 'ok'

    Assert-Equal "Status moved to Pending DZSM Approval (2)" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 2
    Assert-Equal "Payment plan version incremented" (Invoke-Scalar "SELECT PaymentPlanVersion FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 1
    Assert-Equal "Two schedule rows stored" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalSchedule WHERE OrderPaymentApprovalId = $approvalId AND IsActive = 1") 2
    Assert-Equal "Scheduled total equals total due" (Invoke-Scalar "SELECT SUM(PaymentAmount) FROM tblOrderPaymentApprovalSchedule WHERE OrderPaymentApprovalId = $approvalId AND IsActive = 1") $due
    Assert-Equal "Payment numbers are date-ordered" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalSchedule s1 JOIN tblOrderPaymentApprovalSchedule s2 ON s2.OrderPaymentApprovalId = s1.OrderPaymentApprovalId AND s2.PaymentNo > s1.PaymentNo AND s2.PaymentDate <= s1.PaymentDate WHERE s1.OrderPaymentApprovalId = $approvalId") 0
    Assert-Equal "AM Approved + Pending DZSM history rows written" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalHistory WHERE OrderPaymentApprovalId = $approvalId AND ActionName IN ('AM Approved','Pending DZSM Approval')") 2

    Assert-Sql "AM cannot approve twice" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $amUser, @Action = N'Approve'" 'error' 'not authorized'

    $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId"
    Assert-Equal "Invoice still blocked at DZSM step" $gate.Rows[0]["CanCreate"] $false

    # -------------------------------------------------------------------------------
    #  6. DZSM approval - and the schedule is now frozen to the AM's plan
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 6. DZSM approval ---"
    Assert-Sql "NSM cannot approve at the DZSM step" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $nsUser, @Action = N'Approve'" 'error' 'not authorized'
    Assert-Sql "DZSM cannot rewrite the payment schedule" `
        "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $dzUser, @Action = N'Approve', @ScheduleXml = N'<Schedule><Row Date=""$d1"" Amount=""$due"" /></Schedule>'" 'error' 'Only the AM step'
    Assert-Sql "DZSM approves" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $dzUser, @Action = N'Approve', @Remarks = N'DZSM ok'" 'ok'
    Assert-Equal "Status moved to Pending NSM Approval (4)" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 4

    # -------------------------------------------------------------------------------
    #  7. NSM final approval
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 7. NSM final approval ---"
    Assert-Sql "AM cannot approve at the NSM step" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $amUser, @Action = N'Approve'" 'error' 'not authorized'
    Assert-Sql "NSM approves" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $nsUser, @Action = N'Approve', @Remarks = N'Final'" 'ok'
    Assert-Equal "Status is Fully Approved (5)" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 5
    Assert-Equal "Payment schedule is locked" (Invoke-Scalar "SELECT CONVERT(int, IsScheduleLocked) FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId") 1
    Assert-Sql "A closed request cannot be actioned again" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId, @ActionUserId = $nsUser, @Action = N'Approve'" 'error' 'already closed'

    $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId"
    Assert-Equal "Invoice creation now allowed" $gate.Rows[0]["CanCreate"] $true
    Assert-Equal "Gate reports Fully Approved" $gate.Rows[0]["ApprovalStatus"] 5

    # -------------------------------------------------------------------------------
    #  8. Audit trail is append-only
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 8. Audit ---"
    $histCount = [int](Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalHistory WHERE OrderPaymentApprovalId = $approvalId")
    Assert-Equal "Full history recorded (Requested + 3 approvals expanded)" $histCount 6
    Assert-Sql "History rows cannot be updated" "UPDATE tblOrderPaymentApprovalHistory SET Remarks = N'tampered' WHERE OrderPaymentApprovalId = $approvalId" 'error' 'append-only'
    Assert-Sql "History rows cannot be deleted" "DELETE FROM tblOrderPaymentApprovalHistory WHERE OrderPaymentApprovalId = $approvalId" 'error' 'append-only'

    # -------------------------------------------------------------------------------
    #  9. Rejection + re-submission on a second order
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 9. Rejection and re-submission ---"
    $seed2 = Invoke-Table @"
SELECT TOP 1 o.OrderId, ch.AMEmpId, uAM.UserId AS AMUser
FROM tblOrder o WITH(NOLOCK)
CROSS APPLY dbo.fnOrderCreditValidation(o.OrderId) cv
CROSS APPLY dbo.fnOrderApproverChain(o.TerritoryId) ch
OUTER APPLY (SELECT TOP 1 u.UserId FROM tblUser u JOIN tbl_UserRoleInfo r ON r.UserRoleID=u.UserRoleID
             WHERE u.EmpInfoId=ch.AMEmpId AND r.RoleTypeId=2) uAM
WHERE o.IsInvoice = 0 AND o.OrderType = 'Regular' AND o.IsPrepareforInvoice = 1
  AND o.ActionStatus = '2' AND o.IsSubDepo = 0
  AND (cv.IsMaxOutstandingExceeded = 1 OR cv.IsCreditPeriodExceeded = 1)
  AND cv.DueAmount > 0
  AND ch.AMEmpId IS NOT NULL AND ch.DZSMEmpId IS NOT NULL AND ch.NSMEmpId IS NOT NULL
  AND uAM.UserId IS NOT NULL
  AND o.OrderId <> $orderId
  AND NOT EXISTS (SELECT 1 FROM tblOrderPaymentApproval pa WHERE pa.OrderId = o.OrderId)
ORDER BY o.OrderId DESC
"@

    $approvalId2 = 0
    if ($seed2.Rows.Count -eq 0) {
        Write-Host "  SKIP  No second credit-blocked order available for the rejection case" -ForegroundColor Yellow
    } else {
        $orderId2 = [int]$seed2.Rows[0]["OrderId"]
        $amUser2 = [int]$seed2.Rows[0]["AMUser"]

        Assert-Sql "Second request created" "EXEC sp_OrderPaymentApproval_Request @OrderId = $orderId2, @ActionUserId = $requester" 'ok'
        $approvalId2 = [int](Invoke-Scalar "SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId2 AND IsActive = 1")

        Assert-Sql "Rejection without a reason is refused" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId2, @ActionUserId = $amUser2, @Action = N'Reject'" 'error' 'reason is required'
        Assert-Sql "AM rejects with a reason" "EXEC sp_OrderPaymentApproval_Act @OrderPaymentApprovalId = $approvalId2, @ActionUserId = $amUser2, @Action = N'Reject', @Remarks = N'Customer history poor'" 'ok'
        Assert-Equal "Status is Rejected (6)" (Invoke-Scalar "SELECT ApprovalStatus FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId2") 6
        Assert-Equal "Rejected request is deactivated" (Invoke-Scalar "SELECT CONVERT(int, IsActive) FROM tblOrderPaymentApproval WHERE OrderPaymentApprovalId = $approvalId2") 0

        $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId2"
        Assert-Equal "Rejected order still cannot create an invoice" $gate.Rows[0]["CanCreate"] $false

        Assert-Sql "Re-submission after rejection is allowed" "EXEC sp_OrderPaymentApproval_Request @OrderId = $orderId2, @ActionUserId = $requester, @Remarks = N'Resubmitted'" 'ok'
        Assert-Equal "Exactly one live request for the order" (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApproval WHERE OrderId = $orderId2 AND IsActive = 1") 1
    }

    # -------------------------------------------------------------------------------
    # 10. A non-blocked order must not enter the workflow at all
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 10. Non-blocked order ---"
    $clean = Invoke-Scalar @"
SELECT TOP 1 o.OrderId
FROM tblOrder o WITH(NOLOCK)
CROSS APPLY dbo.fnOrderCreditValidation(o.OrderId) cv
WHERE o.IsInvoice = 0 AND o.OrderType = 'Regular' AND o.IsPrepareforInvoice = 1
  AND o.ActionStatus = '2' AND o.IsSubDepo = 0
  AND cv.IsMaxOutstandingExceeded = 0 AND cv.IsCreditPeriodExceeded = 0
ORDER BY o.OrderId DESC
"@
    if (-not $clean) {
        Write-Host "  SKIP  No non-blocked order available" -ForegroundColor Yellow
    } else {
        $cleanId = [int]$clean
        $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $cleanId"
        Assert-Equal "Normal order can create an invoice (existing behaviour intact)" $gate.Rows[0]["CanCreate"] $true
        Assert-Sql "Approval cannot be requested for a non-blocked order" "EXEC sp_OrderPaymentApproval_Request @OrderId = $cleanId, @ActionUserId = $requester" 'error' 'not credit blocked'
    }

    # -------------------------------------------------------------------------------
    # 11. Regression - the Invoice Creation grid procs still work and still hide nothing
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 11. Regression: Invoice Creation list procs ---"
    $params = Invoke-Table "SELECT TOP 1 ComUnitId, DistributionRouteId, TerritoryId FROM tblOrder WITH(NOLOCK) WHERE IsInvoice=0 AND OrderType='Regular' AND IsPrepareforInvoice=1 AND ActionStatus='2' AND IsSubDepo=0 GROUP BY ComUnitId, DistributionRouteId, TerritoryId ORDER BY COUNT(*) DESC"
    $cu = [int]$params.Rows[0]["ComUnitId"]; $rt = [int]$params.Rows[0]["DistributionRouteId"]; $tr = [int]$params.Rows[0]["TerritoryId"]

    $grid = Invoke-Table "EXEC sp_LoadOrderListForOrderCreationbyTerri @manufacId = $rt, @comunitId = $cu, @TerritoryId = $tr"
    Assert-Equal "Territory-wise proc returns rows" ($grid.Rows.Count -gt 0) $true
    Assert-Equal "PaymentApprovalStatus column present" $grid.Columns.Contains("PaymentApprovalStatus") $true
    Assert-Equal "IsCreditPeriodExceeded still present" $grid.Columns.Contains("IsCreditPeriodExceeded") $true
    Assert-Equal "DueAmount still present" $grid.Columns.Contains("DueAmount") $true

    $rowsWithJoin = $grid.Rows.Count
    $rowsBaseline = [int](Invoke-Scalar "SELECT COUNT(*) FROM tblOrder WITH(NOLOCK) WHERE IsInvoice=0 AND OrderType='Regular' AND ComUnitId=$cu AND DistributionRouteId=$rt AND TerritoryId=$tr AND IsPrepareforInvoice=1 AND ActionStatus='2' AND IsSubDepo=0")
    Assert-Equal "The new LEFT JOIN did not duplicate or drop rows" $rowsWithJoin $rowsBaseline

    $grid2 = Invoke-Table "EXEC sp_LoadOrderListForOrderRouteDayWise @comunitId = $cu, @routeId = $rt, @RouteDate = '$today'"
    Assert-Equal "Route-wise proc exposes PaymentApprovalStatus" $grid2.Columns.Contains("PaymentApprovalStatus") $true

} catch {
    Write-Host "`nUNEXPECTED FAILURE: $($_.Exception.Message)" -ForegroundColor Red
    $script:fail++
} finally {
    # ---------------------------------------------------------------------------------
    #  Cleanup. The history table is append-only by trigger, so it is disabled for the
    #  duration of the delete and re-enabled immediately - dev/staging only.
    # ---------------------------------------------------------------------------------
    if ($conn.State -eq 'Open') {
        try {
            Write-Host "`n--- Cleanup ---"
            Invoke-NonQuery "DISABLE TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange ON dbo.tblOrderPaymentApprovalHistory"
            if ($approvalId) {
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApprovalHistory  WHERE OrderPaymentApprovalId IN (SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId)"
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApprovalSchedule WHERE OrderPaymentApprovalId IN (SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId)"
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApproval WHERE OrderId = $orderId"
            }
            if ($approvalId2) {
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApprovalHistory  WHERE OrderPaymentApprovalId IN (SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId2)"
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApprovalSchedule WHERE OrderPaymentApprovalId IN (SELECT OrderPaymentApprovalId FROM tblOrderPaymentApproval WHERE OrderId = $orderId2)"
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApproval WHERE OrderId = $orderId2"
            }
            Invoke-NonQuery "ENABLE TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange ON dbo.tblOrderPaymentApprovalHistory"
            Write-Host "  Test rows removed; append-only trigger re-enabled."
        } catch {
            Write-Host "  CLEANUP FAILED: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "  Re-enable the trigger manually:" -ForegroundColor Red
            Write-Host "    ENABLE TRIGGER dbo.trg_tblOrderPaymentApprovalHistory_NoChange ON dbo.tblOrderPaymentApprovalHistory" -ForegroundColor Red
        }
        $conn.Close()
    }

    Write-Host "`n=============================================="
    Write-Host " PASSED: $script:pass    FAILED: $script:fail"
    Write-Host "=============================================="
}

if ($script:fail -gt 0) { exit 1 }
