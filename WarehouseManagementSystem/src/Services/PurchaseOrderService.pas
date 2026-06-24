unit PurchaseOrderService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  PurchaseOrder, PurchaseOrderItem, PurchaseOrderRepository,
  InventoryService, AuditService;

type
  TPurchaseOrderService = class
  private
    FRepo: TPurchaseOrderRepository;
    FInvService: TInventoryService;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetPO(AID: Integer): TPurchaseOrder;
    function GetAllPOs: TObjectList<TPurchaseOrder>;
    function GetPOsBySupplier(ASupplierID: Integer): TObjectList<TPurchaseOrder>;
    function GetPOsByStatus(AStatus: string): TObjectList<TPurchaseOrder>;

    function CreatePO(APO: TPurchaseOrder; AUserID: Integer): Integer;
    procedure UpdatePO(APO: TPurchaseOrder; AUserID: Integer);
    procedure SubmitPO(APOID: Integer; AUserID: Integer);
    procedure ReceivePO(APOID: Integer; AUserID: Integer); // receives all items into inventory
    procedure CancelPO(APOID: Integer; AUserID: Integer);

    function GetPOItems(APOID: Integer): TObjectList<TPurchaseOrderItem>;
  end;

implementation

{ TPurchaseOrderService }

constructor TPurchaseOrderService.Create;
begin
  inherited;
  FRepo := TPurchaseOrderRepository.Create;
  FInvService := TInventoryService.Create;
  FAudit := TAuditService.Create;
end;

destructor TPurchaseOrderService.Destroy;
begin
  FRepo.Free;
  FInvService.Free;
  FAudit.Free;
  inherited;
end;

function TPurchaseOrderService.GetPO(AID: Integer): TPurchaseOrder;
begin
  Result := FRepo.GetPOByID(AID);
end;

function TPurchaseOrderService.GetAllPOs: TObjectList<TPurchaseOrder>;
begin
  Result := FRepo.GetAllPOs;
end;

function TPurchaseOrderService.GetPOsBySupplier(ASupplierID: Integer): TObjectList<TPurchaseOrder>;
begin
  Result := FRepo.GetPOsBySupplier(ASupplierID);
end;

function TPurchaseOrderService.GetPOsByStatus(AStatus: string): TObjectList<TPurchaseOrder>;
begin
  Result := FRepo.GetPOsByStatus(AStatus);
end;

function TPurchaseOrderService.CreatePO(APO: TPurchaseOrder; AUserID: Integer): Integer;
begin
  Result := FRepo.InsertPO(APO);
  FAudit.LogAction(AUserID, Format('Created purchase order #%d', [Result]), '');
end;

procedure TPurchaseOrderService.UpdatePO(APO: TPurchaseOrder; AUserID: Integer);
begin
  FRepo.UpdatePO(APO);
  FAudit.LogAction(AUserID, Format('Updated purchase order #%d', [APO.POID]), '');
end;

procedure TPurchaseOrderService.SubmitPO(APOID: Integer; AUserID: Integer);
begin
  FRepo.UpdatePOStatus(APOID, 'Submitted');
  FAudit.LogAction(AUserID, Format('Submitted purchase order #%d', [APOID]), '');
end;

procedure TPurchaseOrderService.ReceivePO(APOID: Integer; AUserID: Integer);
var
  PO: TPurchaseOrder;
  I: Integer;
begin
  PO := FRepo.GetPOByID(APOID);
  if PO = nil then
    raise Exception.Create('Purchase order not found.');
  if PO.Status <> posSubmitted then
    raise Exception.Create('Purchase order must be in Submitted status to receive.');

  // For each item, receive stock
  FRepo.BeginTransaction;
  try
    for I := 0 to PO.Items.Count - 1 do
    begin
      var Item := PO.Items[I];
      // Receive into the default warehouse? We need to specify. For simplicity, use item's warehouse? Actually we need to know which warehouse to receive into. We might have a default or use the item's warehouse. We'll assume the item's warehouse from inventory. We need to get the item to know its warehouse.
      var InvItem := FInvService.GetItem(Item.ItemID);
      if InvItem = nil then
        raise Exception.CreateFmt('Inventory item %d not found.', [Item.ItemID]);
      FInvService.ReceiveStock(Item.ItemID, InvItem.WarehouseID, AUserID, Item.Quantity, Format('PO #%d', [APOID]));
    end;
    FRepo.UpdatePOStatus(APOID, 'Received');
    FAudit.LogAction(AUserID, Format('Received purchase order #%d', [APOID]), '');
    FRepo.CommitTransaction;
  except
    FRepo.RollbackTransaction;
    raise;
  end;
  PO.Free;
end;

procedure TPurchaseOrderService.CancelPO(APOID: Integer; AUserID: Integer);
begin
  FRepo.UpdatePOStatus(APOID, 'Cancelled');
  FAudit.LogAction(AUserID, Format('Cancelled purchase order #%d', [APOID]), '');
end;

function TPurchaseOrderService.GetPOItems(APOID: Integer): TObjectList<TPurchaseOrderItem>;
begin
  Result := FRepo.GetPOItemsByPO(APOID);
end;

end.