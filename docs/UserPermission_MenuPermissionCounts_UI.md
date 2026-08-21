# Menu Permission screen — change counters, parent grouping, button placement

**Page:** `Solution.Web/UserPermission/UserPermission.aspx` (per-role menu permission admin)
**Date:** 2026-08-20
**Scope:** presentation only. No code-behind, BLL/DAL, stored proc, or schema change.

## What changed

### 1. Change counters above the grid

The screen previously gave no indication of what a save would actually do — an admin
re-picking a role saw a grid of checkboxes with no way to tell how many permissions were
already assigned, or how many they had just toggled on/off before hitting Submit.

A `#permCounts` line now sits directly above the grid and reports, live:

```
Previously assigned: 42 | Newly added: 3 | Deselected: 1 | After save: 44
```

- `SetBaseline()` runs after each grid render (both the Web and App loaders) and snapshots
  the checked state of every `permission{i}` checkbox into `permBaseline[]`.
- `UpdateCounts()` diffs the current state against that baseline; it is called from
  `SetBaseline()` and from the end of `CheckRowCheck(i)`, which already fires on every
  Permission-checkbox toggle.
- The baseline is per-render, so switching Role or Type resets the counters to a fresh
  "nothing changed yet" state.

The counters track the **Permission** column only — that is the column that decides whether
a menu is granted at all. The Add/View/Edit/Delete flags are per-permission detail and,
per [`spec/functional-spec.md`](../spec/functional-spec.md) §2, are mostly decorative
(menu rendering only checks row existence).

### 2. Parent name moved to its own header row

Previously the parent menu name was printed in column 3 of the first data row of each group,
sharing that row with a menu name. Each group now gets a dedicated grey (`table-secondary`)
header row carrying only the parent name; every data row leaves column 3 blank.

### 3. Submit / Reset moved below the grid

The button row was above the grid, i.e. above a list that can run to hundreds of rows. It now
sits after the table, so the admin reaches it by scrolling to the end of what they just edited.

## The one non-obvious bit: `tr.dataRow`

`Save()` iterates `$('#dtTble > tbody > tr').each(function (i) { ... })` and uses the **loop
index** `i` to look up `#slid{i}`, `#permission{i}`, `#add{i}`, etc. Those IDs are assigned from
the *data* index at render time. Injecting parent-header rows into the same `<tbody>` therefore
desynchronises the two — row 5 of the DOM is no longer data item 5 — which would have silently
saved the wrong menus.

Fix: data rows are rendered as `<tr class='dataRow'>`, header rows carry no such class, and all
three loops now select `$('#dtTble > tbody > tr.dataRow')`:

| Function | Line (approx.) |
|---|---|
| `SetBaseline()` | 370 |
| `UpdateCounts()` | 378 |
| `Save()` | 653 |

**If you ever add another non-data row to this grid, it must not carry `dataRow`.**

## Verification

Manual, in the browser (IIS Express, site `Solution.Web`, `http://localhost:58461/`):

1. Pick a Role with existing permissions → counters show `Previously assigned: N`, added/deselected `0`.
2. Tick an unchecked Permission → `Newly added` increments, `After save` increments.
3. Untick a previously-checked one → `Deselected` increments, `After save` decrements.
4. Re-tick it → both return to `0` / `N`.
5. Submit, reload, re-pick the same role → the new baseline equals the previous `After save` value.

Step 5 is the one that actually proves `tr.dataRow` is right: if the Save loop were still
misaligned, the reloaded grid would show a different set of menus than what was submitted.
