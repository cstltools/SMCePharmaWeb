# Workspace Project Context & Rules (AI Memory)

## Project Overview
- **Project Name:** Live_ePhrama_web (ePharma Management System)
- **Technology Stack:** 
  - ASP.NET WebForms (C#)
  - Data Access Layer (DAL) & Business Logic Layer (BLL) architecture
  - MS SQL Server (Stored Procedures & Direct Query Execution)
  - Flutter Mobile Application (`Apps/clickpharma_flutter`)
  - IIS / Docker Containerization

## Code Architecture & Conventions
1. **Data Access Layer (DAL):** Located in `Library.DAL/`. Uses `DB_Authentication` / `SqlUserAccess` for database operations.
2. **Business Logic Layer (BLL):** Located in `Library.BLL/`.
3. **User Interface (UI):** Located in `Solution.Web/` containing `.aspx` WebForms pages and `.ashx` handlers.
4. **Database Stored Procedures:** SQL scripts located at project root and applied to MS SQL Server. Backup script available at `backup_db.ps1`.
5. **Mobile Application (Flutter):** Located at `d:\CSTL_Projects\SMC\ePharma\Apps\clickpharma_flutter`. Manages mobile UI, local storage (sqflite), REST API connection, and push notifications.

## Development & AI Workflow Rules
- Always preserve existing function signatures and UI element IDs.
- For SQL operations, prefer Stored Procedures over inline SQL queries where applicable.
- All configuration keys should be read from `Web.config` or environment variables (`.env`).
- Maintain synchronicity between backend REST APIs and Flutter API client models (`dio`).

