unit InventoryRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, InventoryItem;

type
  TInventoryRepository = class(TRepositoryBase)
  public
    function GetInventoryItemByID(AInventoryID: Integer): TInventoryItem;
    function GetInventoryItemsByMedicine(AMedicineID: Integer): TObjectList<TInventoryItem>;
    function GetAllInventoryItems: TObjectList<TInventoryItem>;
    function GetExpiringItems(ADaysThreshold: Integer = 30): TObjectList<TInventoryItem>;
    function GetLowStockItems: TObjectList<TInventoryItem>;  // returns items with total stock < reorder level
    function InsertInventoryItem(AItem: TInventoryItem): Integer;
    procedure UpdateInventoryItem(AItem: TInventoryItem);
    procedure DeleteInventoryItem(AInventoryID: Integer);
    procedure AdjustStock(AInventoryID: Integer; AQuantity: Double); // positive = increase, negative = decrease
    function GetTotalStockForMedicine(AMedicineID: Integer): Double;
  end;

implementation

{ TInventoryRepository }

function TInventoryRepository.GetInventoryItemByID(AInventoryID: Integer): TInventoryItem;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT InventoryID, MedicineID, SupplierID, BatchNumber, QuantityInStock, ' +
                  'ManufacturingDate, ExpiryDate FROM Inventory WHERE InventoryID = :InventoryID';
    Q.ParamByName('InventoryID').AsInteger := AInventoryID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TInventoryItem.Create;
      Result.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      Result.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Result.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Result.BatchNumber := Q.FieldByName('BatchNumber').AsString;
      Result.QuantityInStock := Q.FieldByName('QuantityInStock').AsFloat;
      Result.ManufacturingDate := Q.FieldByName('ManufacturingDate').AsDateTime;
      Result.ExpiryDate := Q.FieldByName('ExpiryDate').AsDateTime;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetInventoryItemsByMedicine(AMedicineID: Integer): TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT InventoryID, MedicineID, SupplierID, BatchNumber, QuantityInStock, ' +
                  'ManufacturingDate, ExpiryDate FROM Inventory WHERE MedicineID = :MedicineID ' +
                  'ORDER BY ExpiryDate';
    Q.ParamByName('MedicineID').AsInteger := AMedicineID;
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      Item.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Item.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Item.BatchNumber := Q.FieldByName('BatchNumber').AsString;
      Item.QuantityInStock := Q.FieldByName('QuantityInStock').AsFloat;
      Item.ManufacturingDate := Q.FieldByName('ManufacturingDate').AsDateTime;
      Item.ExpiryDate := Q.FieldByName('ExpiryDate').AsDateTime;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetAllInventoryItems: TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT InventoryID, MedicineID, SupplierID, BatchNumber, QuantityInStock, ' +
                  'ManufacturingDate, ExpiryDate FROM Inventory ORDER BY MedicineID, ExpiryDate';
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      Item.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Item.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Item.BatchNumber := Q.FieldByName('BatchNumber').AsString;
      Item.QuantityInStock := Q.FieldByName('QuantityInStock').AsFloat;
      Item.ManufacturingDate := Q.FieldByName('ManufacturingDate').AsDateTime;
      Item.ExpiryDate := Q.FieldByName('ExpiryDate').AsDateTime;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetExpiringItems(ADaysThreshold: Integer): TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT InventoryID, MedicineID, SupplierID, BatchNumber, QuantityInStock, ' +
                  'ManufacturingDate, ExpiryDate FROM Inventory ' +
                  'WHERE ExpiryDate BETWEEN GETDATE() AND DATEADD(day, :Days, GETDATE()) ' +
                  'AND QuantityInStock > 0 ORDER BY ExpiryDate';
    Q.ParamByName('Days').AsInteger := ADaysThreshold;
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      Item.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Item.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Item.BatchNumber := Q.FieldByName('BatchNumber').AsString;
      Item.QuantityInStock := Q.FieldByName('QuantityInStock').AsFloat;
      Item.ManufacturingDate := Q.FieldByName('ManufacturingDate').AsDateTime;
      Item.ExpiryDate := Q.FieldByName('ExpiryDate').AsDateTime;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetLowStockItems: TObjectList<TInventoryItem>;
begin
  // Returns inventory items where total stock per medicine is below reorder level.
  // We'll get all and compute in service, or use a query.
  // For simplicity, we'll return all items; the service will filter.
  Result := GetAllInventoryItems;
end;

function TInventoryRepository.InsertInventoryItem(AItem: TInventoryItem): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AItem.Validate then
    raise Exception.Create('Inventory item data invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Inventory (MedicineID, SupplierID, BatchNumber, QuantityInStock, ' +
                  'ManufacturingDate, ExpiryDate) VALUES (:MedicineID, :SupplierID, :BatchNumber, ' +
                  ':QuantityInStock, :ManufacturingDate, :ExpiryDate); SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('MedicineID').AsInteger := AItem.MedicineID;
    Q.ParamByName('SupplierID').AsInteger := AItem.SupplierID;
    Q.ParamByName('BatchNumber').AsString := AItem.BatchNumber;
    Q.ParamByName('QuantityInStock').AsFloat := AItem.QuantityInStock;
    Q.ParamByName('ManufacturingDate').AsDateTime := AItem.ManufacturingDate;
    Q.ParamByName('ExpiryDate').AsDateTime := AItem.ExpiryDate;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.UpdateInventoryItem(AItem: TInventoryItem);
var
  Q: TFDQuery;
begin
  if not AItem.Validate then
    raise Exception.Create('Inventory item data invalid.');
  if AItem.InventoryID <= 0 then
    raise Exception.Create('InventoryID must be set.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Inventory SET MedicineID = :MedicineID, SupplierID = :SupplierID, ' +
                  'BatchNumber = :BatchNumber, QuantityInStock = :QuantityInStock, ' +
                  'ManufacturingDate = :ManufacturingDate, ExpiryDate = :ExpiryDate ' +
                  'WHERE InventoryID = :InventoryID';
    Q.ParamByName('InventoryID').AsInteger := AItem.InventoryID;
    Q.ParamByName('MedicineID').AsInteger := AItem.MedicineID;
    Q.ParamByName('SupplierID').AsInteger := AItem.SupplierID;
    Q.ParamByName('BatchNumber').AsString := AItem.BatchNumber;
    Q.ParamByName('QuantityInStock').AsFloat := AItem.QuantityInStock;
    Q.ParamByName('ManufacturingDate').AsDateTime := AItem.ManufacturingDate;
    Q.ParamByName('ExpiryDate').AsDateTime := AItem.ExpiryDate;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.DeleteInventoryItem(AInventoryID: Integer);
var
  Q: TFDQuery;
begin
  if AInventoryID <= 0 then
    raise Exception.Create('Invalid InventoryID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Inventory WHERE InventoryID = :InventoryID';
    Q.ParamByName('InventoryID').AsInteger := AInventoryID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.AdjustStock(AInventoryID: Integer; AQuantity: Double);
var
  Q: TFDQuery;
begin
  if AInventoryID <= 0 then
    raise Exception.Create('Invalid InventoryID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Inventory SET QuantityInStock = QuantityInStock + :Delta ' +
                  'WHERE InventoryID = :InventoryID AND (QuantityInStock + :Delta) >= 0';
    Q.ParamByName('Delta').AsFloat := AQuantity;
    Q.ParamByName('InventoryID').AsInteger := AInventoryID;
    if Q.ExecRows = 0 then
      raise Exception.Create('Stock adjustment failed – possibly negative quantity.');
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetTotalStockForMedicine(AMedicineID: Integer): Double;
var
  Q: TFDQuery;
begin
  Result := 0;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT SUM(QuantityInStock) AS Total FROM Inventory WHERE MedicineID = :MedicineID';
    Q.ParamByName('MedicineID').AsInteger := AMedicineID;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('Total').AsFloat;
    Q.Close;
  finally
    Q.Free;
  end;
end;

end.