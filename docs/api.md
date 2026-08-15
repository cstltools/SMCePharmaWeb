# API

This repository has **no REST/Web API framework** — no `ApiController`, no `WebApiConfig.cs`, no routing table for JSON endpoints (confirmed this revision: a repo-wide search for `ApiController`/`WebApiConfig`/`System.Web.Http.Routing` returns zero matches anywhere, including inside the one vendored MVC package present, `packages/Microsoft.AspNet.Mvc.4.0.20710.0` — that package is plain MVC 4, not Web API, and its XML doc comments don't reference these terms either; corrected this revision from a previous claim that matches existed there). The integration surface this repo exposes is two older ASP.NET mechanisms.

## 1. `SInventoryWebService.asmx` — SOAP/ScriptService

Defined once in `Solution.Web/App_Code/SInventoryWebService.cs`, mounted at **three separate URLs** (all serving the same class):

- `Solution.Web/MasterSetup_UI/SInventoryWebService.asmx`
- `Solution.Web/SInventory_UI/SInventoryWebService.asmx`
- `Solution.Web/SubDepot_UI/SInventoryWebService.asmx`

Decorated `[WebService(Namespace = "http://tempuri.org/")]`, `[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]`, `[System.Web.Script.Services.ScriptService]` — callable both as classic SOAP and via ASP.NET AJAX's client-side `ScriptService` proxy (the latter is how it's actually used: jQuery/AjaxControlToolkit autocomplete widgets on `.aspx` pages call these methods client-side). Data access is Dapper against `ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"]`.

### Methods

All are typeahead/autocomplete lookups returning `string[]` (each element pre-formatted as `"Code : Name"` or similar for direct display), except `HelloWorld`. None require authentication beyond an active ASP.NET session (several read `Session[...]` directly — see below).

| Method | Session dependency | Purpose |
|---|---|---|
| `HelloWorld()` | none | Health-check stub |
| `GetProductList(prefixText)` | none | Product autocomplete (Group 1, active only) |
| `GetSubDepotInvoiceNo(prefixText)` | `Session["ComUnitId"]` | Sub-depot invoice number autocomplete — **builds SQL by string concatenation of `ComUnitId`**, see [`docs/security.md`](security.md) |
| `GetProformaInvoiceNo(prefixText)` | `Session["ComUnitId"]` | Proforma invoice autocomplete — same concatenation pattern |
| `GetProformaInvoiceNoNew(prefixText)` | `Session["ComUnitId"]` | Variant of the above, includes a "N/A" placeholder row |
| `GetPreBatch(prefixText)` | `Session["ProductId"]` (consumed/nulled on read) | Batch-number autocomplete for a product set earlier in session |
| `GetAllInvoice(prefixText)` | `Session["CompIDD"]` | Invoice number autocomplete scoped to a company unit |
| `GetProductWithCode(prefixText)` | none | Product autocomplete by code+name |
| `GetCustomer(prefixText)` | `Session["UserType"]`, `Session["ComUnitId"]` | Customer autocomplete, admin sees all, others scoped to their unit |
| `GetCustomer_New` / `GetCustomer_ALL` / `GetCustomer_ALL_Active` / `GetCustomer_ALL_new` / `GetCustomer_WithoutGeneral` / `GetCustomer_ALL_ForDIC` | varies (some none, some `Session["UserType"]`) | Six near-duplicate customer-autocomplete variants with slightly different filters/joins (active-only, DIC market-hierarchy join, program-type exclusion) — no single canonical version |
| `GetDoctor_ALL(prefixText)` | none | Doctor autocomplete |
| `GetProduct2` / `GetProduct3` / `GetProduct` | none | Further product-autocomplete variants (different display formats) |
| `GetProductByMenufracturer(prefixText, contextKey)` | none | Product autocomplete filtered by manufacturer ID passed via AjaxControlToolkit's `contextKey` |
| `GetEmpInfo(prefixText)` | `Session["UserType"]` | Employee autocomplete, admin vs. unit-scoped |

The six near-duplicate `GetCustomer*` methods and three `GetProduct*` methods are not a documented API surface with versioning — they accumulated as one-off variants for different pages. When adding a caller, check whether an existing variant already fits before adding a seventh.

## 2. `.ashx` generic HTTP handlers

Single-file handlers (`<%@ WebHandler %>`, no separate code-behind):

| Handler | Path | Behavior |
|---|---|---|
| `PictureHandler.ashx` | `Solution.Web/PictureHandler.ashx` | Streams `Session["ImageBytes"]` back as `image/JPEG`. Requires `IRequiresSessionState`. |
| `SignatureHandler.ashx` | `Solution.Web/SignatureHandler.ashx` | Streams a signature image. **Note**: its guard checks `Session["ImageBytes"] != null` but then reads and returns `Session["SigImageBytes"]` — an existing inconsistency in the checked-in code, not something introduced by this documentation pass. |
| `HandlerDocCV.ashx` | `Solution.Web/SInventory_UI/HandlerDocCV.ashx` | Generic file-upload endpoint: accepts a posted file, saves it under `~/UploadFile/` with a GUID-prefixed name, returns `{name, dbfilename}` as JSON. No file-type/size validation visible in the handler itself. |

## 3. External REST endpoint (not in this repo)

`Library.DAL/DataManager/SqlUserAccess.cs` defines `BASE_URL = "http://45.64.134.85:570"` under a `"Rest API calling"` comment, and an `AppName = "CSTL-Development"` constant. This points at a separate backend application — presumably what the Flutter mobile app talks to — that is **not part of this repository**. Its endpoint list, auth scheme, and implementation are **Not Found** here.

## 4. Outbound calls this codebase makes

- `Solution.Web/App_Code/UserSessionTrackingManager.cs` calls `https://ipapi.co/{ip}/json/` on every successful login to resolve the user's approximate location for session-tracking/audit purposes (`dbo.tblUserSessionTracking`). This is a real-time outbound dependency on a third-party service — a failure or block of that endpoint is swallowed (`catch { }`) and does not affect login, but location data will silently be empty.
- `Solution.Web/App_Code/ArchiveDbConnectRepository.cs` triggers a SQL Server Agent job (`EXEC msdb.dbo.sp_start_job`) from the web application to run a database backup — an operational/infra action exposed through application code rather than a scheduled job.

## 5. The bigger picture — inline `[WebMethod]` page methods

The `.asmx`/`.ashx` surface above is only part of the story. A full repo-wide scan found **459
`[WebMethod]`-tagged static methods across 116 `.aspx.cs` files**, scattered through every `*_UI`
folder — dashboard chart data, master-data CRUD, dropdown lookups, approval bulk-actions, and more.
None of this was previously cataloged. See [`spec/api-spec.md`](../spec/api-spec.md) §3 for the
complete method-by-method inventory (grouped by module), and
[`spec/integrations.md`](../spec/integrations.md) for the full external-integrations catalog
(including a corrected finding: active SMTP-sending code exists, contradicting an earlier version
of that document).
