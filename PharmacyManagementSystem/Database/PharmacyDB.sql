-- ============================================================
-- Pharmacy Management System – Database Schema
-- SQL Server / T‑SQL syntax – adjust for other RDBMS
-- ============================================================

-- 1. Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'PharmacyDB')
BEGIN
    CREATE DATABASE PharmacyDB;
END;
GO

USE PharmacyDB;
GO

-- 2. Drop tables in reverse dependency order
IF OBJECT_ID('DispenseTransactions', 'U') IS NOT NULL DROP TABLE DispenseTransactions;
IF OBJECT_ID('PurchaseItems', 'U') IS NOT NULL DROP TABLE PurchaseItems;
IF OBJECT_ID('Purchases', 'U') IS NOT NULL DROP TABLE Purchases;
IF OBJECT_ID('Inventory', 'U') IS NOT NULL DROP TABLE Inventory;
IF OBJECT_ID('Medicines', 'U') IS NOT NULL DROP TABLE Medicines;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('AuditLogs', 'U') IS NOT NULL DROP TABLE AuditLogs;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
GO

-- 3. Create Tables

-- Roles
CREATE TABLE Roles (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200) NULL
);

-- Users
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName    NVARCHAR(50) NOT NULL,
    LastName     NVARCHAR(50) NOT NULL,
    Email        NVARCHAR(100) NOT NULL,
    RoleID       INT NOT NULL,
    IsActive     BIT NOT NULL DEFAULT 1,
    CreatedDate  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Categories
CREATE TABLE Categories (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

-- Medicines
CREATE TABLE Medicines (
    MedicineID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID   INT NOT NULL,
    MedicineName NVARCHAR(200) NOT NULL,
    GenericName  NVARCHAR(200) NULL,
    Manufacturer NVARCHAR(200) NULL,
    Barcode      NVARCHAR(50) NULL,
    UnitPrice    DECIMAL(18,2) NOT NULL DEFAULT 0,
    ReorderLevel DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Medicines_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Suppliers
CREATE TABLE Suppliers (
    SupplierID    INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName  NVARCHAR(200) NOT NULL,
    ContactPerson NVARCHAR(100) NULL,
    Phone         NVARCHAR(20) NULL,
    Email         NVARCHAR(100) NULL,
    Address       NVARCHAR(500) NULL
);

-- Inventory (batch‑level stock)
CREATE TABLE Inventory (
    InventoryID       INT IDENTITY(1,1) PRIMARY KEY,
    MedicineID        INT NOT NULL,
    SupplierID        INT NOT NULL,
    BatchNumber       NVARCHAR(50) NOT NULL,
    QuantityInStock   DECIMAL(18,2) NOT NULL DEFAULT 0,
    ManufacturingDate DATETIME NULL,
    ExpiryDate        DATETIME NOT NULL,
    CONSTRAINT FK_Inventory_Medicines FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    CONSTRAINT FK_Inventory_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Purchases (header)
CREATE TABLE Purchases (
    PurchaseID   INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID   INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    CreatedBy    INT NOT NULL,
    CONSTRAINT FK_Purchases_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_Purchases_Users FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Purchase Items (detail)
CREATE TABLE PurchaseItems (
    PurchaseItemID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseID     INT NOT NULL,
    MedicineID     INT NOT NULL,
    Quantity       DECIMAL(18,2) NOT NULL,
    UnitCost       DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_PurchaseItems_Purchases FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID) ON DELETE CASCADE,
    CONSTRAINT FK_PurchaseItems_Medicines FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);

-- Dispense Transactions
CREATE TABLE DispenseTransactions (
    TransactionID   INT IDENTITY(1,1) PRIMARY KEY,
    MedicineID      INT NOT NULL,
    InventoryID     INT NOT NULL,        -- specific batch
    QuantityDispensed DECIMAL(18,2) NOT NULL,
    DispenseDate    DATETIME NOT NULL DEFAULT GETDATE(),
    ProcessedBy     INT NOT NULL,        -- UserID
    CONSTRAINT FK_Dispense_Medicines FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    CONSTRAINT FK_Dispense_Inventory FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID),
    CONSTRAINT FK_Dispense_Users FOREIGN KEY (ProcessedBy) REFERENCES Users(UserID)
);

-- Audit Logs
CREATE TABLE AuditLogs (
    AuditID     INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT NOT NULL,
    Action      NVARCHAR(255) NOT NULL,
    ActionDate  DATETIME NOT NULL DEFAULT GETDATE(),
    Details     NVARCHAR(MAX) NULL,
    IPAddress   NVARCHAR(50) NULL,
    CONSTRAINT FK_Audit_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 4. Indexes for Performance
CREATE INDEX IX_Inventory_MedicineID ON Inventory(MedicineID);
CREATE INDEX IX_Inventory_ExpiryDate ON Inventory(ExpiryDate);
CREATE INDEX IX_Purchases_SupplierID ON Purchases(SupplierID);
CREATE INDEX IX_PurchaseItems_PurchaseID ON PurchaseItems(PurchaseID);
CREATE INDEX IX_DispenseTransactions_MedicineID ON DispenseTransactions(MedicineID);
CREATE INDEX IX_DispenseTransactions_Date ON DispenseTransactions(DispenseDate);
CREATE INDEX IX_Users_RoleID ON Users(RoleID);
CREATE INDEX IX_AuditLogs_UserID ON AuditLogs(UserID);
CREATE INDEX IX_AuditLogs_Date ON AuditLogs(ActionDate);