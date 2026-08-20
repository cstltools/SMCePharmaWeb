# Business Summary vs Product-wise Sales Summary — Gross Sales mismatch

**Date:** 2026-08-20
**Pages:**
- `Solution.Web/SInventory_UI/RptBussinessSummary_Loading.aspx` ("Business Summary") — the reference report
- `Solution.Web/SInventory_UI/TotalSummaryNew.aspx` ("Product wise Sales Summary") — the wrong one

**Reported symptom:** with Distribution Center wise + `01-Jul-2025` … `30-Jun-2026`, the Business
Summary report's **Net Sales → Gross Amount** total and the Product wise Sales Summary's
**Sales → Gross Sales Amt** total did not agree.

**Verdict:** stored-procedure defect, not a data problem.

## The two data paths

| Report | Grid column | BLL/DAL | Stored procedure |
|---|---|---|---|
| Business Summary | `JustSalesGrossAmt` | `TotalSummaryBLL.LoadRptBussinessSummary_LoadingDAL` → `TotalSummaryDAL.cs:532` | `sp_RPT_MIS_BusinessSummary` |
| Product wise Sales Summary | `GrossSales` | `TotalSummaryBLL.LoadSummaryProductcodewise` → `TotalSummaryDAL.LoadSummaryProductcodewiseNew` (`TotalSummaryDAL.cs:121`) | `sp_ProductWiseBusinessSummaryMISReportByParam` |

Both take the same six parameters (`@fromdate`, `@todate`, `@Type`, `@Area`, `@Terr`, `@ZonId`) and
`@Type='SC'` for Distribution Center. The first aggregates per `ComUnitId`, the second per
`ProductCode`, but they are meant to net out to the same company-wide totals.

## Root cause — the 2nd return (sndReturn) was never deducted

`sp_RPT_MIS_BusinessSummary` has a `tbl2Rtn` derived table over
`tblInvoiceDetailReturn` / `tblInvoice.SndReturnPaymentDate` — the **2nd return**, i.e. goods
returned *after* the payment/collection return has already been posted — and subtracts it:

```sql
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))
 - (isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))
 - isnull(tbl2Rtn.gross,0)                     -- <— this term
   JustSalesGrossAmt
```

(The `tblOldRtn` terms cancel algebraically, so the rule reduces to
**Net Sales = delivered sales − 1st return − 2nd return**.)

`sp_ProductWiseBusinessSummaryMISReportByParam` had **no `tbl2Rtn` join at all**, in any of its four
`@Type` branches (`SC`, `Zone`, `Area`, `Territory`):

```sql
((isnull(tblSale.SalesGrossAmt,0))+isnull(tblOldRtn.ReturnGrossAmt,0))
 - (isnull(tblRtn.ReturnGrossAmt,0)+isnull(tblOldRtn.ReturnGrossAmt,0))
   AS GrossSales                               -- 2nd return simply missing
```

So its **Gross Sales Amt was overstated** — and its **Gross Return Amt understated** — by the entire
2nd-return amount for the period.

Note the proc named its old-system-return join `---return 2` in a comment; that block is
`RejectionSts='Old'` (`tblOldRtn`), which is a different thing from the sndReturn `tbl2Rtn` and is
not a substitute for it.

## Evidence

Running both procs against the dev database (`SalesDisDB_SMC_NEWDB`) with
`@fromdate='2025-07-01', @todate='2026-06-30', @Type='SC'`:

| | Before fix |
|---|---:|
| A — `sp_RPT_MIS_BusinessSummary`, Σ `JustSalesGrossAmt` | 1,822,980,384.45 |
| B — `sp_ProductWiseBusinessSummaryMISReportByParam`, Σ `GrossSales` | 1,824,006,712.44 |
| **Gap (B − A)** | **1,026,327.99** |

The raw sales base was **identical** in both procs (`Σ tblSale.SalesGrossAmt + tblOldRtn` =
1,884,028,632.15), which ruled out a data problem — the whole gap sat on the return side. A direct
query over the 2nd-return rows for the same period:

```sql
SELECT COUNT(DISTINCT iv.InvoiceId),
       SUM(ISNULL(ivD.PaymentTotalPrice        - r.sndReturnTotalPrice,0))
     - SUM(ISNULL(ivD.PaymentDiscountAmount    - r.sndReturnDiscountAmount,0))
     + SUM(ISNULL(ivD.PaymentTotalPriceVatAmount - r.sndReturnTotalPriceVatAmount,0))
FROM tblInvoice iv
JOIN tblInvoiceDetail ivD       ON iv.InvoiceId = ivD.InvoiceId
JOIN tblInvoiceDetailReturn r   ON r.InvoiceDetailId = ivD.InvoiceDetailId
WHERE r.PreviousQuantity <> r.sndReturnQuantity
  AND CONVERT(date, iv.SndReturnPaymentDate) BETWEEN '2025-07-01' AND '2026-06-30';
```

returned **106 invoices / 1,026,327.99** — the gap to the cent.

## Fix

All four `@Type` branches of `sp_ProductWiseBusinessSummaryMISReportByParam` now carry a `tbl2Rtn`
join, mirroring `sp_RPT_MIS_BusinessSummary`'s but grouped on `ProductCode` instead of `ComUnitId`:

```sql
LEFT JOIN (
SELECT  ivD.ProductCode ,
sum(ISNULL(ivD.PaymentTotalPrice- r.sndReturnTotalPrice,0)) as TP,
sum(ISNULL(ivD.PaymentTotalPriceVatAmount- r.sndReturnTotalPriceVatAmount,0)) as vat,
((sum(ISNULL(ivD.PaymentTotalPrice- r.sndReturnTotalPrice,0)) )
 -sum(ISNULL(ivD.PaymentDiscountAmount- r.sndReturnDiscountAmount,0)) )
 + sum(ISNULL(ivD.PaymentTotalPriceVatAmount- r.sndReturnTotalPriceVatAmount,0)) gross
FROM dbo.tblInvoice  iv with(nolock)
INNER JOIN dbo.tblInvoiceDetail ivD with(nolock) on iv.InvoiceId=ivD.InvoiceId
INNER JOIN dbo.tblInvoiceDetailReturn r with(nolock) on r.InvoiceDetailId=ivD.InvoiceDetailId
where  r.PreviousQuantity<>r.sndReturnQuantity
 and CONVERT(date,iv.SndReturnPaymentDate) between CONVERT(date,@fromdate) AND CONVERT(date,@todate)
GROUP BY ivD.ProductCode
)tbl2Rtn ON tbl2Rtn.ProductCode=C.ProductCode
```

The `Area` and `Territory` branches additionally join `tblOrder mas` and apply the same
`COALESCE(NULLIF(@Area,0), …)` / `@Terr` / `@ZonId` scope predicates the sibling joins in those
branches already use. The `SC` and `Zone` branches apply no scope predicate — matching the rest of
those branches, which are byte-identical to each other and ignore `@ZonId` (pre-existing behaviour,
see "Not changed" below).

Six output columns changed in each branch — the 2nd return goes **into** the Return group and
**out of** the Sales group:

| Column group | Columns | Change |
|---|---|---|
| Return | `SumofNetReturnAmount`, `DelReTpVat`, `GrossRetuen` | `+ isnull(tbl2Rtn.TP/vat/gross, 0)` |
| Sales | `SumofNetSalesAmount`, `DelTpVat`, `GrossSales` | `− isnull(tbl2Rtn.TP/vat/gross, 0)` |

No column was added, removed or renamed, so the GridView bindings and the code-behind footer sums in
`TotalSummaryNew.aspx.cs` (`row.Field<decimal?>(…)`, `row.Field<Int32?>("RetQty")`) are unaffected —
result column CLR types were re-checked after the change and are unchanged (`Decimal`, and `Int32`
for `RetQty`).

### Files

- `spec/database/procs/sp_ProductWiseBusinessSummaryMISReportByParam.sql` — source of truth
- `update_sps_ProductWiseBusinessSummary.sql` — DROP + CREATE apply script (same convention as
  `update_sps_RptBussinessSummary_DayWise.sql`)

## Verification

After applying to the dev database, both procs re-run over `01-Jul-2025 … 30-Jun-2026`, `@Type='SC'`:

| Column | Business Summary (A) | Product wise (B) | diff |
|---|---:|---:|---:|
| Net Sales Amount (TP) — `JustSalesAmtTP` / `SumofNetSalesAmount` | 1,550,414,661.35 | 1,550,414,661.35 | 0.00 |
| Net Sales VAT — `JustSalesVat` / `DelTpVat` | 272,563,539.74 | 272,563,539.74 | 0.00 |
| **Net Sales Gross — `JustSalesGrossAmt` / `GrossSales`** | **1,822,980,384.45** | **1,822,980,384.45** | **0.00** |
| Return Amount (TP) — `ReturnAmountTP` / `SumofNetReturnAmount` | 51,890,568.82 | 51,890,568.82 | 0.00 |
| Return VAT — `ReturnAmountVat` / `DelReTpVat` | 9,159,862.24 | 9,159,862.24 | 0.00 |
| Return Gross — `ReturnGrossAmt` / `GrossRetuen` | 61,048,247.70 | 61,048,247.70 | 0.00 |

`Zone`, `Area` and `Territory` branches were smoke-tested (unfiltered, and with a real
Zone=12 / Area=58 / Territory=133) — all execute and return data.

**Not yet applied to production** — run `update_sps_ProductWiseBusinessSummary.sql` against the
`SolutionConnectionStringSSIDB` target there (see `runsql.ps1` for the connection pattern).

## Not changed (deliberate — known, separate defects)

1. **Quantity columns.** `RetQty` and `NumberofInvoiceSold` do not account for 2nd-return quantity.
   `tblRtn.Retqty` is `count(ID.DeliveryQuantity-ID.PaymentQuantity)` — a `COUNT`, not a `SUM` — so
   the quantity column is already wrong independently of this fix; making it "consistent" with the
   amounts would not make it correct. Needs its own fix.
2. **`tbl2Rtn.TP` is not net of discount.** `sp_RPT_MIS_BusinessSummary` subtracts the raw
   `sum(PaymentTotalPrice − sndReturnTotalPrice)` from `JustSalesAmtTP` while computing `gross` as
   `(TP − discount) + vat`. The new join mirrors that quirk exactly so the two reports agree to the
   cent; the discount component inside it was 2,183.36 over the test period. Making both procs
   net-of-discount would change the Business Summary report's TP column and was not in scope.
3. **`Zone` branch ignores `@ZonId`.** The `Zone` branch of
   `sp_ProductWiseBusinessSummaryMISReportByParam` is byte-identical to the `SC` branch and applies
   no zone predicate; `TotalSummaryNew.aspx.cs` passes `ZonId=""` for that report type anyway
   (the assignment is commented out). Pre-existing, separate.
4. **`where C.Productgroupid=1`.** Every branch's outer `FROM dbo.tblProduct C` is filtered to
   product group 1 — 64 products, against 231 in group 3 and 76 with a NULL group. Nothing was lost
   over the test period (the sales base matched the DC-wise proc exactly), but any sale of a
   non-group-1 product would silently vanish from this report. Latent risk, untouched.

## Same defect elsewhere (not fixed)

Four more procedures reference `tblOldRtn` but have no `tbl2Rtn` join, so they carry the same
missing-2nd-return bug. Each backs a different report page and was left alone:

| Proc | Called from |
|---|---|
| `sp_ProductWiseBusinessSummaryMISReport` | `Library.DAL/SInventory_DAL/TotalSummaryDAL.cs:147` |
| `sp_ProductWiseBranchwiseBusinessSummaryMISReport` | `TotalSummaryDAL.cs:1366` |
| `sp_RPT_MIS_ProductWiseSalesReport` | `TotalSummaryDAL.cs:611` |
| `sp_RPT_MIS_RptMIOWiseReceiveableReport` | `TotalSummaryDAL.cs:579` |
