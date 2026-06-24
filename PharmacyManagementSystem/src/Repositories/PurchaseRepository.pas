unit PurchaseRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, Purchase, PurchaseItem;

type
  TPurchaseRepository = class(TRepositoryBase)
  public
    function GetPurchaseByID(APurchaseID: Integer): TPurchase;
    function GetAllPurchases: TObjectList<TPurchase>;
    function InsertPurchase(APurchase: TPurchase): Integer; // returns PurchaseID
    procedure UpdatePurchase(APurchase: TPurchase);
    procedure DeletePurchase(APurchaseID: Integer);

    // Purchase Items
    procedure InsertPurchaseItem(AItem: TPurchaseItem);
    procedure DeletePurchaseItems(APurchaseID: Integer);
    function GetPurchaseItems(APurchaseID: Integer): TObjectList<TPurchaseItem>;
  end;

implementation

{ TPurchaseRepository }

function TPurchaseRepository.GetPurchaseByID(APurchaseID: Integer): TPurchase;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT PurchaseID, SupplierID, PurchaseDate, TotalAmount, CreatedBy ' +
                  'FROM Purchases WHERE PurchaseID = :PurchaseID';
    Q.ParamByName('PurchaseID').AsInteger := APurchaseID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TPurchase.Create;
      Result.PurchaseID := Q.FieldByName('PurchaseID').AsInteger;
      Result.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Result.PurchaseDate := Q.FieldByName('PurchaseDate').AsDateTime;
      Result.TotalAmount := Q.FieldByName('TotalAmount').AsFloat;
      Result.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      // Load items
      Result.Items.AddRange(GetPurchaseItems(APurchaseID));
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseRepository.GetAllPurchases: TObjectList<TPurchase>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchase>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT PurchaseID, SupplierID, PurchaseDate, TotalAmount, CreatedBy ' +
                  'FROM Purchases ORDER BY PurchaseDate DESC';
    Q.Open;
    while not Q.Eof do
    begin
      var P := TPurchase.Create;
      P.PurchaseID := Q.FieldByName('PurchaseID').AsInteger;
      P.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      P.PurchaseDate := Q.FieldByName('PurchaseDate').AsDateTime;
      P.TotalAmount := Q.FieldByName('TotalAmount').AsFloat;
      P.CreatedBy := Q.FieldByName('CreatedBy').AsInteger;
      Result.Add(P);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPurchaseRepository.InsertPurchase(APurchase: TPurchase): Integer;
var
  Q: TFDQuery;
  I: Integer;
begin
  Result := 0;
  if not APurchase.Validate then
    raise Exception.Create('Purchase data invalid.');

  BeginTransaction;
  try
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := Connection;
      // Insert header
      Q.SQL.Text := 'INSERT INTO Purchases (SupplierID, PurchaseDate, TotalAmount, CreatedBy) ' +
                    'VALUES (:SupplierID, :PurchaseDate, :TotalAmount, :CreatedBy); ' +
                    'SELECT SCOPE_IDENTITY() AS NewID';
      Q.ParamByName('SupplierID').AsInteger := APurchase.SupplierID;
      Q.ParamByName('PurchaseDate').AsDateTime := APurchase.PurchaseDate;
      Q.ParamByName('TotalAmount').AsFloat := APurchase.TotalAmount; // compute later if needed
      Q.ParamByName('CreatedBy').AsInteger := APurchase.CreatedBy;
      Q.Open;
      if Q.IsEmpty then
        raise Exception.Create('Failed to insert purchase header.');
      Result := Q.FieldByName('NewID').AsInteger;
      Q.Close;

      // Insert items
      for I := 0 to APurchase.Items.Count - 1 do
      begin
        var Item := APurchase.Items[I];
        Item.PurchaseID := Result;
        InsertPurchaseItem(Item);
      end;

      // Update total amount if not set
      if APurchase.TotalAmount = 0 then
      begin
        APurchase.TotalAmount := APurchase.GetTotalAmount;
        Q.SQL.Text := 'UPDATE Purchases SET TotalAmount = :TotalAmount WHERE PurchaseID = :PurchaseID';
        Q.ParamByName('TotalAmount').AsFloat := APurchase.TotalAmount;
        Q.ParamByName('PurchaseID').AsInteger := Result;
        Q.ExecSQL;
      end;

      CommitTransaction;
    except
      RollbackTransaction;
      raise;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseRepository.UpdatePurchase(APurchase: TPurchase);
var
  Q: TFDQuery;
begin
  if APurchase.PurchaseID <= 0 then
    raise Exception.Create('PurchaseID must be set.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Purchases SET SupplierID = :SupplierID, PurchaseDate = :PurchaseDate, ' +
                  'TotalAmount = :TotalAmount, CreatedBy = :CreatedBy WHERE PurchaseID = :PurchaseID';
    Q.ParamByName('PurchaseID').AsInteger := APurchase.PurchaseID;
    Q.ParamByName('SupplierID').AsInteger := APurchase.SupplierID;
    Q.ParamByName('PurchaseDate').AsDateTime := APurchase.PurchaseDate;
    Q.ParamByName('TotalAmount').AsFloat := APurchase.TotalAmount;
    Q.ParamByName('CreatedBy').AsInteger := APurchase.CreatedBy;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseRepository.DeletePurchase(APurchaseID: Integer);
var
  Q: TFDQuery;
begin
  if APurchaseID <= 0 then
    raise Exception.Create('Invalid PurchaseID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Purchases WHERE PurchaseID = :PurchaseID';
    Q.ParamByName('PurchaseID').AsInteger := APurchaseID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

// ---- Purchase Items ----

procedure TPurchaseRepository.InsertPurchaseItem(AItem: TPurchaseItem);
var
  Q: TFDQuery;
begin
  if not AItem.Validate then
    raise Exception.Create('Purchase item invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO PurchaseItems (PurchaseID, MedicineID, Quantity, UnitCost) ' +
                  'VALUES (:PurchaseID, :MedicineID, :Quantity, :UnitCost)';
    Q.ParamByName('PurchaseID').AsInteger := AItem.PurchaseID;
    Q.ParamByName('MedicineID').AsInteger := AItem.MedicineID;
    Q.ParamByName('Quantity').AsFloat := AItem.Quantity;
    Q.ParamByName('UnitCost').AsFloat := AItem.UnitCost;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TPurchaseRepository.DeletePurchaseItems(APurchaseID: Integer);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM PurchaseItems WHERE PurchaseID = :PurchaseID';
    Q.ParamByName('PurchaseID').AsInteger := APurchaseID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TPurchaseRepository.GetPurchaseItems(APurchaseID: Integer): TObjectList<TPurchaseItem>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TPurchaseItem>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT PurchaseItemID, PurchaseID, MedicineID, Quantity, UnitCost ' +
                  'FROM PurchaseItems WHERE PurchaseID = :PurchaseID';
    Q.ParamByName('PurchaseID').AsInteger := APurchaseID;
    Q.Open;
    while not Q.Eof do
    begin
      var Item := TPurchaseItem.Create;
      Item.PurchaseItemID := Q.FieldByName('PurchaseItemID').AsInteger;
      Item.PurchaseID := Q.FieldByName('PurchaseID').AsInteger;
      Item.MedicineID := Q.FieldByName('MedicineID').AsInteger;
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