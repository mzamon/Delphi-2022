USE PharmacyDB;
GO

-- 1. Insert default Roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Admin', 'Full system access'),
('Pharmacist', 'Can dispense and manage inventory'),
('Cashier', 'Can dispense and process sales');

-- 2. Insert admin user (password: 'password' – hash must match your Hashing unit)
-- For demo, we use a dummy hash – in production, generate with PBKDF2.
INSERT INTO Users (Username, PasswordHash, FirstName, LastName, Email, RoleID, IsActive)
VALUES ('admin', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', 'Admin', 'User', 'admin@pharmacy.local', 1, 1);

-- 3. Insert Categories
INSERT INTO Categories (CategoryName) VALUES 
('Antibiotics'),
('Analgesics'),
('Antihypertensives'),
('Vitamins'),
('Antidiabetics');

-- 4. Insert Sample Suppliers
INSERT INTO Suppliers (SupplierName, ContactPerson, Phone, Email, Address)
VALUES 
('PharmaCorp Ltd.', 'John Smith', '555-1111', 'john@pharmacorp.com', '123 Main St'),
('MediSource Inc.', 'Alice Johnson', '555-2222', 'alice@medisource.com', '456 Oak Ave');

-- 5. Insert Sample Medicines
INSERT INTO Medicines (CategoryID, MedicineName, GenericName, Manufacturer, Barcode, UnitPrice, ReorderLevel)
VALUES 
(1, 'Amoxicillin 500mg', 'Amoxicillin', 'PharmaCorp', '1234567890', 15.00, 100),
(2, 'Paracetamol 500mg', 'Acetaminophen', 'MediSource', '2345678901', 5.00, 200),
(3, 'Lisinopril 10mg', 'Lisinopril', 'PharmaCorp', '3456789012', 20.00, 50),
(4, 'Vitamin C 1000mg', 'Ascorbic Acid', 'MediSource', '4567890123', 10.00, 150),
(5, 'Metformin 500mg', 'Metformin', 'PharmaCorp', '5678901234', 12.00, 80);

-- 6. Insert Sample Inventory (batches)
-- First get MedicineIDs: assume Amoxicillin=1, Paracetamol=2, etc. (adjust as needed)
-- We'll use explicit IDs after insert – you can query to get actual IDs.
-- For seeding, we assume IDENTITY starts at 1.
INSERT INTO Inventory (MedicineID, SupplierID, BatchNumber, QuantityInStock, ManufacturingDate, ExpiryDate)
VALUES 
(1, 1, 'BATCH001', 500, '2024-01-01', '2025-12-31'),
(2, 2, 'BATCH002', 800, '2024-02-01', '2025-11-30'),
(3, 1, 'BATCH003', 300, '2024-03-01', '2025-10-31'),
(4, 2, 'BATCH004', 600, '2024-04-01', '2025-09-30'),
(5, 1, 'BATCH005', 400, '2024-05-01', '2025-08-31');

-- 7. Insert a sample purchase
INSERT INTO Purchases (SupplierID, PurchaseDate, TotalAmount, CreatedBy)
VALUES (1, GETDATE(), 7500.00, 1); -- admin user

-- Insert purchase items
INSERT INTO PurchaseItems (PurchaseID, MedicineID, Quantity, UnitCost)
VALUES 
(1, 1, 100, 12.00),
(1, 3, 50, 18.00);
GO