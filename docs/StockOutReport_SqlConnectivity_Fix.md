# Stock Out Report — local dev SQL connectivity fix

**Date:** 2026-08-16
**Page:** `Solution.Web/SInventory_UI/StockOutReport.aspx` ("Stock Out Report", see `spec/reports.md` §3)
**Reported symptom:** any page touching the database (including login) failed with

```
System.Data.SqlClient.SqlException: A network-related or instance-specific error occurred while
establishing a connection to SQL Server. ... (provider: SQL Network Interfaces, error: 26 -
Error Locating Server/Instance Specified)
```

## Root cause

`Solution.Web/web.config`'s `SolutionConnectionStringSSIDB` (and the two older hardcoded
connection sources, `Library.DAL/DataManager/SqlUserAccess.cs` and
`Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` — see `CLAUDE.md`'s note on this repo's
hardcoded-credential pattern) were pointed at `TOWSIF\MSSQLSERVER2019`, a **named instance with no
static TCP port** (`TcpDynamicPorts` in the registry, currently `57694`, changes on every SQL
Server restart).

Named-instance resolution over TCP requires a round-trip to the SQL Server Browser service (UDP
1434) to translate the instance name into that dynamic port. `sqlcmd` run directly from an
interactive shell resolved this fine — but the same connection attempted from an IIS Express
worker process launched via automation failed the same UDP resolution every time, even though
`SQLBrowser` and `MSSQL$MSSQLSERVER2019` were both confirmed `Running`. The exact mechanism
wasn't pinned down (most likely a firewall/process-sandboxing rule scoped to how that child
process was spawned) — but pointing the connection at the machine's LAN IP
(`192.168.110.110\MSSQLSERVER2019`, the same physical server) instead of the hostname sidesteps
it entirely.

## Fix

Repointed all three connection sources from `TOWSIF\MSSQLSERVER2019` to
`192.168.110.110\MSSQLSERVER2019` (same server, same database, `sa`/`sa1234`):

- `Solution.Web/web.config` → `connectionStrings/SolutionConnectionStringSSIDB`
- `Library.DAL/DataManager/SqlUserAccess.cs` → `DataSource`/`UserName`/`PassWord`
- `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` → `DataSource`/`UserId`/`Password`

All three files already had this exact connection string sitting there commented-out from a prior
round of server-switching — this was toggling to an already-prepared config, not introducing new
values.

## Verification

Exercised end-to-end via IIS Express (not just a direct SQL connection test):

- Logged in as `Admin` → redirected to `Dashboard_UI/AdminDashboard.aspx` (previously failed with
  the error above at the exact moment `PanalClsDAL.Login` opened its connection).
- Loaded `StockOutReport.aspx`, submitted a **Gift** search (Barishal Distribution Center,
  2022–2026) → real rows, correct `dd-MMM-yyyy`/`N2` formatting, working pagination.
- Submitted an **NCP** search → confirmed header swap ("Expiry Date"/"Quantity") and real rows
  from `SAP_API_Data.dbo.tbl_ExpiryReturn`.

No application code changed as part of this fix — purely the three connection-string sources.

## Update 2026-08-17: LAN IP goes stale across networks

`192.168.110.110` was only valid while the dev machine was on that particular LAN/Wi-Fi. After a
network change the machine's IP moved (check with `Get-NetIPAddress`), and the same error 26
resurfaced. Since SQL Server runs on this same machine, the durable fix is to skip both the
hostname *and* any LAN IP and connect via loopback + the instance's actual TCP port, which avoids
SQL Browser/UDP resolution entirely:

1. Read the current dynamic port from the registry (changes on every SQL Server service restart):
   `HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.MSSQLSERVER2019\MSSQLServer\SuperSocketNetLib\Tcp\IPAll`
   → `TcpDynamicPorts`.
2. Set all three connection sources' `Data Source` to `127.0.0.1,<port>` (no instance name, no
   backslash — comma-port syntax bypasses named-instance resolution).
3. Rebuild `Library.DAL` (`SqlUserAccess.cs`/`DB_Authentication.cs` are compiled into
   `Library.DAL.dll`, not read at runtime) and copy the output into `Solution.Web\bin\Library.DAL.dll`,
   then restart IIS Express so the new DLL is loaded.

If SQL Server is ever configured with a **static** TCP port instead of dynamic, this becomes a
one-time fix instead of something to redo per network change.
