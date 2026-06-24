-- ============================================================
-- Warehouse Management System (WMS) – Database Schema
-- Compatible with: SQL Server, PostgreSQL, SQLite (syntax adjusted)
-- This script uses SQL Server / T‑SQL syntax.
-- ============================================================

-- 1. Create Database (adjust file paths as needed)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'WMS_DB')
BEGIN
    CREATE DATABASE WMS_DB;
END;
GO

USE WMS_DB;
GO

-- 2. Drop tables in reverse dependency order (for clean reruns)
-- ------------------------------------------------------------
IF OBJECT_ID('PurchaseOrderItems', 'U') IS NOT NULL DROP TABLE PurchaseOrderItems;
IF OBJECT_ID('PurchaseOrders', 'U') IS NOT NULL DROP TABLE PurchaseOrders;
IF OBJECT_ID('StockMovements', 'U') IS NOT NULL DROP TABLE StockMovements;
IF OBJECT_ID('Inventory', 'U') IS NOT NULL DROP TABLE Inventory;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
IF OBJECT_ID('Warehouses', 'U') IS NOT NULL DROP TABLE Warehouses;
IF OBJECT_ID('AuditLogs', 'U') IS NOT NULL DROP TABLE AuditLogs;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
GO

-- 3. Create Tables
-- ------------------------------------------------------------

-- Roles (lookup)
CREATE TABLE Roles (
    RoleID       INT IDENTITY(1,1) PRIMARY KEY,
    RoleName     NVARCHAR(50) NOT NULL UNIQUE
);

-- Users
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,   -- PBKDF2/BCrypt hash
    FirstName    NVARCHAR(50) NOT NULL,
    LastName     NVARCHAR(50) NOT NULL,
    Email        NVARCHAR(100) NOT NULL,
    RoleID       INT NOT NULL,
    IsActive     BIT NOT NULL DEFAULT 1,
    CreatedDate  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Warehouses
CREATE TABLE Warehouses (
    WarehouseID  INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    Location     NVARCHAR(200) NOT NULL
);

-- Suppliers
CREATE TABLE Suppliers (
    SupplierID   INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName  NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100) NULL,
    Phone        NVARCHAR(20) NULL,
    Email        NVARCHAR(100) NULL
);

-- Inventory
CREATE TABLE Inventory (
    ItemID       INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID  INT NOT NULL,
    SKU          NVARCHAR(50) NOT NULL,
    ItemName     NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(500) NULL,
    Quantity     DECIMAL(18,2) NOT NULL DEFAULT 0,
    ReorderLevel DECIMAL(18,2) NOT NULL DEFAULT 0,
    UnitPrice    DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT UQ_Inventory_Warehouse_SKU UNIQUE (WarehouseID, SKU),
    CONSTRAINT FK_Inventory_Warehouses FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- PurchaseOrders (header)
CREATE TABLE PurchaseOrders (
    POID         INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID   INT NOT NULL,
    CreatedBy    INT NOT NULL,          -- UserID
    OrderDate    DATETIME NOT NULL DEFAULT GETDATE(),
    Status       NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- Draft, Submitted, Received, Cancelled
    CONSTRAINT FK_PO_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_PO_Users FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- PurchaseOrderItems (detail)
CREATE TABLE PurchaseOrderItems (
    POItemID     INT IDENTITY(1,1) PRIMARY KEY,
    POID         INT NOT NULL,
    ItemID       INT NOT NULL,
    Quantity     DECIMAL(18,2) NOT NULL,
    UnitCost     DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_POItems_PO FOREIGN KEY (POID) REFERENCES PurchaseOrders(POID) ON DELETE CASCADE,
    CONSTRAINT FK_POItems_Inventory FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID)
);

-- StockMovements
CREATE TABLE StockMovements (
    MovementID   INT IDENTITY(1,1) PRIMARY KEY,
    ItemID       INT NOT NULL,
    WarehouseID  INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL,  -- 'IN', 'OUT', 'ADJUST'
    Quantity     DECIMAL(18,2) NOT NULL,
    MovementDate DATETIME NOT NULL DEFAULT GETDATE(),
    UserID       INT NOT NULL,
    Reference    NVARCHAR(50) NULL,      -- optional PO number, adjustment note
    CONSTRAINT FK_SM_Inventory FOREIGN KEY (ItemID) REFERENCES Inventory(ItemID),
    CONSTRAINT FK_SM_Warehouse FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    CONSTRAINT FK_SM_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- AuditLogs
CREATE TABLE AuditLogs (
    AuditID      INT IDENTITY(1,1) PRIMARY KEY,
    UserID       INT NOT NULL,
    Action       NVARCHAR(255) NOT NULL, -- description of action
    ActionDate   DATETIME NOT NULL DEFAULT GETDATE(),
    IPAddress    NVARCHAR(50) NULL,
    CONSTRAINT FK_Audit_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 4. Indexes for performance
-- ------------------------------------------------------------
CREATE INDEX IX_Inventory_WarehouseID ON Inventory(WarehouseID);
CREATE INDEX IX_Inventory_SKU ON Inventory(SKU);
CREATE INDEX IX_StockMovements_ItemID ON StockMovements(ItemID);
CREATE INDEX IX_StockMovements_WarehouseID ON StockMovements(WarehouseID);
CREATE INDEX IX_StockMovements_Date ON StockMovements(MovementDate);
CREATE INDEX IX_PurchaseOrders_SupplierID ON PurchaseOrders(SupplierID);
CREATE INDEX IX_PurchaseOrders_Status ON PurchaseOrders(Status);
CREATE INDEX IX_PurchaseOrderItems_POID ON PurchaseOrderItems(POID);
CREATE INDEX IX_AuditLogs_UserID ON AuditLogs(UserID);
CREATE INDEX IX_AuditLogs_Date ON AuditLogs(ActionDate);
CREATE INDEX IX_Users_RoleID ON Users(RoleID);