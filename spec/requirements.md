# Customer Entry – Doctor Tagging Requirement

## 1. Requirement Overview

**Page:**

```text
MasterSetup_UI/CustomerEntry.aspx
```

Customer Entry page-এ `tblDoctorMaster` থেকে approved এবং active doctors load করে একটি **multi-select Doctor dropdown** যোগ করতে হবে।

একজন Customer-এর সাথে একাধিক Doctor tag করা যাবে।

Doctor tagging information একটি নতুন mapping table-এ সংরক্ষণ করতে হবে:

```text
tblCustTaggDoc
```

---

# 2. Doctor List

Doctor dropdown-এর data source হবে:

```sql
SELECT *
FROM tblDoctorMaster
WHERE IsActive = 1
  AND DoctorCode IS NOT NULL
  AND ApprovalStatus = 2
```

শুধুমাত্র এই condition পূরণ করা doctors dropdown-এ দেখাবে।

### Display Format

Dropdown-এ Doctor দেখাতে হবে:

```text
DoctorCode : DoctorName
```

Example:

```text
D001 : Dr. Rahman
D002 : Dr. Karim
D003 : Dr. Hasan
```

### Dropdown Value

Dropdown-এর selected value হিসেবে `tblDoctorMaster`-এর **actual primary key / Doctor ID** ব্যবহার করতে হবে।

`DoctorCode` কে database relationship key হিসেবে ব্যবহার করা যাবে না।

Implementation-এর আগে existing `tblDoctorMaster` schema inspect করে actual primary key column identify করতে হবে।

---

# 3. Multi-Select Doctor Dropdown

`CustomerEntry.aspx` page-এ একটি Doctor multi-select dropdown যোগ করতে হবে।

Requirements:

* Multiple doctors select করা যাবে।
* একজন customer-এর সাথে 1 বা একাধিক doctor tag করা যাবে।
* কোনো doctor select না করেও customer save করা যাবে।
* Existing project-এ যদি কোনো multi-select dropdown library/component already থাকে, সেটিই ব্যবহার করতে হবে।
* নতুন unnecessary JavaScript/plugin/library add করা যাবে না।

Example:

```text
Doctor
--------------------------------
☑ D001 : Dr. Rahman
☑ D002 : Dr. Karim
☐ D003 : Dr. Hasan
☑ D004 : Dr. Ahmed
--------------------------------
```

---

# 4. Database Mapping Table

নতুন table:

```text
tblCustTaggDoc
```

Table-এর মূল উদ্দেশ্য হলো:

```text
Customer ↔ Multiple Doctors
```

প্রস্তাবিত structure:

```text
tblCustTaggDoc
---------------------------
CustomerMasterId
DoctorId
```

### Relationship

```text
tblCustMaster
      |
      | CustomerMasterId
      |
      v
tblCustTaggDoc
      |
      | DoctorId
      |
      v
tblDoctorMaster
```

`DoctorId` অবশ্যই `tblDoctorMaster`-এর actual primary key/ID reference করবে।

`CustomerMasterId` অবশ্যই existing `tblCustMaster` customer ID reference করবে।

Implementation-এর আগে existing database schema এবং naming/datatype/constraint convention inspect করতে হবে।

---

# 5. Multiple Doctor Relationship

একজন customer-এর সাথে multiple doctors থাকতে পারবে।

Example:

```text
CustomerMasterId = 1001
```

এর জন্য:

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
1001             | 31
1001             | 45
```

অর্থাৎ:

```text
Customer 1001
    ├── Doctor 25
    ├── Doctor 31
    └── Doctor 45
```

---

# 6. Customer Save Logic

Customer নতুনভাবে save করার সময়:

### Step 1

Existing customer save logic অনুযায়ী `tblCustMaster`-এ customer save করতে হবে।

### Step 2

Customer-এর `CustomerMasterId` পাওয়া যাবে।

### Step 3

Selected doctors থেকে প্রতিটি Doctor ID নিয়ে `tblCustTaggDoc`-এ mapping insert করতে হবে।

Example:

```text
CustomerMasterId = 1001

Selected Doctor IDs:
25
31
45
```

Save হবে:

```text
1001 | 25
1001 | 31
1001 | 45
```

### Step 4

Customer এবং Doctor mapping save সম্ভব হলে একই database transaction-এর মধ্যে করতে হবে।

Customer save সফল হলেও Doctor mapping save ব্যর্থ হলে transaction rollback করতে হবে, যদি existing architecture transaction support করে।

---

# 7. Customer Edit Logic

Existing customer edit করার সময়:

1. Customer information load হবে।
2. `tblCustTaggDoc` থেকে ওই customer-এর tagged doctors load করতে হবে।
3. Multi-select dropdown-এ existing doctors automatically selected থাকবে।

Example:

```text
CustomerMasterId = 1001

Existing mappings:
25
31
45
```

Dropdown:

```text
☑ D001 : Dr. Rahman
☑ D002 : Dr. Karim
☑ D003 : Dr. Hasan
```

User চাইলে:

* নতুন doctor add করতে পারবে।
* Existing doctor remove করতে পারবে।
* সব doctor remove করতে পারবে।

---

# 8. Doctor Mapping Update Logic

Customer edit করে save করার সময় mapping synchronize করতে হবে।

Recommended approach:

```text
1. Save/Update Customer
2. Delete existing tblCustTaggDoc records for CustomerMasterId
3. Insert currently selected Doctor IDs
4. Commit transaction
```

Example:

### Before

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
1001             | 31
1001             | 45
```

User যদি শুধু Doctor `25` এবং `45` রাখে:

### After

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
1001             | 45
```

Doctor `31` automatically removed হবে।

---

# 9. No Doctor Selected

Customer-এর জন্য কোনো Doctor selected না থাকলেও customer save করতে হবে।

Example:

```text
CustomerMasterId = 1002
```

No selected doctor:

```text
tblCustTaggDoc
---------------------------
No record
```

এটি valid scenario।

---

# 10. Duplicate Prevention

একই customer-এর সাথে একই doctor একাধিকবার mapping করা যাবে না।

Invalid:

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
1001             | 25
```

Valid:

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
1001             | 31
1001             | 45
```

Database level-এ সম্ভব হলে:

```text
UNIQUE(CustomerMasterId, DoctorId)
```

unique constraint/index ব্যবহার করতে হবে, যদি existing project/database convention-এর সাথে compatible হয়।

---

# 11. Doctor Filtering

Doctor dropdown অবশ্যই নিচের condition অনুযায়ী load হবে:

```sql
SELECT *
FROM tblDoctorMaster
WHERE IsActive = 1
  AND DoctorCode IS NOT NULL
  AND ApprovalStatus = 2
```

Therefore:

| Condition             | Result      |
| --------------------- | ----------- |
| `IsActive = 1`        | Show        |
| `IsActive = 0`        | Do not show |
| `DoctorCode IS NULL`  | Do not show |
| `ApprovalStatus = 2`  | Show        |
| `ApprovalStatus != 2` | Do not show |

---

# 12. Existing Code Inspection

Implementation শুরু করার আগে Claude Code অবশ্যই নিচের বিষয়গুলো inspect করবে:

### Page

```text
MasterSetup_UI/CustomerEntry.aspx
```

### Code Behind

```text
MasterSetup_UI/CustomerEntry.aspx.cs
```

### Database

Inspect:

```text
tblCustMaster
tblDoctorMaster
```

### Existing Stored Procedures

Customer Entry-এর existing:

```text
Insert
Update
Get
Edit
Save
```

stored procedures identify করতে হবে।

### Existing UI Pattern

Project-এ অন্য কোনো page-এ:

```text
Multi Select
MultiSelect Dropdown
Select2
Bootstrap Multiselect
Checkbox Dropdown
```

ব্যবহার করা হয়ে থাকলে একই pattern follow করতে হবে।

---

# 13. Stored Procedure Convention

Project যদি stored procedure-based architecture ব্যবহার করে, তাহলে existing architecture follow করতে হবে।

Unnecessary direct SQL code-behind-এ add করা যাবে না।

যদি নতুন stored procedure প্রয়োজন হয়, existing naming convention follow করতে হবে।

Possible operations:

```text
Get Customer Tagged Doctors
Save Customer Tagged Doctors
```

তবে existing architecture inspect না করে নতুন procedure name assume করা যাবে না।

---

# 14. UI Requirements

Doctor field customer entry form-এর existing UI design-এর সাথে consistent হতে হবে।

Field label:

```text
Doctor
```

or existing project naming convention অনুযায়ী appropriate label ব্যবহার করতে হবে।

Multi-select dropdown:

* Search করা গেলে ভালো।
* Multiple selection clearly visible হতে হবে।
* Existing selected doctors edit mode-এ দেখাতে হবে।
* Dropdown responsive হতে হবে।
* Existing page layout break করা যাবে না।

---

# 15. Validation

Implementation শেষে নিচের test cases অবশ্যই verify করতে হবে।

### Test Case 1 – No Doctor

```text
Create Customer
Doctor = None
Save
```

Expected:

```text
Customer saved successfully.
No tblCustTaggDoc record.
```

### Test Case 2 – One Doctor

```text
Select Doctor 25
Save
```

Expected:

```text
CustomerMasterId | DoctorId
-----------------|---------
1001             | 25
```

### Test Case 3 – Multiple Doctors

```text
Select:
25
31
45
```

Expected:

```text
1001 | 25
1001 | 31
1001 | 45
```

### Test Case 4 – Edit Customer

Existing:

```text
1001 | 25
1001 | 31
```

Open edit page.

Expected:

```text
Doctor 25 = Selected
Doctor 31 = Selected
```

### Test Case 5 – Add Doctor

Existing:

```text
25
31
```

Add:

```text
45
```

Expected:

```text
25
31
45
```

### Test Case 6 – Remove Doctor

Existing:

```text
25
31
45
```

Remove:

```text
31
```

Expected:

```text
25
45
```

### Test Case 7 – Remove All

Remove all selected doctors.

Expected:

```text
tblCustTaggDoc
```

এর ওই customer-এর জন্য কোনো record থাকবে না।

### Test Case 8 – Duplicate Prevention

Save একই customer একাধিকবার।

Expected:

```text
No duplicate CustomerMasterId + DoctorId
```

### Test Case 9 – Inactive Doctor

```text
IsActive = 0
```

Expected:

```text
Doctor not visible in dropdown.
```

### Test Case 10 – Unapproved Doctor

```text
ApprovalStatus != 2
```

Expected:

```text
Doctor not visible.
```

### Test Case 11 – NULL DoctorCode

```text
DoctorCode IS NULL
```

Expected:

```text
Doctor not visible.
```

---

# 16. Important Implementation Rules

Claude Code must follow these rules:

1. Do not rewrite unrelated Customer Entry functionality.
2. Do not change existing customer business logic unnecessarily.
3. Do not assume primary key column names.
4. Inspect database schema before creating relationships.
5. Use the existing project coding pattern.
6. Use existing dropdown/multi-select component if available.
7. Do not add unnecessary packages.
8. Do not store DoctorCode as `DoctorId`.
9. Store the actual `tblDoctorMaster` primary key in `tblCustTaggDoc.DoctorId`.
10. Customer can have zero, one, or multiple doctors.
11. Existing customer edit must load previously tagged doctors.
12. Updating customer doctor tags must remove obsolete mappings.
13. Prevent duplicate customer-doctor mappings.
14. Do not modify unrelated modules/pages.

---

# 17. Expected Final Result

After implementation:

```text
Customer Entry
------------------------------------------------

Customer Name: [________________________]

Customer Code: [________________________]

Doctor:
┌──────────────────────────────────────────┐
│ ☑ D001 : Dr. Rahman                    │
│ ☑ D002 : Dr. Karim                     │
│ ☐ D003 : Dr. Hasan                     │
│ ☑ D004 : Dr. Ahmed                     │
└──────────────────────────────────────────┘

                    [ Save ]
```

Database:

```text
tblCustMaster
      |
      | CustomerMasterId
      |
      v
tblCustTaggDoc
      |
      | DoctorId
      |
      v
tblDoctorMaster
```

Final relationship:

```text
One Customer
     |
     +---- Doctor 1
     |
     +---- Doctor 2
     |
     +---- Doctor 3
     |
     +---- Doctor N
```

This is a **many-to-many style mapping structure**, where one customer can be associated with multiple doctors and the same doctor can potentially be associated with multiple customers.
