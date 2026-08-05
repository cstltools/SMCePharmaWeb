# Functional Spec

Functional description of what the system does, organized by capability. This complements [`modules.md`](modules.md) (structural inventory) and [`workflow.md`](workflow.md) (process detail) rather than repeating them — read those alongside this file for the full picture.

## 1. Authentication & session

A user logs in with a username/password on `Login.aspx`. On success, ~14 pieces of context (user ID, role, company unit, employee info, designation, password-change-required flag, etc.) are loaded into the session in one shot, and the user is routed either to an admin dashboard or a role-specific dashboard depending on an `IsMainDashboard` flag returned by the login query. Every subsequent page (that uses a shared master page) checks for an active session and bounces to login if absent. See [`docs/security.md`](../docs/security.md) for the authentication mechanism's actual (non-hashed, non-Forms-Auth) implementation.

## 2. Menu & permissions

Each logged-in user sees a nav menu built specifically for them: `Solution.Web/CommonUI/UserPermission.aspx` lets an admin grant/revoke individual menu items per user (not per role), and the master page renders only granted items (with `UserId == 1` as an unfiltered superuser). This is presentation-layer filtering, not access control — see [`docs/security.md`](../docs/security.md) for the distinction.

## 3. Master data management

Customers, doctors, products, employees, and the full geographic/organizational hierarchy (Group → Region → Area → Territory → Sub-Territory → Market, and separately Division → District → Thana) are each managed through a consistent list/entry pattern across dozens of `*_UI` folders — see [`modules.md`](modules.md). Most support a "name already exists" uniqueness rule (see [`business-rules.md`](business-rules.md)) before allowing a save.

## 4. Order-to-cash (core distribution function)

The system's primary transactional function: a sales order is entered, routed through approval, converted to an invoice, confirmed for delivery by a DA (delivery agent, re-approved by a DIC), delivered via a challan, and finally collected as payment — with sales return as a possible branch at multiple points. See [`docs/business-flow.md`](../docs/business-flow.md) for the full lifecycle diagram and [`workflow.md`](workflow.md) for each approval stage's mechanics. Customer-specific invoice value limits (`CustomerInvoiceLimitService`) and invoice-not-binding exception rules can gate or exempt specific customers from this flow.

## 5. Warehouse & stock management

Central store, distribution-center (DC) store, sub-depot store, and warehouse stock are each tracked with their own set of transfer, adjustment, freeze/release, and stock-out workflows (`SInventory_UI`, `SubDepot_UI`). Stock-out and return quantities are checked against current stock (see [`validation-rules.md`](validation-rules.md)) before being accepted, though enforcement strength varies by page.

## 6. Field-force / medical rep management

A separate but related function tracking the sales-rep hierarchy (MIO/ASM/RSM/NSM roles — see [`../knowledge/glossary.md`](../knowledge/glossary.md)), their tour plans, doctor visits (DCR — daily call reports), doctor call programmes (DCP), and prescription (RX) capture — each with its own approval workflow (see [`workflow.md`](workflow.md)) and monthly reporting family (`Reports_UI`).

## 7. Targets

Sales targets can be set at national, zone, area, and territory level (`DWSP`, `Target_UI`), and achievement against those targets is reported (`Reports_UI/TargetAChivementReport[New]`).

## 8. Claims & leave

Employees submit expense claims, mileage claims, and leave applications (`LeaveProcess_UI`, and entry points feeding the `Approval_UI` claim queues), each routed through the same multi-level approval engine as the sales workflows.

## 9. Promotions

Group-wise and MIO-tagged promotional (free-goods) quantity allocation (`PromoAlloc`) — a narrower module, 6 pages, not deeply investigated beyond its existence and folder purpose in this pass.

## 10. Reporting

Two parallel reporting capabilities — formal printable documents via Crystal Reports (94 report types) and ad hoc tabular/Excel-exportable reports via GridView (14+ report types plus the 16-report `Reports_UI` family) — see [`reports.md`](reports.md) for the full catalog.

## 11. SAP reconciliation & loyalty program

Internal staging-table reconciliation screens for data destined for/from a separate SAP integration process, plus a retail-outlet "e-Program" loyalty scheme's dropout-request tracking — see [`integrations.md`](integrations.md). The actual SAP-side connector is outside this repository.

## 12. Administration

User/role/menu-permission management, approval-routing configuration (`UserPermission`), archive-database-backup triggering (`SettingPanel_UI`), company/notice-board setup, and session/activity tracking (`UserTracking`, reading `dbo.tblUserSessionTracking`).

## Explicitly out of scope for this document

Any function this repository doesn't implement — e.g. the Flutter mobile app's own logic — is **Not
Found** here by definition; this spec only covers what's observable in `D:\Projects\SMCePharmaWeb`.
Note `BASE_URL` in `SqlUserAccess.cs` is now confirmed **dead** (zero call sites, see
[`integrations.md`](integrations.md) §4a) rather than an unknown live integration — the mobile app's
actual entry points into this repo are the `sp_Webapi*`/`sp_SalesAPI*` stored procedures, not that
constant.
