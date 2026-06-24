unit InventoryRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  RepositoryBase, InventoryItem, Warehouse;

type
  TInventoryRepository = class(TRepositoryBase)
  public
    function GetItemByID(AItemID: Integer): TInventoryItem;
    function GetItemsByWarehouse(AWarehouseID: Integer): TObjectList<TInventoryItem>;
    function GetAllItems: TObjectList<TInventoryItem>;
    function GetLowStockItems: TObjectList<TInventoryItem>;
    function GetItemsBySKU(const ASKU: string): TObjectList<TInventoryItem>;
    function InsertItem(AItem: TInventoryItem): Integer;  // returns new ItemID
    procedure UpdateItem(AItem: TInventoryItem);
    procedure DeleteItem(AItemID: Integer);
    procedure UpdateQuantity(AItemID: Integer; AQuantityDelta: Double); // delta can be negative
    function GetItemQuantity(AItemID: Integer): Double;
  end;

implementation

{ TInventoryRepository }

function TInventoryRepository.GetItemByID(AItemID: Integer): TInventoryItem;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT ItemID, WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice FROM Inventory WHERE ItemID = :ItemID';
    Q.ParamByName('ItemID').AsInteger := AItemID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TInventoryItem.Create;
      Result.ItemID := Q.FieldByName('ItemID').AsInteger;
      Result.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Result.SKU := Q.FieldByName('SKU').AsString;
      Result.ItemName := Q.FieldByName('ItemName').AsString;
      Result.Description := Q.FieldByName('Description').AsString;
      Result.Quantity := Q.FieldByName('Quantity').AsFloat;
      Result.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Result.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetItemsByWarehouse(AWarehouseID: Integer): TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT ItemID, WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice FROM Inventory WHERE WarehouseID = :WarehouseID ORDER BY SKU';
    Q.ParamByName('WarehouseID').AsInteger := AWarehouseID;
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.ItemID := Q.FieldByName('ItemID').AsInteger;
      Item.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Item.SKU := Q.FieldByName('SKU').AsString;
      Item.ItemName := Q.FieldByName('ItemName').AsString;
      Item.Description := Q.FieldByName('Description').AsString;
      Item.Quantity := Q.FieldByName('Quantity').AsFloat;
      Item.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Item.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetAllItems: TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT ItemID, WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice FROM Inventory ORDER BY SKU';
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.ItemID := Q.FieldByName('ItemID').AsInteger;
      Item.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Item.SKU := Q.FieldByName('SKU').AsString;
      Item.ItemName := Q.FieldByName('ItemName').AsString;
      Item.Description := Q.FieldByName('Description').AsString;
      Item.Quantity := Q.FieldByName('Quantity').AsFloat;
      Item.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Item.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetLowStockItems: TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT ItemID, WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice FROM Inventory WHERE Quantity < ReorderLevel ORDER BY SKU';
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.ItemID := Q.FieldByName('ItemID').AsInteger;
      Item.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Item.SKU := Q.FieldByName('SKU').AsString;
      Item.ItemName := Q.FieldByName('ItemName').AsString;
      Item.Description := Q.FieldByName('Description').AsString;
      Item.Quantity := Q.FieldByName('Quantity').AsFloat;
      Item.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Item.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetItemsBySKU(const ASKU: string): TObjectList<TInventoryItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TInventoryItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT ItemID, WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice FROM Inventory WHERE SKU LIKE :SKU ORDER BY SKU';
    Q.ParamByName('SKU').AsString := '%' + ASKU + '%';
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TInventoryItem.Create;
      Item.ItemID := Q.FieldByName('ItemID').AsInteger;
      Item.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Item.SKU := Q.FieldByName('SKU').AsString;
      Item.ItemName := Q.FieldByName('ItemName').AsString;
      Item.Description := Q.FieldByName('Description').AsString;
      Item.Quantity := Q.FieldByName('Quantity').AsFloat;
      Item.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Item.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.InsertItem(AItem: TInventoryItem): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AItem.Validate then
    raise Exception.Create('Inventory item data is invalid.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Inventory (WarehouseID, SKU, ItemName, Description, ' +
                  'Quantity, ReorderLevel, UnitPrice) VALUES ' +
                  '(:WarehouseID, :SKU, :ItemName, :Description, :Quantity, :ReorderLevel, :UnitPrice); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('WarehouseID').AsInteger := AItem.WarehouseID;
    Q.ParamByName('SKU').AsString := AItem.SKU;
    Q.ParamByName('ItemName').AsString := AItem.ItemName;
    Q.ParamByName('Description').AsString := AItem.Description;
    Q.ParamByName('Quantity').AsFloat := AItem.Quantity;
    Q.ParamByName('ReorderLevel').AsFloat := AItem.ReorderLevel;
    Q.ParamByName('UnitPrice').AsFloat := AItem.UnitPrice;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.UpdateItem(AItem: TInventoryItem);
var
  Q: TFDQuery;
begin
  if not AItem.Validate then
    raise Exception.Create('Inventory item data is invalid.');
  if AItem.ItemID <= 0 then
    raise Exception.Create('Item ID must be set for update.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Inventory SET WarehouseID = :WarehouseID, SKU = :SKU, ' +
                  'ItemName = :ItemName, Description = :Description, ' +
                  'Quantity = :Quantity, ReorderLevel = :ReorderLevel, UnitPrice = :UnitPrice ' +
                  'WHERE ItemID = :ItemID';
    Q.ParamByName('ItemID').AsInteger := AItem.ItemID;
    Q.ParamByName('WarehouseID').AsInteger := AItem.WarehouseID;
    Q.ParamByName('SKU').AsString := AItem.SKU;
    Q.ParamByName('ItemName').AsString := AItem.ItemName;
    Q.ParamByName('Description').AsString := AItem.Description;
    Q.ParamByName('Quantity').AsFloat := AItem.Quantity;
    Q.ParamByName('ReorderLevel').AsFloat := AItem.ReorderLevel;
    Q.ParamByName('UnitPrice').AsFloat := AItem.UnitPrice;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.DeleteItem(AItemID: Integer);
var
  Q: TFDQuery;
begin
  if AItemID <= 0 then
    raise Exception.Create('Invalid Item ID.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Inventory WHERE ItemID = :ItemID';
    Q.ParamByName('ItemID').AsInteger := AItemID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TInventoryRepository.UpdateQuantity(AItemID: Integer; AQuantityDelta: Double);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Inventory SET Quantity = Quantity + :Delta WHERE ItemID = :ItemID';
    Q.ParamByName('Delta').AsFloat := AQuantityDelta;
    Q.ParamByName('ItemID').AsInteger := AItemID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TInventoryRepository.GetItemQuantity(AItemID: Integer): Double;
var
  Q: TFDQuery;
begin
  Result := 0;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT Quantity FROM Inventory WHERE ItemID = :ItemID';
    Q.ParamByName('ItemID').AsInteger := AItemID;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('Quantity').AsFloat;
    Q.Close;
  finally
    Q.Free;
  end;
end;

end.