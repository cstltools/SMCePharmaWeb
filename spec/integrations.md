# Integrations

Every point where this codebase talks to something outside itself. **This version corrects the
prior one on three points**: it wrongly claimed no email/SMTP code exists (there is, and most of it
is active); it missed a dead-but-credential-leaking direct SAP REST call; and — the most significant
correction, found only by reading the stored-procedure source directly rather than the C# call site
alone — **the `MakeRESTRequest` stored procedure that §1 below previously described as "no actual
outbound HTTP call" genuinely does make a live outbound HTTPS call**, from inside SQL Server, with
hardcoded plaintext credentials. See the rewritten §1 below; this was verified by reading
`spec/database/procs/MakeRESTRequest.sql` directly, not inferred.

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

### 1b. Known risk (investigated, not fixed): duplicate-shipment re-sync has no detection, and `sp_SAP_StockInTransfer`'s duplicate guard is unsafe

A full end-to-end trace of the `SAP_StockReceive` → `ReceiveProductByChalanByDC.aspx` flow (triggered
by a real reported discrepancy on Chalan `4500008881`) found that this pipeline has **no reliable way
to detect when the same SAP shipment is re-synced into `SAP_API_Data.tblSAP_StockMovementMaster`
under a different `challan_code` string** — matching throughout the chain (`sp_SAP_WhStockInMaster`'s
"already processed" guard included) is plain string equality on `challan_code`, and neither
`tblSAP_StockMovementMaster` nor `tblSAP_StockMovementDetail` carries any SAP document number, line
number, or other stable natural key. A shipment synced twice under two different Chalan-code strings
sails through as two independent, fully-processed Requisitions — the second receive silently
double-counts stock already received, with nothing on the receiving screen to hint at it.

Separately, `sp_SAP_StockInTransfer`'s "already inserted?" duplicate-row guard is a plain
`WHERE ReqChildId NOT IN (SELECT DISTINCT ReqChildId FROM tblStockInTransfar ...)` check with no
lock, no transaction scope, and no uniqueness constraint on `tblStockInTransfar(ReqChildId)` backing
it up — unsafe if the procedure is ever invoked twice for the same input in overlapping/repeated
executions, and a live duplicate matching this exact failure shape was found in the dev database
during the investigation.

**This was investigated and root-caused in this session, not fixed** — no code, stored procedure, or
schema change was made. Full trace (data flow, live-database evidence, ranked root causes, and a
proposed-but-unimplemented fix plan) is in
[`docs/ReceiveQty_RootCause_Analysis.md`](../docs/ReceiveQty_RootCause_Analysis.md).

### 1a-revised. `MakeRESTRequest` — CORRECTED: this is a real, live outbound HTTPS call, made from inside SQL Server

**This section was wrong in the prior version of this document and is corrected here after reading
the stored procedure's source directly.** `SAP_IntrigationPointDAL.MakeRESTRequestWithUpdateChallan()`
(`Library.DAL/SAP_IntegrationDAL/SAP_IntrigationPointDAL.cs:548-577`) does indeed only call a stored
procedure named `MakeRESTRequest`, with no `HttpClient`/`WebRequest` anywhere in that C# method —
that much was correct. But **the stored procedure itself is not a passive database operation**;
`spec/database/procs/MakeRESTRequest.sql` uses SQL Server's OLE Automation extended procedures
(`sp_OACreate`, `sp_OAMethod`) to genuinely issue an outbound HTTPS POST:

```sql
EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
DECLARE @url varchar(200) = 'https://smcsap.smc-bd.org:42223/RESTAdapter/eph_sto';
EXEC sp_OAMethod @Object, 'open', NULL, 'POST', @url, false, 'smc_epharma', 'Eph@rma2023#';
EXEC sp_OAMethod @Object, 'setRequestHeader', NULL, 'Content-Type', 'application/json';
DECLARE @jsonRequest varchar(MAX) = '{"StoNo":"' + @StoNo + '", ...}';
EXEC sp_OAMethod @Object, 'send', NULL, @jsonRequest;
```

This is a real, working call to a SAP Stock Transfer Order REST endpoint (`eph_sto`), issued from the
**database tier**, not the application tier — an unusual but functioning architecture. It requires
SQL Server's `Ole Automation Procedures` configuration option to be enabled on the instance; if that
option is off, the call fails completely silently (the proc has **no `TRY/CATCH`**), and the caller's
own empty `catch {}` block (see call sites below) means neither layer would ever surface the failure.

**The credentials are the same pair already flagged in §1a below as "dead code, but leaks
live-looking credentials"** — `smc_epharma` / `Eph@rma2023#`, same host `smcsap.smc-bd.org:42223` —
except that C# instance (`BankDepositSAP.aspx.cs`, endpoint `eph_mio`) is genuinely dead (its HTTP
call is commented out), while **this stored-procedure instance is live and actively called**:
- `Solution.Web/SInventory_UI/ReceiveProductByChalanByDC.aspx.cs:148`
- `Solution.Web/SInventory_UI/TransferReceiveProductByChalanByDC.aspx.cs:118`

Both call sites wrap the invocation in an empty `catch { }` block, so any failure — network, auth,
OLE Automation disabled, malformed JSON — is silently swallowed with no logging and no user-facing
error. **Treat this credential pair as live and in active use, not merely "committed but inert"** —
correcting the framing of §1a below, which still accurately describes the separate, genuinely-dead
`BankDepositSAP.aspx.cs` C# path.

### 1a. Direct SAP REST call from C# (`BankDepositSAP.aspx.cs`) — this specific C# path is dead code, but leaks the same live credentials used by §1a-revised above

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

The mobile-facing surface inside this repo is the 341 `sp_Webapi*` (corrected this revision from a
previous estimate of ~333) + 14 `sp_SalesAPI*` stored
procedures (full source in `spec/database/procs/`), called from:

- `Library.DAL/DoctorModule_DAL/{CommonDataLoad,AppPrimaryDAL,TourTypeDal}.cs`
- `Library.DAL/MasterSetup_DAL/{CustomerInfoDAL,DoctorDAL,EmployeeInformationDaL,ExpenseDal,LeaveApplicationDal,OrderTrackingDAL}.cs`
- `Library.DAL/Transfer_DAL/MarketStructureTransferDAL.cs`

**The HTTP layer that exposes these to the mobile app was not located as `.asmx.cs` or otherwise in
this pass** — worth a follow-up grep for `ApiController`/`[Route]` (a prior full-repo sweep in
`api-spec.md` found none, so if this layer exists it may live in a different project or the mobile
app calls the same page-method/`.asmx` surface documented in `api-spec.md` directly). Flag this as
an open question rather than assumed-resolved.

**Independent corroboration (this revision):** a full read of all 58 database views found a dedicated
`View_FieldForce{Group,Region,Area,Territory,SubTerritory,Nsm,Rsm,Asm,Mio,Market}` family plus
`View_webapi_FieldForce`/`View_Webapi_EmployeeFieldForceInfo`, and confirmed by direct grep that
these views are consumed specifically by the `sp_SalesAPI_FieldForce*` procedure family — reinforcing
that the `sp_Webapi_*`/`sp_SalesAPI_*` layer, not `SInventoryWebService.cs`, is the far more probable
mobile-app data surface. This strengthens rather than resolves the open question above: the *data
layer* the mobile app most likely reads is now better characterized, but the *HTTP entry point* that
exposes it remains genuinely unlocated in this repository.

### 4a. `BASE_URL` — declared, dead

`Library.DAL/DataManager/SqlUserAccess.cs:75-76` defines:

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

## 10. Docker (dev/deploy tooling, not a runtime integration) — corrected this revision, docker-compose no longer exists

**This section was stale.** `docker-compose.yml`/`docker-compose.prod.yml` — which used to orchestrate
a `mssql/server:2019` container alongside the web container — were deleted in commit `ddd28c0`
("Point CustPayment flow and DB config at local dev DB; clean up scratch scripts") and do not exist in
the working tree; confirmed by `find`/`git log --diff-filter=D`, not merely assumed. Only the root
`Dockerfile` remains (`mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019`,
copies `Solution.Web` into `/inetpub/wwwroot`, `EXPOSE 80`) — it can still build a standalone web
container, but there is no longer a checked-in compose file to run it alongside a SQL Server
container. See [`docs/deployment.md`](../docs/deployment.md), which may itself need the same
correction if it still describes the deleted compose files.

## What's explicitly not present

No payment gateway, no SMS gateway, no OAuth/SSO provider, no message queue (RabbitMQ/Azure Service
Bus/etc.), no cloud storage SDK — all confirmed absent by grep across the whole repository. (SMTP
email **is** present, correcting the prior version of this document — see §2.)
