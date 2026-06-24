USE WMS_DB;
GO

-- 1. Insert default Roles
-- ------------------------------------------------------------
INSERT INTO Roles (RoleName) VALUES ('Admin');
INSERT INTO Roles (RoleName) VALUES ('Manager');
INSERT INTO Roles (RoleName) VALUES ('User');
GO

-- 2. Insert admin user (password: 'password' hashed with PBKDF2 – placeholder)
--    In a real system, the hash must be generated with a secure algorithm.
--    For demo, we use a known hash (PBKDF2 with SHA-256, salt=1234, iterations=10000).
--    The actual hashing is handled in code; this is just for seeding.
--    Hash for 'password' (adjust to match your Hashing unit).
INSERT INTO Users (Username, PasswordHash, FirstName, LastName, Email, RoleID, IsActive)
VALUES ('admin', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', 'Admin', 'User', 'admin@wms.local', 1, 1);
GO

-- 3. Sample Warehouses
-- ------------------------------------------------------------
INSERT INTO Warehouses (WarehouseName, Location) VALUES ('Main Warehouse', '123 Main St, City A');
INSERT INTO Warehouses (WarehouseName, Location) VALUES ('North Branch', '456 North Ave, City B');
GO

-- 4. Sample Suppliers
-- ------------------------------------------------------------
INSERT INTO Suppliers (CompanyName, ContactPerson, Phone, Email)
VALUES ('Tech Supplies Ltd.', 'John Doe', '555-1234', 'john@techsupplies.com');
INSERT INTO Suppliers (CompanyName, ContactPerson, Phone, Email)
VALUES ('Global Parts Inc.', 'Jane Smith', '555-5678', 'jane@globalparts.com');
GO

-- 5. Sample Inventory (assumes WarehouseID 1 and 2 exist)
-- ------------------------------------------------------------
-- Insert items for Main Warehouse (WarehouseID = 1)
INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, Quantity, ReorderLevel, UnitPrice)
VALUES (1, 'SKU-001', 'Laptop', 'Dell XPS 13', 25, 5, 1200.00);
INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, Quantity, ReorderLevel, UnitPrice)
VALUES (1, 'SKU-002', 'Monitor', '24-inch LED', 40, 10, 250.00);
INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, Quantity, ReorderLevel, UnitPrice)
VALUES (1, 'SKU-003', 'Keyboard', 'Wireless Bluetooth', 60, 15, 45.00);

-- Insert items for North Branch (WarehouseID = 2)
INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, Quantity, ReorderLevel, UnitPrice)
VALUES (2, 'SKU-101', 'Printer', 'LaserJet Pro', 10, 3, 350.00);
INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, Quantity, ReorderLevel, UnitPrice)
VALUES (2, 'SKU-102', 'Mouse', 'Wireless Optical', 100, 20, 15.00);
GO