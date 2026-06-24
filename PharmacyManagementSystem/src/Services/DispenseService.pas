unit DispenseService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  DispenseTransaction, DispenseRepository, InventoryRepository,
  AuditService, Constants;

type
  TDispenseService = class
  private
    FDispRepo: TDispenseRepository;
    FInvRepo: TInventoryRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    procedure DispenseMedicine(AMedicineID: Integer; AQuantity: Double; ALoggedInUserID: Integer);
    function GetDispensesByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
    function GetDispensesByMedicine(AMedicineID: Integer): TObjectList<TDispenseTransaction>;
  end;

implementation

{ TDispenseService }

constructor TDispenseService.Create;
begin
  FDispRepo := TDispenseRepository.Create;
  FInvRepo := TInventoryRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TDispenseService.Destroy;
begin
  FDispRepo.Free;
  FInvRepo.Free;
  FAudit.Free;
  inherited;
end;

procedure TDispenseService.DispenseMedicine(AMedicineID: Integer; AQuantity: Double; ALoggedInUserID: Integer);
var
  Batches: TObjectList<TInventoryItem>;
  Remaining: Double;
  I: Integer;
  Dispense: TDispenseTransaction;
begin
  if AQuantity <= 0 then
    raise Exception.Create('Quantity must be positive.');

  // Get batches for this medicine, sorted by expiry (FIFO)
  Batches := FInvRepo.GetInventoryItemsByMedicine(AMedicineID);
  try
    // Remove expired batches? – we'll filter out expired
    for I := Batches.Count - 1 downto 0 do
      if Batches[I].IsExpired then
        Batches.Delete(I);

    if Batches.Count = 0 then
      raise Exception.Create('No available stock for this medicine.');

    Remaining := AQuantity;
    FDispRepo.BeginTransaction;
    try
      for I := 0 to Batches.Count - 1 do
      begin
        if Remaining <= 0 then Break;
        var Batch := Batches[I];
        var QtyToTake := Min(Remaining, Batch.QuantityInStock);
        if QtyToTake > 0 then
        begin
          // Update inventory
          FInvRepo.AdjustStock(Batch.InventoryID, -QtyToTake);

          // Log dispense
          Dispense := TDispenseTransaction.Create;
          Dispense.MedicineID := AMedicineID;
          Dispense.InventoryID := Batch.InventoryID;
          Dispense.QuantityDispensed := QtyToTake;
          Dispense.ProcessedBy := ALoggedInUserID;
          FDispRepo.InsertDispense(Dispense);
          Dispense.Free;

          Remaining := Remaining - QtyToTake;
        end;
      end;

      if Remaining > 0 then
        raise Exception.CreateFmt('Insufficient stock. Only %f dispensed, %f remaining.', [AQuantity - Remaining, Remaining]);

      FAudit.LogAction(ALoggedInUserID, AUDIT_DISPENSE,
        Format('Dispensed %f of medicine %d', [AQuantity, AMedicineID]), '');
      FDispRepo.CommitTransaction;
    except
      FDispRepo.RollbackTransaction;
      raise;
    end;
  finally
    Batches.Free;
  end;
end;

function TDispenseService.GetDispensesByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
begin
  Result := FDispRepo.GetDispensesByDateRange(AStartDate, AEndDate);
end;

function TDispenseService.GetDispensesByMedicine(AMedicineID: Integer): TObjectList<TDispenseTransaction>;
begin
  Result := FDispRepo.GetDispensesByMedicine(AMedicineID);
end;

end.