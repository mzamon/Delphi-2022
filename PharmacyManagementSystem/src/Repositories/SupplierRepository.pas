unit SupplierRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, Supplier;

type
  TSupplierRepository = class(TRepositoryBase)
  public
    function GetSupplierByID(ASupplierID: Integer): TSupplier;
    function GetAllSuppliers: TObjectList<TSupplier>;
    function InsertSupplier(ASupplier: TSupplier): Integer;
    procedure UpdateSupplier(ASupplier: TSupplier);
    procedure DeleteSupplier(ASupplierID: Integer);
  end;

implementation

{ TSupplierRepository }

function TSupplierRepository.GetSupplierByID(ASupplierID: Integer): TSupplier;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT SupplierID, SupplierName, ContactPerson, Phone, Email, Address ' +
                  'FROM Suppliers WHERE SupplierID = :SupplierID';
    Q.ParamByName('SupplierID').AsInteger := ASupplierID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TSupplier.Create;
      Result.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Result.SupplierName := Q.FieldByName('SupplierName').AsString;
      Result.ContactPerson := Q.FieldByName('ContactPerson').AsString;
      Result.Phone := Q.FieldByName('Phone').AsString;
      Result.Email := Q.FieldByName('Email').AsString;
      Result.Address := Q.FieldByName('Address').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TSupplierRepository.GetAllSuppliers: TObjectList<TSupplier>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TSupplier>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT SupplierID, SupplierName, ContactPerson, Phone, Email, Address ' +
                  'FROM Suppliers ORDER BY SupplierName';
    Q.Open;
    while not Q.Eof do
    begin
      var Sup := TSupplier.Create;
      Sup.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Sup.SupplierName := Q.FieldByName('SupplierName').AsString;
      Sup.ContactPerson := Q.FieldByName('ContactPerson').AsString;
      Sup.Phone := Q.FieldByName('Phone').AsString;
      Sup.Email := Q.FieldByName('Email').AsString;
      Sup.Address := Q.FieldByName('Address').AsString;
      Result.Add(Sup);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TSupplierRepository.InsertSupplier(ASupplier: TSupplier): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not ASupplier.Validate then
    raise Exception.Create('Supplier data invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Suppliers (SupplierName, ContactPerson, Phone, Email, Address) ' +
                  'VALUES (:SupplierName, :ContactPerson, :Phone, :Email, :Address); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('SupplierName').AsString := ASupplier.SupplierName;
    Q.ParamByName('ContactPerson').AsString := ASupplier.ContactPerson;
    Q.ParamByName('Phone').AsString := ASupplier.Phone;
    Q.ParamByName('Email').AsString := ASupplier.Email;
    Q.ParamByName('Address').AsString := ASupplier.Address;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TSupplierRepository.UpdateSupplier(ASupplier: TSupplier);
var
  Q: TFDQuery;
begin
  if not ASupplier.Validate then
    raise Exception.Create('Supplier data invalid.');
  if ASupplier.SupplierID <= 0 then
    raise Exception.Create('SupplierID must be set.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Suppliers SET SupplierName = :SupplierName, ContactPerson = :ContactPerson, ' +
                  'Phone = :Phone, Email = :Email, Address = :Address WHERE SupplierID = :SupplierID';
    Q.ParamByName('SupplierID').AsInteger := ASupplier.SupplierID;
    Q.ParamByName('SupplierName').AsString := ASupplier.SupplierName;
    Q.ParamByName('ContactPerson').AsString := ASupplier.ContactPerson;
    Q.ParamByName('Phone').AsString := ASupplier.Phone;
    Q.ParamByName('Email').AsString := ASupplier.Email;
    Q.ParamByName('Address').AsString := ASupplier.Address;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TSupplierRepository.DeleteSupplier(ASupplierID: Integer);
var
  Q: TFDQuery;
begin
  if ASupplierID <= 0 then
    raise Exception.Create('Invalid SupplierID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Suppliers WHERE SupplierID = :SupplierID';
    Q.ParamByName('SupplierID').AsInteger := ASupplierID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.