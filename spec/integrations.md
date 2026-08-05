# Integrations

Every point where this codebase talks to something outside itself. **This version corrects the
prior one on two points**: it wrongly claimed no email/SMTP code exists (there is, and most of it
is active), and it missed a dead-but-credential-leaking direct SAP REST call. Both are below.

## 1. SAP staging/reconciliation

**Not a live SOAP/REST connection to an SAP server for the bulk of the traffic.** Pattern: a
separate database (`SAP_API_Data`, referenced cross-DB e.g. `SAP_API_Data..tbl_BankDeposit`) is
written to by this app; an external SAP-side process (not in this repo) drains/fills it. 77 stored
procedures carry an `sp_SAP*` prefix (full source in [`spec/database/procs/`](database/procs/)).
Representative ones:

- `sp_SAP_BankDepositSendtoSAP.sql` — flips `IS_SAP_Send`/`SAP_SendDone` flags on deposit rows
  (app → SAP direction).
- `sp_SAP_ChallanSendMaster.sql` / `sp_SAP_B2BChallanMasterInsert.sql` — challan push to the
  staging tables.
- `sp_SAP_API_InsertProduct.sql` — looks like the SAP → app direction (product master sync).

C# entry point: `Library.DAL/SAP_IntegrationDAL/SAP_IntrigationPointDAL.cs`, driven manually via
admin pages `Solution.Web/SAP_Integration/SAP_IntrigationPoint[DIC].aspx`,
`SAP_StockReceive[DIC].aspx`, plus `eProgram_UI/ProviderDropoutRequestList.aspx` (shares the same
DAL class via `GetProviderDropoutIntrigrationListDAL()` — provider-dropout events for a
retail-outlet loyalty scheme flow through the same staging pipeline).

Notable: `SAP_IntrigationPointDAL.MakeRESTRequestWithUpdateChallan()`
(`Library.DAL/SAP_IntegrationDAL/SAP_IntrigationPointDAL.cs:548-577`) is misleadingly named — despite
the name, it only calls a stored procedure literally named `MakeRESTRequest`; there is no actual
outbound HTTP call in this C# method.

### 1a. Direct SAP REST call — dead code, but leaks live-looking credentials

`Solution.Web/SInventory_UI/BankDepositSAP.aspx.cs:276-277`:

```csharp
string apiUrl = "https://smcsap.smc-bd.org:42223/RESTAdapter/eph_mio";
string username = "smc_epharma";
string password = "Eph@rma2023#";
```

The actual `HttpClient.PostAsync` call using these is **commented out** (lines 280-338) — this code
path is inert. The credentials are committed to source control regardless and look production-shaped
(named host, dated password). Treat as a credential-rotation candidate even though the call itself
never fires. See [`docs/security.md`](../docs/security.md) for the broader hardcoded-credential
pattern this fits into.

## 2. SMTP email — real, and mostly active (the prior version of this doc was wrong to say "none found")

All send via `smtp.gmail.com:587` over SSL. **Active** (the actual `.Send()` call is not commented
out):

- `Solution.Web/MasterSetup_UI/CampaignSetupPT.aspx.cs:1672-1681`
- `Solution.Web/MasterSetup_UI/CampaignSetup_final.aspx.cs:1760-1769`
- `Solution.Web/MasterSetup_UI/CampaignSetup_new.aspx.cs:1596-1605`
- `Solution.Web/MasterSetup_UI/OLdCampaignSetup.aspx.cs:1672-1681`
- `Solution.Web/SInventory_UI/OrderRequisitionCreation.aspx.cs:518-549,575-586,601-612`
- `Solution.Web/SInventory_UI/StockTransferOrder.aspx.cs`
- `Solution.Web/SInventory_UI/DeliveryExcelUploadOldData.aspx.cs`
- `Solution.Web/TransferUI/CustomerImport.aspx.cs`, `TransferUI/DoctorImport.aspx.cs` (both ~lines 446-509)

**Inert** (the `.Send()` call is commented out, notification code path never fires):
`CampaignSetup.aspx.cs:1811-1821`, `CampaignSetup_Mult.aspx.cs:1825-1834` — noted in
[`business-rules.md`](business-rules.md) §3 as "email-failure handling commented out"; this is the
matching finding that the *send itself* is also disabled on these two specific files, not just the
failure-message branch.

Credential patterns found across these files (three different approaches, not one consistent
scheme):

1. **Hardcoded** Gmail account + app password directly in the `Campaign*` files.
2. **Per-user** Gmail app password pulled from `Session["EmailID"]`/`Session["AppPass"]` in the
   Order/Transfer files — meaning each user's own Gmail app password is presumably stored somewhere
   upstream (not traced in this pass) and used to send on their behalf.
3. **Hardcoded weak shared credential**: `no-reply@smc-bd.org` / password `smc12345`, sending to
   hardcoded individual mailboxes in some files.

None of these are secrets-manager-backed; all are committed to source in some form.

## 3. `.asmx` SOAP service — internal, not the mobile API

`Solution.Web/{MasterSetup_UI,SInventory_UI,SubDepot_UI}/SInventoryWebService.asmx`, all three
mounted on `Solution.Web/App_Code/SInventoryWebService.cs`. Its `[WebMethod]`s (`GetProductList`,
`GetCustomer`, etc.) back jQuery autocomplete widgets **within this same application** — same
process, not an external integration. Full endpoint catalog in [`api-spec.md`](api-spec.md) §1.

## 4. Flutter mobile app — external, not in this repo

The mobile-facing surface inside this repo is the ~333 `sp_Webapi*` + ~14 `sp_SalesAPI*` stored
procedures (full source in `spec/database/procs/`), called from:

- `Library.DAL/DoctorModule_DAL/{CommonDataLoad,AppPrimaryDAL,TourTypeDal}.cs`
- `Library.DAL/MasterSetup_DAL/{CustomerInfoDAL,DoctorDAL,EmployeeInformationDaL,ExpenseDal,LeaveApplicationDal,OrderTrackingDAL}.cs`
- `Library.DAL/Transfer_DAL/MarketStructureTransferDAL.cs`

**The HTTP layer that exposes these to the mobile app was not located as `.asmx.cs` or otherwise in
this pass** — worth a follow-up grep for `ApiController`/`[Route]` (a prior full-repo sweep in
`api-spec.md` found none, so if this layer exists it may live in a different project or the mobile
app calls the same page-method/`.asmx` surface documented in `api-spec.md` directly). Flag this as
an open question rather than assumed-resolved.

### 4a. `BASE_URL` — declared, dead

`Library.DAL/DataManager/SqlUserAccess.cs:69-70` defines:

```csharp
public static string AppName = "CSTL-Development";
public static string BASE_URL = "http://45.64.134.85:570";
```

A repo-wide grep for `SqlUserAccess.BASE_URL`/`SqlUserAccess.AppName` returns **zero call sites**.
Declared, never used — despite `CLAUDE.md`'s framing of this as an active REST host for older DAL
code, it is currently dead configuration. Don't confuse this with §1a's SAP credentials, which are a
*different* dead-but-real integration point.

## 5. File uploads — local disk only, no cloud storage

- `PictureHandler.ashx` / `SignatureHandler.ashx`: pure session-memory image echo, no disk I/O at
  all (see [`api-spec.md`](api-spec.md) §2).
- `Solution.Web/SInventory_UI/HandlerDocCV.ashx`: real upload handler —
  `postedFile.SaveAs(Server.MapPath("~/UploadFile/") + guidFileName)`, saved under the web root on
  local disk. Same local-disk pattern in `NoticeBoard.aspx.cs`, `ProductEntry.aspx.cs`, and the
  Excel-upload screens cataloged in [`validation-rules.md`](validation-rules.md) §3.
- No cloud storage SDK (S3, Azure Blob, etc.) anywhere in the codebase — confirmed by grep, not
  merely assumed.

## 6. `ipapi.co` — third-party IP geolocation

`Solution.Web/App_Code/UserSessionTrackingManager.cs` calls `https://ipapi.co/{ip}/json/`
synchronously on every successful login (3-second timeout, failures swallowed) to resolve
country/region/city for the session-tracking audit table `dbo.tblUserSessionTracking`. Real-time
dependency on a free/public third-party API with no API key configured — a rate-limiting/
availability risk, and an outbound PII (IP address) flow worth flagging for any data-privacy review.
See [`docs/security.md`](../docs/security.md) §7.

## 7. SQL Server Agent (self-integration)

`Solution.Web/App_Code/ArchiveDbConnectRepository.cs` executes
`EXEC msdb.dbo.sp_start_job @job_name = @JobName` (default job name `"Society_DB_Backup_Job"`,
overridable via `AppSettings["DatabaseBackupJobName"]`) directly from the web application, triggering
a SQL Server Agent job on the database server for backups, via the `SettingPanel_UI` admin screen.
Couples the web app to SQL Server Agent being configured with a job of that name on the connected
instance — outside this repo's control.

## 8. Crystal Reports engine (SAP BusinessObjects / CrystalDecisions runtime)

`CrystalDecisions.CrystalReports.Engine` and `CrystalDecisions.Web` (version 13.0.2000.0) — a
licensed third-party reporting runtime, in-process rather than a network integration, but a
significant runtime dependency for the 94 `SInventory_RPTVIEW` pages. See [`reports.md`](reports.md).

## 9. Excel export libraries (in-process, not a network integration)

ClosedXML 0.95.4, EPPlus 4.1.0, DocumentFormat.OpenXml 2.7.2 — used for the GridView-export report
pages (see [`reports.md`](reports.md)). Purely in-process; no external service.

## 10. Docker / SQL Server container (dev/deploy tooling, not a runtime integration)

`docker-compose.yml`/`.prod.yml` orchestrate a `mssql/server:2019` container alongside the web
container — infrastructure, not an application-level integration. See
[`docs/deployment.md`](../docs/deployment.md). Confirmed no other services are defined.

## What's explicitly not present

No payment gateway, no SMS gateway, no OAuth/SSO provider, no message queue (RabbitMQ/Azure Service
Bus/etc.), no cloud storage SDK — all confirmed absent by grep across the whole repository. (SMTP
email **is** present, correcting the prior version of this document — see §2.)
