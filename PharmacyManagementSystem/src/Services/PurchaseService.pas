unit PurchaseService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Purchase, PurchaseItem, PurchaseRepository, InventoryRepository, MedicineRepository,
  AuditService, Constants;

type
  TPurchaseService = class
  private
    FPurchaseRepo: TPurchaseRepository;
    FInventoryRepo: TInventoryRepository;
    FMedicineRepo: TMedicineRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetPurchaseByID(APurchaseID: Integer): TPurchase;
    function GetAllPurchases: TObjectList<TPurchase>;
    function CreatePurchase(APurchase: TPurchase; ALoggedInUserID: Integer): Integer;
    procedure ReceivePurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
    procedure CancelPurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
    procedure DeletePurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
  end;

implementation

{ TPurchaseService }

constructor TPurchaseService.Create;
begin
  FPurchaseRepo := TPurchaseRepository.Create;
  FInventoryRepo := TInventoryRepository.Create;
  FMedicineRepo := TMedicineRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TPurchaseService.Destroy;
begin
  FPurchaseRepo.Free;
  FInventoryRepo.Free;
  FMedicineRepo.Free;
  FAudit.Free;
  inherited;
end;

function TPurchaseService.GetPurchaseByID(APurchaseID: Integer): TPurchase;
begin
  Result := FPurchaseRepo.GetPurchaseByID(APurchaseID);
end;

function TPurchaseService.GetAllPurchases: TObjectList<TPurchase>;
begin
  Result := FPurchaseRepo.GetAllPurchases;
end;

function TPurchaseService.CreatePurchase(APurchase: TPurchase; ALoggedInUserID: Integer): Integer;
begin
  // Validate that all medicines exist
  var I: Integer;
  for I := 0 to APurchase.Items.Count - 1 do
  begin
    var Med := FMedicineRepo.GetMedicineByID(APurchase.Items[I].MedicineID);
    if Med = nil then
      raise Exception.CreateFmt('Medicine ID %d not found.', [APurchase.Items[I].MedicineID]);
    Med.Free;
  end;

  Result := FPurchaseRepo.InsertPurchase(APurchase);
  FAudit.LogAction(ALoggedInUserID, AUDIT_PURCHASE_CREATE,
    Format('Created purchase PO#%d from supplier %d', [Result, APurchase.SupplierID]), '');
end;

procedure TPurchaseService.ReceivePurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
var
  Purchase: TPurchase;
  Items: TObjectList<TPurchaseItem>;
  I: Integer;
begin
  Purchase := FPurchaseRepo.GetPurchaseByID(APurchaseID);
  if Purchase = nil then
    raise Exception.Create('Purchase not found.');

  // For each item, add to inventory
  Items := FPurchaseRepo.GetPurchaseItems(APurchaseID);
  try
    FPurchaseRepo.BeginTransaction;
    try
      for I := 0 to Items.Count - 1 do
      begin
        var InvItem := TInventoryItem.Create;
        InvItem.MedicineID := Items[I].MedicineID;
        // SupplierID from purchase header
        InvItem.SupplierID := Purchase.SupplierID;
        InvItem.BatchNumber := 'PO-' + IntToStr(APurchaseID) + '-' + IntToStr(I+1);
        InvItem.QuantityInStock := Items[I].Quantity;
        InvItem.ManufacturingDate := Now;
        InvItem.ExpiryDate := Now + 365; // default 1 year
        FInventoryRepo.InsertInventoryItem(InvItem);
      end;
      // Mark purchase as received? (optional: we could have a status field)
      FAudit.LogAction(ALoggedInUserID, AUDIT_PURCHASE_CREATE,
        Format('Received purchase PO#%d', [APurchaseID]), '');
      FPurchaseRepo.CommitTransaction;
    except
      FPurchaseRepo.RollbackTransaction;
      raise;
    end;
  finally
    Items.Free;
    Purchase.Free;
  end;
end;

procedure TPurchaseService.CancelPurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
begin
  // Could update status, but no status column exists – we can add one or just delete.
  // For now, just delete.
  DeletePurchase(APurchaseID, ALoggedInUserID);
end;

procedure TPurchaseService.DeletePurchase(APurchaseID: Integer; ALoggedInUserID: Integer);
begin
  FPurchaseRepo.DeletePurchase(APurchaseID);
  FAudit.LogAction(ALoggedInUserID, AUDIT_PURCHASE_DELETE,
    Format('Deleted purchase PO#%d', [APurchaseID]), '');
end;

end.