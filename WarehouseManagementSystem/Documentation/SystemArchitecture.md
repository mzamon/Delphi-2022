# System Architecture

## Layers
1. **Presentation Layer** – VCL Forms (frm*.pas)
2. **Business Logic Layer** – Services (Authentication, Inventory, etc.)
3. **Data Access Layer** – Repositories (CRUD, parameterized SQL)
4. **Database Layer** – SQL Server (or SQLite) with tables, constraints, indexes

## Components
- **FireDAC** – Database access with connection pooling and transactions.
- **Services** – Encapsulate business rules (e.g., stock validation, PO processing).
- **Repositories** – All SQL is parameterized; no SQL in forms.
- **Audit** – Every critical action is logged.

## Security
- Password hashing (PBKDF2/SHA-256) in `Hashing.pas`.
- Role‑based UI visibility.
- Transactions for stock updates to ensure consistency.

## Flow
1. User logs in via `frmLogin` → `AuthenticationService`.
2. Main form shows menu based on role.
3. Each form uses a corresponding service to perform operations.
4. Services call repositories which execute SQL.
5. Auditing is performed via `AuditService`.