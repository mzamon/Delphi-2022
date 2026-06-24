unit InventoryService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  InventoryItem, Warehouse, InventoryRepository, WarehouseRepository,
  StockMovementRepository, StockMovement, AuditService;

type
  TInventoryService = class
  private
    FInvRepo: TInventoryRepository;
    FWHRepo: TWarehouseRepository;
    FSMRepo: TStockMovementRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetItem(AItemID: Integer): TInventoryItem;
    function GetAllItems: TObjectList<TInventoryItem>;
    function GetItemsByWarehouse(AWarehouseID: Integer): TObjectList<TInventoryItem>;
    function GetLowStockItems: TObjectList<TInventoryItem>;

    function AddItem(AItem: TInventoryItem; AUserID: Integer): Integer; // returns new ItemID
    procedure UpdateItem(AItem: TInventoryItem; AUserID: Integer);
    procedure DeleteItem(AItemID: Integer; AUserID: Integer);

    // Stock movement
    procedure AdjustStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReason: string);
    procedure ReceiveStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReference: string);
    procedure IssueStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReference: string);

    function GetCurrentQuantity(AItemID: Integer): Double;
  end;

implementation

{ TInventoryService }

constructor TInventoryService.Create;
begin
  inherited Create;
  FInvRepo := TInventoryRepository.Create;
  FWHRepo := TWarehouseRepository.Create;
  FSMRepo := TStockMovementRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TInventoryService.Destroy;
begin
  FInvRepo.Free;
  FWHRepo.Free;
  FSMRepo.Free;
  FAudit.Free;
  inherited;
end;

function TInventoryService.GetItem(AItemID: Integer): TInventoryItem;
begin
  Result := FInvRepo.GetItemByID(AItemID);
end;

function TInventoryService.GetAllItems: TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetAllItems;
end;

function TInventoryService.GetItemsByWarehouse(AWarehouseID: Integer): TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetItemsByWarehouse(AWarehouseID);
end;

function TInventoryService.GetLowStockItems: TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetLowStockItems;
end;

function TInventoryService.AddItem(AItem: TInventoryItem; AUserID: Integer): Integer;
begin
  Result := FInvRepo.InsertItem(AItem);
  FAudit.LogAction(AUserID, Format('Added inventory item: %s (SKU: %s)', [AItem.ItemName, AItem.SKU]), '');
end;

procedure TInventoryService.UpdateItem(AItem: TInventoryItem; AUserID: Integer);
begin
  FInvRepo.UpdateItem(AItem);
  FAudit.LogAction(AUserID, Format('Updated inventory item: %s (SKU: %s)', [AItem.ItemName, AItem.SKU]), '');
end;

procedure TInventoryService.DeleteItem(AItemID: Integer; AUserID: Integer);
begin
  var Item := FInvRepo.GetItemByID(AItemID);
  if Item <> nil then
  begin
    FInvRepo.DeleteItem(AItemID);
    FAudit.LogAction(AUserID, Format('Deleted inventory item: %s (SKU: %s)', [Item.ItemName, Item.SKU]), '');
    Item.Free;
  end;
end;

procedure TInventoryService.AdjustStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReason: string);
begin
  if AQuantity = 0 then Exit;
  FInvRepo.BeginTransaction;
  try
    // Update quantity
    FInvRepo.UpdateQuantity(AItemID, AQuantity);
    // Record movement
    var Mov := TStockMovement.Create;
    Mov.ItemID := AItemID;
    Mov.WarehouseID := AWarehouseID;
    Mov.MovementType := smtAdjust;
    Mov.Quantity := AQuantity;
    Mov.MovementDate := Now;
    Mov.UserID := AUserID;
    Mov.Reference := AReason;
    FSMRepo.InsertMovement(Mov);
    Mov.Free;
    FAudit.LogAction(AUserID, Format('Adjusted stock for item %d by %f (reason: %s)', [AItemID, AQuantity, AReason]), '');
    FInvRepo.CommitTransaction;
  except
    FInvRepo.RollbackTransaction;
    raise;
  end;
end;

procedure TInventoryService.ReceiveStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReference: string);
begin
  if AQuantity <= 0 then raise Exception.Create('Receive quantity must be positive.');
  FInvRepo.BeginTransaction;
  try
    FInvRepo.UpdateQuantity(AItemID, AQuantity);
    var Mov := TStockMovement.Create;
    Mov.ItemID := AItemID;
    Mov.WarehouseID := AWarehouseID;
    Mov.MovementType := smtIn;
    Mov.Quantity := AQuantity;
    Mov.MovementDate := Now;
    Mov.UserID := AUserID;
    Mov.Reference := AReference;
    FSMRepo.InsertMovement(Mov);
    Mov.Free;
    FAudit.LogAction(AUserID, Format('Received stock for item %d: %f (ref: %s)', [AItemID, AQuantity, AReference]), '');
    FInvRepo.CommitTransaction;
  except
    FInvRepo.RollbackTransaction;
    raise;
  end;
end;

procedure TInventoryService.IssueStock(AItemID, AWarehouseID, AUserID: Integer; AQuantity: Double; const AReference: string);
begin
  if AQuantity <= 0 then raise Exception.Create('Issue quantity must be positive.');
  // Check sufficient quantity
  var CurrentQty := FInvRepo.GetItemQuantity(AItemID);
  if CurrentQty < AQuantity then
    raise Exception.Create('Insufficient stock.');
  FInvRepo.BeginTransaction;
  try
    FInvRepo.UpdateQuantity(AItemID, -AQuantity);
    var Mov := TStockMovement.Create;
    Mov.ItemID := AItemID;
    Mov.WarehouseID := AWarehouseID;
    Mov.MovementType := smtOut;
    Mov.Quantity := -AQuantity; // negative for OUT
    Mov.MovementDate := Now;
    Mov.UserID := AUserID;
    Mov.Reference := AReference;
    FSMRepo.InsertMovement(Mov);
    Mov.Free;
    FAudit.LogAction(AUserID, Format('Issued stock for item %d: %f (ref: %s)', [AItemID, AQuantity, AReference]), '');
    FInvRepo.CommitTransaction;
  except
    FInvRepo.RollbackTransaction;
    raise;
  end;
end;

function TInventoryService.GetCurrentQuantity(AItemID: Integer): Double;
begin
  Result := FInvRepo.GetItemQuantity(AItemID);
end;

end.