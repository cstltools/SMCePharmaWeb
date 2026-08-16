# Receivable Report — "no data shows" bug fix

**Date:** 2026-08-16
**Page:** `Solution.Web/SInventory_UI/NewReceiveableReport.aspx` ("Receivable Report", see `spec/reports.md` §2)
**Reported symptom:** clicking Search on the Receivable Report grid never showed any rows, with no visible error.

## Root cause (two separate defects, both on the same page)

### 1. Real result sets always crashed `LoadData()` before `DataBind()`

`sp_Get_NewReceiveableListWeb` (`spec/database/procs/sp_Get_NewReceiveableListWeb.sql`) returns
`OrderCreatedByEmpCodeName` as a computed expression column:

```sql
isnull(mas.OrderSenderCode,'') + isnull(' : '+mas.OrderSenderName,'') OrderCreatedByEmpCodeName
```

`DataAccessManager.GetDataTable` loads the result via `dt.Load(reader)`
(`Library.DAL/DataManager/DataAccessManager.cs:292`), which marks SQL Server computed columns
`ReadOnly = true` on the resulting `DataTable`. `NewReceiveableReport.aspx.cs`'s
`EnsureRequestedGridColumns()` then unconditionally writes to that column for every row
(`row["OrderCreatedByEmpCodeName"] = ...`, line ~322) to backfill a display value — which threw
`System.Data.ReadOnlyException` on the very first row, aborting `LoadData()` before
`loadGridView.DataBind()` ever ran.

Net effect: **whenever the query actually returned rows, the page crashed silently.** With
`web.config`'s `<customErrors mode="RemoteOnly" defaultRedirect="login.aspx">`, a real (non-localhost)
user hitting this just got redirected back to the login page — which reads exactly like "the report
never shows anything."

The only case that ever rendered correctly was a genuinely empty result set (0 rows), because the
row-writing loop never ran.

### 2. Zero-row results rendered a blank grid with no feedback

Separately, when the query legitimately returns 0 rows, `LoadData()` bound an empty `DataTable` to
the grid and gave no indication to the user that the search had actually run — reads the same as
"nothing happened."

## Fix

`Solution.Web/SInventory_UI/NewReceiveableReport.aspx.cs`:

1. **`EnsureStringColumn`** (~line 380) now clears `ReadOnly` on any pre-existing column before the
   row-write loop runs, instead of only adding the column when it's missing:
   ```csharp
   private void EnsureStringColumn(DataTable dataTable, string columnName)
   {
       if (!dataTable.Columns.Contains(columnName))
       {
           dataTable.Columns.Add(columnName, typeof(string));
       }
       else
       {
           dataTable.Columns[columnName].ReadOnly = false;
       }
   }
   ```
2. **`LoadData()`** (~line 261) now calls `faildalert('No Data Found!', 'Faild')` when the query
   genuinely returns 0 rows, so the empty-result case is visibly distinct from "still loading" /
   "broken."

## Verification

Both fixes were exercised end-to-end against a local dev copy of `SalesDisDB_SMC_NEWDB`
(`TOWSIF\MSSQLSERVER2019`) via IIS Express, logged in as `Admin`, driven through a real Chrome
browser session (Playwright):

- **Zero-row case** (default filters, no Sales Center selected): "No Data Found!" popup now shows;
  grid stays empty as expected.
- **Real-data case** (Dhaka Distribution Center, 01-Jan-2020 – 16-Aug-2026): grid renders real
  invoice/receivable rows with correct footer totals and pagination — previously this same search
  threw the `ReadOnlyException` above on every attempt.

No stored procedure or database schema changed — this was purely an ADO.NET `DataTable` mutability
bug in the code-behind's post-processing step.
