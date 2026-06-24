program WMS;

uses
  Vcl.Forms,
  frmMain in 'Forms\frmMain.pas',
  frmLogin in 'Forms\frmLogin.pas',
  frmUsers in 'Forms\frmUsers.pas',
  frmInventory in 'Forms\frmInventory.pas',
  frmSuppliers in 'Forms\frmSuppliers.pas',
  frmWarehouses in 'Forms\frmWarehouses.pas',
  frmPurchaseOrders in 'Forms\frmPurchaseOrders.pas',
  frmStockMovement in 'Forms\frmStockMovement.pas',
  frmReports in 'Forms\frmReports.pas',
  dmDatabase in 'DataModules\dmDatabase.pas',
  dmQueries in 'DataModules\dmQueries.pas',
  User in 'Models\User.pas',
  Role in 'Models\Role.pas',
  InventoryItem in 'Models\InventoryItem.pas',
  Warehouse in 'Models\Warehouse.pas',
  Supplier in 'Models\Supplier.pas',
  PurchaseOrder in 'Models\PurchaseOrder.pas',
  PurchaseOrderItem in 'Models\PurchaseOrderItem.pas',
  StockMovement in 'Models\StockMovement.pas',
  AuditLog in 'Models\AuditLog.pas',
  RepositoryBase in 'Repositories\RepositoryBase.pas',
  UserRepository in 'Repositories\UserRepository.pas',
  InventoryRepository in 'Repositories\InventoryRepository.pas',
  WarehouseRepository in 'Repositories\WarehouseRepository.pas',
  SupplierRepository in 'Repositories\SupplierRepository.pas',
  PurchaseOrderRepository in 'Repositories\PurchaseOrderRepository.pas',
  StockMovementRepository in 'Repositories\StockMovementRepository.pas',
  AuditRepository in 'Repositories\AuditRepository.pas',
  AuthenticationService in 'Services\AuthenticationService.pas',
  InventoryService in 'Services\InventoryService.pas',
  WarehouseService in 'Services\WarehouseService.pas',
  PurchaseOrderService in 'Services\PurchaseOrderService.pas',
  ReportingService in 'Services\ReportingService.pas',
  AuditService in 'Services\AuditService.pas',
  Hashing in 'Utilities\Hashing.pas',
  Validation in 'Utilities\Validation.pas',
  Constants in 'Utilities\Constants.pas',
  Helpers in 'Utilities\Helpers.pas',
  Logger in 'Utilities\Logger.pas',
  InventoryReport in 'Reports\InventoryReport.pas',
  UserReport in 'Reports\UserReport.pas',
  SupplierReport in 'Reports\SupplierReport.pas',
  AuditReport in 'Reports\AuditReport.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.