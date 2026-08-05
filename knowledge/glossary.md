# Glossary

**None of these acronyms are defined in code comments, documentation, or any other in-repo source.** Expansions below are informed inferences from folder names, field names, and general pharma-distribution/field-force industry convention — marked as inferred, not confirmed. Where no confident inference could be made, the entry says so.

| Term | Likely meaning | Confidence / evidence |
|---|---|---|
| **DA** | Delivery Agent / Distribution Agent (the party who delivers goods and collects payment) — but see note below, the letters are **overloaded** in this codebase | High for the sales-flow usage (`Approval_UI/DAApprovalList`, `DA_SalesConfirmStatus`, `DA_PaymentCollection`, `DA_SalesReturn` columns, `DAInfo` table). Inferred from context; not spelled out anywhere. |
| **DA** (second meaning) | "Daily Allowance," as in "TA/DA" (Travel Allowance / Daily Allowance), a common HR expense-claim term | Seen in `TADAMarketruleConfig.cs` (`TAAmount`, `DAAmount` fields) and the `DAApprovalList` claim workflow, which is about employee TA/DA claims, not delivery. **These are two different meanings of "DA" in the same codebase** — always check context (sales/invoice vs. HR/claim) before assuming which one applies. |
| **TADA** | Travel Allowance / Daily Allowance | Inferred from `TADAMarketruleConfig` field names (`TAAmount`, `DAAmount`) — standard South Asian HR/ERP terminology. |
| **DIC** | Distribution-In-Charge (a supervisory role that re-approves DA sales-confirmation/return actions) | Medium — inferred from `DICApprovalStatus`/`DICApproveDate`/`DICApproveBy` columns and `DICCompanyUnitId` session/role usage in `SAP_Integration` pages. Full expansion not found in code. |
| **DCR** | Daily Call Report (a field rep's record of a doctor visit) | Medium-high — standard pharma field-force term, matches `DoctorVisit_UI`/`Reports_UI/DcrDoctoriseMonthlypt` context and the DCR approval workflow. |
| **DCP** | Doctor Call Programme/Plan (planned doctor visits, as distinct from the DCR record of what happened) | Medium — inferred from `DCPCVPApproval.aspx` and `Reports_UI/DcpDoctoriseMonthlypt`, paired conceptually with DCR. |
| **CVP** / **CVR** | **Not Found** — appears alongside DCP in `DCPCVPApproval.aspx` and as `Reports_UI/CVRDoctoriseMonthlypt`; no confident expansion could be inferred. Possibly "Call/Visit Plan" or "Call/Visit Report" by analogy with DCP/DCR, but this is speculative. |
| **RX** | Prescription (standard medical abbreviation) | High — `Approval_UI/RXApprovalList`, `PrescriptionMaster`/`PrescriptionDetails` DAO classes. |
| **MIO** | Medical Information Officer (a field-rep role, territory-level per `MIOInfo.TerritoryId`) | Medium — standard pharma field-force title; inferred from `MIOInfo` DAO's `TerritoryId`/`AreaId`/`RegionId` hierarchy fields, not spelled out in code. |
| **ASM** | Area Sales Manager | Medium — inferred by position in the sales-hierarchy DAO family (`ASMInfo`, alongside `RSMInfo`/`NSMInfo`), standard industry title. |
| **RSM** | Regional Sales Manager | Medium — same basis as ASM. |
| **NSM** | National Sales Manager | Medium — same basis as ASM. |
| **DZSM** | Zone Sales Manager (District/Divisional Zone Sales Manager?) — referenced in `DZSMTotalSummary.aspx` | Low — the "Z" for Zone is a reasonable guess given `tblZone`/`ZoneInfo` exist elsewhere, but the "D" is unclear. |
| **AM** | Area Manager (appears in role lists alongside ASM/RSM/NSM) | Low-medium — inferred by pattern, not confirmed. |
| **DC** | Distribution Center / Depot | High — `tblDCStore`, `DCPicking`, `DCStockReport`, matches standard usage throughout `SInventory_UI`. |
| **WH** | Warehouse | High — `tblWHStockInDetail`, `WarehouseStockOut.aspx`, consistently used alongside DC as a separate stock-holding tier. |
| **SC** | Sub-Center / Sales Center — appears in `SubdepotInfoEntry.aspx.cs` field prompts ("Sales Center Name") | Medium — inferred from the validation message text itself (`"Please Input Sales Center Name!!"`) rather than a formal definition. |
| **MIA** | **Not Found** — `MIAInfo`/`MIAInformationBLL` exist (a master-data entity with a uniqueness rule, see [`../spec/business-rules.md`](../spec/business-rules.md)) but no expansion is inferable from available context. |
| **TA/DA** | Travel Allowance / Daily Allowance | See TADA above — the combined term appears in expense-claim context throughout `DoctorModule_UI`. |
| **DWSP** | **Not Found** — a distinct module (`Solution.Web/DWSP`, `sp_Process_DWSPReport`) for sales-target setup by zone/area/territory. Possibly "Doctor-Wise Sales Programme" or similar, but no confident expansion found. |
| **SSIDB** | The main application database's connection-string key (`SolutionConnectionStringSSIDB`) | High — directly observable in `web.config`; the "SSIDB" letters themselves are not further expanded anywhere. |
| **Chalan / Challan** | Delivery document/waybill accompanying a shipment (standard South Asian logistics term) | High — `ChalanInfo`, `ChalanDetail`, `ChallanReportViewer`, used consistently for the delivery-document stage of order-to-cash. |
| **Thana** | A sub-district administrative unit in Bangladesh, below District | High — standard Bangladeshi geography term; matches `Thana_UI`'s Division/District/Thana hierarchy. |
| **MIGO** | **Not Found** — `MigoMasterDAO`, `sp_Upsertdate_ProductInfo`-adjacent procs (`MIGODetail`); in SAP terminology "MIGO" is a standard SAP transaction code for goods movement, and this codebase's `SAP_Integration` context makes that a plausible (but unconfirmed) origin. |
| **DAO/DAL/BLL** | Data Access Object / Data Access Layer / Business Logic Layer | High — standard software-architecture terms, used as this codebase's own project/namespace names. |

## Checked and ruled out as a source

`sys.extended_properties` on the live database was checked for `MS_Description`-style column/table
comments that might resolve the remaining "Not Found" entries (DWSP, MIA, CVP/CVR, MIGO) — it
contains only SSMS database-diagram layout metadata (`MS_DiagramPane*`), no descriptive text. The
live `tblMainMenuNew` menu labels (pulled for [`spec/modules.md`](../spec/modules.md)) were also
checked and don't expand any acronym beyond what's already in the table below (e.g. the menu item is
literally labeled "DWSP Information," not spelled out further). These remain genuinely **Not
Found** in this repository — resolving them requires an outside source (a team member, external
documentation), not more code/database archaeology.

## How to extend this glossary responsibly

If you learn a confirmed expansion (e.g. from a team member, a database comment, or documentation outside this repo), update the entry and raise its confidence — but do not silently upgrade a "Not Found"/"Low confidence" entry to "High" without a citable source, per [`.claude/ai-rules.md`](../.claude/ai-rules.md).
