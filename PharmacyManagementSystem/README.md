# Pharmacy Inventory & User Management System

## Overview
A complete pharmacy management desktop application built with Delphi VCL and FireDAC, following a clean layered architecture (Presentation → Business Logic → Data Access → Database). Designed for community pharmacies, hospital dispensaries, and medical stores.

## Key Features
- Multi‑user authentication with roles (Admin, Pharmacist, Cashier)
- Medicine catalogue with categories, suppliers, barcodes
- Inventory tracking with batch numbers and expiry dates
- Purchase orders and stock receiving
- Medicine dispensing with automatic stock deduction
- Expiry alerts and low‑stock warnings
- Audit logging for all transactions
- Comprehensive reporting (inventory, dispensing, purchases, user activity)

## Technology Stack
- Delphi 10.4+ (VCL)
- FireDAC
- SQL Server / PostgreSQL / MySQL (adjustable)
- Layered architecture

## Database Setup
1. Run `Database/PharmacyDB.sql` to create database, tables, constraints, indexes.
2. Run `Database/SeedData.sql` to insert default roles, admin user, categories, and sample medicines.

## Default Login
- **Username**: `admin`
- **Password**: `password`  
  (Change immediately after first login.)

## Project Structure
- `Database/` – SQL scripts
- `src/Forms/` – VCL UI
- `src/DataModules/` – FireDAC connection
- `src/Models/` – Entity classes
- `src/Repositories/` – Data access (parameterised SQL)
- `src/Services/` – Business logic
- `src/Utilities/` – Helpers, hashing, validation, logging
- `src/Reports/` – Report definitions
- `Documentation/` – Design and test documents

## File Tree

PharmacyManagementSystem/
│
├── Database/
│   ├── PharmacyDB.sql            # Creates database, tables, constraints, indexes
│   ├── SeedData.sql              # Default roles, admin user, sample categories, medicines, suppliers
│   └── StoredProcedures.sql      # Optional stored procedures for reporting
│
├── src/                          # <-- Main source root
│   ├── Forms/                    # Presentation layer – VCL forms
│   │   ├── frmLogin.pas / .dfm
│   │   ├── frmDashboard.pas / .dfm
│   │   ├── frmUsers.pas / .dfm
│   │   ├── frmMedicines.pas / .dfm
│   │   ├── frmInventory.pas / .dfm
│   │   ├── frmSuppliers.pas / .dfm
│   │   ├── frmPurchases.pas / .dfm
│   │   ├── frmDispensing.pas / .dfm
│   │   ├── frmExpiryTracking.pas / .dfm
│   │   └── frmReports.pas / .dfm
│   │
│   ├── DataModules/              # FireDAC connection & shared components
│   │   ├── dmDatabase.pas / .dfm
│   │   └── dmQueries.pas / .dfm
│   │
│   ├── Models/                   # Entity classes
│   │   ├── User.pas
│   │   ├── Role.pas
│   │   ├── Category.pas
│   │   ├── Medicine.pas
│   │   ├── Supplier.pas
│   │   ├── InventoryItem.pas
│   │   ├── Purchase.pas
│   │   ├── PurchaseItem.pas
│   │   ├── DispenseTransaction.pas
│   │   └── AuditLog.pas
│   │
│   ├── Repositories/             # Data access layer – parameterised SQL
│   │   ├── RepositoryBase.pas
│   │   ├── UserRepository.pas
│   │   ├── MedicineRepository.pas
│   │   ├── InventoryRepository.pas
│   │   ├── SupplierRepository.pas
│   │   ├── PurchaseRepository.pas
│   │   ├── DispenseRepository.pas
│   │   └── AuditRepository.pas
│   │
│   ├── Services/                 # Business logic layer
│   │   ├── AuthenticationService.pas
│   │   ├── UserService.pas
│   │   ├── MedicineService.pas
│   │   ├── InventoryService.pas
│   │   ├── SupplierService.pas
│   │   ├── PurchaseService.pas
│   │   ├── DispenseService.pas
│   │   ├── AlertService.pas      # Expiry & low‑stock alerts
│   │   └── ReportingService.pas
│   │
│   ├── Utilities/                # Helpers, hashing, validation, logging
│   │   ├── Hashing.pas
│   │   ├── Validation.pas
│   │   ├── Constants.pas
│   │   ├── Helpers.pas
│   │   └── Logger.pas
│   │
│   ├── Reports/                  # Report definitions (QuickReport/FastReport)
│   │   ├── InventoryReport.pas
│   │   ├── ExpiryReport.pas
│   │   ├── DispensingReport.pas
│   │   ├── PurchaseReport.pas
│   │   └── UserActivityReport.pas
│   │
│   └── PharmacyManagementSystem.dpr   # Main Delphi project file
│
├── Documentation/                # Project documentation
│   ├── ERD.png
│   ├── DatabaseDictionary.md
│   ├── UseCases.md
│   ├── SystemArchitecture.md
│   └── TestPlan.md
│
└── README.md                     # Project overview & setup

## Compilation
Open `PharmacyManagementSystem.dpr` in Delphi, add all units to the project, and build.

## License
Educational/demonstration purposes only.