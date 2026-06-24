unit SupplierRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
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
    Q.SQL.Text := 'SELECT SupplierID, CompanyName, ContactPerson, Phone, Email FROM Suppliers WHERE SupplierID = :SupplierID';
    Q.ParamByName('SupplierID').AsInteger := ASupplierID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TSupplier.Create;
      Result.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Result.CompanyName := Q.FieldByName('CompanyName').AsString;
      Result.ContactPerson := Q.FieldByName('ContactPerson').AsString;
      Result.Phone := Q.FieldByName('Phone').AsString;
      Result.Email := Q.FieldByName('Email').AsString;
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
    Q.SQL.Text := 'SELECT SupplierID, CompanyName, ContactPerson, Phone, Email FROM Suppliers ORDER BY CompanyName';
    Q.Open;
    while not Q.Eof do
    begin
      var Sup := TSupplier.Create;
      Sup.SupplierID := Q.FieldByName('SupplierID').AsInteger;
      Sup.CompanyName := Q.FieldByName('CompanyName').AsString;
      Sup.ContactPerson := Q.FieldByName('ContactPerson').AsString;
      Sup.Phone := Q.FieldByName('Phone').AsString;
      Sup.Email := Q.FieldByName('Email').AsString;
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
    raise Exception.Create('Supplier data is invalid.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Suppliers (CompanyName, ContactPerson, Phone, Email) ' +
                  'VALUES (:CompanyName, :ContactPerson, :Phone, :Email); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('CompanyName').AsString := ASupplier.CompanyName;
    Q.ParamByName('ContactPerson').AsString := ASupplier.ContactPerson;
    Q.ParamByName('Phone').AsString := ASupplier.Phone;
    Q.ParamByName('Email').AsString := ASupplier.Email;
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
    raise Exception.Create('Supplier data is invalid.');
  if ASupplier.SupplierID <= 0 then
    raise Exception.Create('Supplier ID must be set for update.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Suppliers SET CompanyName = :CompanyName, ContactPerson = :ContactPerson, ' +
                  'Phone = :Phone, Email = :Email WHERE SupplierID = :SupplierID';
    Q.ParamByName('SupplierID').AsInteger := ASupplier.SupplierID;
    Q.ParamByName('CompanyName').AsString := ASupplier.CompanyName;
    Q.ParamByName('ContactPerson').AsString := ASupplier.ContactPerson;
    Q.ParamByName('Phone').AsString := ASupplier.Phone;
    Q.ParamByName('Email').AsString := ASupplier.Email;
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
    raise Exception.Create('Invalid Supplier ID.');

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