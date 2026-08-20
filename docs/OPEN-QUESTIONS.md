# Open Questions

Ambiguities found while implementing the Order Payment Approval System
(`spec/requirements.md`). Each records the decision taken so the system is coherent today, and
what would change if the answer differs.

None of these blocked implementation. **Q1 and Q2 are the two worth a decision before this goes
to production** — they change what the numbers on the screen mean.

---

## OQ-1 — "Total Due" for the payment schedule: outstanding receivable, or this order's value?

`spec/requirements.md` Phase 15 requires `SUM(PaymentAmount) = TotalDueAmount` but does not say
which figure that is. The Invoice Creation grid shows two candidates per row: `DueAmount` (the
customer's outstanding receivable across unpaid invoices) and `GrossValue` (this order's value).

**Decision taken:** the customer's **outstanding receivable** (`DueAmount`), snapshotted into
`tblOrderPaymentApproval.TotalDueAmount` at request time. Rationale: the block is caused by that
outstanding balance, so the payment plan that unblocks it should clear that balance, not
pre-schedule payment for an order not yet invoiced.

**If this is wrong:** change the one `SELECT` in `sp_OrderPaymentApproval_Request` that sets
`TotalDueAmount` (currently `cv.DueAmount`) to `@GrossValue`, or store both and let the AM pick.
Nothing else changes — the validation compares against whatever is stored. Both figures are
already displayed on the approval screen.

## OQ-2 — Does the plan cover only the blocking due, or the due *plus* the new order?

Related to OQ-1 and not answered by the requirement. Business may well want the customer to
commit to clearing the old balance **and** paying for the order being released.

**Decision taken:** old balance only.
**If this is wrong:** `TotalDueAmount = cv.DueAmount + @GrossValue`, same single line.

## OQ-3 — Who may cancel a request, and is there a UI for it?

Phase 14 lists status 7 (`Cancelled`) but no phase describes who triggers it or from where.

**Decision taken:** `sp_OrderPaymentApproval_Act @Action='Cancel'` accepts it from **the
requester only**, on a request that is not yet closed, and `OrderPaymentApprovalService.Cancel`
exposes it — but no button was added, because no screen in the specification has one. The
capability exists and is authorization-checked; wiring a button to it is a markup change.

**Needs a decision:** should an Admin also be able to cancel a stuck request? Today they cannot.

## OQ-4 — Rejected/cancelled state is not shown on the Invoice Creation grid

Statuses 6 and 7 set `IsActive = 0` so the order can be re-submitted, which means the grid's
`LEFT JOIN … WHERE IsActive = 1` reports `−1` ("no live request") and the row shows **Go for
Approval** again. Phase 18's UI table lists no rejected state, so this matches the spec — but a
user does not see on that screen that their previous request was rejected, only on the approval
list.

**If a "last request was rejected" badge is wanted:** add a second `OUTER APPLY` for the most
recent inactive request and a badge in `orderGridView_RowDataBound`. Small, additive, no schema
change.

## OQ-5 — Is a rejection final, or should re-submission be limited?

Phase 21 lists "Re-submission" as a test case, so re-submission is clearly intended.

**Decision taken:** unlimited re-submission after rejection. There is currently nothing stopping
a user from re-raising a rejected request immediately and repeatedly.
**If a limit is wanted** (e.g. max 2 attempts, or a cool-off period), it is one `COUNT` against
the history in `sp_OrderPaymentApproval_Request`.

## OQ-6 — Which "NSM" is the final approver?

`tblRoleType` has two candidates: `RoleTypeId 4` (`RoleType = 'NSM'`, `DisplayName = 'Regional
Head'`) and `RoleTypeId 14` (`RoleType = 'Head of NSM'`, `DisplayName = 'NSM'`).

**Decision taken:** `RoleTypeId 4`, because that is the role held by the employees that
`tblNSMInfo` maps to a group — verified live (employee 683 → `UserRoleID` 5 → `RoleTypeId` 4).
`RoleTypeId 14` is not mapped to the org hierarchy at all.

**If Head of NSM should be the final approver instead:** change the expected role type in
`sp_OrderPaymentApproval_Act` and the resolution in `dbo.fnOrderApproverChain`, and add a
mapping table or column, since none exists for role type 14 today.

## OQ-7 — Credit rule is now expressed in three places

`dbo.fnOrderCreditValidation` duplicates the rule that lives inline inside
`sp_LoadOrderListForOrderCreationbyTerri` and `sp_LoadOrderListForOrderRouteDayWise`. This was
deliberate: rewriting two hot list procs to `CROSS APPLY` the function is a performance-risky
change to a page that loads a whole territory at once, and it is outside this requirement.

**Consequence:** if the credit rule changes, it must change in all three places. Marked with a
`ponytail:` comment in `deploy_order_payment_approval.sql` §2.
**Upgrade path:** confirm an index on `tblInvoice(CustomerMasterId)`, load-test the `CROSS APPLY`
form, then collapse to one definition.

## OQ-8 — Only one invoice-creation page is gated

`spec/requirements.md` Phase 18 names the Invoice Creation page, so
`InvoiceCreationByOrder_daaw.aspx` and the screen it navigates into
(`InvoiceCreationForCustomerByOrder.aspx`) are gated. The sample, doctor, sub-depot and DA-side
invoice paths are not.

**Needs confirmation:** should credit-blocked orders be stoppable through those routes too? The
gate is `sp_OrderPaymentApproval_CanCreateInvoice` — extending it to another page is a two-line
change there.

---

## Pre-existing issues found and fixed

- **PRE-0 — `DataAccessManager_daaw.GetDataSet` silently dropped every second result set. FIXED.**
  `DataTable.Load(IDataReader)` already advances the reader past the result set it consumed; the
  loop called `NextResult()` on top of that, so a procedure returning 3 result sets produced tables
  `[1st, 3rd]` and one returning 2 produced only the 1st. Found by driving the new approval screen in
  a browser — the page reported "not authorized" while the procedure had in fact returned data.
  Fixed at the shared method (3 callers total), which also repairs
  `Solution.Web/SInventory_UI/DAExpenseClaimList.aspx.cs:244` — its claim-**details** table has
  always come back empty for this reason. Worth a regression check on the DA Expense Claim page by
  whoever owns it, since that page's details section will start showing data it never showed before.
  Detail: `spec/business-rules.md` §0.2.

## Pre-existing issues found, not fixed (out of scope)

- **PRE-1 — Full precompilation is broken.** Three user controls declare the same class name
  `SInventory_UI_IVMarketStructureInvoSearch`
  (`SInventory_UI/IVMarketStructureInvoSearch.ascx.cs`,
  `SInventory_UI/IVMarketStructureInvoSearchReport.ascx.cs`,
  `MasterSetup_UI/IVMarketStructureInvoSearch.ascx.cs`), so `AspNetCompiler` fails CS0433 on the
  eight pages that consume them. Present since the initial commit; the running site is unaffected
  because non-precompiled ASP.NET batches per directory. Fix = rename two of the three classes
  and their `Inherits` attributes. Verified during this pass that with those two renamed the
  entire solution builds clean, so nothing else is hiding behind it.
- **PRE-2 — The "Invoice Creation" sidebar row still points at the retired
  `InvoiceCreationByOrder.aspx`** (`tblMainMenuNew` SL 324) rather than the live
  `InvoiceCreationByOrder_daaw.aspx`. Already recorded in `spec/modules.md`; left alone as an
  unrelated change.
- **PRE-3 — The AM test account (`51557`, UserId 132) has `IsPasswordChange = 0`**, so the app's
  force-password-change modal (`data-bs-backdrop="static"`, undismissable) blocks the page until the
  password is changed. Not caused by this change and not a defect — but it makes that account
  unusable for scripted UI testing without first clearing the flag, and 914 accounts in the dev
  database are in the same state.
- **PRE-4 — `Solution.Web/Bin` is not refreshed by the solution build.** The website compiles
  against that folder, so the three `Library.*.dll` files must be copied there manually after a
  build or the site compiles against stale assemblies. Worth a build step.
