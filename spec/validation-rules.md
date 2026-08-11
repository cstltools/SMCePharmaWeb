# Validation Rules

Field-level and input-format validation patterns: ASP.NET validator controls, client-side JS
validation, and server-side format/length checks that are independent of business logic. For
business-logic rules (duplicate checks, approval routing, quantity limits, invoice limits), see
[`business-rules.md`](business-rules.md). For the full foreign-key/constraint inventory, see
[`database-spec.md`](database-spec.md). For the injection-surface and password-storage findings,
see [`docs/security.md`](../docs/security.md).

## 1. ASP.NET validator controls (`.aspx` markup)

Across all 700 `.aspx` files in `Solution.Web`, only **4 files** use any of
`RequiredFieldValidator` / `RegularExpressionValidator` / `CompareValidator` / `RangeValidator` /
`CustomValidator`. This is the dominant fact about this angle: field validation is essentially
**not done via ASP.NET validator controls** anywhere in the application — required-field and
format checks are instead done ad hoc in code-behind (`Validation()`/`showMessageBox(...)`
patterns cataloged in [`business-rules.md`](business-rules.md)).

| File | Module | Validator(s) | Field | Detail |
|---|---|---|---|---|
| `SInventory_UI/UserEntry.aspx:207-210` | SInventory_UI | `RegularExpressionValidator` | `emailNameTextBox` | `ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"` |
| `UserProfile_UI/ChangePassword.aspx:476` | UserProfile_UI | `RegularExpressionValidator` | `txt_Password` | `ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$"` — the only password-complexity rule found anywhere in the codebase; not mirrored server-side, only enforced client-side by this one control |
| `UserProfile_UI/ChangePassword.aspx:488` | UserProfile_UI | `CompareValidator` | `txtConfirm` vs `txt_Password` | Confirm-password match |
| `UserProfile_UI/UserProfile.aspx:367` | UserProfile_UI | `CompareValidator` | `txtConfirm` vs `txt_Password` | Same confirm-password pattern, duplicated on the self-service profile page |
| `SInventory_UI/StockReceive.aspx:177` | SInventory_UI | `RequiredFieldValidator` | `BatchNoTextBox` | Present in markup but wrapped in an HTML comment (`<%-- ... --%>`) — dead, never rendered |

No module has "dozens of `RequiredFieldValidator`s on one form" — that pattern, common in typical
Web Forms apps, does not occur here at all. Required-field enforcement across all other ~696 pages
is done exclusively via code-behind checks before save (see `business-rules.md`'s
required-field tables per module).

## 2. Client-side JS validation

- **jQuery Validate plugin** (`assets/vendors/jquery-validation/jquery.validate.min.js`) is loaded
  globally in `Solution.Web/MasterPages/MasterPage.master:1687`, alongside
  `assets/js/form-validation.js:1701`.
- `form-validation.js` calls `$("#signupForm").validate({...})` with rules for `name`, `password`,
  `confirm_password`, `email`, `topic`, `agree` — but **no page in the application has an element
  with id `signupForm`**. This is unused boilerplate carried over from the admin-dashboard UI theme
  template; the plugin is loaded on every page but never actually invoked against a real form.
- No other `.validate(` call sites exist anywhere in `Solution.Web` outside vendor library files
  (`jquery.validate.min.js` itself, `jquery.datepick.validation.js`, `highcharts/accessibility.js`
  — all third-party, non-app code).
- **Conclusion: there is no functioning client-side JS validation anywhere in the app.** All
  `OnClientClick`/inline `onclick` handlers found on ~20+ pages (e.g. `Approval_UI/*.aspx`,
  `DoctorModule_UI/*.aspx`, `DWSP/*.aspx`) are confirm-dialog/UX helpers (e.g. "are you sure?"),
  not field-format validation.

## 3. Server-side field-format validation (code-behind, format-only)

### Already covered in `business-rules.md` (cited briefly, not re-derived)

11-digit mobile / 17-digit NID length checks recur in `CustomerEntry.aspx.cs:768` (mobile),
`DoctorEntry.aspx.cs`, `DASetup.aspx.cs`. Also confirmed in this pass:
`EmployeeSetup.aspx.cs` has **four** separate instances of the same pattern in one file —
`txtNIDNO.Text.Length != 17` (line 660), `txtEmpContactNo.Text.Length != 11` (line 674),
`ReferenceContactNo.Text.Length != 11` (line 689), `txtEmergencyContactNo.Text.Length != 11`
(line 703) — each a standalone, independently-copy-pasted check rather than a shared helper.
`CustomerEntry.aspx.cs:754` also has a commented-out `txtVoterID.Text.Length != 17` check —
dead code, not enforced.

### File upload validation (new ground)

- **`PictureHandler.ashx` / `SignatureHandler.ashx`**: both are pure image-*serving* handlers that
  stream `byte[]` out of `Session["ImageBytes"]`/`Session["SigImageBytes"]`. Neither contains any
  upload-side code — there is no extension check, no size limit, no content-type check in either
  handler. (The actual upload/capture logic that populates those session variables lives
  elsewhere, e.g. webcam/signature-pad capture pages, not scanned here.)
- **Excel/file upload pages** (16 pages with `asp:FileUpload`, e.g. `SInventory_UI/CustomerExcelUpload.aspx`,
  `CustomerPaymentExcelUpload.aspx`, `OrderListUpload.aspx`, `TransferUI/CustomerImport.aspx`, etc.):
  representative pattern in `CustomerExcelUpload.aspx.cs:262-283` (`ExcelToGrid()`):
  1. `id_fu.SaveAs(MapPath(FilePath))` — file is written to `~/ExcelFiles/` **before any
     validation of its contents or extension**.
  2. `Path.GetExtension(path) == ".xls"` / `== ".xlsx"` then selects an OLEDB provider
     (`Jet.OLEDB.4.0` vs `ACE.OLEDB.12.0`) accordingly.
  3. **Any other extension** (`.csv`, `.txt`, a renamed executable, etc.) leaves `oledbConn`
     null; the subsequent `oledbConn.Open()` throws a `NullReferenceException` — this is
     accidental failure via unhandled exception, not a deliberate validation rejection.
  4. **No file-size limit** is checked anywhere in this or the other 15 upload pages.
  5. Files are saved to a predictable path in `~/ExcelFiles/` using the user-supplied filename,
     with no filename sanitization — a path-traversal/overwrite risk worth flagging alongside
     [`docs/security.md`](../docs/security.md)'s injection catalog, though out of scope to fully
     re-derive here.
- This same "save-first, branch-on-extension-string, no size cap" shape is repeated near-verbatim
  across `CustomerPaymentExcelUpload.aspx.cs`, `CustomerTagChangeExcelUpload.aspx.cs`,
  `DeliveryExcelUploadOldData.aspx.cs`, `DepositSlipExcelUpload.aspx.cs`,
  `FixedCustomerUpload.aspx.cs`, `MIGO_Upload.aspx.cs`, `OrderListUpload.aspx.cs`,
  `StockTransferOrder.aspx.cs`, `TargetExcelUpload.aspx.cs`, `TransferUI/CustomerImport.aspx.cs`,
  `TransferUI/DoctorImport.aspx.cs`, `TransferUI/MarketInfoImport.aspx.cs` — noted once as a
  pattern rather than enumerated per file.

### Password complexity (already found, cited for completeness)

`ChangePassword.aspx.cs` pairs with the client-side `RegularExpressionValidator` above
(§1); the regex `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$` requires 12-20
characters with lower/upper/digit/symbol. This is **client-side only** — no server-side
re-validation of password strength was found in `ChangePasswordDAL.cs` or the code-behind
`ChangePassword_Click` handler, meaning a direct POST bypassing JS/validator execution would not
be rejected server-side. Passwords are stored/compared in plaintext regardless (see
[`docs/security.md`](../docs/security.md)).

### No additional numeric ID-length rules found

Beyond the mobile(11)/NID(17) pattern, a repo-wide scan for other `Length == N`/`Length != N`
guards on ID-shaped fields (`Length == 1[0-9]`) turned up no further instances outside
`CustomerEntry.aspx.cs`, `EmployeeSetup.aspx.cs`, `DoctorEntry.aspx.cs`, and `DASetup.aspx.cs` —
the pattern does not extend to other entity types (e.g. no length check found for tax IDs, trade
license numbers, or bank account numbers).

## 4. Authorization

*(Consolidated summary — referenced from `business-rules.md`'s "What's explicitly not enforced"
section, which links back here.)*

- **Login gate**: every page whose `MasterPageFile` is one of
  `Solution.Web/MasterPages/{MasterPage,MainMasterPage,NewMasterPage}.master` redirects to
  `Login.aspx` when `Session["UserId"]` is empty. This check is duplicated independently in each
  master page's own `Page_Load` rather than shared — the only universal access control in the app,
  and it only proves "is logged in," not "is authorized for this page."
- **Coarse role-bypass pattern**: `UserPersmissionValidation()` — `if (Session["UserRoleID"].ToString() != "2")` looks up a permission row keyed on the current page path; role `"2"` (Admin)
  bypasses the lookup entirely, and a missing permission row for any other role redirects to
  `Dashboard_UI/DashboardOne.aspx`. Present on 11 of 12 `Approval_UI` list pages and several
  `DoctorModule_UI`/reporting pages (full file list in `business-rules.md`); **absent** on
  `DoctorCustomerTransferApproval.aspx.cs`, which has no gate at all.
- **Granted-permission enforcement is inconsistent even when the gate fires**: once a permission
  row is found, the code that should apply its `RAdd`/`REdit` flags to hide/show Add/Edit controls
  is commented out on most pages (`AttendanceListApproval.aspx.cs:305-315`,
  `AppMonitoringList.aspx.cs`, `TourPlannedApprovalList.aspx.cs`); only `UserRecords.aspx.cs:56-65`
  applies it correctly. So passing the coarse gate still exposes full CRUD UI regardless of the
  specific rights actually granted.
- **No object-level or menu-driven access control**: menu visibility (per-user grants in
  `tblMainMenu`) only hides navigation links; it is not enforced as a page-access check, so any
  authenticated user who knows/guesses a URL can reach pages not shown in their menu, subject only
  to whichever of the two gates above (if either) happens to be present on that specific page.
- **Net effect**: authorization in this app is "logged in, plus an inconsistently-applied,
  independently-copy-pasted, per-page opt-in role check" rather than a centralized policy. See
  [`docs/security.md`](../docs/security.md) for the broader security posture (SQL concatenation,
  plaintext passwords, legacy request validation) this authorization gap sits alongside.

## 5. Database-schema-level validation (cross-reference)

The live schema (see [`database-tables.md`](database-tables.md)) enforces its own baseline
validation independent of any application code:

- **`NOT NULL` constraints** act as required-field validation at the DB layer regardless of
  whether the corresponding `.aspx` page validates the field — e.g.
  `AspNetUsers.Id nvarchar(128) NOT NULL` and `AspNetUsers.EmailConfirmed bit NOT NULL` (from
  `database-tables.md`) will reject a null insert even if code-behind never checks the field.
- **`nvarchar(N)` column widths** act as a hard length cap — an oversized value fails at the DB
  layer with a truncation/overflow error rather than a friendly validation message, even though
  the `.aspx` layer has no client- or server-side length check on the corresponding `TextBox`
  (`MaxLength` is rarely set — see §1, where no `RangeValidator`/length-bound validator exists
  anywhere in the app).
- **This is essentially the only "referential" validation the DB performs.** As documented in
  [`database-spec.md`](database-spec.md) and re-confirmed this revision by direct live-database
  introspection, only **3 real foreign-key constraints** (and 0 triggers) exist across the entire
  **570-table** schema (`sys.tables` count, `TOWSIF\MSSQLSERVER2019`/`SalesDisDB_SMC_NEWDB`, this
  pass) — so cross-table validity (e.g. "does this `CustomerId` actually exist in the customer
  table") is almost never enforced by the database itself; it depends entirely on whichever
  application-layer check (if any) was written for that specific insert/update path, per the
  duplicate-check and quantity-check tables in [`business-rules.md`](business-rules.md).

## 6. Confirmed validation-logic bugs found by reading stored-procedure/code-behind bodies directly (this revision)

- **`GroupWisePromoQtyEntry.aspx.cs`'s central-warehouse stock-cap check has a loop-exit bug that
  defeats it for any multi-row allocation.** The accumulation loop that sums checked employees' promo
  quantities calls `break` immediately after processing the *first* checked row, so the "assigned
  stock exceeds available stock" comparison never actually sums more than one employee's quantity —
  it is possible to allocate more promotional stock across employees than the central warehouse
  actually holds, and the validation will not catch it once more than one row is selected. See
  `spec/business-rules.md` §0.1 (transactional modules).
- **Insert-side duplicate-name validation is missing across at least 8 master-data entities**
  (District, Thana, CustomerType, StationType, ProgramType, SMCType, Customer Master, Delivery
  Agent) — the `sp_check_*` duplicate-check procedure is called on the UPDATE path but never on
  INSERT for these entities, so new duplicate rows can be freely created and are only caught if a
  user later tries to rename an existing row to the colliding value. See `spec/business-rules.md`
  §0.1 (MasterSetup) BR-MS-01.
- **No duplicate-shipment validation anywhere in the SAP stock-receive pipeline (2026-08-11,
  confirmed, unfixed)**: `sp_SAP_WhStockInMaster`'s only guard against re-processing a Chalan is a
  literal-string `challan_code NOT IN (...)` check — it has no way to recognize the same physical
  shipment re-synced under a *different* `challan_code` string, so `ReceiveProductByChalanByDC.aspx`
  can present an already-received shipment as a normal, un-flagged pending Chalan. Separately,
  `sp_SAP_StockInTransfer`'s own duplicate-row guard (`ReqChildId NOT IN (...)`) is an unsafe
  check-then-insert with no lock or unique constraint, confirmed to have produced 4 rows instead of
  2 for one product/batch line within a single Chalan. See `spec/business-rules.md` §1 ("Stock
  Receive by Chalan") and `spec/workflow.md` §3.4 for full detail, and
  `docs/ReceiveQty_RootCause_Analysis.md` for the investigation.
