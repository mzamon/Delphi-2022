program PharmacyManagementSystem;

uses
  Vcl.Forms,
  dmDatabase in 'DataModules\dmDatabase.pas' {dmDatabase},
  dmQueries in 'DataModules\dmQueries.pas' {dmQueries},
  frmLogin in 'Forms\frmLogin.pas' {frmLogin},
  frmMain in 'Forms\frmMain.pas' {frmMain},
  frmUsers in 'Forms\frmUsers.pas' {frmUsers},
  frmMedicines in 'Forms\frmMedicines.pas' {frmMedicines},
  frmInventory in 'Forms\frmInventory.pas' {frmInventory},
  frmSuppliers in 'Forms\frmSuppliers.pas' {frmSuppliers},
  frmPurchases in 'Forms\frmPurchases.pas' {frmPurchases},
  frmDispensing in 'Forms\frmDispensing.pas' {frmDispensing},
  frmExpiryTracking in 'Forms\frmExpiryTracking.pas' {frmExpiryTracking},
  frmReports in 'Forms\frmReports.pas' {frmReports},
  User in 'Models\User.pas',
  Role in 'Models\Role.pas',
  Category in 'Models\Category.pas',
  Medicine in 'Models\Medicine.pas',
  Supplier in 'Models\Supplier.pas',
  InventoryItem in 'Models\InventoryItem.pas',
  Purchase in 'Models\Purchase.pas',
  PurchaseItem in 'Models\PurchaseItem.pas',
  DispenseTransaction in 'Models\DispenseTransaction.pas',
  AuditLog in 'Models\AuditLog.pas',
  RepositoryBase in 'Repositories\RepositoryBase.pas',
  UserRepository in 'Repositories\UserRepository.pas',
  MedicineRepository in 'Repositories\MedicineRepository.pas',
  InventoryRepository in 'Repositories\InventoryRepository.pas',
  SupplierRepository in 'Repositories\SupplierRepository.pas',
  PurchaseRepository in 'Repositories\PurchaseRepository.pas',
  DispenseRepository in 'Repositories\DispenseRepository.pas',
  AuditRepository in 'Repositories\AuditRepository.pas',
  AuthenticationService in 'Services\AuthenticationService.pas',
  UserService in 'Services\UserService.pas',
  MedicineService in 'Services\MedicineService.pas',
  InventoryService in 'Services\InventoryService.pas',
  SupplierService in 'Services\SupplierService.pas',
  PurchaseService in 'Services\PurchaseService.pas',
  DispenseService in 'Services\DispenseService.pas',
  AlertService in 'Services\AlertService.pas',
  ReportingService in 'Services\ReportingService.pas',
  AuditService in 'Services\AuditService.pas',
  Hashing in 'Utilities\Hashing.pas',
  Validation in 'Utilities\Validation.pas',
  Constants in 'Utilities\Constants.pas',
  Helpers in 'Utilities\Helpers.pas',
  Logger in 'Utilities\Logger.pas',
  InventoryReport in 'Reports\InventoryReport.pas',
  ExpiryReport in 'Reports\ExpiryReport.pas',
  DispensingReport in 'Reports\DispensingReport.pas',
  PurchaseReport in 'Reports\PurchaseReport.pas',
  UserActivityReport in 'Reports\UserActivityReport.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TfrmLogin, frmLogin);
  if frmLogin.ShowModal = mrOk then
  begin
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;
end.