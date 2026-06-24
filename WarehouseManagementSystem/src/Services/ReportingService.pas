unit ReportingService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  InventoryItem, User, Supplier, AuditLog,
  InventoryRepository, UserRepository, SupplierRepository, AuditRepository,
  StockMovementRepository;

type
  TReportingService = class
  private
    FInvRepo: TInventoryRepository;
    FUserRepo: TUserRepository;
    FSupplierRepo: TSupplierRepository;
    FAuditRepo: TAuditRepository;
    FSMRepo: TStockMovementRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function GetInventoryReport: TObjectList<TInventoryItem>;
    function GetUserReport: TObjectList<TUser>;
    function GetSupplierReport: TObjectList<TSupplier>;
    function GetAuditReport: TObjectList<TAuditLog>;
    function GetStockMovementSummary(AStartDate, AEndDate: TDateTime): TObjectList<TStockMovement>;
  end;

implementation

{ TReportingService }

constructor TReportingService.Create;
begin
  inherited;
  FInvRepo := TInventoryRepository.Create;
  FUserRepo := TUserRepository.Create;
  FSupplierRepo := TSupplierRepository.Create;
  FAuditRepo := TAuditRepository.Create;
  FSMRepo := TStockMovementRepository.Create;
end;

destructor TReportingService.Destroy;
begin
  FInvRepo.Free;
  FUserRepo.Free;
  FSupplierRepo.Free;
  FAuditRepo.Free;
  FSMRepo.Free;
  inherited;
end;

function TReportingService.GetInventoryReport: TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetAllItems;
end;

function TReportingService.GetUserReport: TObjectList<TUser>;
begin
  Result := FUserRepo.GetAllUsers;
end;

function TReportingService.GetSupplierReport: TObjectList<TSupplier>;
begin
  Result := FSupplierRepo.GetAllSuppliers;
end;

function TReportingService.GetAuditReport: TObjectList<TAuditLog>;
begin
  Result := FAuditRepo.GetAllAudits;
end;

function TReportingService.GetStockMovementSummary(AStartDate, AEndDate: TDateTime): TObjectList<TStockMovement>;
begin
  Result := FSMRepo.GetMovementsByDateRange(AStartDate, AEndDate);
end;

end.