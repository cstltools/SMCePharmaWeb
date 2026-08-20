# UI Spec

## Framework

ASP.NET Web Forms (`.aspx`/`.aspx.cs` code-behind pairs, `.ascx` user controls), 702 pages across ~25 feature folders (701 as of the last full count, +1 for `SInventory_UI/RptBussinessSummary_DayWise.aspx` added 2026-08-15) — see [`modules.md`](modules.md) for the full inventory, including the live menu tree pulled directly from `tblMainMenuNew` (328 rows, 34 top-level categories) — that's the ground truth for what pages a logged-in user actually navigates to; this document covers the UI *mechanics*, not the navigation structure. `Solution.Web` is an AspNetCompiler Website project, not MVC/Razor.

## Master pages (layout shells)

Three independent master pages exist, each implementing its own copy of the session-auth gate and menu-rendering logic (not shared via inheritance):

| Master page | Notes |
|---|---|
| `MasterPages/MasterPage.master` | **Not individually inspected in this pass beyond its existence** |
| `MasterPages/MainMasterPage.master` | Auth gate + nested `<ul>` menu built by string concatenation from `PanalClsDAL.MainMenu()`/`SubItem()`/`SubSubItem()`, filtered per-user (`Session["UserId"] == 1` sees everything unfiltered) |
| `MasterPages/NewMasterPage.master` | Used by newer pages (e.g. `AreaWiseMonthlyInventoryReport.aspx`); referenced via `<%@ Page ... MasterPageFile="~/MasterPages/NewMasterPage.master" %>` |

A page not referencing any of the three gets **no** built-in login redirect — see [`docs/security.md`](../docs/security.md).

## Client-side stack

- jQuery + AjaxControlToolkit (`<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>` — `TagPrefix` varies per file, `asp` is the most common of the three seen (~183 register lines) vs. `cc1` (~69) and `ajaxToolkit` (~19); as of 2026-08-15 the `Assembly=` attribute across all of them was simplified from a pinned `Version=.../PublicKeyToken=...` reference to the bare assembly name, relying on the `<assemblyBinding>` redirect already in `web.config` instead) for autocomplete (`AutoCompleteExtender` against `SInventoryWebService` methods), tab/accordion controls.
- A Bootstrap-derived admin theme under `Solution.Web/assets/` and `Solution.Web/VerticalAsset/` (menus, icons, flags, jsPDF, DataTables.net for grid enhancement).
- `Solution.Web/CustomScript/_QuickDataAccess.js`, `_myCusGen_Func.js` — shared custom JS helpers referenced across pages.
- `crystalreportviewers13/` — the client-side JS/CSS bundle for the `CrystalDecisions.Web.CrystalReportViewer` control, localized into dozens of languages (only English is used per the app's evident audience, the rest ship unused).

## Common page patterns

- **List + Add/Edit pattern**: most master-data modules (`Area`, `Department`, `District`, `Zone`, `Market`, `Customer Category`, ...) follow a two-page pattern: an `*Entry.aspx` (or similarly named) form page and a `*View.aspx` grid page, backed by the corresponding `*BLL`/`*DAL` pair.
- **Approval grid pattern**: all 12 `Approval_UI` pages use a `GridView` (`loadGridView`) with per-row Approve/Reject `LinkButton`s gated by role match — see [`workflow.md`](workflow.md).
- **Report pattern A (Crystal)**: a thin page hosts a `CR:CrystalReportViewer` control; code-behind loads a `.rpt` and calls `.SetDataSource()`.
- **Report pattern B (GridView export)**: a filter form + `GridView`, with an export button invoking EPPlus/ClosedXML directly.
- **UpdatePanel/partial-postback AJAX (confirmed this revision, previously undocumented)**: `asp:UpdatePanel` (usually paired with `asp:UpdateProgress` for a loading indicator) wraps most page content on **562 of the ~701 `.aspx` files** — this is the dominant AJAX mechanism in the app, not the AjaxControlToolkit autocomplete/tab controls described below under Client-side stack (those are a separate, smaller usage). `asp:ScriptManager` (required to host any `UpdatePanel`) appears on 127 pages — the discrepancy is expected: a page can nest additional `UpdatePanel`s under a `ScriptManager` declared on its master page rather than itself. `GridView` itself is even more common, appearing on 337 pages (336 plus `RptBussinessSummary_DayWise.aspx`, added 2026-08-15, which alone hosts 9). Confirmed present on both of the two pages examined for this revision (`SInventory_UI/ReceiveProductByChalanByDC.aspx`, `SInventory_UI/dadtlsDelivaryInvoiceDetailsCreation_DA.aspx`), each using `NewMasterPage.master` and each hosting 2 `GridView`s.

## Conditional row actions — Invoice Creation (added 2026-08-20)

The only place in the app where a grid row's primary action is swapped for a different control based
on server-evaluated state, rather than merely disabled. `SInventory_UI/InvoiceCreationByOrder_daaw.aspx`,
driven from `orderGridView_RowDataBound` using the `PaymentApprovalStatus` column the list procedures
now emit:

| Order state | Row checkbox | Action cell |
|---|---|---|
| Not credit blocked | enabled | **Go To Invoice >>** (`btn btn-sm btn-info`) |
| Credit blocked, no request | disabled | **Go for Approval** (`btn btn-sm btn-warning`) + red reason text |
| Pending AM Approval (0) | disabled | grey badge "Pending AM Approval" |
| Pending DZSM Approval (2) | disabled | grey badge "Pending DZSM Approval" |
| Pending NSM Approval (4) | disabled | grey badge "Pending NSM Approval" |
| Fully Approved (5) | enabled | **Go To Invoice >>** |

Implementation note worth preserving: when the Go To Invoice button is hidden it is also left
`Enabled = false`, because `SyncMainGridCheckboxes()` derives each row's checkbox state from
`gotoinvoiceButton.Enabled`. Setting only `Visible = false` would silently re-enable the checkbox
for blocked rows.

`Approval_UI/OrderPaymentApprovalList.aspx` follows the existing Approval_UI conventions exactly —
`NewMasterPage.master`, Bootstrap 5 card with a coloured top border, `GridView` inside an
`UpdatePanel`, `pickadate` on `.datepicker` re-initialised from `pageLoad()`, `ShowSuccesalert`/
`faildalert` for messages and `sweetAlertConfirm_Submit` on destructive buttons. One page serves
AM, DZSM and NSM; the payment-schedule editor is rendered only on the AM step.

Note for anyone scripting these pages: ASP.NET renders GridView child controls with the **row index
appended** (`ContentPlaceHolder1_orderGridView_chkSelect_6`), not as `..._ctl08_chkSelect`, so a
`[id$="_chkSelect"]` selector matches nothing — use `[id*="_chkSelect"]`.

## Client-side validation

**Confirmed absent, not just "largely absent."** A full sweep of all `.aspx` files (700 at the time
[`validation-rules.md`](validation-rules.md) §1-2 was written; 701 as of this revision, one having
been added since — re-verified directly this revision, finding unaffected) found only 4 files using
an ASP.NET validator control at all, and the one global client-side library loaded on every page
(jQuery Validate, via `MasterPage.master`) targets a form ID (`#signupForm`) that doesn't exist anywhere in the
application — dead template boilerplate, never actually wired up. Validation in this codebase runs
server-side, on postback (`Validation()`-style methods checking `.Text == ""` after the round-trip),
full stop.

## Theming / branding

No design-system or component-library documentation found in the repo — the admin theme is a third-party Bootstrap template (assets present, no attribution/license file found in `assets/`/`VerticalAsset/` — **Not Found**).

## Accessibility

**Not Found** — no ARIA attributes, accessibility statement, or accessibility-testing configuration found in a sample of pages reviewed. Not exhaustively audited.

## Mobile / responsive

`Solution.Web/APK_File/` contains two `.apk` files (`E-Pharma.apk`, `click-pharma.apk`) — built Android app artifacts checked directly into the web project, presumably served as a direct download link somewhere in the UI (not traced to a specific page in this pass). The actual Flutter app source is not in this repository — see [`integrations.md`](integrations.md).
