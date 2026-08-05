# Security

Findings from static analysis only — nothing here was exploited or verified against a running system, and nothing in the codebase was modified to produce this document.

## 1. Hardcoded, drifted database credentials — Critical

Connection details are duplicated in at least four places, out of sync with each other, and committed to git history:

- `Solution.Web/web.config:38` — `SolutionConnectionStringSSIDB`: `Data Source=NASA-PC\MSSQLSERVER2019;Initial Catalog=SalesDisDB_SMC_NEWDB;Integrated Security=false; User ID=sa; Password=sa1234;`. Lines 33-36 keep three earlier server/password combinations commented out rather than deleted (`95.211.159.93\SQLSERVER2014` / `PULAK**10`; `CSTL-PC-7` / `CSTL**10`; `.` / `sa1234#`).
- `Library.DAL/DataManager/SqlUserAccess.cs:54-56` — a different active `DataSource`/`UserName`/`PassWord` (`192.168.35.174\MSSQLSERVER2019`, `ePharmadb_Webuser`, password `Web_useR!#@**10##`), with roughly ten more prior combinations commented out above it.
- `Library.DAL/MAIN_FUNCTION/DB_Authentication.cs` — yet another hardcoded set (`NASA-PC\MSSQLSERVER2019` / `sa` / `sa1234`).
- Every root `*.ps1` script embeds its own literal connection string.

`docs/CI-CD-README.md`'s own setup checklist item #4 calls for rotating the plaintext `sa` credentials "currently committed in `Solution.Web/Web.config`" into GitHub Secrets — i.e. this is already a known, documented issue, not a new finding.

## 2. Login passwords are stored and compared in plaintext — Critical

No hashing exists anywhere in the login path:

- `Library.DAL/PanalCls/PanalClsDAL.cs:35` — the login query is `where LoginName=@LoginName and Password=@Password and UserStatus='active'`, comparing the submitted password directly against the stored `tblUser.Password` column. `Login.aspx.cs:29-30` passes `passwordTextBox.Text.Trim()` straight in.
- `Library.DAL/UserProfileDAL/ChangePasswordDAL.cs:74,78` — `UpdatePass` writes `Password=@Password` with no hashing applied before storage.
- `Solution.Web/SInventory_UI/AccountSettings.aspx.cs:83` — assigns `Password = passwordTextBox.Text` directly into the save DTO.
- A repo-wide search for `MD5`/`SHA1`/`SHA256`/`Rfc2898`/`PasswordHasher`/`ComputeHash` finds no password-hashing code anywhere in `Library.DAL`/`Library.BLL`/`Solution.Web`. The one `SHA1` usage that does exist (`EncryptDecrypt.cs`, next section) is unrelated to authentication and appears unused.
- This is visible directly in C#, not hidden behind a stored procedure — `PanalClsDAL.cs` builds and runs the comparison SQL itself.

## 3. `EncryptDecrypt.cs` — present, unused, and weak if it were used

`Library.DAL/DataManager/EncryptDecrypt.cs` implements symmetric encrypt/decrypt (not hashing) using `RijndaelManaged` in CBC mode, keyed via `PasswordDeriveBytes` with a **hardcoded pass-phrase** (`"Pas5pr@se"`), **hardcoded salt** (`"s@1tValue"`), **hardcoded IV** (`"@1B2c3D4e5F6g7H8"`), and only 2 derivation iterations of SHA1. A repo-wide search for callers of `EncryptText`/`DecryptText` finds none outside the file itself — it is dead code. If it were wired up later, the hardcoded key material would make it provide no real confidentiality regardless.

## 4. SQL injection surface — string-concatenated SQL beyond the known autocomplete cases

Concatenation of variables (frequently session-derived or user-supplied) directly into SQL text was found in **44 files** under `Library.DAL`. Confirmed concrete instances include:

- `Library.DAL/UserProfileDAL/ChangePasswordDAL.cs:59,103,109,120,152,189` — six separate queries built with `"... WHERE X=" + Id`, including line 109's `"select u.Password from tblUser u ... where u.UserId=" + Id` (concatenates an ID into a query that also returns the plaintext password column).
- `Library.DAL/SInventory_DAL/CustomerMasterInfoDal.cs:183,188` — `"SELECT * FROM dbo.View_CustomerMaster" + cust`.
- `Library.DAL/SubDepot_DAL/SubDepotDAL.cs:32,92` — a `SELECT` and a full multi-field `UPDATE tblSubDepot SET ... WHERE SubDepotId=` built by concatenation.
- `Library.DAL/MasterSetup_DAL/CustomerInvoiceLimitRepository.cs:120,191,331` — even the newer, otherwise Dapper-parameterized repository builds a few `"EXEC sp_... " + id` calls this way; line 191 attempts manual quote-doubling (`keyword.Replace("'", "''")`) instead of parameterizing, which is fragile.
- `Library.DAL/SInventory_DAL/InvoiceDAL.cs:1513,2002` — an `IN (...)` clause and a `SELECT` literal built by concatenation.
- Additional files matching the same pattern, not individually line-audited: `Sub_InvoiceDAL.cs`, `ProuctWiseSalesDAL.cs`, `TargetDAL.cs`, `SubDepotChalanDAL.cs`, `SubDepotChalanReturnDAL.cs`, `SubDepotStockAdjustmentsVoucherDal.cs`, `SubDepoAdjustDAL.cs`, `dadtlsInvoiceDAL.cs`, `dadtlsOrderInfoDAL.cs`, `dadtlsRequisitionDAL.cs`, `dadtlsCustPaymentDAL.cs`, `WhStockMonitoringReportDal.cs`, `WarehouseStockInApprovalDal.cs`, `WhStockConditionFreezeDal.cs`, `WHStockAdjDAL.cs`, `WHStockInReportDal.cs`, `ShortExpProductDAL.cs`, `SalesReturnDAL.cs`, `SalesReturnNewDAL.cs`, `SCtoWHTransferDal.cs`, `ReturnInvoiceDAL.cs`, `ProformaOrInvoiceReturn.cs`, `OrderInfoDAL_daaw.cs`, `OrderInfoDALSalesReturn.cs`, `MultiCustomerEditDAL.cs`, `OrderInfoDAL.cs`, `InvoiceDAL_daaw.cs`, `ExcelUpForOrderListDAL.cs`, `DistrictSalesReportDAL.cs`, `ExcelUpForCustTagChangeDAL.cs`, `ExcelUpForMIGODAL.cs`, `CustPaymentDAL_daaw.cs`, `CentralStoreDAL.cs`, `B2BTransferViewDal.cs`, `BatchWiseCollectionReportDal.cs`, `GroupWisePromoQtyDAL.cs`, `PromoGroupDAL.cs`, `PromoMITagDAL.cs`, and `InternalCls/ClsPrimaryKeyFind.cs` (table/column name concatenation for its `MAX()+1` key-generation query).
- `Solution.Web/App_Code/SInventoryWebService.cs` — `GetSubDepotInvoiceNo`, `GetProformaInvoiceNo`, `GetProformaInvoiceNoNew`, `GetPreBatch`, `GetAllInvoice`, `GetCustomer`, `GetEmpInfo` all concatenate a `Session[...]` value into SQL text (see [`api.md`](api.md)).

## 5. Web.config settings

From `Solution.Web/web.config` (full file read):

- `<compilation debug="true" targetFramework="4.8">` (line 60) — debug compilation left enabled.
- `<customErrors>`: **not present** — no custom error page configured, default ASP.NET error behavior applies (which, combined with `debug="true"`, can surface stack traces).
- `<trust level="...">`: **not present**.
- `<machineKey>`: **not present** — view-state/forms-auth-ticket encryption keys are auto-generated per-server rather than explicitly pinned, which matters if this app ever runs behind a load balancer (not evidenced either way in this repo).
- `<httpCookies>`: **not present** — no `httpOnlyCookies`/`requireSSL` element.
- `<authorization>`: **not present** — no app-level allow/deny rules.
- `<httpRuntime executionTimeout="36000" maxRequestLength="4194303" maxUrlLength="131072" requestPathInvalidCharacters="" requestValidationMode="2.0" />` (line 59) — `requestValidationMode="2.0"` keeps ASP.NET's older, lazy (per-control-access) request validation rather than 4.5's eager validation; `requestPathInvalidCharacters=""` clears the default blocked-character list for the URL path.
- `<authentication mode="Forms" ...>` with `timeout="2880"` (48 hours) — declared but not actually used in code, see [`spec/workflow.md`](../spec/workflow.md) and §6 below.
- `<sessionState mode="InProc" timeout="24000" cookieless="false" />` — no `requireSSL` or `httpOnlyCookies` attribute present (see next section).

## 6. Session/authentication mechanism

Despite `<authentication mode="Forms">` being configured, no code in the repo calls `FormsAuthentication.SetAuthCookie` or reads `User.Identity` — authentication is entirely a hand-rolled `Session[...]`-key scheme (~14 keys set in `Login.aspx.cs` after a successful `PanalBLL.Login()` call). The session cookie itself has no `requireSSL`/`httpOnlyCookies` hardening configured. No HTTPS-enforcement code (`Request.IsSecureConnection`, `RequireHttps`) exists anywhere in the solution. See [`spec/workflow.md`](../spec/workflow.md) for the full login sequence and [`spec/validation-rules.md`](../spec/validation-rules.md) §Authorization for the menu-visibility-vs-page-access gap already identified in the prior architecture review.

## 7. Additional hardcoded credentials — found via full spec/ scan

Two further sets of committed, real-looking credentials, beyond the DB connection strings in §1:

- **SAP REST API** (`Solution.Web/SInventory_UI/BankDepositSAP.aspx.cs:276-277`): a production-shaped
  host (`https://smcsap.smc-bd.org:42223/RESTAdapter/eph_mio`), username `smc_epharma`, and password
  `Eph@rma2023#`. The `HttpClient.PostAsync` call that would use these is commented out (lines
  280-338), so this specific code path is inert — but the credentials are committed regardless and
  should be rotated as a precaution. See [`spec/integrations.md`](../spec/integrations.md) §1a.
- **SMTP email** (multiple `Campaign*.aspx.cs` files under `MasterSetup_UI`, plus
  `OrderRequisitionCreation.aspx.cs`, `TransferUI/CustomerImport.aspx.cs`,
  `TransferUI/DoctorImport.aspx.cs`): three different credential patterns, some **active** (the send
  call is not commented out) — a hardcoded shared Gmail account + app password in the Campaign files,
  a weak hardcoded shared credential (`no-reply@smc-bd.org` / `smc12345`), and a per-user Gmail app
  password pulled from `Session["EmailID"]`/`Session["AppPass"]` in the Order/Transfer files (implying
  individual users' Gmail app passwords are stored/passed through session, not a secrets manager).
  None of this was previously documented — a prior pass of this file incorrectly stated no
  email/SMTP code exists. See [`spec/integrations.md`](../spec/integrations.md) §2 for the full file
  list and credential breakdown.

## 8. Third-party data exposure

`Solution.Web/App_Code/UserSessionTrackingManager.cs` sends every logged-in user's resolved public IP address to the third-party service `https://ipapi.co/{ip}/json/` on every login, to populate country/region/city for an internal audit table (`dbo.tblUserSessionTracking`). This is an undocumented outbound data flow to an external service — worth flagging for any data-privacy/compliance review, independent of whether it's a "vulnerability" per se.

## 9. Not evaluated

Server/network-level configuration (IIS hardening, firewall rules, TLS certificate configuration, SQL Server-side permissions and auditing) is outside what a static code read can determine — **Not Found** in this repo, and out of scope for this analysis.
