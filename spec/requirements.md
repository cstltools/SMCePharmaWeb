# EXISTING PROJECT — FULL REVERSE ENGINEERING + REQUIREMENT IMPLEMENTATION

You are working on an EXISTING production software project.

Your responsibility is NOT to build a new system from scratch.

You must first understand the complete existing system, reverse-engineer it, understand its architecture, database, business rules, documentation, specifications, existing implementation and dependencies, and only then implement the new requirement.

==================================================
PROJECT RULE
============

DO NOT start coding immediately.

First:

1. Read the complete existing project.
2. Read ALL documentation.
3. Read ALL specification files.
4. Read the complete database structure.
5. Read the existing implementation.
6. Reverse-engineer the current architecture and business flow.
7. Compare the new requirement with the existing system.
8. Identify impacted modules/files/tables/SPs/APIs.
9. Update requirements.md.
10. Prepare implementation plan.
11. Only then start development.

NEVER assume that this is a new project.

==================================================
PHASE 1 — PROJECT DISCOVERY
===========================

Read the complete project directory recursively.

Do NOT limit yourself to recently modified files.

Inspect:

* Source code
* Controllers
* Services
* Repositories
* Models
* DTOs
* ViewModels
* Views
* JavaScript
* CSS
* APIs
* Middleware
* Authentication
* Authorization
* Configuration
* Database scripts
* Stored Procedures
* Functions
* Views
* Triggers
* Tables
* Indexes
* Foreign Keys
* Seed/Data scripts
* Tests
* Documentation
* Configuration files
* Deployment files

Create a complete project inventory.

Record:

Path
File
Purpose
Module
Dependencies
Impact

==================================================
PHASE 2 — READ ALL DOCS
=======================

Find and read ALL documentation directories/files.

Typical locations:

docs/
documentation/
README.md
*.md
*.doc
*.docx
*.pdf

Do not assume only docs/ contains documentation.

Read:

* Architecture documents
* Business flow documents
* API documentation
* Database documentation
* Deployment documents
* Coding standards
* Security documents
* Existing requirements
* Existing specifications
* SRS
* BPML
* UAT documents
* Change requests
* Bug-fix documents
* Integration documents

Create:

docs/PROJECT-DISCOVERY.md

Document what was found.

==================================================
PHASE 3 — READ ALL SPECS
========================

Find every specification file.

Typical locations:

specs/
requirements/
SRS/
business/
functional-spec/
change-request/

Read ALL files.

Do not read only filenames.

Extract:

* Functional requirements
* Business rules
* UI requirements
* Validation rules
* Workflow
* Roles
* Permissions
* Approval rules
* Integration rules
* Database requirements
* Reporting requirements
* Exceptions
* Known limitations

Create a requirement inventory.

==================================================
PHASE 4 — DATABASE REVERSE ENGINEERING
======================================

This is mandatory.

Read the COMPLETE database.

Do not only inspect tables related to the new requirement.

Identify:

### Tables

* Table names
* Columns
* Data types
* Primary keys
* Foreign keys
* Unique constraints
* Default constraints
* Check constraints
* Identity columns

### Stored Procedures

* Parameters
* Result sets
* Tables used
* Business logic
* Validation
* Insert/update/delete behavior
* Dependencies

### Views

Identify:

* Source tables
* Joins
* Filters
* Calculations
* Dependencies

### Functions

### Triggers

### Indexes

### Relationships

Build a database dependency map.

Create/update:

docs/database/

At minimum:

database-overview.md
table-inventory.md
stored-procedure-inventory.md
database-relationships.md
database-business-rules.md

==================================================
PHASE 5 — EXISTING ARCHITECTURE REVERSE ENGINEERING
===================================================

Determine the actual architecture from the source code.

Do NOT assume architecture from README only.

Identify:

* Application architecture
* Layer structure
* Dependency flow
* Request lifecycle
* Authentication flow
* Authorization flow
* Database access pattern
* Transaction handling
* Error handling
* Logging
* Audit logging
* API architecture
* Frontend architecture
* Validation strategy
* Configuration strategy

Document actual architecture in:

docs/architecture/current-architecture.md

==================================================
PHASE 6 — BUSINESS FLOW REVERSE ENGINEERING
===========================================

Trace actual business flows from:

UI
↓
Controller/API
↓
Service
↓
Repository/Data Access
↓
Stored Procedure/SQL
↓
Database

For each important workflow document:

* Entry point
* User action
* Validation
* Business rule
* Database operation
* Result
* Error handling
* Audit logging

Do not document theoretical architecture.

Document what the existing code ACTUALLY does.

==================================================
PHASE 7 — SECURITY REVERSE ENGINEERING
======================================

Inspect the existing implementation for:

* Authentication
* Password handling
* Session management
* JWT/cookies
* Role-based authorization
* Permission checks
* Object-level authorization
* SQL Injection protection
* Parameterized queries
* CSRF protection
* XSS protection
* Input validation
* File upload security
* Secrets/configuration
* Audit logging
* Privilege escalation
* Approval authority
* Separation of Duties

Document:

docs/security/current-security.md

If something is missing, explicitly identify it.

Do not assume it exists.

==================================================
PHASE 8 — NEW REQUIREMENT ANALYSIS
==================================

Now analyze the NEW requirement:

Order Payment Approval System.

Source specification includes:

Invoice Creation
→ Credit Validation
→ Go for Approval
→ AM Approval
→ Payment Schedule
→ DZSM Approval
→ NSM Approval
→ Final Approval
→ Invoice Creation Allowed

Read the complete supplied specification.

Do not lose any requirement.

==================================================
PHASE 9 — IMPACT ANALYSIS
=========================

Compare the new requirement against the existing system.

Identify exactly:

### Existing modules affected

### Existing pages affected

### Existing controllers affected

### Existing services affected

### Existing repositories affected

### Existing APIs affected

### Existing stored procedures affected

### Existing tables affected

### New tables required

### Existing database columns required

### Existing roles affected

### Existing permissions affected

### Existing reports affected

### Existing audit system affected

### Existing integrations affected

Create:

docs/impact-analysis/order-payment-approval-impact.md

==================================================
PHASE 10 — REQUIREMENTS.MD
==========================

Create/update:

requirements.md

IMPORTANT:

requirements.md must represent BOTH:

1. Existing system behavior
2. New requested behavior

Do not create requirements disconnected from the existing system.

Every requirement must have a unique ID.

Use:

FR-001
FR-002
...

BR-001
BR-002
...

VR-001
VR-002
...

SEC-001
SEC-002
...

AUD-001
AUD-002
...

NFR-001
NFR-002
...

Each requirement must contain:

* ID
* Name
* Description
* Source
* Existing behavior
* Required behavior
* Impact
* Acceptance criteria
* Status

==================================================
PHASE 11 — REQUIREMENT TRACEABILITY
===================================

Every new requirement must map to:

Requirement
↓
UI
↓
Controller/API
↓
Service
↓
Repository
↓
Stored Procedure/SQL
↓
Database
↓
Test

Create:

docs/traceability/order-payment-approval-traceability.md

Nothing should remain untraceable.

==================================================
PHASE 12 — DATABASE DESIGN
==========================

Before modifying the database, determine whether the existing database already contains equivalent structures.

DO NOT create duplicate tables unnecessarily.

First search for:

* Existing approval tables
* Existing workflow tables
* Existing approval history
* Existing payment schedule
* Existing audit tables
* Existing employee hierarchy
* Existing role hierarchy
* Existing order tables
* Existing customer credit tables
* Existing invoice validation logic

Reuse existing structures where appropriate.

Only create new structures where required.

For the requested system, evaluate:

tblOrderPaymentApproval

tblOrderPaymentApprovalSchedule

tblOrderPaymentApprovalHistory

But DO NOT blindly create them if equivalent existing tables already exist.

==================================================
PHASE 13 — EXISTING CODE REUSE
==============================

Before creating a new:

* Controller
* Service
* Repository
* API
* Stored Procedure
* Table
* JavaScript module
* Component

search the entire project for existing equivalent functionality.

Prefer:

REUSE
→ EXTEND
→ REFACTOR

Only then:

CREATE NEW

Avoid duplicate logic.

==================================================
PHASE 14 — APPROVAL WORKFLOW
============================

Implement:

Order
↓
Credit Validation
↓
Can Create Invoice?

YES
↓
Invoice Creation

NO
↓
Go for Approval
↓
AM
↓
DZSM
↓
NSM
↓
Final Approval
↓
Invoice Creation Allowed

Statuses:

0 = Pending AM Approval
1 = AM Approved
2 = Pending DZSM Approval
3 = DZSM Approved
4 = Pending NSM Approval
5 = Fully Approved
6 = Rejected
7 = Cancelled

Implement strict state transition validation.

Users must not be able to bypass approval levels.

==================================================
PHASE 15 — PAYMENT SCHEDULE
===========================

Implement:

* Payment No
* Payment Date
* Payment Amount
* Total Due
* Scheduled Amount
* Remaining Amount

Mandatory rules:

1. Payment date >= Today
2. Payment amount > 0
3. SUM(PaymentAmount) = TotalDueAmount
4. Duplicate payment date prohibited
5. Payment dates ascending
6. Final NSM approval locks schedule

All validations must be enforced server-side.

Client-side validation alone is NOT acceptable.

==================================================
PHASE 16 — AUDIT
================

Every approval action must be auditable.

Capture:

* User
* Role
* Action
* Date/time
* From Status
* To Status
* Remarks
* Payment Plan Version
* Old value
* New value where applicable

Audit records must not be silently overwritten.

==================================================
PHASE 17 — AUTHORIZATION
========================

Implement strict role-level authorization.

AM:

* AM approval only

DZSM:

* DZSM approval only

NSM:

* NSM approval only

No role can bypass another approval level.

Do not trust UI visibility as authorization.

Authorization must be enforced server-side.

==================================================
PHASE 18 — UI
=============

Modify the EXISTING Invoice Creation page instead of creating a duplicate page.

Required behavior:

Normal Order:

[Checkbox Enabled]
[Go To Invoice >>]

Credit Blocked:

[Checkbox Disabled]
[Go for Approval]

Approval Pending:

[Pending AM Approval]

AM Approved:

[Pending DZSM Approval]

DZSM Approved:

[Pending NSM Approval]

Final Approved:

[Checkbox Enabled]
[Go To Invoice >>]

Use the existing project's UI conventions, components, CSS framework and JavaScript patterns.

Do NOT introduce a new frontend framework unless the existing project requires it.

==================================================
PHASE 19 — DEVELOPMENT PLAN
===========================

Before coding create:

docs/implementation/order-payment-approval-plan.md

Include:

1. Files to modify
2. Files to create
3. Database changes
4. Stored procedure changes
5. API changes
6. UI changes
7. Security changes
8. Audit changes
9. Test changes
10. Deployment considerations
11. Rollback plan

==================================================
PHASE 20 — IMPLEMENTATION
=========================

ONLY AFTER ALL PREVIOUS PHASES ARE COMPLETE:

Start development.

Development rules:

* Follow existing coding standards.
* Follow existing architecture.
* Reuse existing components.
* Reuse existing database patterns.
* Reuse existing authentication/authorization.
* Reuse existing audit mechanism.
* Do not duplicate functionality.
* Do not break existing behavior.
* Do not change unrelated modules.
* Do not perform destructive database changes without explicit justification.
* Use transactions where multiple related database operations must succeed/fail together.
* Handle concurrency properly.
* Validate all important business rules server-side.
* Preserve backward compatibility where possible.

==================================================
PHASE 21 — TESTING
==================

After implementation, test:

### Functional

* Normal invoice creation
* Credit blocked order
* Approval request
* Duplicate request
* AM approval
* AM rejection
* Payment schedule
* Payment validation
* DZSM approval
* DZSM rejection
* NSM approval
* NSM rejection
* Final approval
* Invoice creation after final approval
* Re-submission

### Security

* Unauthorized AM approval
* Unauthorized DZSM approval
* Unauthorized NSM approval
* Approval level bypass
* Direct API manipulation
* IDOR
* SQL Injection
* XSS
* CSRF where applicable
* Privilege escalation

### Data Integrity

* Concurrent approval
* Duplicate approval
* Payment total mismatch
* Duplicate payment date
* Invalid status transition
* Finalized schedule modification

==================================================
PHASE 22 — REGRESSION TEST
==========================

IMPORTANT:

Existing functionality must continue working.

Run regression checks on every affected module.

Document:

* Existing behavior
* New behavior
* Regression result
* Issues found
* Fix applied

==================================================
PHASE 23 — FINAL REVIEW
=======================

Before declaring completion verify:

[ ] Complete project read
[ ] Complete docs read
[ ] Complete specs read
[ ] Complete database read
[ ] Existing architecture understood
[ ] Existing business flow understood
[ ] Security reviewed
[ ] Existing functionality reused
[ ] Impact analysis completed
[ ] requirements.md updated
[ ] Database impact documented
[ ] Approval workflow implemented
[ ] Payment schedule implemented
[ ] AM implemented
[ ] DZSM implemented
[ ] NSM implemented
[ ] Rejection implemented
[ ] Audit implemented
[ ] Authorization implemented
[ ] UI implemented
[ ] Tests completed
[ ] Regression completed
[ ] No unrelated changes
[ ] No duplicate functionality
[ ] No unsupported assumptions
[ ] All TBD items documented

==================================================
CRITICAL STOP RULE
==================

If you discover ambiguity:

DO NOT silently assume.

Add it to:

docs/OPEN-QUESTIONS.md

Continue with other work only if the ambiguity does not block implementation.

If the ambiguity affects architecture, database design, security, or business-critical workflow, STOP and ask for clarification before making that decision.

==================================================
FINAL OUTPUT
============

After development provide:

1. What you discovered
2. Existing architecture summary
3. Database impact
4. Files changed
5. Files created
6. Stored procedures changed/created
7. Tables changed/created
8. APIs changed/created
9. UI changes
10. Security changes
11. Audit changes
12. Tests executed
13. Regression result
14. Remaining issues
15. Open questions
16. Deployment/rollback instructions

DO NOT claim completion unless the implementation and tests have actually been performed.
