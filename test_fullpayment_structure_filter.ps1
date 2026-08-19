# Regression check for SInventory_UI/DeliveryPaymentReport.aspx (Full Payment Report).
# tblOrder keeps a snapshot of the market structure, so ANDing Group+Zone+Area+Territory
# (the old Parm_2) drops every order placed before a structure change. Parm_2 now emits
# only the deepest selected level, expanding Group/Zone/Area to current territories.
# Point this at a dev/staging DB - read-only, but it runs the full report query.

$cs = "Data Source=127.0.0.1,57694;Initial Catalog=SalesDisDB_SMC_NEWDB;User ID=sa;Password=sa1234;Connect Timeout=15"

# Screenshot case: Group ER-100 / Zone NK-100 / Area NK-140 / Territory NK-142, payments Jul'25-Jun'26.
$GroupId = 4; $RegionId = 12; $AreaId = 23; $TerritoryId = 124
$dates = " AND CONVERT(date,tblCustPay.custPaymentDate) BETWEEN '2025-07-01' AND '2026-06-30' "

$terrExpand = "SELECT t.TerritoryId FROM dbo.tblTerritory t WITH (NOLOCK)"
$areaJoin   = " INNER JOIN dbo.tblArea a WITH (NOLOCK) ON a.AreaId=t.AreaId"
$regionJoin = " INNER JOIN dbo.tblRegion r WITH (NOLOCK) ON r.RegionId=a.RegionId"

$cases = [ordered]@{
    'old (all levels ANDed)' = " AND mas.GroupId='$GroupId'  AND mas.RegionId='$RegionId'  AND mas.AreaId='$AreaId'  AND mas.TerritoryId='$TerritoryId' "
    'new territory'          = " AND mas.TerritoryId='$TerritoryId' "
    'new area'               = " AND mas.TerritoryId IN ($terrExpand WHERE t.AreaId='$AreaId') "
    'new zone'               = " AND mas.TerritoryId IN ($terrExpand$areaJoin WHERE a.RegionId='$RegionId') "
    'new group'              = " AND mas.TerritoryId IN ($terrExpand$areaJoin$regionJoin WHERE r.GroupId='$GroupId') "
}

$cn = New-Object System.Data.SqlClient.SqlConnection $cs
$cn.Open()
$counts = @{}
try {
    foreach ($k in $cases.Keys) {
        $cmd = $cn.CreateCommand()
        $cmd.CommandTimeout = 900
        $cmd.CommandText = "sp_Get_AllSalesReportListParam2"
        $cmd.CommandType = [System.Data.CommandType]::StoredProcedure
        [void]$cmd.Parameters.AddWithValue("@NewParm", $dates)
        [void]$cmd.Parameters.AddWithValue("@Parm", "")
        [void]$cmd.Parameters.AddWithValue("@Parm2", $cases[$k])
        $dt = New-Object System.Data.DataTable
        [void](New-Object System.Data.SqlClient.SqlDataAdapter $cmd).Fill($dt)
        $counts[$k] = $dt.Rows.Count
        Write-Output ("{0,-24} rows = {1}" -f $k, $dt.Rows.Count)
    }
} finally { $cn.Close() }

$fail = $false
function Check($ok, $msg) {
    if ($ok) { Write-Output "PASS: $msg" } else { Write-Output "FAIL: $msg"; $script:fail = $true }
}

Check ($counts['old (all levels ANDed)'] -eq 0) "old filter reproduces the empty report"
Check ($counts['new territory'] -gt 0) "territory-level filter returns rows"
Check ($counts['new area'] -ge $counts['new territory']) "area expansion covers its territory"
Check ($counts['new zone'] -ge $counts['new area']) "zone expansion covers its area"
Check ($counts['new group'] -ge $counts['new zone']) "group expansion covers its zone"

if ($fail) { exit 1 } else { Write-Output "ALL PASS" }
