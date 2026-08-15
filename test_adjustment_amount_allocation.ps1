# Verifies the sequential MIN-based adjustment allocation algorithm now used by
# AdjustmentAmount() in Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs
# against the four worked examples from the business requirement spec.
# Pure arithmetic check - no DB connection, no page lifecycle involved.

function Allocate-Adjustment {
    param([decimal]$TotalAdjustment, [decimal[]]$NetBeforeAdjustment)

    $remaining = $TotalAdjustment
    $applied = @()
    foreach ($net in $NetBeforeAdjustment) {
        $row = if ($remaining -gt 0) { [Math]::Min($net, $remaining) } else { 0 }
        $applied += $row
        $remaining -= $row
    }
    return ,$applied
}

function Assert-Equal($expected, $actual, $label) {
    if ("$expected" -ne "$actual") {
        throw "FAIL: $label - expected [$($expected -join ',')] got [$($actual -join ',')]"
    }
    Write-Output "PASS: $label"
}

# Example 1: 100 adjustment, rows exactly consume it
$applied = Allocate-Adjustment -TotalAdjustment 100 -NetBeforeAdjustment @(60, 20, 10, 10)
Assert-Equal @(60, 20, 10, 10) $applied "Example 1 - exact consumption"

# Example 2: 100 adjustment, extra row left untouched
$applied = Allocate-Adjustment -TotalAdjustment 100 -NetBeforeAdjustment @(60, 20, 10, 10, 50)
Assert-Equal @(60, 20, 10, 10, 0) $applied "Example 2 - trailing row untouched"

# Example 3: 100 adjustment, last row partially absorbs remainder
$applied = Allocate-Adjustment -TotalAdjustment 100 -NetBeforeAdjustment @(60, 20, 10, 50)
Assert-Equal @(60, 20, 10, 10) $applied "Example 3 - partial last row"

# Example 4: adjustment exceeds total available net amount - never goes negative
$applied = Allocate-Adjustment -TotalAdjustment 150 -NetBeforeAdjustment @(60, 20, 10, 10)
Assert-Equal @(60, 20, 10, 10) $applied "Example 4 - capped at available net amount"
$sumApplied = ($applied | Measure-Object -Sum).Sum
if ($sumApplied -gt 150) { throw "FAIL: Example 4 - sum applied ($sumApplied) exceeds total adjustment (150)" }
Write-Output "PASS: Example 4 - sum applied ($sumApplied) never exceeds total adjustment"

# Invariant: every NetAmountAfterAdjustment >= 0
$netBefore = @(60, 20, 10, 10)
$applied = Allocate-Adjustment -TotalAdjustment 150 -NetBeforeAdjustment $netBefore
for ($i = 0; $i -lt $netBefore.Count; $i++) {
    $after = $netBefore[$i] - $applied[$i]
    if ($after -lt 0) { throw "FAIL: row $i went negative ($after)" }
}
Write-Output "PASS: NetAmountAfterAdjustment never negative"

Write-Output "All allocation checks passed."
