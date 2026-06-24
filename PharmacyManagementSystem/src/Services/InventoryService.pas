unit InventoryService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  InventoryItem, InventoryRepository, MedicineRepository, AuditService, Constants;

type
  TInventoryService = class
  private
    FInvRepo: TInventoryRepository;
    FMedRepo: TMedicineRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetInventoryItemByID(AInventoryID: Integer): TInventoryItem;
    function GetItemsByMedicine(AMedicineID: Integer): TObjectList<TInventoryItem>;
    function GetAllItems: TObjectList<TInventoryItem>;
    function GetExpiringItems(ADaysThreshold: Integer = 30): TObjectList<TInventoryItem>;
    function GetLowStockItems: TObjectList<TInventoryItem>;
    function AddInventoryItem(AItem: TInventoryItem; ALoggedInUserID: Integer): Integer;
    procedure UpdateInventoryItem(AItem: TInventoryItem; ALoggedInUserID: Integer);
    procedure DeleteInventoryItem(AInventoryID: Integer; ALoggedInUserID: Integer);
    procedure AdjustStock(AInventoryID: Integer; AQuantity: Double; ALoggedInUserID: Integer; const AReason: string);
    function GetTotalStockForMedicine(AMedicineID: Integer): Double;
  end;

implementation

{ TInventoryService }

constructor TInventoryService.Create;
begin
  FInvRepo := TInventoryRepository.Create;
  FMedRepo := TMedicineRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TInventoryService.Destroy;
begin
  FInvRepo.Free;
  FMedRepo.Free;
  FAudit.Free;
  inherited;
end;

function TInventoryService.GetInventoryItemByID(AInventoryID: Integer): TInventoryItem;
begin
  Result := FInvRepo.GetInventoryItemByID(AInventoryID);
end;

function TInventoryService.GetItemsByMedicine(AMedicineID: Integer): TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetInventoryItemsByMedicine(AMedicineID);
end;

function TInventoryService.GetAllItems: TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetAllInventoryItems;
end;

function TInventoryService.GetExpiringItems(ADaysThreshold: Integer): TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetExpiringItems(ADaysThreshold);
end;

function TInventoryService.GetLowStockItems: TObjectList<TInventoryItem>;
var
  AllItems: TObjectList<TInventoryItem>;
  MedList: TObjectList<TMedicine>;
  I, J: Integer;
  TotalStock: Double;
begin
  Result := TObjectList<TInventoryItem>.Create(False);
  MedList := FMedRepo.GetAllMedicines;
  try
    for I := 0 to MedList.Count - 1 do
    begin
      TotalStock := FInvRepo.GetTotalStockForMedicine(MedList[I].MedicineID);
      if TotalStock < MedList[I].ReorderLevel then
      begin
        // Add one inventory item as representative (or create a dummy)
        var Item := TInventoryItem.Create;
        Item.MedicineID := MedList[I].MedicineID;
        Item.QuantityInStock := TotalStock;
        Item.ExpiryDate := Now; // dummy
        Result.Add(Item);
      end;
    end;
  finally
    MedList.Free;
  end;
end;

function TInventoryService.AddInventoryItem(AItem: TInventoryItem; ALoggedInUserID: Integer): Integer;
begin
  Result := FInvRepo.InsertInventoryItem(AItem);
  if Result > 0 then
    FAudit.LogAction(ALoggedInUserID, AUDIT_INVENTORY_ADJUST,
      Format('Added new batch for medicine %d, qty %f', [AItem.MedicineID, AItem.QuantityInStock]), '');
end;

procedure TInventoryService.UpdateInventoryItem(AItem: TInventoryItem; ALoggedInUserID: Integer);
begin
  FInvRepo.UpdateInventoryItem(AItem);
  FAudit.LogAction(ALoggedInUserID, AUDIT_INVENTORY_ADJUST,
    Format('Updated inventory item %d', [AItem.InventoryID]), '');
end;

procedure TInventoryService.DeleteInventoryItem(AInventoryID: Integer; ALoggedInUserID: Integer);
begin
  FInvRepo.DeleteInventoryItem(AInventoryID);
  FAudit.LogAction(ALoggedInUserID, AUDIT_INVENTORY_ADJUST,
    Format('Deleted inventory item %d', [AInventoryID]), '');
end;

procedure TInventoryService.AdjustStock(AInventoryID: Integer; AQuantity: Double;
  ALoggedInUserID: Integer; const AReason: string);
begin
  FInvRepo.BeginTransaction;
  try
    FInvRepo.AdjustStock(AInventoryID, AQuantity);
    FAudit.LogAction(ALoggedInUserID, AUDIT_INVENTORY_ADJUST,
      Format('Adjusted stock for inventory %d by %f (reason: %s)', [AInventoryID, AQuantity, AReason]), '');
    FInvRepo.CommitTransaction;
  except
    FInvRepo.RollbackTransaction;
    raise;
  end;
end;

function TInventoryService.GetTotalStockForMedicine(AMedicineID: Integer): Double;
begin
  Result := FInvRepo.GetTotalStockForMedicine(AMedicineID);
end;

end.