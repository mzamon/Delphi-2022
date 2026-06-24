unit DispenseRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, DispenseTransaction;

type
  TDispenseRepository = class(TRepositoryBase)
  public
    function GetDispenseByID(ATransactionID: Integer): TDispenseTransaction;
    function GetDispensesByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
    function GetDispensesByMedicine(AMedicineID: Integer): TObjectList<TDispenseTransaction>;
    function InsertDispense(ADispense: TDispenseTransaction): Integer;
    procedure DeleteDispense(ATransactionID: Integer);
  end;

implementation

{ TDispenseRepository }

function TDispenseRepository.GetDispenseByID(ATransactionID: Integer): TDispenseTransaction;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT TransactionID, MedicineID, InventoryID, QuantityDispensed, ' +
                  'DispenseDate, ProcessedBy FROM DispenseTransactions WHERE TransactionID = :TransactionID';
    Q.ParamByName('TransactionID').AsInteger := ATransactionID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TDispenseTransaction.Create;
      Result.TransactionID := Q.FieldByName('TransactionID').AsInteger;
      Result.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Result.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      Result.QuantityDispensed := Q.FieldByName('QuantityDispensed').AsFloat;
      Result.DispenseDate := Q.FieldByName('DispenseDate').AsDateTime;
      Result.ProcessedBy := Q.FieldByName('ProcessedBy').AsInteger;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TDispenseRepository.GetDispensesByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TDispenseTransaction>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT TransactionID, MedicineID, InventoryID, QuantityDispensed, ' +
                  'DispenseDate, ProcessedBy FROM DispenseTransactions ' +
                  'WHERE DispenseDate BETWEEN :StartDate AND :EndDate ORDER BY DispenseDate DESC';
    Q.ParamByName('StartDate').AsDateTime := AStartDate;
    Q.ParamByName('EndDate').AsDateTime := AEndDate;
    Q.Open;
    while not Q.Eof do
    begin
      var D := TDispenseTransaction.Create;
      D.TransactionID := Q.FieldByName('TransactionID').AsInteger;
      D.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      D.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      D.QuantityDispensed := Q.FieldByName('QuantityDispensed').AsFloat;
      D.DispenseDate := Q.FieldByName('DispenseDate').AsDateTime;
      D.ProcessedBy := Q.FieldByName('ProcessedBy').AsInteger;
      Result.Add(D);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TDispenseRepository.GetDispensesByMedicine(AMedicineID: Integer): TObjectList<TDispenseTransaction>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TDispenseTransaction>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT TransactionID, MedicineID, InventoryID, QuantityDispensed, ' +
                  'DispenseDate, ProcessedBy FROM DispenseTransactions ' +
                  'WHERE MedicineID = :MedicineID ORDER BY DispenseDate DESC';
    Q.ParamByName('MedicineID').AsInteger := AMedicineID;
    Q.Open;
    while not Q.Eof do
    begin
      var D := TDispenseTransaction.Create;
      D.TransactionID := Q.FieldByName('TransactionID').AsInteger;
      D.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      D.InventoryID := Q.FieldByName('InventoryID').AsInteger;
      D.QuantityDispensed := Q.FieldByName('QuantityDispensed').AsFloat;
      D.DispenseDate := Q.FieldByName('DispenseDate').AsDateTime;
      D.ProcessedBy := Q.FieldByName('ProcessedBy').AsInteger;
      Result.Add(D);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TDispenseRepository.InsertDispense(ADispense: TDispenseTransaction): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not ADispense.Validate then
    raise Exception.Create('Dispense transaction invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO DispenseTransactions (MedicineID, InventoryID, QuantityDispensed, ' +
                  'DispenseDate, ProcessedBy) VALUES (:MedicineID, :InventoryID, :QuantityDispensed, ' +
                  ':DispenseDate, :ProcessedBy); SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('MedicineID').AsInteger := ADispense.MedicineID;
    Q.ParamByName('InventoryID').AsInteger := ADispense.InventoryID;
    Q.ParamByName('QuantityDispensed').AsFloat := ADispense.QuantityDispensed;
    Q.ParamByName('DispenseDate').AsDateTime := ADispense.DispenseDate;
    Q.ParamByName('ProcessedBy').AsInteger := ADispense.ProcessedBy;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TDispenseRepository.DeleteDispense(ATransactionID: Integer);
var
  Q: TFDQuery;
begin
  if ATransactionID <= 0 then
    raise Exception.Create('Invalid TransactionID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM DispenseTransactions WHERE TransactionID = :TransactionID';
    Q.ParamByName('TransactionID').AsInteger := ATransactionID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.