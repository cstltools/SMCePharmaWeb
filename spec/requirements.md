# Monthly Inventory Report – Batch Wise

## 1. Requirement Overview

Create a **new report page** for the Monthly Inventory Report (Batch Wise).

### Existing Stored Procedure

The report data must be generated using:

```text
sp_Get_MonthlyInventoryReportBatchWise
```

### New Page

Create a new ASP.NET Web Forms page under:

```text
SInventory_UI/
```

Suggested page name:

```text
MonthlyInventoryReportBatchWise.aspx
```

Before creating the page, inspect the existing `SInventory_UI` folder and follow the project's existing report page naming convention.

---

# 2. UI / Design

The new report page must follow the existing design, layout, controls, styling, and report interaction pattern of:

```text
SInventory_UI/DepositSlipReport.aspx
```

IMPORTANT:

* First inspect `DepositSlipReport.aspx`.
* Inspect its `.aspx.cs` code-behind.
* Inspect the related JavaScript/CSS.
* Follow the same page structure.
* Reuse existing common controls/components where possible.
* Do not redesign the report UI from scratch.
* Do not introduce a new UI framework.

---

# 3. Report Filters

The report page must contain the following filters:

```text
Sales Center: *
From Date:   *
To Date:     *
```

Expected layout:

```text
Sales Center: [________________________] *

From Date:    [31-Jul-2026_____________] *

To Date:      [________________________] *
```

The exact visual layout should follow:

```text
SInventory_UI/DepositSlipReport.aspx
```

---

# 4. Sales Center

Sales Center is a mandatory filter.

Requirements:

* Load Sales Center using the existing project/master-data mechanism.
* Inspect `DepositSlipReport.aspx` and other inventory report pages to determine how Sales Center is currently loaded.
* Reuse the existing Sales Center dropdown/data-loading pattern.
* Do not hard-code Sales Center values.

Validation:

```text
Sales Center is required.
```

If the user tries to generate the report without selecting a Sales Center, show the project's standard validation message.

---

# 5. From Date

The **From Date must be fixed to 31-July-2026**.

Initial/default value:

```text
31-Jul-2026
```

The user must not be allowed to select a date earlier than:

```text
31-Jul-2026
```

Prefer setting the date control's minimum date to:

```text
31-Jul-2026
```

and defaulting the From Date to:

```text
31-Jul-2026
```

### Important

Do not assume whether the date should be editable after 31-Jul-2026.

Inspect existing report/date-filter patterns in the project.

Minimum business rule:

```text
From Date >= 31-Jul-2026
```

If the user enters/selects a date before 31-Jul-2026, prevent report generation and show an appropriate validation message.

---

# 6. To Date

To Date is mandatory.

Validation:

```text
To Date >= From Date
```

Invalid example:

```text
From Date = 31-Jul-2026
To Date   = 30-Jul-2026
```

Expected:

```text
Invalid date range.
To Date cannot be earlier than From Date.
```

To Date should normally default according to the existing report page convention.

Do not invent a different default date without checking the existing reporting pages.

---

# 7. Stored Procedure

The report must use:

```text
sp_Get_MonthlyInventoryReportBatchWise
```

Before implementing the report, inspect the stored procedure definition and determine:

* Required parameters
* Parameter names
* Parameter datatypes
* Sales Center parameter
* From Date parameter
* To Date parameter
* Result columns
* Sorting/order
* Any additional required parameters

Do not guess the stored procedure parameters.

---

# 8. Stored Procedure Parameter Mapping

Expected logical mapping:

```text
Sales Center → Sales Center parameter
From Date    → From Date parameter
To Date      → To Date parameter
```

The actual parameter names must be taken directly from:

```text
sp_Get_MonthlyInventoryReportBatchWise
```

Example only:

```text
@SalesCenterId
@FromDate
@ToDate
```

Do NOT assume these exact names until the stored procedure is inspected.

---

# 9. Report Result

The report should display all columns returned by:

```text
sp_Get_MonthlyInventoryReportBatchWise
```

Do not manually omit important result columns without a business requirement.

Inspect the existing report implementation pattern and determine whether the project uses:

* GridView
* Repeater
* DataTable
* ReportViewer
* HTML table
* Excel export
* Print view

Use the same mechanism already used by:

```text
SInventory_UI/DepositSlipReport.aspx
```

or the closest existing inventory report.

---

# 10. Report Generation Flow

Expected flow:

```text
User opens report
        ↓
Sales Center loaded
        ↓
From Date = 31-Jul-2026
        ↓
User selects Sales Center
        ↓
User selects To Date
        ↓
User clicks Search/Generate
        ↓
Validate filters
        ↓
Execute sp_Get_MonthlyInventoryReportBatchWise
        ↓
Display report
```

---

# 11. Validation Rules

Before executing the stored procedure:

### Sales Center

```text
Required
```

### From Date

```text
Required
Minimum = 31-Jul-2026
```

### To Date

```text
Required
To Date >= From Date
```

Validation should follow the existing validation/message style of the project.

---

# 12. Page Naming

Create a new page.

Preferred:

```text
SInventory_UI/MonthlyInventoryReportBatchWise.aspx
```

with:

```text
SInventory_UI/MonthlyInventoryReportBatchWise.aspx.cs
```

However, first inspect existing page naming conventions and use the closest consistent naming pattern if one exists.

---

# 13. Existing Page Inspection

Before implementation Claude Code must inspect:

```text
SInventory_UI/DepositSlipReport.aspx
SInventory_UI/DepositSlipReport.aspx.cs
```

Also inspect:

```text
sp_Get_MonthlyInventoryReportBatchWise
```

and relevant existing inventory reports.

Identify:

* Page layout
* Master page
* CSS
* JavaScript
* Date picker
* Sales Center dropdown
* Search button
* Report/grid component
* Export functionality
* Print functionality
* Data access pattern
* Stored procedure execution pattern
* Error handling
* Validation pattern

Then implement the new page using the same architecture.

---

# 14. Important Implementation Rules

1. This is a **NEW report page**.
2. Do not modify `DepositSlipReport.aspx` unless absolutely required.
3. `DepositSlipReport.aspx` is the design/reference page only.
4. Use `sp_Get_MonthlyInventoryReportBatchWise` as the report data source.
5. Do not duplicate existing business logic unnecessarily.
6. Reuse existing controls and utilities wherever possible.
7. Do not introduce unnecessary packages/libraries.
8. Do not guess stored procedure parameters.
9. Inspect the stored procedure first.
10. From Date minimum must be **31-Jul-2026**.
11. From Date must default to **31-Jul-2026**.
12. To Date cannot be earlier than From Date.
13. Sales Center is mandatory.
14. Follow existing project coding conventions.

---

# 15. Test Cases

### TC-01: Page Load

Expected:

```text
Sales Center: Loaded
From Date: 31-Jul-2026
To Date: Existing project default behavior
```

---

### TC-02: No Sales Center

Leave Sales Center empty and generate report.

Expected:

```text
Validation message.
Report should not execute.
```

---

### TC-03: From Date Before Minimum

Try:

```text
From Date = 30-Jul-2026
```

Expected:

```text
Validation error.
From Date cannot be earlier than 31-Jul-2026.
```

---

### TC-04: Valid Date Range

```text
From Date = 31-Jul-2026
To Date   = 09-Aug-2026
```

Expected:

```text
sp_Get_MonthlyInventoryReportBatchWise executes successfully.
Report data displayed.
```

---

### TC-05: Invalid Date Range

```text
From Date = 05-Aug-2026
To Date   = 04-Aug-2026
```

Expected:

```text
Validation error.
Report should not execute.
```

---

### TC-06: Multiple Sales Centers

Select a valid Sales Center and generate report.

Expected:

```text
Report contains data for the selected Sales Center
according to the stored procedure result.
```

---

### TC-07: No Data

Select valid filters where no records exist.

Expected:

```text
No data found.
```

Use the existing project's standard no-data behavior.

---

# 16. Final Deliverables

After implementation, provide:

1. New page name.
2. Files created/modified.
3. Stored procedure used.
4. Parameter mapping.
5. UI/filter details.
6. Validation implemented.
7. Test cases executed.
8. Test results.
9. Any assumptions made.

---

# 17. Implementation Instruction

**First inspect, then implement.**

Do not immediately start coding.

The required sequence is:

```text
1. Inspect DepositSlipReport.aspx
2. Inspect DepositSlipReport.aspx.cs
3. Inspect existing inventory report pages
4. Inspect sp_Get_MonthlyInventoryReportBatchWise
5. Identify SP parameters/result columns
6. Identify existing Sales Center loading pattern
7. Identify existing date-picker/validation pattern
8. Create new report page
9. Implement filters
10. Implement SP execution
11. Implement report display
12. Build/compile
13. Test the report
14. Report changed files and test results
```

The final implementation should be the **smallest clean change** that fits the existing application architecture.
