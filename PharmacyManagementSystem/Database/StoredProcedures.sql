USE PharmacyDB;
GO

-- ============================================================
-- Optional Stored Procedures for advanced queries and reporting
-- ============================================================

-- 1. Get Expiring Medicines (within next 30 days)
IF OBJECT_ID('sp_GetExpiringMedicines', 'P') IS NOT NULL DROP PROC sp_GetExpiringMedicines;
GO
CREATE PROC sp_GetExpiringMedicines
    @DaysThreshold INT = 30
AS
BEGIN
    SELECT 
        m.MedicineName, 
        m.GenericName,
        i.BatchNumber,
        i.QuantityInStock,
        i.ExpiryDate,
        DATEDIFF(day, GETDATE(), i.ExpiryDate) AS DaysUntilExpiry
    FROM Inventory i
    INNER JOIN Medicines m ON i.MedicineID = m.MedicineID
    WHERE i.ExpiryDate BETWEEN GETDATE() AND DATEADD(day, @DaysThreshold, GETDATE())
      AND i.QuantityInStock > 0
    ORDER BY i.ExpiryDate;
END;
GO

-- 2. Get Low Stock Items (below reorder level)
IF OBJECT_ID('sp_GetLowStockMedicines', 'P') IS NOT NULL DROP PROC sp_GetLowStockMedicines;
GO
CREATE PROC sp_GetLowStockMedicines
AS
BEGIN
    SELECT 
        m.MedicineName,
        m.GenericName,
        SUM(i.QuantityInStock) AS TotalStock,
        m.ReorderLevel
    FROM Medicines m
    LEFT JOIN Inventory i ON m.MedicineID = i.MedicineID
    GROUP BY m.MedicineID, m.MedicineName, m.GenericName, m.ReorderLevel
    HAVING SUM(i.QuantityInStock) < m.ReorderLevel
    ORDER BY m.MedicineName;
END;
GO

-- 3. Get Dispensing Summary by Date Range
IF OBJECT_ID('sp_DispensingSummary', 'P') IS NOT NULL DROP PROC sp_DispensingSummary;
GO
CREATE PROC sp_DispensingSummary
    @StartDate DATETIME,
    @EndDate   DATETIME
AS
BEGIN
    SELECT 
        m.MedicineName,
        COUNT(d.TransactionID) AS PrescriptionCount,
        SUM(d.QuantityDispensed) AS TotalQuantityDispensed,
        SUM(d.QuantityDispensed * m.UnitPrice) AS TotalRevenue
    FROM DispenseTransactions d
    INNER JOIN Medicines m ON d.MedicineID = m.MedicineID
    WHERE d.DispenseDate BETWEEN @StartDate AND @EndDate
    GROUP BY m.MedicineName
    ORDER BY TotalRevenue DESC;
END;
GO