# Project Context

> Generated from static analysis of the repository at `D:\Projects\SMCePharmaWeb` on 2026-08-05. Every claim below is grounded in a file in this repo; anything that couldn't be verified this way is marked **Not Found**.

## What this system is

**ePharma** is a distribution and field-force management ERP for a pharmaceutical company. It covers three broad areas, visible directly in the folder structure of `Solution.Web`:

1. **Distribution / inventory** (`SInventory_UI`, `SubDepot_UI`, `MasterSetup_UI`) — customers, products, warehouses/depots, stock transfers, invoicing, delivery challans, and payment collection.
2. **Field-force / medical rep management** (`DoctorModule_UI`, `DoctorMaster_UI`, `DoctorVisit_UI`, `DWSP`, `Target_UI`) — doctors, employees (MIO/ASM/RSM/NSM roles), tour plans, doctor call reports, sales targets by zone/area/territory.
3. **Approvals and reporting** (`Approval_UI`, `Reports_UI`, `SInventory_RPTVIEW`, `Dashboard_UI`) — multi-stage approval queues and both printable (Crystal Reports) and tabular (GridView/Excel) reporting.

A companion **Flutter mobile app** ("clickpharma") is referenced in `.agents/AGENTS.md` but lives outside this repository, at a path (`Apps/clickpharma_flutter`) not present here. It talks to a separate REST API host, not the ASMX service in this repo — see [`docs/integrations.md`](../docs/integrations.md).

## Repository shape

One Visual Studio solution, `Solution.sln`, five projects:

| Project | Role | Notes |
|---|---|---|
| `Solution.Web` | UI | AspNetCompiler **Website** project — no `.csproj`, see `website.publishproj` |
| `Library.DAO` | Data-holder entities/view models | No logic |
| `Library.DAL` | Data access | ~365 classes, module folders mirror `Library.DAO` |
| `Library.BLL` | Business logic | Called from `Solution.Web` code-behind |
| `Library.CrystalReports` | Report data-set definitions | Typed DataSets for Crystal Reports |

Full detail: [`docs/architecture.md`](../docs/architecture.md).

## Repository history

`git log` shows exactly **two commits**: an initial commit and "Add full ePharma web solution codebase" — the entire codebase was checked in as a single snapshot. There is no incremental commit history to mine for feature timelines, authorship of individual modules, or past decisions. Treat any "why was this built this way" question as unanswerable from git history; the code itself is the only record.

## Codebase eras

The code visibly comes from two different periods of practice, coexisting without a migration in progress:

- **Legacy majority**: raw ADO.NET, `DataTable` return types, classes named `*BLL`/`*DAL` (e.g. `PanalBLL`, `PanalClsDAL`), inline `new` instantiation, session-key-driven state.
- **Newer minority**: Dapper-backed `*Repository` classes, `*Service` classes that return human-readable validation strings, typed `Model`/`ViewModel` pairs. The clearest example is `Library.BLL/MasterSetup_BLL/CustomerInvoiceLimitService.cs` and its repository.

Most day-to-day work will touch the legacy pattern; match the surrounding file's convention rather than introducing a third style. See [`.claude/coding-rules.md`](coding-rules.md).

## Who/what this doc set is for

This `.claude/`, `docs/`, `spec/`, `plans/`, and `knowledge/` tree was generated to brief both human developers and AI coding assistants working in this repository. `plans/` in particular documents an **absence** — see that directory's files — because no roadmap, sprint plan, task tracker, or estimation artifact exists anywhere in this repo or its (two-commit) history.

## Known critical issue

Database credentials are hardcoded in plaintext in multiple places in this repo and have drifted out of sync with each other. See [`docs/security.md`](../docs/security.md) before touching any connection-string-related code.
