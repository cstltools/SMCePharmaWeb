# Impact Analysis — Order Payment Approval System

Date: 2026-08-25 (rebuilt on the shared approval framework; first version 2026-08-20) ·
Source requirement: `spec/requirements.md` (Phases 8–14) ·
Plan: `docs/implementation/order-payment-approval-plan.md`

---

## 0. Reversal of a decision made on 2026-08-20

The first version's §3 reuse assessment **rejected** `tblApprovalMapMaster` /
`tblApprovalMapDetail`, reasoning that the sequence was fixed by the requirement
(AM → DZSM → NSM) and that a configuration surface "nobody asked for" added a way to
mis-configure a bypass.

That call was wrong on both halves, and the rebuild reverses it.

- **The sequence is not fixed.** The requirement names a default. Who approves is an
  organisational decision that changes without the code changing, and every other approval page
  in this system already treats it that way.
- **The routing is not better territory-derived.** Deriving a *named employee* per level from
  `tblASMInfo` / `tblRSMInfo` / `tblNSMInfo` looked more precise; measured against live data it
  was strictly worse. 230 of 526 active territories had no `tblNSMInfo` row for their group and
  41 had no `tblRSMInfo` row — **18,471 orders in 90 days that could never have raised a
  request**, failing with "Approver chain is incomplete for this territory". A further 18
  territories would have stalled at step one because the employee sitting in `tblASMInfo` as AM
  has a login role of DZSM. Matching on **role plus market scope**, as the framework does, has
  none of these failure modes.
- **The bypass risk was real but is addressed directly.** A configurable chain can be
  mis-configured, and the framework's own default behaviour on a missing configuration is to
  silently approve. That is fixed here rather than avoided: see FR-OPA-14.

Everything else in this document is restated against the rebuilt design.

---

## 1. What the requirement asks for, against what already exists

```
Order → Credit Validation → Can create invoice?
   YES → Invoice creation
   NO  → Go for Approval (+ payment commitment)
         → each role in the chain configured for this page
         → Invoice creation allowed
```

| Step | Existed before | Gap |
|---|---|---|
| Credit validation | **Yes**, fully. `IsMaxOutstandingExceeded` / `IsCreditPeriodExceeded` from the two order-list procs; `tblInvoiceNotBinding` holds per-customer and per-customer-type overrides | none |
| Blocked order is stopped | **Yes**, in the UI only — `orderGridView_RowDataBound` disables the checkbox and button | no server-side re-check; nothing stopped a replayed postback or direct navigation |
| Go for Approval | no | everything |
| Multi-level approval chain | **Yes** — `tblApprovalMapMaster`/`Detail` + `tblRoleType` + a per-module log table, driven from `UserPermission/ApprovalStepMap.aspx`, used by twelve pages | a log table and a pair of procs for this module; the engine itself is reused |
| Payment commitment | no | everything |
| Audit of approval actions | the framework's per-module log tables carry it for other modules | one for this module |

## 2. Existing objects affected

### Pages
| Page | Change |
|---|---|
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx` | payment-commitment modal (`mpeSchedule`/`pnlSchedule`/`gvSchedule`) added after the existing `pnl_1` modal, using the same `ModalPopupExtender` idiom; `btnGoForApproval` opens it; three display-only `HiddenField`s. No grid column added or removed. |
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs` | `orderGridView_RowDataBound` reads the framework status string; modal handlers; server-side gate in `gotoinvoiceButton_Click` **and** in `DataValidation()` (the bulk path); `Page_Load` surfaces a bounce-back reason. |
| `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs` | unchanged by the rebuild — it uses `gate.CanCreate` / `gate.Reason`, both of which survive. |
| `Solution.Web/UserPermission/ApprovalStepMap.aspx` | **not modified.** It picks up the new page automatically once `tblMainMenuNew.SL = 383` has `IsApprovalPage = 1`, because `sp_GET_MainMenuByType` filters on that flag. |

No other page is touched. `AutoInvoiceCreationByOrder.aspx`, `DoctorInvoiceCreationByOrder.aspx`,
`SampleInvoiceCreationByOrder.aspx`, `SubDepotInvoiceCreation.aspx` and the DA-side screens are
**deliberately out of scope** — see §6.

### Services / Repositories
`OrderPaymentApprovalModels.cs`, `OrderPaymentApprovalRepository.cs` and
`OrderPaymentApprovalService.cs` are rewritten in place; the three `<Compile Include>` entries
already exist. No other service or repository is modified by the rebuild.

One shared file was modified by the **first** version and is untouched here, still load-bearing:
`Library.DAL/DataManager/DataAccessManager_daaw.cs`'s `GetDataSet` skipped every second result set
(`DataTable.Load` already advances the reader; the loop called `NextResult()` on top of it). That
fix also repairs `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:244`, whose claim-details
table had always come back empty for the same reason. Detail: `spec/business-rules.md` §0.2.

### APIs
No `.asmx` / `.ashx` endpoint is added or changed. The Flutter app is unaffected. Because every
rule lives in the stored procedures rather than in the page, an API for this workflow can be added
later without re-implementing any of it.

### Stored procedures
| Proc | Change | Risk |
|---|---|---|
| `sp_LoadOrderListForOrderCreationbyTerri` | `+ OUTER APPLY (SELECT TOP 1 …) PA` over `tblOrderPaymentApprovalLog`, `+ PaymentApprovalStatus`, `+ PaymentApprovalWaitingRole` | low — `OUTER APPLY … TOP 1` returns at most one row per order, so it cannot fan out. Verified: row count identical before and after (27 → 27 on the test route). |
| `sp_LoadOrderListForOrderRouteDayWise` | same two additions | same |

No existing column, filter, join or `WHERE` clause is altered. Applied via
`alter_orderlist_payment_approval.sql`, generated from each proc's live definition so the rest of
the body is byte-identical to what is deployed today.

**Not modified:** `sp_Save_ApprovalMapMaster`, `sp_Save_ApprovalMapDetail`,
`sp_GET_ApprovalMapLoad`, `sp_GET_MainMenuByType`, `sp_GET_RoleType`. The configuration page and
its procedures are reused exactly as they are.

### Tables
No existing table is altered. `tblOrder`, `tblInvoice`, `tblInvoiceNotBinding`, `tblCustMaster`,
`tblTerritory`/`tblArea`/`tblRegion`, `tblUser`/`tbl_UserRoleInfo`/`tblRoleType`,
`View_Webapi_EmployeeFieldForceInfo` are read-only to this feature.

Two tables receive **data**, not schema changes:
`tblMainMenuNew` / `tblMenuRole` (the menu row and its grants) and
`tblApprovalMapMaster` / `tblApprovalMapDetail` (the chain — written by the configuration page,
or seeded on a dev database by `spec/database/menu/OrderPaymentApproval_chain_sample.sql`).

### Roles / permissions
No role is created. `tblMenuRole` gains grants for the new page (SL 383): the same five roles that
see the Order Approval List, **plus AM** (`UserRoleID` 3). Note that menu grants control who can
*open* the page; who can *act* is decided entirely by the configured chain.

### Reports
None affected. No report reads the new tables.

### Integrations
None. SAP staging tables and the outbound SAP call are not on this path.

## 3. Reuse assessment

| Candidate | Verdict |
|---|---|
| `tblApprovalMapMaster` / `tblApprovalMapDetail` / `tblRoleType` + `UserPermission/ApprovalStepMap.aspx` | **Reused as the engine.** This is the reversal described in §0. The chain, its ordering and its per-raising-role variants are configuration, read at runtime by the two write procs. No configuration UI was built — the existing page serves it once `IsApprovalPage = 1` is set. |
| `tblCustomerApprovalLog` and its siblings | **Pattern reused, table not shared.** Every module in this framework has its own log table keyed on its own `TableId`; sharing one across modules would collide on that key. `tblOrderPaymentApprovalLog` mirrors the shape, minus the columns nothing reads and plus `Round` (plan §3). |
| `tblApprovalLog` (1.06 M rows) / `tblOrderApprovalLog` (1.10 M rows) | **Rejected**, unchanged from the first assessment. Flat `From/To Emp` audit logs written from procs this change does not own, with a free-text `Status` and a generic `TableId`. They can record *that* something was approved; they cannot carry the round, step and waiting-role semantics the engine needs, and altering a million-row table serving other modules is a far riskier change. |
| `tblASMInfo` / `tblRSMInfo` / `tblNSMInfo` | **No longer used by this feature.** They were the first version's approver source; the framework matches on role plus market scope instead. Left completely untouched — other reports read them. |
| `View_Webapi_EmployeeFieldForceInfo` | **Reused as-is** for the caller's own market position, exactly as `CustomerApproveList.LoadData` does. |
| `tblInvoiceNotBinding` + the credit rule in the two list procs | **Reused as-is.** `dbo.fnOrderCreditValidation` re-expresses the same rule for a single order so the server-side gate has an authority; no rule was re-decided. |
| `tblUser` / `tbl_UserRoleInfo` / `tblRoleType` | **Reused as-is** for identity and role resolution. No new role, no new permission table. |
| `tblMainMenuNew` / `tblMenuRole` | **Reused as-is** for navigation. |
| `IVMarketStructureInvoSearch.ascx` | **Reused as-is** as the worklist filter, as on `CustomerApproveList.aspx`. |
| `ModalPopupExtender` idiom on `InvoiceCreationByOrder_daaw.aspx` | **Reused** for the commitment modal rather than introducing a second modal mechanism. |
| `CustomerInvoiceLimitService` pattern | **Reused as the code shape** for the service/repository. |

Created: `tblOrderPaymentApprovalLog`, `tblOrderPaymentSchedule`. Two tables, down from the first
version's three plus a trigger.

**Known duplication, deliberate:** the credit rule exists in three places — inside each of the two
list procs (unchanged, for the whole-territory set) and in `dbo.fnOrderCreditValidation` (per
order). Rewriting the two hot list procs to `CROSS APPLY` the function would remove the
duplication but is a performance-risky change to a page that loads a full territory at a time, and
is outside this requirement. Marked with a `ponytail:` note in `deploy_order_payment_approval.sql`
§3 and tracked in `docs/OPEN-QUESTIONS.md`.

## 4. New database objects

| Object | Type | Purpose |
|---|---|---|
| `tblOrderPaymentApprovalLog` | table | one row per action; **the state**. `UNIQUE (TableId, Round, Step)`. |
| `tblOrderPaymentSchedule` | table | instalments per round; `UNIQUE (OrderId, PlanVersion, PaymentDate)`, `CHECK (PaymentAmount > 0)` |
| `dbo.fnOrderCreditValidation` | inline TVF | per-order credit flags + due amount (unchanged from the first version) |
| `dbo.fnOrderPaymentApprovalState` | inline TVF | "where is this order now" — one definition shared by the gate, the list and the action proc |
| `sp_Post_OrderPaymentApp` | proc | Go for Approval + commitment validation |
| `sp_Get_OrderPaymentApp` | proc | scope-derived worklist, fully parameterised |
| `sp_Save_OrderPaymentAppLog` | proc | approve / reject, with role, turn and market checks |
| `sp_Get_OrderPaymentSchedule` | proc | the plan of one round |
| `sp_Get_OrderPaymentAppHistory` | proc | full audit trail for one order |
| `sp_OrderPaymentApproval_CanCreateInvoice` | proc | the invoice-creation gate |

**Dropped by the deploy script** (first version): `tblOrderPaymentApproval`,
`tblOrderPaymentApprovalSchedule`, `tblOrderPaymentApprovalHistory`,
`trg_tblOrderPaymentApprovalHistory_NoChange`, `dbo.fnOrderApproverChain`,
`sp_OrderPaymentApproval_Request`, `_Act`, `_GetList`, `_GetDetail`.

## 5. Concurrency and data-integrity impact

- Duplicate "Go for Approval" from two sessions: the proc refuses the second because the current
  round is still `Posted`/`Verified`, and `UNIQUE (TableId, Round, Step)` catches the race; 2601 /
  2627 is reported as a business rule ("sent for approval by someone else, please refresh").
- Two approvers acting simultaneously: the current-row read takes `UPDLOCK, HOLDLOCK` inside the
  transaction, and the unique index is the backstop — both computing the same `Step` cannot both
  land. The loser is told to refresh rather than double-approving.
- Commitment rows and the log row move together inside one transaction with `XACT_ABORT ON`.
- A rejected round stays in place; a re-submission opens a new `Round`, so nothing is overwritten
  or deactivated and the earlier attempt remains readable.

## 6. Explicitly out of scope

1. **Other invoice-creation pages.** Only the page named in the requirement
   (`InvoiceCreationByOrder_daaw.aspx`) and the screen it navigates into are gated. The sample,
   doctor, sub-depot and DA-side paths keep their current behaviour. Because the gate is a stored
   procedure, extending it to any of them later is a two-line change on that page.
2. **The pre-existing `SInventory_UI_IVMarketStructureInvoSearch` triple class-name collision**
   that breaks full precompilation. Unrelated to this requirement; see `docs/OPEN-QUESTIONS.md`.
3. **Recording actual payments against the agreed plan.** The requirement defines the plan and its
   approval, not its subsequent collection. `tblCustPayDetail` is untouched.
4. **Fixing the framework's other pages.** The weaknesses identified in `CustomerApproveList` and
   `sp_Get_CustomerApp` — client-side authorization, concatenated dynamic SQL, no transaction, and
   the `OR @Status='Accepted'` chain skip unique to `sp_webapi_SaveCustomerAppLog` — are **not**
   inherited by this module, but they are also not fixed in theirs. Each is a separate change with
   its own regression surface.
