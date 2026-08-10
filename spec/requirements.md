# Requirement: Conditional Doctor Dropdown by Customer Type

## Objective

Update the Customer Entry page:

`MasterSetup_UI/CustomerEntry.aspx`

The **Doctor** dropdown/list should be loaded and displayed/enabled **only when Customer Type is "MDC"**.

Currently, the Customer Type dropdown contains values such as:

- MDC (FY 26-27)
- Other customer types

The Doctor field should depend on the selected Customer Type.

---

## Functional Requirement

### 1. Customer Type = MDC

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

### 2. Customer Type is NOT MDC

When the selected Customer Type does NOT match **MDC**:

- Doctor dropdown should NOT be loaded.
- Doctor field should be disabled or hidden according to the existing UI pattern.
- Any previously selected Doctor value should be cleared.
- No Doctor-related API/database call should be triggered unnecessarily.

Example:

`Customer Type: XYZ`

→ Doctor dropdown should not be available.

---

## Matching Rule

The Customer Type value should be checked based on the **MDC identifier**, not by hardcoding the complete display text.

For example:

`MDC (FY 26-27)`

should be considered an MDC customer type.

If the database value/ID represents MDC, use that value/ID for the condition whenever possible.

Do NOT make the logic dependent only on:

```javascript
if (customerType == "MDC (FY 26-27)")