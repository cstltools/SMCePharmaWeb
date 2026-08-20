# Impact Analysis — Order Payment Approval System

Date: 2026-08-20 · Source requirement: `spec/requirements.md` (Phases 8–14) ·
Plan: `docs/implementation/order-payment-approval-plan.md`

---

## 1. What the requirement asks for, against what already exists

```
Order → Credit Validation → Can create invoice?
   YES → Invoice creation
   NO  → Go for Approval → AM → Payment Schedule → DZSM → NSM → Invoice creation allowed
```

| Step | Existed before | Gap |
|---|---|---|
| Credit validation | **Yes**, fully. `IsMaxOutstandingExceeded` / `IsCreditPeriodExceeded` from the two order-list procs; `tblInvoiceNotBinding` holds per-customer and per-customer-type overrides | none |
| Blocked order is stopped | **Yes**, in the UI only — `orderGridView_RowDataBound` disables the checkbox and button | no server-side re-check; nothing stopped a replayed postback or direct navigation |
| Go for Approval | no | everything |
| AM → DZSM → NSM chain | the **org ladder** exists (`tblASMInfo`/`tblRSMInfo`/`tblNSMInfo`); no approval workflow rides on it for this purpose | workflow, state machine, authorization |
| Payment schedule | no | everything |
| Audit of approval actions | generic logs exist (`tblApprovalLog`, `tblOrderApprovalLog`) but carry no payment-plan or 0–7 status semantics | purpose-built history |

## 2. Existing objects affected

### Pages
| Page | Change |
|---|---|
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx` | +1 button (`btnGoForApproval`), +1 status label (`lblApprovalStatus`) inside the existing "Go To Invoice" template column. No column added or removed. |
| `Solution.Web/SInventory_UI/InvoiceCreationByOrder_daaw.aspx.cs` | `orderGridView_RowDataBound` becomes approval-status aware; new `btnGoForApproval_Click`; server-side gate added to `gotoinvoiceButton_Click` **and** to `DataValidation()` (the bulk path); `Page_Load` surfaces a bounce-back reason. |
| `Solution.Web/SInventory_UI/InvoiceCreationForCustomerByOrder.aspx.cs` | `Page_Load` re-checks the gate for `Session["OrderId"]` and bounces a blocked order back. |

No other page is touched. `AutoInvoiceCreationByOrder.aspx`, `DoctorInvoiceCreationByOrder.aspx`,
`SampleInvoiceCreationByOrder.aspx`, `SubDepotInvoiceCreation.aspx` and the DA-side screens are
**deliberately out of scope** — see §6.

### Controllers / Services / Repositories
One existing shared file is modified: `Library.DAL/DataManager/DataAccessManager_daaw.cs`'s
`GetDataSet` skipped every second result set (`DataTable.Load` already advances the reader; the loop
called `NextResult()` on top of it). Found by driving the new approval screen in a browser. Fixed at
the shared method rather than worked around per caller — it has only three callers, and the fix also
repairs `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:244`, whose claim-details table has
always come back empty for the same reason. `DAExpenseClaimApprovalList.aspx.cs` reads only
`Tables[0]` and is unaffected either way. Detail: `spec/business-rules.md` §0.2.

No other existing service or repository is modified. Three files are added
(`OrderPaymentApprovalModels.cs`, `OrderPaymentApprovalRepository.cs`,
`OrderPaymentApprovalService.cs`) plus their `<Compile Include>` entries in the three `.csproj`
files.

### APIs
No `.asmx` / `.ashx` endpoint is added or changed. The Flutter app is unaffected — it does not
consume the Invoice Creation page. **However**, because every rule lives in the stored
procedures rather than in the page, an API for this workflow can be added later without
re-implementing any of it.

### Stored procedures
| Proc | Change | Risk |
|---|---|---|
| `sp_LoadOrderListForOrderCreationbyTerri` | `+ LEFT JOIN dbo.tblOrderPaymentApproval PA ON PA.OrderId = tblOrder.OrderId AND PA.IsActive = 1`, `+ PaymentApprovalStatus`, `+ PaymentApprovalId` | low — join is on a unique filtered index, so it cannot fan out rows. Verified: row count identical before and after (27 → 27 on the test route). |
| `sp_LoadOrderListForOrderRouteDayWise` | same two additions | same |

No existing column, filter, join or `WHERE` clause is altered. Applied via
`alter_orderlist_payment_approval.sql`, generated from each proc's live definition so the rest
of the body is byte-identical to what is deployed today.

### Tables
No existing table is altered. `tblOrder`, `tblInvoice`, `tblInvoiceNotBinding`,
`tblCustMaster` are read-only to this feature.

### Roles / permissions
No role is created. `tblMenuRole` gains grants for the new page (SL 383): the same five roles
that see the Order Approval List, **plus AM** (`UserRoleID` 3), which is a first-class approver
here but is not on that list's grant set.

### Reports
None affected. No report reads the new tables.

### Audit
The existing generic logs are untouched and keep receiving what they receive today. The new
workflow writes to its own append-only history table.

### Integrations
None. SAP staging tables and the outbound SAP call are not on this path.

## 3. Reuse assessment — why three new tables, and only three

Per `spec/requirements.md` Phase 12, existing structures were searched before creating anything.

| Candidate | Verdict |
|---|---|
| `tblApprovalLog` (1.06 M rows) / `tblOrderApprovalLog` (1.10 M rows) | **Rejected as the workflow store.** Both are flat `From/To Emp` audit logs written from inside procs this change does not own, keyed on a generic `TableId`, with a free-text `Status`. They can record *that* something was approved; they cannot express a payment schedule, a plan version, an old/new value pair, or a strict 0–7 state machine, and adding columns to a table with a million rows serving other modules would be a far riskier change than a new table. |
| `tblApprovalMapMaster` / `tblApprovalMapDetail` / `tblApprovalStepsNew` | **Rejected.** These configure *role-sequence-by-menu* for the generic approval engine. This workflow's sequence is fixed by the requirement (AM → DZSM → NSM) and its routing is territory-derived per order, not menu-derived. Wiring it through the generic engine would add a configuration surface nobody asked for and a way to mis-configure a bypass. |
| `tblASMInfo` / `tblRSMInfo` / `tblNSMInfo` + `tblTerritory`/`tblArea`/`tblRegion` | **Reused as-is** for approver resolution, via `dbo.fnOrderApproverChain`. No hierarchy table created. |
| `tblInvoiceNotBinding` + the credit rule in the two list procs | **Reused as-is.** `dbo.fnOrderCreditValidation` re-expresses the same rule for a single order so the server-side gate has an authority; no rule was re-decided. |
| `tblUser` / `tbl_UserRoleInfo` / `tblRoleType` | **Reused as-is** for identity and role resolution. No new role, no new permission table. |
| `tblMainMenuNew` / `tblMenuRole` | **Reused as-is** for navigation. |
| `CustomerInvoiceLimitService` pattern | **Reused as the code shape** for the new service/repository. |

Created: `tblOrderPaymentApproval`, `tblOrderPaymentApprovalSchedule`,
`tblOrderPaymentApprovalHistory` — exactly the three the requirement anticipated, and no more.

**Known duplication, deliberate:** the credit rule now exists in three places — inside each of
the two list procs (unchanged, for the whole-territory set) and in `dbo.fnOrderCreditValidation`
(per order). Rewriting the two hot list procs to `CROSS APPLY` the function would remove the
duplication but is a performance-risky change to a page that loads a full territory at a time,
and is outside this requirement. Marked with a `ponytail:` note in
`deploy_order_payment_approval.sql` §2 and tracked in `docs/OPEN-QUESTIONS.md`.

## 4. New database objects

| Object | Type | Purpose |
|---|---|---|
| `tblOrderPaymentApproval` | table | one live request per order (filtered unique index on `OrderId WHERE IsActive = 1`), status 0–7, snapshotted due amount and approver chain |
| `tblOrderPaymentApprovalSchedule` | table | instalments per plan version; unique index on `(request, version, date)` |
| `tblOrderPaymentApprovalHistory` | table | append-only audit; `INSTEAD OF UPDATE, DELETE` trigger raises |
| `dbo.fnOrderCreditValidation` | inline TVF | per-order credit flags + due amount |
| `dbo.fnOrderApproverChain` | inline TVF | territory → AM / DZSM / NSM employee ids |
| `sp_OrderPaymentApproval_Request` | proc | Go for Approval |
| `sp_OrderPaymentApproval_Act` | proc | approve / reject / cancel, with the payment schedule on the AM step |
| `sp_OrderPaymentApproval_GetList` | proc | role-scoped worklist |
| `sp_OrderPaymentApproval_GetDetail` | proc | header + schedule + history, IDOR-checked |
| `sp_OrderPaymentApproval_CanCreateInvoice` | proc | the invoice-creation gate |

## 5. Concurrency and data-integrity impact

- Duplicate "Go for Approval" from two sessions: the filtered unique index rejects the second;
  the proc catches 2601/2627 and reports it as a business rule.
- Two approvers acting simultaneously: the `UPDATE … WHERE ApprovalStatus = @expected` +
  `@@ROWCOUNT = 0` check means the loser is told to reload rather than double-approving.
- Schedule and header move together inside one transaction with `XACT_ABORT ON`.
- A rejected or cancelled request is deactivated (`IsActive = 0`), which both frees the unique
  index for a re-submission and preserves the row and its history.

## 6. Explicitly out of scope

1. **Other invoice-creation pages.** Only the page named in the requirement
   (`InvoiceCreationByOrder_daaw.aspx`) and the screen it navigates into are gated. The sample,
   doctor, sub-depot and DA-side paths keep their current behaviour. Because the gate is a
   stored procedure, extending it to any of them later is a two-line change on that page.
2. **The pre-existing `SInventory_UI_IVMarketStructureInvoSearch` triple class-name collision**
   that breaks full precompilation. Unrelated to this requirement; see
   `docs/OPEN-QUESTIONS.md`.
3. **Recording actual payments against the agreed schedule.** The requirement defines the plan
   and its approval, not its subsequent collection. `tblCustPayDetail` is untouched.
