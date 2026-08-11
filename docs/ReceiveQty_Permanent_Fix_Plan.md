# Receive Quantity — Permanent Fix Plan

**Scope:** the three confirmed problems from `docs/ReceiveQty_RootCause_Analysis.md`, investigated and fixed at their actual source (not just inside `sp_SAP_StockInTransfer`). All investigation below was run as read-only queries against the dev copy of `SalesDisDB_SMC_NEWDB`/`SAP_API_Data` on `TOWSIF\MSSQLSERVER2019` (confirmed safe/non-production earlier this engagement). No destructive statement was executed against existing data.

---

## 1. Problem 1 root cause

`sp_SAP_StockInTransfer`'s duplicate check (`RD.ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar ...)`) is evaluated once, with no transaction and no lock. Two overlapping executions for the same `@ReqId` both see the same "not yet transferred" `ReqChildId`s and both insert them. **Already fixed and verified in this engagement** (see §8 below — carried forward, not re-done here).

## 2. Problem 2 root cause

**CONFIRMED, CRITICAL.** The same physical SAP shipment can be synced into the app under a different `challan_code`/`ChalanNo` string, because:

- `SAP_API_Data.tblSAP_StockMovementMaster.challan_code` has no unique constraint and no accompanying document number, movement type, or reference field (confirmed schema investigation, prior report §6).
- `sp_SAP_WhStockInMaster`'s only duplicate guard (`challan_code NOT IN (SELECT ChallanNo FROM tblWHStockInMaster WHERE ChallanNo IS NOT NULL)`) compares the literal string — a re-issued/corrected/renumbered Chalan string sails straight through it and gets a brand-new `tblWHStockInMaster` row, which then flows through `sp_SAP_STOMaster`/`sp_SAP_STODetails` into a brand-new, independent `tblRequisition`/`tblRequsitionChild` chain.
- I re-investigated whether any *other* SAP-native field could serve as a stable identity (this session, fresh, on live data — see §4): `truck_no`, `driver_name`, `from_plant_code` are empty or reused as non-identity markers on the known duplicate records; `to_plant_code` is stable but far too coarse (shared by every shipment to that DC). **No field-level SAP identity survives a Chalan-code change.**
- I then searched the *entire* `tblWHStockInMaster`/`tblWHStockInDetail` dataset (3,144 masters, 28,691 detail rows) for shipments whose full line-item content (the complete multiset of `ProductId|Batch|Qty` tuples) is identical across two or more different `ChalanNo` values. Found **8 confirmed groups (17 duplicate master records)** with ≥3 identical lines — see §9. The Chalan-string patterns across these are inconsistent (`4500010416_Re` / `4500010416_ReNew`, `K4500002398` / `4500002398`, `1004500010437` / `4500010437`, purely sequential renumbering, and completely unrelated numbers) — **ruling out any string-parsing heuristic** (prefix/suffix stripping, edit distance) as a general solution. The full-content fingerprint is the only signal that held up across all 8 real cases.

## 3. Problem 3 root cause

**CONFIRMED.** `sp_SAP_StockInTransfer`'s CTE joins `tblWHStockInDetail` (D) to `tblRequsitionChild` (RD) only on `PD.ProductCode = RD.ProductCode AND RD.BatchNO = CS.BatchNO` — there is no real key between them. `tblRequsitionChild` has no column at all referencing back to a specific `tblWHStockInDetail`/`WHStockInDetailID` row. Whenever more than one detail row and more than one requisition-child row share the same product+batch (exactly the `ANM01`/`004-24` shape), the join produces a full cross-product before `ROW_NUMBER() OVER (PARTITION BY RD.ReqChildId ...)` arbitrarily picks one — and there is no guarantee it picks the *correct* one. **Confirmed by a live test this session**: a fixture `ReqChildId` created with `ReqQty=88` had `Quantity=77` (the sibling row's quantity) written into `tblStockInTransfar`. Querying the full dataset: **111 `(WHStockInMasterID, ProductId, Batch)` groups covering 223 detail rows** (of 28,691 total, ~0.8%) have more than one detail row and are therefore at risk of this mis-assignment.

## 4. Exact source of each problem

| Problem | Exact source |
|---|---|
| 1 | `sp_SAP_StockInTransfer` — unsynchronized check-then-insert (already fixed) |
| 2 | `sp_SAP_WhStockInMaster` — the exact point where a second, independent `tblWHStockInMaster`/downstream chain gets created for what may be an already-processed shipment under a different Chalan string |
| 3 | `sp_SAP_StockInTransfer`'s CTE join (`tblWHStockInDetail` ⋈ `tblRequsitionChild` on product+batch only) — no structural fix is possible without giving `tblRequsitionChild` a real link back to the specific detail row it came from, which is created in `sp_SAP_STODetails` |

## 5. Affected stored procedures

- `sp_SAP_StockInTransfer` (Problems 1 — already fixed; 3 — new fix below)
- `sp_SAP_WhStockInMaster` (Problem 2 — new fix below)
- `sp_SAP_STODetails` (Problem 3 — must start populating a new link column)

No other procedure in the `sp_SAP_*` chain (`sp_SAP_StockReceive`, `sp_SAP_WhStockInDetails`, `sp_SAP_STOMaster`, `sp_SAP_WHStockInApprove`, `sp_SAP_RequisitionMasterUpdate`, `sp_SAP_RequisitionDetailUpdate`) needs to change — they only pass IDs through or operate on already-correct data.

## 6. Affected SQL queries

- New duplicate-shipment fingerprint query inside `sp_SAP_WhStockInMaster` (built from the same `SAP_API_Data` join `sp_SAP_WhStockInDetails` already uses, so no new join pattern is introduced into the codebase).
- The `tblRequsitionChild` ⋈ `tblWHStockInDetail` join inside `sp_SAP_StockInTransfer`'s CTE, changed to key on the new link column (with a documented fallback for legacy rows — see §8).

## 7. Affected application code

**None.** Confirmed: no C# file calls any of `sp_SAP_WhStockInMaster`, `sp_SAP_WhStockInDetails`, `sp_SAP_STOMaster`, `sp_SAP_STODetails`, or `sp_SAP_StockInTransfer` directly — they're only reached via `sp_SAP_StockReceive`'s internal `EXEC` chain, itself triggered from `SAP_IntrigationPointDAL.SaveStockReceive` on the admin pages `SAP_StockReceive.aspx`/`SAP_StockReceiveDIC.aspx`. Per your instruction, `RcvQty`/`ReceiveProductByChalanByDC.aspx` are untouched — once `Quantity` is correct upstream, `RcvQty` (`Eval("Quantity")`) is correct automatically.

## 8. Proposed fix for each problem

### Problem 1 (already implemented and verified — carried forward)
`sp_SAP_StockInTransfer`: wrap the check-and-insert in `BEGIN TRAN` + a per-`@ReqId` `sp_getapplock` (`LockOwner='Transaction'`, auto-released on commit/rollback), `TRY/CATCH` cleanup. See prior session turn for full detail; unchanged here except for the Problem 3 join fix layered on top (below).

### Problem 2 — new
**File/SP:** `sp_SAP_WhStockInMaster`
**Current logic:** guards only on `challan_code NOT IN (SELECT ChallanNo FROM tblWHStockInMaster ...)` — literal string match.
**Problem:** a re-issued/renumbered Chalan for the same physical shipment sails through, creating a second independent Requisition chain.
**New logic:** before inserting the new `tblWHStockInMaster` row for a given `@ChallanNo`, compute that Chalan's line-item fingerprint from `SAP_API_Data` (same product/batch/qty extraction `sp_SAP_WhStockInDetails` already uses) and compare it against the fingerprints of existing `tblWHStockInMaster` records (via their already-materialized `tblWHStockInDetail` rows) from the last 90 days. If an **exact match with ≥3 lines** is found: do **not** insert the new master row (so the entire downstream chain — STOMaster/STODetails/StockInTransfer — never fires for this Chalan), and record the match in a new, purely additive table, `tblSAP_SuspectedDuplicateShipment`, for manual confirmation. If the match has 1–2 lines (weaker evidence — a small basket could coincidentally repeat), log it to the same table but **do not block** — matches your "legitimate multiple movements must not be blocked" requirement while still surfacing it for review, satisfying "do not hide the issue."
**Why this fixes it:** it directly closes the confirmed failure mode (validated against all 8 real duplicate groups found in the data) without relying on `ChalanNo` string parsing, and without silently merging/deleting anything — a human confirms before any Chalan flagged this way is allowed to proceed (by manually resolving/removing its `tblSAP_SuspectedDuplicateShipment` row, or by the ops team re-running `sp_SAP_StockReceive` once confirmed legitimate — see rollback plan §14 for exactly how that manual override works).
**Risk:** a genuinely legitimate re-delivery whose entire line-item set happens to exactly match a prior shipment (rare, but possible for a small, fixed standing order) would be flagged and held rather than auto-processed — this is a false positive, not a false negative, and requires one manual confirmation click to release, not data loss.
**Test case:** TEST 3 below.

### Problem 3 — new
**File/SP:** `tblRequsitionChild` (new nullable column), `sp_SAP_STODetails` (populate it), `sp_SAP_StockInTransfer` (use it)
**Current logic:** `tblRequsitionChild` has no reference back to the `tblWHStockInDetail` row it was created from; `sp_SAP_StockInTransfer` re-derives the association via `ProductCode+BatchNo`, which is ambiguous whenever more than one row shares both.
**Problem:** ambiguous join → arbitrary (not necessarily correct) `Quantity` assigned to a `ReqChildId`.
**New logic:** add `tblRequsitionChild.WHStockInDetailID INT NULL` (additive, nullable — does not break any existing row or query). `sp_SAP_STODetails` already loops over `tblWHStockInDetail` one row at a time to create each `tblRequsitionChild` row 1:1 — it now also writes that row's `WHStockInDetailID` into the new column. `sp_SAP_StockInTransfer`'s CTE then joins `RD ON RD.WHStockInDetailID = D.WHStockInDetailID` when that column is populated, falling back to the existing `ProductCode+BatchNo` join only for legacy `tblRequsitionChild` rows created before this fix (where the new column is `NULL`) — so nothing already in flight breaks.
**Why this fixes it:** `WHStockInDetailID` **is** the correct 1:1 key (`sp_SAP_STODetails` already iterates `tblWHStockInDetail` row-by-row when creating each `tblRequsitionChild` row) — using it removes the ambiguity entirely, rather than approximating it through product+batch.
**Risk:** none identified for new data going forward; legacy rows (created before this fix, still `IsTransfared IS NULL`) keep using the old, already-shipped ambiguous join until they're received — this is unavoidable without retroactively back-filling history, which is a data-migration decision, not a schema/logic one (see §10, §11).
**Test case:** TEST 5, TEST 6 below.

## 9. Existing duplicate-data cleanup strategy — classification (no cleanup performed)

### A. Cross-Chalan whole-shipment duplicates (Problem 2), found across the full dataset

| Group | Masters (WHId:ChalanNo) | Lines | Both/all sides received? |
|---|---|---|---|
| 1 | 1271:`4500010416_Re`, 1272:`4500010416_ReNew` | 30 | **Yes — both fully received (30/30 each)** |
| 2 | 873:`4500002398`, 875:`K4500002398` | 18 | **One pending (0/34 — this session's WHId 873/ReqId 5936), one already fully received (18/18)** — same shape as the original example |
| 3 | 1269:`1004500010437`, 1270:`4500010437` | 6 | **Yes — both fully received (6/6 each)** |
| 4 | 1998:`4500023311`, 2009:`4500023312` | 4 | **Yes — both fully received (4/4 each)** |
| 5 | 2003:`4500023304`, 2006:`4500023309` | 4 | **Yes — both fully received (4/4 each)** |
| 6 | 2196:`4901392898`, 2198:`4901392940`, 2200:`4901392977` | 3 | **Yes — all three fully received (3/3 each)** — a **triple**, not just a pair |
| 7 | 2195:`4901393222`, 2222:`4901392986` | 3 | **Yes — both fully received (3/3 each)** |
| 8 | (the originally reported case) 6295 (`4500008881`, pending), 6304 (`45000088812`, received) | 8 (sample checked; full set not re-verified here, already documented in the prior report) | One pending, one received |

**Classification: all 8 groups → DUPLICATE (high confidence).** The full line-item set matching (≥3 lines each) across genuinely different Chalan strings, with no plausible legitimate business reason for a standing order to repeat an *entire* multi-line basket identically, makes coincidence implausible. **Groups 1, 3, 4, 5, 6, 7 represent shipments that appear to have already been physically double- (or, for group 6, triple-) counted into stock**, since both/all sides show `ReceiveIssue='OK'` — **this needs inventory/finance reconciliation, which is outside what a code fix can undo.** Group 2 and the originally-reported group 8 are still partially actionable (one side not yet received) — those should be held, not received, pending confirmation.

Weaker-signal (1–2 line) matches: **119 groups, 292 masters involved** — not individually verified here (too large a set to hand-check one by one); classified as **SUSPECTED / NEEDS BUSINESS CONFIRMATION**. These are exactly what the new logging-only (non-blocking) path in the Problem 2 fix will continue to surface for review going forward, and the same fingerprint query (§9 query, reusable) can be re-run against this historical set for a dedicated reconciliation pass if you want one.

### B. Quantity mis-assignment candidates (Problem 3)

**111 `(WHStockInMasterID, ProductId, Batch)` groups, 223 `tblWHStockInDetail` rows** have more than one detail row sharing the same product+batch within the same shipment — every one of these is a **SUSPECTED** Quantity mis-assignment candidate in whatever `tblStockInTransfar`/downstream rows were derived from them (whether the assigned quantity is actually wrong depends on which of the ambiguous rows the query happened to pick at the time — not deterministically knowable in hindsight without re-deriving from `tblWHStockInDetail` directly per group, which is possible as a follow-up reconciliation report if wanted, but is a data-analysis task, not a schema/code fix).

**No records in either category were deleted, merged, or modified.** Cleanup (if wanted) is a separate, deliberate follow-up decision for you — this fix only stops **new** occurrences of both patterns.

## 10. Data migration considerations

- The new `tblRequsitionChild.WHStockInDetailID` column is added `NULL`-able with no default and **is not back-filled** for existing rows. Back-filling historical rows accurately isn't possible in the general case for exactly the reason Problem 3 exists — the correct 1:1 pairing for already-ambiguous historical rows cannot be reconstructed after the fact with certainty.
- The new `tblSAP_SuspectedDuplicateShipment` table starts empty; it only records *newly detected* matches going forward. It does not retroactively scan and populate itself with the 8 (or 119 weak) historical groups found above — that's presented as a report (§9) for your review, not auto-loaded into the new flag table, since auto-populating it would look like the system had already "acted" on historical data when it has not.

## 11. Concurrency protection

- Problem 1's per-`@ReqId` `sp_getapplock` already protects `sp_SAP_StockInTransfer` against concurrent/repeated execution for the same Requisition (already verified this session).
- Problem 2's fingerprint check in `sp_SAP_WhStockInMaster` is a read against `tblWHStockInDetail`/`tblWHStockInMaster`, evaluated before that Chalan's own insert — under the existing `challan_code NOT IN (...)` guard's transaction shape it is exposed to the same class of TOCTOU race as Problem 1 was (two concurrent calls for two *different* but content-identical Chalans could both pass the fingerprint check before either commits). Given `sp_SAP_WhStockInMaster` is only ever invoked one Chalan at a time from the admin page (not itself looped/batched by any caller in this repo), and this same class of race was already closed at the `sp_SAP_StockInTransfer` layer, I'm flagging this as a **residual, low-likelihood risk** rather than adding a second global lock here — doing so would add a global serialization point across every Chalan sync in the system, which is disproportionate for a race that would need two *simultaneous, content-identical* Chalan submissions to trigger. Noted, not fixed, in this pass — happy to add if you want it hardened further.

## 12. API retry protection

- Retrying `sp_SAP_StockReceive @ChallanNo` for the exact same Chalan string is already blocked by `sp_SAP_WhStockInMaster`'s existing exact-match guard (unchanged).
- Retrying under a re-issued/renumbered Chalan string for the same shipment is now caught by the Problem 2 fingerprint check (halted + logged, ≥3-line case).
- Retrying `sp_SAP_StockInTransfer` itself (whether via API retry or manual re-trigger) for the same `@ReqId` is protected by the Problem 1 lock.

## 13. Regression test plan

See TEST 1–10 in your message; executed and reported in §G/§H of the final report below (read-only where the existing data was used; an isolated, self-cleaning fixture used where fresh/controlled data was required).

## 14. Rollback plan

- All three changes are schema-additive or logic-only within existing procedures — no existing table was altered destructively, no existing column dropped/renamed, no existing row modified.
- To roll back: `ALTER PROCEDURE` each of the three procedures back to its pre-this-fix definition (the previous versions are preserved in git history — `sp_SAP_StockInTransfer`'s pre-Problem-1-fix version is the commit before this engagement's `spec/database/procs/sp_SAP_StockInTransfer.sql` change; `sp_SAP_WhStockInMaster`/`sp_SAP_STODetails`'s pre-fix versions are their current committed state before this change).
- `DROP TABLE dbo.tblSAP_SuspectedDuplicateShipment` if the flagging mechanism needs to be removed — safe, since nothing else references it.
- `ALTER TABLE dbo.tblRequsitionChild DROP COLUMN WHStockInDetailID` if the link column needs to be removed — safe, since `sp_SAP_StockInTransfer`'s fallback path means removing it just reverts to the pre-fix ambiguous-join behavior, it doesn't break anything structurally.
- A manual override for a Chalan wrongly held by the Problem 2 flag: mark its `tblSAP_SuspectedDuplicateShipment` row `Resolved=1` with a note, then re-run `sp_SAP_StockReceive @ChallanNo=...` — since that Chalan's fingerprint check will still find the same match, **the procedure change also needs to treat `Resolved=1` as "already confirmed legitimate, do not re-block"** (implemented below).
