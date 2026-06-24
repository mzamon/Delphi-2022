unit StockMovementRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  RepositoryBase, StockMovement;

type
  TStockMovementRepository = class(TRepositoryBase)
  public
    function GetMovementByID(AMovementID: Integer): TStockMovement;
    function GetMovementsByItem(AItemID: Integer): TObjectList<TStockMovement>;
    function GetMovementsByWarehouse(AWarehouseID: Integer): TObjectList<TStockMovement>;
    function GetMovementsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TStockMovement>;
    function InsertMovement(AMovement: TStockMovement): Integer; // returns new MovementID
    procedure DeleteMovement(AMovementID: Integer);
  end;

implementation

{ TStockMovementRepository }

function TStockMovementRepository.GetMovementByID(AMovementID: Integer): TStockMovement;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MovementID, ItemID, WarehouseID, MovementType, Quantity, ' +
                  'MovementDate, UserID, Reference FROM StockMovements WHERE MovementID = :MovementID';
    Q.ParamByName('MovementID').AsInteger := AMovementID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TStockMovement.Create;
      Result.MovementID := Q.FieldByName('MovementID').AsInteger;
      Result.ItemID := Q.FieldByName('ItemID').AsInteger;
      Result.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      var MovType := Q.FieldByName('MovementType').AsString;
      if MovType = 'IN' then Result.MovementType := smtIn
      else if MovType = 'OUT' then Result.MovementType := smtOut
      else Result.MovementType := smtAdjust;
      Result.Quantity := Q.FieldByName('Quantity').AsFloat;
      Result.MovementDate := Q.FieldByName('MovementDate').AsDateTime;
      Result.UserID := Q.FieldByName('UserID').AsInteger;
      Result.Reference := Q.FieldByName('Reference').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TStockMovementRepository.GetMovementsByItem(AItemID: Integer): TObjectList<TStockMovement>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TStockMovement>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MovementID, ItemID, WarehouseID, MovementType, Quantity, ' +
                  'MovementDate, UserID, Reference FROM StockMovements WHERE ItemID = :ItemID ORDER BY MovementDate DESC';
    Q.ParamByName('ItemID').AsInteger := AItemID;
    Q.Open;
    while not Q.Eof do
    begin
      var Mov := TStockMovement.Create;
      Mov.MovementID := Q.FieldByName('MovementID').AsInteger;
      Mov.ItemID := Q.FieldByName('ItemID').AsInteger;
      Mov.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      var MovType := Q.FieldByName('MovementType').AsString;
      if MovType = 'IN' then Mov.MovementType := smtIn
      else if MovType = 'OUT' then Mov.MovementType := smtOut
      else Mov.MovementType := smtAdjust;
      Mov.Quantity := Q.FieldByName('Quantity').AsFloat;
      Mov.MovementDate := Q.FieldByName('MovementDate').AsDateTime;
      Mov.UserID := Q.FieldByName('UserID').AsInteger;
      Mov.Reference := Q.FieldByName('Reference').AsString;
      Result.Add(Mov);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TStockMovementRepository.GetMovementsByWarehouse(AWarehouseID: Integer): TObjectList<TStockMovement>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TStockMovement>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MovementID, ItemID, WarehouseID, MovementType, Quantity, ' +
                  'MovementDate, UserID, Reference FROM StockMovements WHERE WarehouseID = :WarehouseID ORDER BY MovementDate DESC';
    Q.ParamByName('WarehouseID').AsInteger := AWarehouseID;
    Q.Open;
    while not Q.Eof do
    begin
      var Mov := TStockMovement.Create;
      Mov.MovementID := Q.FieldByName('MovementID').AsInteger;
      Mov.ItemID := Q.FieldByName('ItemID').AsInteger;
      Mov.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      var MovType := Q.FieldByName('MovementType').AsString;
      if MovType = 'IN' then Mov.MovementType := smtIn
      else if MovType = 'OUT' then Mov.MovementType := smtOut
      else Mov.MovementType := smtAdjust;
      Mov.Quantity := Q.FieldByName('Quantity').AsFloat;
      Mov.MovementDate := Q.FieldByName('MovementDate').AsDateTime;
      Mov.UserID := Q.FieldByName('UserID').AsInteger;
      Mov.Reference := Q.FieldByName('Reference').AsString;
      Result.Add(Mov);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TStockMovementRepository.GetMovementsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TStockMovement>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TStockMovement>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MovementID, ItemID, WarehouseID, MovementType, Quantity, ' +
                  'MovementDate, UserID, Reference FROM StockMovements ' +
                  'WHERE MovementDate BETWEEN :StartDate AND :EndDate ORDER BY MovementDate DESC';
    Q.ParamByName('StartDate').AsDateTime := AStartDate;
    Q.ParamByName('EndDate').AsDateTime := AEndDate;
    Q.Open;
    while not Q.Eof do
    begin
      var Mov := TStockMovement.Create;
      Mov.MovementID := Q.FieldByName('MovementID').AsInteger;
      Mov.ItemID := Q.FieldByName('ItemID').AsInteger;
      Mov.WarehouseID := Q.FieldByName('WarehouseID').AsInteger;
      var MovType := Q.FieldByName('MovementType').AsString;
      if MovType = 'IN' then Mov.MovementType := smtIn
      else if MovType = 'OUT' then Mov.MovementType := smtOut
      else Mov.MovementType := smtAdjust;
      Mov.Quantity := Q.FieldByName('Quantity').AsFloat;
      Mov.MovementDate := Q.FieldByName('MovementDate').AsDateTime;
      Mov.UserID := Q.FieldByName('UserID').AsInteger;
      Mov.Reference := Q.FieldByName('Reference').AsString;
      Result.Add(Mov);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TStockMovementRepository.InsertMovement(AMovement: TStockMovement): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AMovement.Validate then
    raise Exception.Create('Stock movement data is invalid.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO StockMovements (ItemID, WarehouseID, MovementType, Quantity, ' +
                  'MovementDate, UserID, Reference) VALUES ' +
                  '(:ItemID, :WarehouseID, :MovementType, :Quantity, :MovementDate, :UserID, :Reference); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('ItemID').AsInteger := AMovement.ItemID;
    Q.ParamByName('WarehouseID').AsInteger := AMovement.WarehouseID;
    var MovType: string;
    case AMovement.MovementType of
      smtIn: MovType := 'IN';
      smtOut: MovType := 'OUT';
      smtAdjust: MovType := 'ADJUST';
    end;
    Q.ParamByName('MovementType').AsString := MovType;
    Q.ParamByName('Quantity').AsFloat := AMovement.Quantity;
    Q.ParamByName('MovementDate').AsDateTime := AMovement.MovementDate;
    Q.ParamByName('UserID').AsInteger := AMovement.UserID;
    Q.ParamByName('Reference').AsString := AMovement.Reference;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TStockMovementRepository.DeleteMovement(AMovementID: Integer);
var
  Q: TFDQuery;
begin
  if AMovementID <= 0 then
    raise Exception.Create('Invalid Movement ID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM StockMovements WHERE MovementID = :MovementID';
    Q.ParamByName('MovementID').AsInteger := AMovementID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.