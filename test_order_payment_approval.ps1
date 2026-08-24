# =====================================================================================
#  Order Payment Approval - end-to-end verification
#
#  Exercises the stored procedures the way Solution.Web does, against the chain that is
#  actually configured on UserPermission/ApprovalStepMap.aspx for MenuId 383. The script
#  does NOT assume AM -> DZSM -> NSM or any other sequence: it reads the configuration,
#  finds a real user for every configured role, and walks whatever chain it finds.
#
#  If MenuId 383 has no chain configured, the script says so and stops - that is the
#  correct outcome, not a failure of the code under test.
#
#  Follows the repo's existing test convention (test_crud_invoice_not_binding.ps1):
#  a standalone script against a real SQL Server, printing PASS/FAIL per case.
#
#  RUN AGAINST A DEV/STAGING DATABASE ONLY - it inserts and deletes real rows.
#  Usage:  ./test_order_payment_approval.ps1
# =====================================================================================

$connStr = "Data Source=127.0.0.1,57694;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;"

$MenuId = 383

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

# <Schedule><Row Date="yyyy-MM-dd" Amount="0.00" /></Schedule> - same shape the repository builds.
function New-ScheduleXml($rows) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('<Schedule>')
    foreach ($r in $rows) {
        [void]$sb.AppendFormat('<Row Date="{0}" Amount="{1}" />',
            $r.Date, [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0:0.00}', $r.Amount))
    }
    [void]$sb.Append('</Schedule>')
    return $sb.ToString()
}

$orderId = 0
$orderId2 = 0

try {
    $conn.Open()
    Write-Host "Connected: $($conn.DataSource) / $($conn.Database)`n"

    # -------------------------------------------------------------------------------
    #  0. The configured chain. Everything below is driven by this, nothing is assumed.
    # -------------------------------------------------------------------------------
    Write-Host "--- 0. Configured approval chain (MenuId $MenuId) ---"

    $chains = Invoke-Table @"
SELECT m.FromRoleId, fr.RoleType AS FromRole, d.[Order], d.ToRoleId, tr.RoleType AS ToRole, tr.DisplayName AS ToRoleShown
FROM tblApprovalMapMaster m
JOIN tblApprovalMapDetail d ON d.ApprovalMapMasterId = m.ApprovalMapMasterId
LEFT JOIN tblRoleType fr ON fr.RoleTypeId = m.FromRoleId
LEFT JOIN tblRoleType tr ON tr.RoleTypeId = d.ToRoleId
WHERE m.MenuId = $MenuId
ORDER BY m.FromRoleId, d.[Order]
"@

    if ($chains.Rows.Count -eq 0) {
        Write-Host "No approval chain is configured for MenuId $MenuId." -ForegroundColor Yellow
        Write-Host "Configure it first: UserPermission/ApprovalStepMap.aspx -> menu 'Order Payment Approval'." -ForegroundColor Yellow
        Write-Host "Reminder: the dropdown shows DisplayName - 'NSM' there is RoleTypeId 14," -ForegroundColor Yellow
        Write-Host "and RoleTypeId 4 is shown as 'Regional Head'." -ForegroundColor Yellow
        exit 1
    }

    foreach ($r in $chains.Rows) {
        Write-Host ("  From {0,-6} step {1} -> {2} (RoleTypeId {3}, shown as '{4}')" -f `
            $r.FromRole, $r.Order, $r.ToRole, $r.ToRoleId, $r.ToRoleShown)
    }

    # -------------------------------------------------------------------------------
    #  1. A credit-blocked order whose whole configured chain has a real user
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 1. Locating test data ---"

    $candidates = Invoke-Table @"
SELECT TOP 40
       o.OrderId, o.OrderCode, o.TerritoryId, o.ComUnitId,
       t.AreaId, a.RegionId, r.GroupId,
       cv.DueAmount
FROM tblOrder o WITH(NOLOCK)
CROSS APPLY dbo.fnOrderCreditValidation(o.OrderId) cv
LEFT JOIN tblTerritory t WITH(NOLOCK) ON t.TerritoryId = o.TerritoryId
LEFT JOIN tblArea      a WITH(NOLOCK) ON a.AreaId      = t.AreaId
LEFT JOIN tblRegion    r WITH(NOLOCK) ON r.RegionId    = a.RegionId
WHERE o.IsInvoice = 0 AND o.OrderType = 'Regular' AND o.IsPrepareforInvoice = 1
  AND o.ActionStatus = '2' AND o.IsSubDepo = 0
  AND (cv.IsMaxOutstandingExceeded = 1 OR cv.IsCreditPeriodExceeded = 1)
  AND cv.DueAmount > 1
  AND NOT EXISTS (SELECT 1 FROM tblOrderPaymentApprovalLog l WHERE l.TableId = o.OrderId)
ORDER BY o.OrderId DESC
"@

    if ($candidates.Rows.Count -eq 0) {
        Write-Host "No unused credit-blocked order found. Aborting." -ForegroundColor Yellow
        exit 1
    }

    # A user with the given role type, inside the given market position.
    function Find-User($roleTypeId, $areaId, $regionId, $groupId, $comUnitId) {
        $sql = @"
SELECT TOP 1 u.UserId
FROM tblUser u WITH(NOLOCK)
JOIN tbl_UserRoleInfo ur WITH(NOLOCK) ON ur.UserRoleID = u.UserRoleID
LEFT JOIN View_Webapi_EmployeeFieldForceInfo ff WITH(NOLOCK) ON ff.EmpInfoId = u.EmpInfoId
WHERE ur.RoleTypeId = $roleTypeId
  AND u.EmpInfoId IS NOT NULL
  AND (
        $roleTypeId NOT IN (2,3,4,8)
     OR ($roleTypeId = 2 AND ff.EmpAreaId   = $areaId)
     OR ($roleTypeId = 3 AND ff.EmpRegionId = $regionId)
     OR ($roleTypeId = 4 AND ff.EmpGroupId  = $groupId)
     OR ($roleTypeId = 8 AND EXISTS (SELECT 1 FROM tblUserCompanyUnit uc WITH(NOLOCK)
                                      WHERE uc.UserId = u.UserId AND uc.CompanyUnitId = $comUnitId))
      )
ORDER BY u.UserId
"@
        $v = Invoke-Scalar $sql
        if ($null -eq $v -or $v -eq [DBNull]::Value) { return $null }
        return [int]$v
    }

    # DataTable.Rows, not the pipeline: piping a DataTable enumerates it into DataRows and
    # .Rows is no longer reachable.
    $fromRoleIds = @($chains.Rows | ForEach-Object { [int]$_.FromRoleId } | Sort-Object -Unique)

    $chosen = $null
    foreach ($cand in $candidates.Rows) {
        if ($cand.AreaId -is [DBNull] -or $cand.RegionId -is [DBNull] -or $cand.GroupId -is [DBNull]) { continue }

        $area = [int]$cand.AreaId; $region = [int]$cand.RegionId; $group = [int]$cand.GroupId
        $cu = if ($cand.ComUnitId -is [DBNull]) { -1 } else { [int]$cand.ComUnitId }

        # try every configured FromRole; take the first that has a requester AND a full chain
        foreach ($fromRoleId in $fromRoleIds) {
            $requester = Find-User $fromRoleId $area $region $group $cu
            if (-not $requester) { continue }

            $steps = @($chains.Select("FromRoleId = $fromRoleId", "[Order] ASC")) | Where-Object { [int]$_.Order -gt 1 }
            if ($steps.Count -eq 0) { continue }

            $approvers = @()
            $complete = $true
            foreach ($s in $steps) {
                $u = Find-User ([int]$s.ToRoleId) $area $region $group $cu
                if (-not $u) { $complete = $false; break }
                $approvers += [pscustomobject]@{ RoleTypeId = [int]$s.ToRoleId; RoleName = $s.ToRole; UserId = $u }
            }

            if ($complete) {
                $chosen = [pscustomobject]@{
                    OrderId = [int]$cand.OrderId; OrderCode = "$($cand.OrderCode)"
                    AreaId = $area; RegionId = $region; GroupId = $group; ComUnitId = $cu
                    Due = [decimal]$cand.DueAmount
                    FromRoleId = [int]$fromRoleId; RequesterUserId = $requester
                    Approvers = $approvers
                }
                break
            }
        }
        if ($chosen) { break }
    }

    if (-not $chosen) {
        Write-Host "No credit-blocked order found whose configured chain has a user at every step." -ForegroundColor Yellow
        Write-Host "Either the chain roles have no accounts in these markets, or the market data is incomplete." -ForegroundColor Yellow
        exit 1
    }

    $orderId = $chosen.OrderId
    $due = $chosen.Due
    $requester = $chosen.RequesterUserId

    Write-Host "  Order      : $orderId ($($chosen.OrderCode)), Total Due = $due"
    Write-Host "  Market     : Area $($chosen.AreaId) / Region $($chosen.RegionId) / Group $($chosen.GroupId)"
    Write-Host "  Requester  : UserId $requester (RoleTypeId $($chosen.FromRoleId))"
    foreach ($a in $chosen.Approvers) {
        Write-Host "  Approver   : UserId $($a.UserId)  role $($a.RoleName) (RoleTypeId $($a.RoleTypeId))"
    }

    $today = (Get-Date).ToString('yyyy-MM-dd')
    $d1 = (Get-Date).AddDays(7).ToString('yyyy-MM-dd')
    $d2 = (Get-Date).AddDays(21).ToString('yyyy-MM-dd')
    $yesterday = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
    $half = [math]::Round($due / 2, 2)
    $rest = $due - $half

    $goodXml = New-ScheduleXml @(
        @{ Date = $d1; Amount = $half },
        @{ Date = $d2; Amount = $rest })

    # -------------------------------------------------------------------------------
    #  2. Invoice gate before anything happens
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 2. Invoice creation gate (blocked, no request yet) ---"
    $gate = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId"
    Assert-Equal "Blocked order cannot create an invoice" $gate.Rows[0]["CanCreate"] $false

    # -------------------------------------------------------------------------------
    #  3. Schedule validation - every rule refused before anything is written
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 3. Payment schedule validation ---"

    Assert-Sql "No schedule at all is refused" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml=NULL" `
        'error' 'payment schedule is required'

    $pastXml = New-ScheduleXml @(@{ Date = $yesterday; Amount = $due })
    Assert-Sql "A date in the past is refused" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$pastXml'" `
        'error' 'today or later'

    $dupXml = New-ScheduleXml @(@{ Date = $d1; Amount = $half }, @{ Date = $d1; Amount = $rest })
    Assert-Sql "Duplicate dates are refused" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$dupXml'" `
        'error' 'must be unique'

    $shortXml = New-ScheduleXml @(@{ Date = $d1; Amount = $half })
    Assert-Sql "A total below the due amount is refused" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$shortXml'" `
        'error' 'must equal the total due'

    Assert-Equal "Nothing was written by the refused attempts" `
        (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentApprovalLog WHERE TableId = $orderId") 0

    # -------------------------------------------------------------------------------
    #  4. Go for Approval
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 4. Go for Approval ---"

    Assert-Sql "Valid request is accepted" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$goodXml'" `
        'ok'

    Assert-Equal "Step 1 row written as Posted" `
        (Invoke-Scalar "SELECT Status FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId AND Round=1 AND Step=1") 'Posted'

    Assert-Equal "Waiting on the first configured approver" `
        (Invoke-Scalar "SELECT ToRoleTypeId FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId AND Round=1 AND Step=1") `
        $chosen.Approvers[0].RoleTypeId

    Assert-Equal "Instalments stored against plan version 1" `
        (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentSchedule WHERE OrderId=$orderId AND PlanVersion=1") 2

    Assert-Sql "A second request while one is live is refused" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$goodXml'" `
        'error' 'already waiting for approval'

    # -------------------------------------------------------------------------------
    #  5. Authorization - the hardening this rebuild adds over the framework default
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 5. Authorization ---"

    # someone whose role is not the one being waited on
    $wrongRoleUser = $null
    foreach ($a in $chosen.Approvers) {
        if ($a.RoleTypeId -ne $chosen.Approvers[0].RoleTypeId) { $wrongRoleUser = $a.UserId; break }
    }
    if ($wrongRoleUser) {
        Assert-Sql "A later-stage approver cannot jump the queue" `
            "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$wrongRoleUser, @Action='Approve'" `
            'error' 'not the approver for this stage'
    } else {
        Write-Host "  SKIP  queue-jump case - the configured chain has only one approver level" -ForegroundColor DarkGray
    }

    # someone with the right role but in a different market
    $firstRole = $chosen.Approvers[0].RoleTypeId
    $outsider = Invoke-Scalar @"
SELECT TOP 1 u.UserId
FROM tblUser u WITH(NOLOCK)
JOIN tbl_UserRoleInfo ur WITH(NOLOCK) ON ur.UserRoleID = u.UserRoleID
JOIN View_Webapi_EmployeeFieldForceInfo ff WITH(NOLOCK) ON ff.EmpInfoId = u.EmpInfoId
WHERE ur.RoleTypeId = $firstRole
  AND ISNULL(ff.EmpAreaId,-1)   <> $($chosen.AreaId)
  AND ISNULL(ff.EmpRegionId,-1) <> $($chosen.RegionId)
  AND ISNULL(ff.EmpGroupId,-1)  <> $($chosen.GroupId)
ORDER BY u.UserId
"@
    if ($outsider -and $outsider -ne [DBNull]::Value) {
        Assert-Sql "Right role, wrong market is refused" `
            "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$outsider, @Action='Approve'" `
            'error' 'outside your market'
    } else {
        Write-Host "  SKIP  wrong-market case - no user of that role outside this market" -ForegroundColor DarkGray
    }

    Assert-Sql "Rejecting without a reason is refused" `
        "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$($chosen.Approvers[0].UserId), @Action='Reject'" `
        'error' 'reason is required'

    Assert-Sql "An unknown action is refused" `
        "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$($chosen.Approvers[0].UserId), @Action='Delete'" `
        'error' 'Unknown action'

    # -------------------------------------------------------------------------------
    #  6. The worklist shows the right row to the right person
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 6. Approver worklist ---"

    $list = Invoke-Table "EXEC sp_Get_OrderPaymentApp @ActionUserId=$($chosen.Approvers[0].UserId), @OrderId=$orderId"
    Assert-Equal "Current approver sees the request" $list.Rows.Count 1
    if ($list.Rows.Count -eq 1) {
        Assert-Equal "...and is allowed to act on it" $list.Rows[0]["CanAct"] $true
        Assert-Equal "...with the schedule rendered inline" ($list.Rows[0]["InstalmentCount"]) 2
        if ("$($list.Rows[0]["ScheduleText"])" -match '\d') {
            Write-Host "  PASS  Schedule text: $($list.Rows[0]["ScheduleText"])" -ForegroundColor Green; $script:pass++
        } else {
            Write-Host "  FAIL  Schedule text is empty" -ForegroundColor Red; $script:fail++
        }
    }

    if ($wrongRoleUser) {
        $list2 = Invoke-Table "EXEC sp_Get_OrderPaymentApp @ActionUserId=$wrongRoleUser, @OrderId=$orderId"
        if ($list2.Rows.Count -eq 1) {
            Assert-Equal "A later-stage approver sees it but cannot act" $list2.Rows[0]["CanAct"] $false
        } else {
            Write-Host "  PASS  A later-stage approver does not see it yet" -ForegroundColor Green; $script:pass++
        }
    }

    # -------------------------------------------------------------------------------
    #  7. Walk the configured chain
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 7. Walking the configured chain ---"

    $stepNo = 1
    foreach ($a in $chosen.Approvers) {
        $stepNo++
        $isLast = ($a -eq $chosen.Approvers[-1])

        Assert-Sql "$($a.RoleName) approves (step $stepNo)" `
            "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$($a.UserId), @Action='Approve', @Comments='ok'" `
            'ok'

        $expected = if ($isLast) { 'Accepted' } else { 'Verified' }
        Assert-Equal "  status after $($a.RoleName)" `
            (Invoke-Scalar "SELECT Status FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId AND Round=1 AND Step=$stepNo") `
            $expected

        Assert-Sql "  $($a.RoleName) cannot approve the same request twice" `
            "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId, @ActionUserId=$($a.UserId), @Action='Approve'" `
            'error'
    }

    Assert-Equal "Chain finished with no one left to wait on" `
        (Invoke-Scalar "SELECT ISNULL(CONVERT(varchar(10), ToRoleTypeId), 'NULL') FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId AND Round=1 AND Step=$stepNo") 'NULL'

    # -------------------------------------------------------------------------------
    #  8. Invoice gate after full approval
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 8. Invoice creation gate (approved) ---"
    $gate2 = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId"
    Assert-Equal "Approved order can create an invoice" $gate2.Rows[0]["CanCreate"] $true
    Assert-Equal "...and reports the framework status" $gate2.Rows[0]["Status"] 'Accepted'

    Assert-Sql "An approved order cannot be sent for approval again" `
        "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId, @ActionUserId=$requester, @ScheduleXml='$goodXml'" `
        'error' 'already approved'

    # -------------------------------------------------------------------------------
    #  9. Audit trail
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 9. Audit trail ---"
    $hist = Invoke-Table "EXEC sp_Get_OrderPaymentAppHistory @OrderId = $orderId"
    Assert-Equal "One history row per action" $hist.Rows.Count ($chosen.Approvers.Count + 1)

    # -------------------------------------------------------------------------------
    # 10. Rejection closes the round; a new round can be opened
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 10. Rejection and resubmission ---"

    # A fresh order for the reject path, so the approved one above stays intact. Only the
    # FIRST approver is needed here - the round is closed by their rejection - so this
    # looks for any other candidate order whose market has a user of that role.
    $orderId2 = 0
    $due2 = 0
    $rejecter = 0
    $firstRoleId = $chosen.Approvers[0].RoleTypeId

    foreach ($cand in $candidates.Rows) {
        if ([int]$cand.OrderId -eq $orderId) { continue }
        if ($cand.AreaId -is [DBNull] -or $cand.RegionId -is [DBNull] -or $cand.GroupId -is [DBNull]) { continue }

        $cu2 = if ($cand.ComUnitId -is [DBNull]) { -1 } else { [int]$cand.ComUnitId }
        $u = Find-User $firstRoleId ([int]$cand.AreaId) ([int]$cand.RegionId) ([int]$cand.GroupId) $cu2
        if (-not $u) { continue }

        $orderId2 = [int]$cand.OrderId
        $due2 = [decimal]$cand.DueAmount
        $rejecter = $u
        break
    }

    if ($orderId2 -gt 0) {
        $xml2 = New-ScheduleXml @(@{ Date = $d1; Amount = $due2 })
        Assert-Sql "Second order sent for approval" `
            "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId2, @ActionUserId=$requester, @ScheduleXml='$xml2'" `
            'ok'

        Assert-Sql "First approver rejects with a reason" `
            "EXEC sp_Save_OrderPaymentAppLog @OrderId=$orderId2, @ActionUserId=$rejecter, @Action='Reject', @Comments='dates not acceptable'" `
            'ok'

        Assert-Equal "Round is closed as Rejected" `
            (Invoke-Scalar "SELECT TOP 1 Status FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId2 ORDER BY Round DESC, Step DESC") 'Rejected'

        $gate3 = Invoke-Table "EXEC sp_OrderPaymentApproval_CanCreateInvoice @OrderId = $orderId2"
        Assert-Equal "Rejected order still cannot create an invoice" $gate3.Rows[0]["CanCreate"] $false

        Assert-Sql "A rejected order can be reworked and resubmitted" `
            "EXEC sp_Post_OrderPaymentApp @OrderId=$orderId2, @ActionUserId=$requester, @ScheduleXml='$xml2'" `
            'ok'

        Assert-Equal "...as round 2, step 1" `
            (Invoke-Scalar "SELECT Status FROM tblOrderPaymentApprovalLog WHERE TableId=$orderId2 AND Round=2 AND Step=1") 'Posted'

        Assert-Equal "...with its own plan version" `
            (Invoke-Scalar "SELECT COUNT(*) FROM tblOrderPaymentSchedule WHERE OrderId=$orderId2 AND PlanVersion=2") 1
    } else {
        Write-Host "  SKIP  rejection path - no second candidate order in the same market" -ForegroundColor DarkGray
    }

    # -------------------------------------------------------------------------------
    # 11. Missing configuration must never auto-approve
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 11. Missing chain configuration ---"

    $unmappedRole = Invoke-Scalar @"
SELECT TOP 1 u.UserId
FROM tblUser u WITH(NOLOCK)
JOIN tbl_UserRoleInfo ur WITH(NOLOCK) ON ur.UserRoleID = u.UserRoleID
WHERE u.EmpInfoId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM tblApprovalMapMaster m WHERE m.MenuId = $MenuId AND m.FromRoleId = ur.RoleTypeId)
ORDER BY u.UserId
"@
    if ($unmappedRole -and $unmappedRole -ne [DBNull]::Value) {
        $freshOrder = Invoke-Scalar @"
SELECT TOP 1 o.OrderId
FROM tblOrder o WITH(NOLOCK)
CROSS APPLY dbo.fnOrderCreditValidation(o.OrderId) cv
WHERE o.IsInvoice = 0 AND o.OrderType = 'Regular' AND o.IsPrepareforInvoice = 1
  AND o.ActionStatus = '2' AND o.IsSubDepo = 0
  AND (cv.IsMaxOutstandingExceeded = 1 OR cv.IsCreditPeriodExceeded = 1) AND cv.DueAmount > 1
  AND NOT EXISTS (SELECT 1 FROM tblOrderPaymentApprovalLog l WHERE l.TableId = o.OrderId)
ORDER BY o.OrderId DESC
"@
        if ($freshOrder -and $freshOrder -ne [DBNull]::Value) {
            $anyXml = New-ScheduleXml @(@{ Date = $d1; Amount = 1 })
            Assert-Sql "An unconfigured role gets an error, not a silent auto-approve" `
                "EXEC sp_Post_OrderPaymentApp @OrderId=$freshOrder, @ActionUserId=$unmappedRole, @ScheduleXml='$anyXml'" `
                'error'
        }
    } else {
        Write-Host "  SKIP  every role is configured for this menu" -ForegroundColor DarkGray
    }

    # -------------------------------------------------------------------------------
    # 12. Regression: the two Invoice Creation list procs
    # -------------------------------------------------------------------------------
    Write-Host "`n--- 12. Regression: Invoice Creation list procs ---"
    $params = Invoke-Table "SELECT TOP 1 ComUnitId, DistributionRouteId, TerritoryId FROM tblOrder WITH(NOLOCK) WHERE IsInvoice=0 AND OrderType='Regular' AND IsPrepareforInvoice=1 AND ActionStatus='2' AND IsSubDepo=0 GROUP BY ComUnitId, DistributionRouteId, TerritoryId ORDER BY COUNT(*) DESC"
    $cu = [int]$params.Rows[0]["ComUnitId"]; $rt = [int]$params.Rows[0]["DistributionRouteId"]; $tr = [int]$params.Rows[0]["TerritoryId"]

    $grid = Invoke-Table "EXEC sp_LoadOrderListForOrderCreationbyTerri @manufacId = $rt, @comunitId = $cu, @TerritoryId = $tr"
    Assert-Equal "Territory-wise proc returns rows" ($grid.Rows.Count -gt 0) $true
    Assert-Equal "PaymentApprovalStatus column present" $grid.Columns.Contains("PaymentApprovalStatus") $true
    Assert-Equal "PaymentApprovalWaitingRole column present" $grid.Columns.Contains("PaymentApprovalWaitingRole") $true
    Assert-Equal "IsCreditPeriodExceeded still present" $grid.Columns.Contains("IsCreditPeriodExceeded") $true
    Assert-Equal "DueAmount still present" $grid.Columns.Contains("DueAmount") $true

    $rowsBaseline = [int](Invoke-Scalar "SELECT COUNT(*) FROM tblOrder WITH(NOLOCK) WHERE IsInvoice=0 AND OrderType='Regular' AND ComUnitId=$cu AND DistributionRouteId=$rt AND TerritoryId=$tr AND IsPrepareforInvoice=1 AND ActionStatus='2' AND IsSubDepo=0")
    Assert-Equal "The new OUTER APPLY did not duplicate or drop rows" $grid.Rows.Count $rowsBaseline

    $grid2 = Invoke-Table "EXEC sp_LoadOrderListForOrderRouteDayWise @comunitId = $cu, @routeId = $rt, @RouteDate = '$today'"
    Assert-Equal "Route-wise proc exposes PaymentApprovalStatus" $grid2.Columns.Contains("PaymentApprovalStatus") $true

} catch {
    Write-Host "`nUNEXPECTED FAILURE: $($_.Exception.Message)" -ForegroundColor Red
    $script:fail++
} finally {
    if ($conn.State -eq 'Open') {
        try {
            Write-Host "`n--- Cleanup ---"
            # Only the orders this run touched - never a time window, which would take
            # real submissions made while the test was running with it.
            $touched = @($orderId, $orderId2) | Where-Object { $_ -gt 0 }
            if ($touched.Count -gt 0) {
                $ids = $touched -join ','
                Invoke-NonQuery "DELETE FROM tblOrderPaymentSchedule WHERE OrderId IN ($ids)"
                Invoke-NonQuery "DELETE FROM tblOrderPaymentApprovalLog WHERE TableId IN ($ids)"
                Write-Host "  Test rows removed for order(s): $ids"
            } else {
                Write-Host "  Nothing to clean up."
            }
        } catch {
            Write-Host "  CLEANUP FAILED: $($_.Exception.Message)" -ForegroundColor Red
        }
        $conn.Close()
    }

    Write-Host "`n=============================================="
    Write-Host " PASSED: $script:pass    FAILED: $script:fail"
    Write-Host "=============================================="
}

if ($script:fail -gt 0) { exit 1 }
