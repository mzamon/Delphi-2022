# Database Dictionary

## Tables

### Users
- UserID (PK, int)
- Username (nvarchar(50), unique)
- PasswordHash (nvarchar(255))
- FirstName (nvarchar(50))
- LastName (nvarchar(50))
- Email (nvarchar(100))
- RoleID (FK to Roles)
- IsActive (bit)
- CreatedDate (datetime)

### Roles
- RoleID (PK, int)
- RoleName (nvarchar(50), unique)

### Warehouses
- WarehouseID (PK, int)
- WarehouseName (nvarchar(100))
- Location (nvarchar(200))

### Inventory
- ItemID (PK, int)
- WarehouseID (FK to Warehouses)
- SKU (nvarchar(50))
- ItemName (nvarchar(100))
- Description (nvarchar(500))
- Quantity (decimal(18,2))
- ReorderLevel (decimal(18,2))
- UnitPrice (decimal(18,2))
- Unique (WarehouseID, SKU)

### Suppliers
- SupplierID (PK, int)
- CompanyName (nvarchar(100))
- ContactPerson (nvarchar(100))
- Phone (nvarchar(20))
- Email (nvarchar(100))

### PurchaseOrders
- POID (PK, int)
- SupplierID (FK to Suppliers)
- CreatedBy (FK to Users)
- OrderDate (datetime)
- Status (nvarchar(20))

### PurchaseOrderItems
- POItemID (PK, int)
- POID (FK to PurchaseOrders)
- ItemID (FK to Inventory)
- Quantity (decimal(18,2))
- UnitCost (decimal(18,2))

### StockMovements
- MovementID (PK, int)
- ItemID (FK to Inventory)
- WarehouseID (FK to Warehouses)
- MovementType (nvarchar(20))
- Quantity (decimal(18,2))
- MovementDate (datetime)
- UserID (FK to Users)
- Reference (nvarchar(50))

### AuditLogs
- AuditID (PK, int)
- UserID (FK to Users)
- Action (nvarchar(255))
- ActionDate (datetime)
- IPAddress (nvarchar(50))