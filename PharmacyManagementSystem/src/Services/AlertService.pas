unit AlertService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  InventoryItem, InventoryRepository, MedicineRepository,
  AuditService, Constants;

type
  TAlertService = class
  private
    FInvRepo: TInventoryRepository;
    FMedRepo: TMedicineRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function CheckExpiryAlerts(ADaysThreshold: Integer = 30): TObjectList<TInventoryItem>;
    function CheckLowStockAlerts: TObjectList<TInventoryItem>;
    procedure LogAlerts;
  end;

implementation

{ TAlertService }

constructor TAlertService.Create;
begin
  FInvRepo := TInventoryRepository.Create;
  FMedRepo := TMedicineRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TAlertService.Destroy;
begin
  FInvRepo.Free;
  FMedRepo.Free;
  FAudit.Free;
  inherited;
end;

function TAlertService.CheckExpiryAlerts(ADaysThreshold: Integer): TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetExpiringItems(ADaysThreshold);
end;

function TAlertService.CheckLowStockAlerts: TObjectList<TInventoryItem>;
var
  Meds: TObjectList<TMedicine>;
  I: Integer;
begin
  Result := TObjectList<TInventoryItem>.Create(False);
  Meds := FMedRepo.GetAllMedicines;
  try
    for I := 0 to Meds.Count - 1 do
    begin
      var Total := FInvRepo.GetTotalStockForMedicine(Meds[I].MedicineID);
      if Total < Meds[I].ReorderLevel then
      begin
        var Item := TInventoryItem.Create;
        Item.MedicineID := Meds[I].MedicineID;
        Item.QuantityInStock := Total;
        Result.Add(Item);
      end;
    end;
  finally
    Meds.Free;
  end;
end;

procedure TAlertService.LogAlerts;
var
  Expiring: TObjectList<TInventoryItem>;
  LowStock: TObjectList<TInventoryItem>;
  I: Integer;
begin
  Expiring := CheckExpiryAlerts(30);
  try
    for I := 0 to Expiring.Count - 1 do
      FAudit.LogAction(1, AUDIT_EXPIRY_ALERT,
        Format('Medicine %d will expire soon (batch %s)', [Expiring[I].MedicineID, Expiring[I].BatchNumber]), '');
  finally
    Expiring.Free;
  end;

  LowStock := CheckLowStockAlerts;
  try
    for I := 0 to LowStock.Count - 1 do
      FAudit.LogAction(1, AUDIT_LOW_STOCK_ALERT,
        Format('Medicine %d is below reorder level. Current stock: %f', [LowStock[I].MedicineID, LowStock[I].QuantityInStock]), '');
  finally
    LowStock.Free;
  end;
end;

end.