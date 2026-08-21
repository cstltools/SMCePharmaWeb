# Full Payment Report — "no data loads" bug fix

**Date:** 2026-08-19
**Page:** `Solution.Web/SInventory_UI/DeliveryPaymentReport.aspx` ("Full Payment Report", see
`spec/reports.md` §2)
**Reported symptom:** clicking **View Report** returned an empty Details List and
`Total Net Amount : 0.00`, with no error message — for a date range that demonstrably contains
payments.

## Root cause — market-structure filters mix a historical snapshot with the current hierarchy

`tblOrder` denormalizes the market structure **as it stood when the order was placed**. It carries
both the id columns (`GroupId`, `RegionId`, `AreaId`, `TerritoryId`, `SubTerritoryId`, `MarketId`)
and a parallel set of snapshot code/name columns (`GroupCode_Ord`, `RegionCode_Ord`, `AreaCode_Ord`,
`TerritoryCode_Ord`, …). Those values are **never back-filled** when the structure is later
reorganized.

The report's cascade dropdowns, by contrast, are built from the **current** master tables —
`tblRegion.GroupId` → `tblArea.RegionId` → `tblTerritory.AreaId`
(`sp_Get_Zone_AllByGroupRpt`, `sp_CS_GetArea_ByZoneId_Rpt`, `sp_CS_GetTerritory_ByAreaId_Rpt`,
all via `IVMarketStructureInvoSearchReport.ascx.cs`).

`Parm_2()` ANDed **every** level of the hierarchy together:

```csharp
if (GroupSelect.SelectedValue    != "") param += " AND mas.GroupId='"        + ... + "' ";
if (ZoneSelect.SelectedValue     != "") param += " AND mas.RegionId='"       + ... + "' ";
if (AreaSelect.SelectedValue     != "") param += " AND mas.AreaId='"         + ... + "' ";
if (TeritorySelect.SelectedValue != "") param += " AND mas.TerritoryId='"    + ... + "' ";
if (SubTeritory.SelectedValue    != "") param += " AND mas.SubTerritoryId='" + ... + "' ";
if (MarketSelect.SelectedValue   != "") param += " AND mas.MarketId='"       + ... + "' ";
```

Once the org restructures, the *ancestor* ids on historical rows stop agreeing with the ancestors
the dropdown offers, and the conjunction matches nothing.

### Confirmed instance (local dev copy of `SalesDisDB_SMC_NEWDB`)

Territory `124` = `NK-142 : Feni-2`, sitting under Area `23` (`NK-140 : Feni`) → Region `12`
(`NK-100 : Noakhali`).

| | |
|---|---|
| Current master says | `tblRegion.RegionId=12` → `GroupId=4` = `ER-100 : East Region` |
| Historical orders say | `tblOrder.GroupId=2` = `EW-100 : East West Region` |

`GroupId=4` was itself renamed — older rows under it are stamped `SR-100 / South Region`, newer ones
`ER-100 / East Region` — so the group **ids and codes both drifted**.

Orders in territory 124 between 2025-07-01 and 2026-06-30: **505 total, 0 with `GroupId=4`.**

Bisecting the report query's `WHERE` clause over the same date range:

| Predicate set | Rows |
|---|---|
| territory 124 only | 12,852 |
| territory 124 + payment-date range | 2,916 |
| territory 124 + date + full-payment guard | 2,916 |
| **… + `mas.GroupId='4'`** | **0** |

The group predicate alone zeroes the report.

### Why it surfaced as "nothing happens" instead of an error

Two amplifiers, both pre-existing:

1. `_DAL_GetFullPaymentDAL()` (`DeliveryPaymentReport.aspx.cs:386`) wraps the DAL call in
   `catch { return new DataTable(); }`, so *any* failure — not just this one — renders as an empty
   grid rather than an error.
2. An MIO/AM/DZSM/NSM user cannot see the cause, because
   `IVMarketStructureInvoSearchReport.ascx.cs` pre-selects **and disables** the structure dropdowns
   for those roles. A field user is silently pinned to a group id that their own historical orders
   were never stamped with, and has no control to change it.

## Fix

`Solution.Web/SInventory_UI/DeliveryPaymentReport.aspx.cs:247` — `Parm_2()` now emits **only the
deepest selected level**, resolving Group / Zone / Area to the territories that currently sit under
them instead of filtering on the snapshot's ancestor ids:

```csharp
if      (MarketSelect.SelectedValue   != "") param += " AND mas.MarketId='"       + ... + "' ";
else if (SubTeritory.SelectedValue    != "") param += " AND mas.SubTerritoryId='" + ... + "' ";
else if (TeritorySelect.SelectedValue != "") param += " AND mas.TerritoryId='"    + ... + "' ";
else if (AreaSelect.SelectedValue     != "")
    param += " AND mas.TerritoryId IN (SELECT t.TerritoryId FROM dbo.tblTerritory t WITH (NOLOCK)"
           + " WHERE t.AreaId='" + AreaSelect.SelectedValue + "') ";
else if (ZoneSelect.SelectedValue     != "")
    param += " AND mas.TerritoryId IN (SELECT t.TerritoryId FROM dbo.tblTerritory t WITH (NOLOCK)"
           + " INNER JOIN dbo.tblArea a WITH (NOLOCK) ON a.AreaId=t.AreaId"
           + " WHERE a.RegionId='" + ZoneSelect.SelectedValue + "') ";
else if (GroupSelect.SelectedValue    != "")
    param += " AND mas.TerritoryId IN (SELECT t.TerritoryId FROM dbo.tblTerritory t WITH (NOLOCK)"
           + " INNER JOIN dbo.tblArea a WITH (NOLOCK) ON a.AreaId=t.AreaId"
           + " INNER JOIN dbo.tblRegion r WITH (NOLOCK) ON r.RegionId=a.RegionId"
           + " WHERE r.GroupId='" + GroupSelect.SelectedValue + "') ";
```

Program Type and Customer Type filters are unchanged — they are attributes of the order, not
hierarchy levels, and stay ANDed on.

Because the dropdowns cascade, the deepest selection already implies its ancestors under the current
structure; the ancestor predicates only ever *removed* history. Expanding Group/Zone/Area to a
territory set rather than dropping the filter entirely means a group-level search also stops losing
pre-restructure rows, not just the territory-level one that was reported.

**No stored procedure or database schema changed.** `sp_Get_AllSalesReportListParam2` concatenates
`@NewParm + @Parm2` into its dynamic SQL and was verified unmodified (`modify_date` still
2025-02-04). Its `@Parm` parameter is dead — the proc body never references it, so
`Parm()` (`DeliveryPaymentReport.aspx.cs:174`) has no effect on the result and was left alone.

## Verification

### 1. Query-level regression check

`test_fullpayment_structure_filter.ps1` (repo root, follows `test_crud_invoice_not_binding.ps1`'s
pattern) executes `sp_Get_AllSalesReportListParam2` with the old and new parameter strings for the
reported filter set:

```
old (all levels ANDed)   rows = 0
new territory            rows = 2916
new area                 rows = 15317
new zone                 rows = 128145
new group                rows = 524895
PASS: old filter reproduces the empty report
PASS: territory-level filter returns rows
PASS: area expansion covers its territory
PASS: zone expansion covers its area
PASS: group expansion covers its zone
ALL PASS
```

It is read-only, but runs the full report query — point it at dev/staging.

### 2. End-to-end browser check

Site served from `Solution.Web` by IIS Express on `http://localhost:8088` against local
`SalesDisDB_SMC_NEWDB`, driven through real Chrome via the DevTools Protocol (no automation
dependency installed — Node 24's built-in `WebSocket`). Logged in as MIO `51466`, whose role locks
the structure dropdowns to exactly the reported combination: `ER-100 : East Region` /
`NK-100 : Noakhali` / `NK-140 : Feni` / `NK-142 : Feni-2`. Filters: Payment Date Wise,
1 July 2025 → 30 June 2026.

| | Before | After |
|---|---|---|
| Total Net Amount | `0.00` | `6,693,900.88` |
| Details List | grid not rendered | 12 rows/page, 10+ pages |
| Round-trip | 1.4s | 2.2s |

The "before" run was produced by checking the original code back out and re-running the same
script, so both sides are the same page, same user, same filters.

## Still outstanding — same defect in 11 sibling pages

`Parm_2()` is copy-pasted, not shared. The identical all-levels-ANDed filter exists in:

| Folder | Pages |
|---|---|
| `SInventory_UI` | `DeliveryPaymentReportNew`, `DHB_DeliveryPaymentReport`, `DynamicSalesReport`, `GpSalesReport`, `ProformaReport`, `SalesConfirmationReport_New`, `SalesRejectionReport`, `SC_PaymentReport` |
| `MasterSetup_UI` | `OrderTrackingList`, `OrderTrackingListDBH`, `OrderTrackingSummary` |

All of them under-report — or return nothing — for any structure node that has been reorganized.
They were left untouched in this pass; the same `Parm_2()` rewrite applies verbatim to each.

Also unfixed, and the reason this class of bug is hard to spot: the swallowing
`catch { return new DataTable(); }` wrapper, which is present on `ProformaReport` as well
(`ProformaReport.aspx.cs:105`).
