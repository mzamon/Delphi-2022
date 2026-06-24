# Warehouse Management System (WMS) – Delphi Desktop Application

## File Name & Purpose

**README.md** – Project overview, setup instructions, architecture summary, and usage guide for the Warehouse Management System Delphi application.

---

## File Tree (Project Structure)

WarehouseManagementSystem/
│
├── Database/
│ ├── WMS_Database.sql # Creates database, tables, constraints, indexes
│ ├── SeedData.sql # Inserts default roles, admin user, sample data
│ └── StoredProcedures.sql # Optional stored procedures for reporting/performance
│
├── src/
│ ├── Forms/ # VCL presentation layer
│ │ ├── frmLogin.pas / .dfm
│ │ ├── frmMain.pas / .dfm
│ │ ├── frmUsers.pas / .dfm
│ │ ├── frmInventory.pas / .dfm
│ │ ├── frmSuppliers.pas / .dfm
│ │ ├── frmWarehouses.pas / .dfm
│ │ ├── frmPurchaseOrders.pas / .dfm
│ │ ├── frmStockMovement.pas / .dfm
│ │ └── frmReports.pas / .dfm
│ │
│ ├── DataModules/ # FireDAC connection and shared components
│ │ ├── dmDatabase.pas / .dfm
│ │ └── dmQueries.pas / .dfm
│ │
│ ├── Models/ # Entity classes (plain objects)
│ │ ├── User.pas
│ │ ├── Role.pas
│ │ ├── InventoryItem.pas
│ │ ├── Warehouse.pas
│ │ ├── Supplier.pas
│ │ ├── PurchaseOrder.pas
│ │ ├── PurchaseOrderItem.pas
│ │ ├── StockMovement.pas
│ │ └── AuditLog.pas
│ │
│ ├── Repositories/ # Data access layer – parameterized SQL
│ │ ├── RepositoryBase.pas
│ │ ├── UserRepository.pas
│ │ ├── InventoryRepository.pas
│ │ ├── WarehouseRepository.pas
│ │ ├── SupplierRepository.pas
│ │ ├── PurchaseOrderRepository.pas
│ │ ├── StockMovementRepository.pas
│ │ └── AuditRepository.pas
│ │
│ ├── Services/ # Business logic layer
│ │ ├── AuthenticationService.pas
│ │ ├── InventoryService.pas
│ │ ├── WarehouseService.pas
│ │ ├── PurchaseOrderService.pas
│ │ ├── ReportingService.pas
│ │ └── AuditService.pas
│ │
│ ├── Utilities/ # Helpers, hashing, validation, logging
│ │ ├── Hashing.pas
│ │ ├── Validation.pas
│ │ ├── Constants.pas
│ │ ├── Helpers.pas
│ │ └── Logger.pas
│ │
│ ├── Reports/ # Report definitions (QuickReport / FastReport)
│ │ ├── InventoryReport.pas
│ │ ├── UserReport.pas
│ │ ├── SupplierReport.pas
│ │ └── AuditReport.pas
│ │
│ └── WMS.dpr # Main Delphi project file
│
├── Documentation/
│ ├── ERD.png # Entity Relationship Diagram image
│ ├── DatabaseDictionary.md # Table/column descriptions
│ ├── UseCases.md # Functional use cases
│ └── SystemArchitecture.md # Layered architecture explanation
│
└── README.md # This file

---

## Project Overview

**Warehouse Management System (WMS)** is a complete desktop application built with **Delphi VCL** and **FireDAC**, following a clean **layered architecture** (Presentation → Business Logic → Data Access → Database).  
It provides:

- Multi‑user authentication with role‑based access control (Admin, Manager, User).
- Full CRUD for users, inventory items, warehouses, suppliers, purchase orders, and stock movements.
- Purchase order lifecycle: Draft → Submitted → Received → Cancelled.
- Automatic stock quantity updates on movements (IN/OUT/ADJUST) with transaction safety.
- Low‑stock alerts and reporting (inventory valuation, audit logs, user/supplier lists).
- Comprehensive audit logging for all critical operations.
- Password hashing using PBKDF2 (or BCrypt) for security.

---

## Technology Stack

- **Delphi** 10.4+ (Community/Professional) – VCL framework.
- **FireDAC** – database access with connection pooling and transaction support.
- **SQL Database** – Microsoft SQL Server (or SQLite / PostgreSQL with minor syntax adjustments).
- **Layered Architecture** – Models, Repositories, Services, Forms.
- **Reporting** – QuickReport or FastReport (placeholders included, can be replaced with any reporting tool).

---

## Database Setup

1. **Create the database**  
   Run `Database/WMS_Database.sql` in your SQL Server (or adapted for your RDBMS).  
   This script creates the `WMS_DB` database, all tables, primary/foreign keys, constraints, and indexes.

2. **Seed default data**  
   Run `Database/SeedData.sql` to insert:
   - Roles: `Admin`, `Manager`, `User`
   - An admin user: `admin` / `password` (hash is a placeholder – the actual hashing is done in code)
   - Sample warehouses and suppliers.

3. **(Optional) Stored procedures**  
   Run `Database/StoredProcedures.sql` for advanced reporting queries (low‑stock, inventory valuation, etc.).  
   They are not required – the same logic is also implemented in the repository layer.

---

## Configuration

- Open `WMS.dpr` in Delphi.
- Ensure all units are in the project search path.
- In `dmDatabase.pas`, adjust the `FDConnection` parameters to point to your database server:
  ```pascal
  FDConnection.Params.Database := 'WMS_DB';
  FDConnection.Params.Server := 'localhost';
  FDConnection.Params.UserName := 'sa';
  FDConnection.Params.Password := 'your_password';

  For SQLite, change the driver and connection string accordingly.

Build and run.

Default Login Credentials
Username	Password	Role
admin	password	Admin
⚠️ Important: Change the password immediately after first login. The system uses PBKDF2 hashing; the seeded password is for demonstration only.

Architecture in Brief
Presentation Layer (Forms): All UI logic, event handlers, and user interaction. Forms only call services – no SQL or business logic.

Business Logic Layer (Services): Encapsulates business rules, validation, workflow (e.g., PO approval, stock adjustments). Services coordinate multiple repositories and perform audits.

Data Access Layer (Repositories): Each repository handles CRUD for one table using parameterised queries. Transactions are managed via RepositoryBase.

Database Layer: SQL tables with constraints, indexes, and stored procedures (optional).

All SQL is parameterised to prevent SQL injection.
Stock updates are wrapped in database transactions to ensure consistency.

Key Features Walkthrough
Login & Session – AuthenticationService verifies credentials, checks user activity, and retrieves role.

Dashboard – Shows summary cards, low‑stock warnings, and recent activity (customisable).

User Management – Add/edit/delete users, assign roles, enable/disable accounts.

Inventory – Add items to warehouses, track quantities, set reorder levels. Low‑stock alerts highlight items below threshold.

Purchase Orders – Create POs with multiple items; submit for approval; upon receipt, stock quantities are automatically increased and movements logged.

Stock Movements – Manual IN/OUT/ADJUST transactions with audit trail. Quantity updates are atomic.

Reports – Generate inventory lists, user lists, supplier lists, and audit logs (plain text or printable).

Audit – Every create/update/delete and critical action is logged with user, timestamp, and IP address.

Customisation & Extensibility
Add new entities: Create model → repository → service → form.

Change database: FireDAC supports multiple RDBMS – adjust connection parameters and SQL syntax (e.g., identity columns).

Reporting: Replace the placeholder Reports units with your preferred reporting library.

Security: The hashing algorithm can be upgraded by modifying Hashing.pas.

Testing
The project includes placeholders for unit tests, integration tests, and acceptance test cases.
For production, expand the test suite using DUnitX or similar.

License
This software is provided as‑is for educational and demonstration purposes.
No warranty is implied. Use at your own risk.

Contact & Support
For questions or contributions, please refer to the project documentation or contact the development team.

---
