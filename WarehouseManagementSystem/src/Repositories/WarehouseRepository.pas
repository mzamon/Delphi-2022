unit WarehouseRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  RepositoryBase, Warehouse;

type
  TWarehouseRepository = class(TRepositoryBase)
  public
    function GetWarehouseByID(AWarehouseID: Integer): TWarehouse;
    function GetAllWarehouses: TObjectList<TWarehouse>;
    function InsertWarehouse(AWarehouse: TWarehouse): Integer;
    procedure UpdateWarehouse(AWarehouse: TWarehouse);
    procedure DeleteWarehouse(AWarehouseID: Integer);
  end;

implementation

{ TWarehouseRepository }

function TWarehouseRepository.GetWarehouseByID(AWarehouseID: Integer): TWarehouse;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT WarehouseID, WarehouseName, Location FROM Warehouses WHERE WarehouseID = :WarehouseID';
    Q.ParamByName('WarehouseID').AsInteger := AWarehouseID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TWarehouse.Create;
      Result.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      Result.WarehouseName := Q.FieldByName('WarehouseName').AsString;
      Result.Location := Q.FieldByName('Location').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TWarehouseRepository.GetAllWarehouses: TObjectList<TWarehouse>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TWarehouse>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT WarehouseID, WarehouseName, Location FROM Warehouses ORDER BY WarehouseName';
    Q.Open;
    while not Q.Eof do
    begin
      var WH := TWarehouse.Create;
      WH.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      WH.WarehouseName := Q.FieldByName('WarehouseName').AsString;
      WH.Location := Q.FieldByName('Location').AsString;
      Result.Add(WH);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TWarehouseRepository.InsertWarehouse(AWarehouse: TWarehouse): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AWarehouse.Validate then
    raise Exception.Create('Warehouse data is invalid.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Warehouses (WarehouseName, Location) VALUES (:WarehouseName, :Location); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('WarehouseName').AsString := AWarehouse.WarehouseName;
    Q.ParamByName('Location').AsString := AWarehouse.Location;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TWarehouseRepository.UpdateWarehouse(AWarehouse: TWarehouse);
var
  Q: TFDQuery;
begin
  if not AWarehouse.Validate then
    raise Exception.Create('Warehouse data is invalid.');
  if AWarehouse.WarehouseID <= 0 then
    raise Exception.Create('Warehouse ID must be set for update.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Warehouses SET WarehouseName = :WarehouseName, Location = :Location WHERE WarehouseID = :WarehouseID';
    Q.ParamByName('WarehouseID').AsInteger := AWarehouse.WarehouseID;
    Q.ParamByName('WarehouseName').AsString := AWarehouse.WarehouseName;
    Q.ParamByName('Location').AsString := AWarehouse.Location;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TWarehouseRepository.DeleteWarehouse(AWarehouseID: Integer);
var
  Q: TFDQuery;
begin
  if AWarehouseID <= 0 then
    raise Exception.Create('Invalid Warehouse ID.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Warehouses WHERE WarehouseID = :WarehouseID';
    Q.ParamByName('WarehouseID').AsInteger := AWarehouseID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.