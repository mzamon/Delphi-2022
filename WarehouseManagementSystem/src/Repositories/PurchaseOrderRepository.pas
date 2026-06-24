unit PurchaseOrderRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  RepositoryBase, PurchaseOrder, PurchaseOrderItem;

type
  TPurchaseOrderRepository = class(TRepositoryBase)
  public
    function GetPOByID(APOID: Integer): TPurchaseOrder;
    function GetAllPOs: TObjectList<TPurchaseOrder>;
    function GetPOsBySupplier(ASupplierID: Integer): TObjectList<TPurchaseOrder>;
    function GetPOsByStatus(AStatus: string): TObjectList<TPurchaseOrder>;
    function InsertPO(APO: TPurchaseOrder): Integer; // returns new POID, also inserts items
    procedure UpdatePO(APO: TPurchaseOrder);
    procedure UpdatePOStatus(APOID: Integer; const AStatus: string);
    procedure DeletePO(APOID: Integer);
    // Items
    procedure InsertPOItem(AItem: TPurchaseOrderItem);
    procedure UpdatePOItem(AItem: TPurchaseOrderItem);
    procedure DeletePOItem(APOItemID: Integer);
    procedure DeletePOItemsByPO(APOID: Integer);
    function GetPOItemsByPO(APOID: Integer): TObjectList<TPurchaseOrderItem>;
  end;

implementation

{ TPurchaseOrderRepository }

function TPurchaseOrderRepository.GetPOByID(APOID: Integer): TPurchaseOrder;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT POID, SupplierID, CreatedBy, OrderDate, Status FROM PurchaseOrders WHERE POID = :POID';
    Q.ParamByName('POID').AsInteger := APOID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TPurchaseOrder.Create;
      Result.POID := Q.FieldByName('POID').AsInteger;
      Result.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Result.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      Result.OrderDate := Q.FieldByName('OrderDate').AsDateTime;
      Result.Status := TPurchaseOrderStatus(Ord(Q.FieldByName('Status').AsString[1])); // quick conversion
      // Load items
      var Items := GetPOItemsByPO(APOID);
      Result.Items.AddRange(Items);
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseOrderRepository.GetAllPOs: TObjectList<TPurchaseOrder>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchaseOrder>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT POID, SupplierID, CreatedBy, OrderDate, Status FROM PurchaseOrders ORDER BY OrderDate DESC';
    Q.Open;
    while not Q.Eof do
    begin
      var PO := TPurchaseOrder.Create;
      PO.POID := Q.FieldByName('POID').AsInteger;
      PO.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      PO.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      PO.OrderDate := Q.FieldByName('OrderDate').AsDateTime;
      PO.Status := TPurchaseOrderStatus(Ord(Q.FieldByName('Status').AsString[1]));
      // We don't load items here for performance; can be lazy loaded
      Result.Add(PO);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseOrderRepository.GetPOsBySupplier(ASupplierID: Integer): TObjectList<TPurchaseOrder>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchaseOrder>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT POID, SupplierID, CreatedBy, OrderDate, Status FROM PurchaseOrders WHERE SupplierID = :SupplierID ORDER BY OrderDate DESC';
    Q.ParamByName('SupplierID').AsInteger := ASupplierID;
    Q.Open;
    while not Q.Eof do
    begin
      var PO := TPurchaseOrder.Create;
      PO.POID := Q.FieldByName('POID').AsInteger;
      PO.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      PO.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      PO.OrderDate := Q.FieldByName('OrderDate').AsDateTime;
      PO.Status := TPurchaseOrderStatus(Ord(Q.FieldByName('Status').AsString[1]));
      Result.Add(PO);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseOrderRepository.GetPOsByStatus(AStatus: string): TObjectList<TPurchaseOrder>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchaseOrder>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT POID, SupplierID, CreatedBy, OrderDate, Status FROM PurchaseOrders WHERE Status = :Status ORDER BY OrderDate DESC';
    Q.ParamByName('Status').AsString := AStatus;
    Q.Open;
    while not Q.Eof do
    begin
      var PO := TPurchaseOrder.Create;
      PO.POID := Q.FieldByName('POID').AsInteger;
      PO.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      PO.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      PO.OrderDate := Q.FieldByName('OrderDate').AsDateTime;
      PO.Status := TPurchaseOrderStatus(Ord(Q.FieldByName('Status').AsString[1]));
      Result.Add(PO);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseOrderRepository.InsertPO(APO: TPurchaseOrder): Integer;
var
  Q: TFDQuery;
  I: Integer;
begin
  Result := 0;
  if not APO.Validate then
    raise Exception.Create('Purchase Order data is invalid.');

  BeginTransaction;
  try
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := Connection;
      Q.SQL.Text := 'INSERT INTO PurchaseOrders (SupplierID, CreatedBy, OrderDate, Status) ' +
                    'VALUES (:SupplierID, :CreatedBy, :OrderDate, :Status); ' +
                    'SELECT SCOPE_IDENTITY() AS NewID';
      Q.ParamByName('SupplierID').AsInteger := APO.SupplierID;
      Q.ParamByName('CreatedBy').AsInteger := APO.CreatedBy;
      Q.ParamByName('OrderDate').AsDateTime := APO.OrderDate;
      Q.ParamByName('Status').AsString := Char(Ord(APO.Status));
      Q.Open;
      if not Q.IsEmpty then
        Result := Q.FieldByName('NewID').AsInteger;
      Q.Close;
    finally
      Q.Free;
    end;

    // Insert items
    if Result > 0 then
    begin
      for I := 0 to APO.Items.Count - 1 do
      begin
        var Item := APO.Items[I];
        Item.POID := Result;
        InsertPOItem(Item);
      end;
    end;
    CommitTransaction;
  except
    RollbackTransaction;
    raise;
  end;
end;

procedure TPurchaseOrderRepository.UpdatePO(APO: TPurchaseOrder);
var
  Q: TFDQuery;
begin
  if not APO.Validate then
    raise Exception.Create('Purchase Order data is invalid.');
  if APO.POID <= 0 then
    raise Exception.Create('PO ID must be set for update.');

  BeginTransaction;
  try
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := Connection;
      Q.SQL.Text := 'UPDATE PurchaseOrders SET SupplierID = :SupplierID, ' +
                    'CreatedBy = :CreatedBy, OrderDate = :OrderDate, Status = :Status ' +
                    'WHERE POID = :POID';
      Q.ParamByName('POID').AsInteger := APO.POID;
      Q.ParamByName('SupplierID').AsInteger := APO.SupplierID;
      Q.ParamByName('CreatedBy').AsInteger := APO.CreatedBy;
      Q.ParamByName('OrderDate').AsDateTime := APO.OrderDate;
      Q.ParamByName('Status').AsString := Char(Ord(APO.Status));
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    // Update items: delete old ones and reinsert (simplistic)
    DeletePOItemsByPO(APO.POID);
    for var I := 0 to APO.Items.Count - 1 do
    begin
      var Item := APO.Items[I];
      Item.POID := APO.POID;
      InsertPOItem(Item);
    end;
    CommitTransaction;
  except
    RollbackTransaction;
    raise;
  end;
end;

procedure TPurchaseOrderRepository.UpdatePOStatus(APOID: Integer; const AStatus: string);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE PurchaseOrders SET Status = :Status WHERE POID = :POID';
    Q.ParamByName('POID').AsInteger := APOID;
    Q.ParamByName('Status').AsString := AStatus;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseOrderRepository.DeletePO(APOID: Integer);
begin
  if APOID <= 0 then
    raise Exception.Create('Invalid PO ID.');
  // Items will be cascade deleted if ON DELETE CASCADE is set; otherwise delete manually
  BeginTransaction;
  try
    DeletePOItemsByPO(APOID);
    var Q := TFDQuery.Create(nil);
    try
      Q.Connection := Connection;
      Q.SQL.Text := 'DELETE FROM PurchaseOrders WHERE POID = :POID';
      Q.ParamByName('POID').AsInteger := APOID;
      Q.ExecSQL;
    finally
      Q.Free;
    end;
    CommitTransaction;
  except
    RollbackTransaction;
    raise;
  end;
end;

procedure TPurchaseOrderRepository.InsertPOItem(AItem: TPurchaseOrderItem);
var
  Q: TFDQuery;
begin
  if not AItem.Validate then
    raise Exception.Create('PO Item data is invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO PurchaseOrderItems (POID, ItemID, Quantity, UnitCost) ' +
                  'VALUES (:POID, :ItemID, :Quantity, :UnitCost); SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('POID').AsInteger := AItem.POID;
    Q.ParamByName('ItemID').AsInteger := AItem.ItemID;
    Q.ParamByName('Quantity').AsFloat := AItem.Quantity;
    Q.ParamByName('UnitCost').AsFloat := AItem.UnitCost;
    Q.Open;
    if not Q.IsEmpty then
      AItem.POItemID := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseOrderRepository.UpdatePOItem(AItem: TPurchaseOrderItem);
var
  Q: TFDQuery;
begin
  if not AItem.Validate then
    raise Exception.Create('PO Item data is invalid.');
  if AItem.POItemID <= 0 then
    raise Exception.Create('PO Item ID must be set for update.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE PurchaseOrderItems SET POID = :POID, ItemID = :ItemID, ' +
                  'Quantity = :Quantity, UnitCost = :UnitCost WHERE POItemID = :POItemID';
    Q.ParamByName('POItemID').AsInteger := AItem.POItemID;
    Q.ParamByName('POID').AsInteger := AItem.POID;
    Q.ParamByName('ItemID').AsInteger := AItem.ItemID;
    Q.ParamByName('Quantity').AsFloat := AItem.Quantity;
    Q.ParamByName('UnitCost').AsFloat := AItem.UnitCost;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseOrderRepository.DeletePOItem(APOItemID: Integer);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM PurchaseOrderItems WHERE POItemID = :POItemID';
    Q.ParamByName('POItemID').AsInteger := APOItemID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseOrderRepository.DeletePOItemsByPO(APOID: Integer);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM PurchaseOrderItems WHERE POID = :POID';
    Q.ParamByName('POID').AsInteger := APOID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TPurchaseOrderRepository.GetPOItemsByPO(APOID: Integer): TObjectList<TPurchaseOrderItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchaseOrderItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT POItemID, POID, ItemID, Quantity, UnitCost FROM PurchaseOrderItems WHERE POID = :POID';
    Q.ParamByName('POID').AsInteger := APOID;
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TPurchaseOrderItem.Create;
      Item.POItemID := Q.FieldByName('POItemID').AsInteger;
      Item.POID := Q.FieldByName('POID').AsInteger;
      Item.ItemID := Q.FieldByName('ItemID').AsInteger;
      Item.Quantity := Q.FieldByName('Quantity').AsFloat;
      Item.UnitCost := Q.FieldByName('UnitCost').AsFloat;
      Result.Add(Item);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

end.