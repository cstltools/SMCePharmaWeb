# Requirements

Per this pass's instructions: requirements below are split into three categories and none are
invented. "Verified from implementation" is inferred strictly from what the running system actually
does (confirmed by direct source reading, live-database introspection, and cross-referencing C# call
sites against stored-procedure bodies across all six module clusters of this codebase — SInventory;
DoctorModule; MasterSetup/Thana/SubDepot; the smaller transactional modules; platform/auth/API; and
all 58 views/43 functions). "Existing documented requirements" is content someone on the team already
wrote down as a requirement/spec — preserved as-is below, not re-derived. "Not verified / requires
confirmation" lists genuine open questions this pass could not resolve from static analysis alone.

## 1. Verified from implementation

The system (confirmed via source + live schema, not assumed) implements:

- **Order-to-cash lifecycle**: order entry → chain-based multi-role approval → conversion to
  proforma/delivery invoice with FEFO batch stock allocation → delivery confirmation → payment
  collection → DA-side sales/payment/return sub-tracking → DIC re-approval. Full detail:
  `spec/workflow.md` §4.
- **Field-force management**: org hierarchy (Group→Region→Area→Territory→SubTerritory→Market,
  cross-cut by an MIO/AM/ASM/DZSM/RSM/NSM reporting ladder), tour/visit planning with a chain-based
  approval workflow **and** a parallel legacy bulk-approve mechanism (`spec/workflow.md` §2a), daily
  call reports, prescription capture with photo evidence, leave/attendance/expense/mileage/TADA claim
  capture and approval.
- **Master data management**: customer, product, doctor, and full geography/org-hierarchy CRUD, with
  update-time (but not consistently insert-time) duplicate-name checking.
- **Sub-depot distribution operations**: stock transfer, invoicing, and adjustment vouchers at the
  sub-depot level, functionally parallel to but implemented independently of the main distribution
  center path.
- **Market-structure transfer**: propose→approve reassignment of Market/Sub-Territory/Territory
  nodes between organizational units — confirmed **not fully functional** for Area/Zone transfers
  specifically (`spec/workflow.md` §5a).
- **Role/menu-based navigation** via three overlapping menu-generation systems, each with a
  hardcoded superadmin bypass (`spec/business-rules.md` §0.1, platform findings).
- **SAP integration**: staging-table reconciliation (bidirectional, app↔SAP via a shared
  `SAP_API_Data` database) plus one live, direct outbound HTTPS call to a SAP REST endpoint issued
  from inside a stored procedure via SQL Server OLE Automation (`spec/integrations.md` §1/§1a-revised).
- **Reporting**: Crystal Reports (`Library.CrystalReports`) and in-page GridView/Excel export
  reporting, plus a family of BI-tool-shaped database views (several frozen to hardcoded historical
  date ranges, several with zero confirmed callers from this application — plausibly consumed by an
  external BI/reporting tool not in this repo).
- **No automated password hashing** — plaintext storage and comparison confirmed at the login,
  change-password, and account-settings layers (`spec/business-rules.md` §0.1, platform findings).
- **No consistent per-page authorization** — a session-exists check is universal; role/permission
  checks beyond menu visibility are opt-in and present on only a minority of the application's ~700
  pages.

## 2. Existing documented requirements

The following is a requirement document that already existed in this repository prior to this pass,
preserved verbatim below (not re-derived). Its described behavior (gate the Doctor dropdown to
Customer Type = MDC, matched by identifier not full display text) was independently **confirmed
already implemented** by the MasterSetup-cluster analysis in this pass — `CustomerInfoDAL.SaveInfo`'s
doctor-tagging sync is gated via `ddlChemisType`'s text prefix match against `"MDC"`
(`CustomerEntry.aspx.cs:913`, per `spec/business-rules.md` §0.1/BR-MS-06) — so this requirement
appears to already be satisfied by current code, though the exact "not hardcode the full display
text" matching-rule nuance below was not independently re-verified line-by-line against the specific
matching logic used.

### Requirement: Conditional Doctor Dropdown by Customer Type

#### Objective

Update the Customer Entry page:

`MasterSetup_UI/CustomerEntry.aspx`

The **Doctor** dropdown/list should be loaded and displayed/enabled **only when Customer Type is "MDC"**.

Currently, the Customer Type dropdown contains values such as:

- MDC (FY 26-27)
- Other customer types

The Doctor field should depend on the selected Customer Type.

---

#### Functional Requirement

##### 1. Customer Type = MDC

When the selected Customer Type matches **MDC**:

- Load the Doctor dropdown/list.
- Doctor field should be enabled.
- Doctor list should be populated from the existing Doctor data source/mechanism.
- Existing Doctor selection functionality should remain unchanged.
- The user should be able to select a Doctor.

Example:

`Customer Type: MDC (FY 26-27)`

→ Doctor dropdown should be available.

---

##### 2. Customer Type is NOT MDC

When the selected Customer Type does NOT match **MDC**:

- Doctor dropdown should NOT be loaded.
- Doctor field should be disabled or hidden according to the existing UI pattern.
- Any previously selected Doctor value should be cleared.
- No Doctor-related API/database call should be triggered unnecessarily.

Example:

`Customer Type: XYZ`

→ Doctor dropdown should not be available.

---

#### Matching Rule

The Customer Type value should be checked based on the **MDC identifier**, not by hardcoding the complete display text.

For example:

`MDC (FY 26-27)`

should be considered an MDC customer type.

If the database value/ID represents MDC, use that value/ID for the condition whenever possible.

Do NOT make the logic dependent only on:

```javascript
if (customerType == "MDC (FY 26-27)")
```

*(The original requirement document was truncated at exactly this point — the closing fence and
whatever example followed were never written. Preserved as-found; not reconstructed, since inventing
the missing example would violate the "do not invent requirements" instruction for this pass.)*

## 3. Not verified / requires confirmation

Genuine open questions surfaced across all six module-cluster analyses that could not be resolved
from static source analysis alone:

- **What HTTP layer, if any, exposes the `sp_Webapi_*`/`sp_SalesAPI_*` stored-procedure family to the
  companion Flutter mobile app?** No `ApiController`/`[Route]`/REST framework code was found anywhere
  in this repository despite strong circumstantial evidence (proc naming, a dedicated
  `View_FieldForce*`/`View_Webapi_*` view family) that this proc family is the mobile app's real data
  layer. `CLAUDE.md`'s claim that `SInventoryWebService.cs` serves this role does not match that
  class's autocomplete-shaped method signatures. Resolving this requires either finding a second
  repository/project, or confirming with whoever built the mobile integration.
- **Is `sp_ApproveCustomerInformation` (customer-approval, direct path) actually invoked in
  production, or has it been superseded by the chain-based `sp_webapi_SaveCustomerAppLog` approval
  path documented in `spec/workflow.md`?** Static analysis suggests the direct path would raise a SQL
  `CAST` error if hit against data produced by the current insert procedure — needs either a
  production error-log check or confirmation from whoever maintains `CustomerApproveList.aspx.cs`.
- **Is the Doctor leg of Customer/Doctor territory-transfer approval (`sp_Update_Customer_Doctor_TransferApprove`) intentionally frozen, or an unnoticed regression?** The entire mutation branch for
  doctors is commented out; the identical Customer-side branch works. Needs confirmation from the
  team of whether doctor transfers are a deprecated/on-hold feature.
- **Is `sp_Deletenvoice` (broken body, `delete Invoice` with no `FROM`) ever actually exercised in
  production**, or has its one live C# call site simply never been hit? Needs a production
  exception-log check.
- **Are the Area Transfer and Zone Transfer screens (`spec/workflow.md` §5a) known to be broken
  already, or is this pass the first time the missing `@Type` branches in
  `sp_Update_MarketStructure_Transfer` have been identified?** Worth an operational check against
  `tblMarketStructureTranfer` row counts by transfer type before assuming this is news to the team.
- **Which of the two/three parallel approval mechanisms for Tour Plan/Visit Plan/Prescription/
  Attendance (`spec/workflow.md` §2a) is the one users and administrators actually consider
  authoritative**, given both are live and reachable today? This is a product/process question, not
  resolvable from code.
- **Is SQL Server's `Ole Automation Procedures` option actually enabled on the production instance
  the `MakeRESTRequest` procedure runs against?** If not, every SAP stock-transfer-order call has been
  silently failing (no `TRY/CATCH` in the proc, empty `catch{}` in both C# callers) — needs a direct
  check against the production SQL Server configuration, not just the development instance this pass
  had access to.