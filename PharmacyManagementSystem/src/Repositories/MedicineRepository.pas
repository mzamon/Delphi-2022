unit MedicineRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, Medicine, Category;

type
  TMedicineRepository = class(TRepositoryBase)
  public
    function GetMedicineByID(AMedicineID: Integer): TMedicine;
    function GetMedicineByBarcode(const ABarcode: string): TMedicine;
    function GetAllMedicines: TObjectList<TMedicine>;
    function GetMedicinesByCategory(ACategoryID: Integer): TObjectList<TMedicine>;
    function InsertMedicine(AMedicine: TMedicine): Integer;
    procedure UpdateMedicine(AMedicine: TMedicine);
    procedure DeleteMedicine(AMedicineID: Integer);

    // Categories
    function GetCategoryByID(ACategoryID: Integer): TCategory;
    function GetAllCategories: TObjectList<TCategory>;
    function InsertCategory(ACategory: TCategory): Integer;
    procedure UpdateCategory(ACategory: TCategory);
    procedure DeleteCategory(ACategoryID: Integer);
  end;

implementation

{ TMedicineRepository }

function TMedicineRepository.GetMedicineByID(AMedicineID: Integer): TMedicine;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MedicineID, CategoryID, MedicineName, GenericName, ' +
                  'Manufacturer, Barcode, UnitPrice, ReorderLevel ' +
                  'FROM Medicines WHERE MedicineID = :MedicineID';
    Q.ParamByName('MedicineID').AsInteger := AMedicineID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TMedicine.Create;
      Result.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Result.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Result.MedicineName := Q.FieldByName('MedicineName').AsString;
      Result.GenericName := Q.FieldByName('GenericName').AsString;
      Result.Manufacturer := Q.FieldByName('Manufacturer').AsString;
      Result.Barcode := Q.FieldByName('Barcode').AsString;
      Result.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.GetMedicineByBarcode(const ABarcode: string): TMedicine;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MedicineID, CategoryID, MedicineName, GenericName, ' +
                  'Manufacturer, Barcode, UnitPrice, ReorderLevel ' +
                  'FROM Medicines WHERE Barcode = :Barcode';
    Q.ParamByName('Barcode').AsString := ABarcode;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TMedicine.Create;
      Result.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Result.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Result.MedicineName := Q.FieldByName('MedicineName').AsString;
      Result.GenericName := Q.FieldByName('GenericName').AsString;
      Result.Manufacturer := Q.FieldByName('Manufacturer').AsString;
      Result.Barcode := Q.FieldByName('Barcode').AsString;
      Result.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Result.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.GetAllMedicines: TObjectList<TMedicine>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TMedicine>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MedicineID, CategoryID, MedicineName, GenericName, ' +
                  'Manufacturer, Barcode, UnitPrice, ReorderLevel ' +
                  'FROM Medicines ORDER BY MedicineName';
    Q.Open;
    while not Q.Eof do
    begin
      var Med := TMedicine.Create;
      Med.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Med.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Med.MedicineName := Q.FieldByName('MedicineName').AsString;
      Med.GenericName := Q.FieldByName('GenericName').AsString;
      Med.Manufacturer := Q.FieldByName('Manufacturer').AsString;
      Med.Barcode := Q.FieldByName('Barcode').AsString;
      Med.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Med.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Result.Add(Med);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.GetMedicinesByCategory(ACategoryID: Integer): TObjectList<TMedicine>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TMedicine>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT MedicineID, CategoryID, MedicineName, GenericName, ' +
                  'Manufacturer, Barcode, UnitPrice, ReorderLevel ' +
                  'FROM Medicines WHERE CategoryID = :CategoryID ORDER BY MedicineName';
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.Open;
    while not Q.Eof do
    begin
      var Med := TMedicine.Create;
      Med.MedicineID := Q.FieldByName('MedicineID').AsInteger;
      Med.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Med.MedicineName := Q.FieldByName('MedicineName').AsString;
      Med.GenericName := Q.FieldByName('GenericName').AsString;
      Med.Manufacturer := Q.FieldByName('Manufacturer').AsString;
      Med.Barcode := Q.FieldByName('Barcode').AsString;
      Med.UnitPrice := Q.FieldByName('UnitPrice').AsFloat;
      Med.ReorderLevel := Q.FieldByName('ReorderLevel').AsFloat;
      Result.Add(Med);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.InsertMedicine(AMedicine: TMedicine): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AMedicine.Validate then
    raise Exception.Create('Medicine data invalid.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Medicines (CategoryID, MedicineName, GenericName, Manufacturer, ' +
                  'Barcode, UnitPrice, ReorderLevel) VALUES (:CategoryID, :MedicineName, :GenericName, ' +
                  ':Manufacturer, :Barcode, :UnitPrice, :ReorderLevel); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('CategoryID').AsInteger := AMedicine.CategoryID;
    Q.ParamByName('MedicineName').AsString := AMedicine.MedicineName;
    Q.ParamByName('GenericName').AsString := AMedicine.GenericName;
    Q.ParamByName('Manufacturer').AsString := AMedicine.Manufacturer;
    Q.ParamByName('Barcode').AsString := AMedicine.Barcode;
    Q.ParamByName('UnitPrice').AsFloat := AMedicine.UnitPrice;
    Q.ParamByName('ReorderLevel').AsFloat := AMedicine.ReorderLevel;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TMedicineRepository.UpdateMedicine(AMedicine: TMedicine);
var
  Q: TFDQuery;
begin
  if not AMedicine.Validate then
    raise Exception.Create('Medicine data invalid.');
  if AMedicine.MedicineID <= 0 then
    raise Exception.Create('MedicineID must be set.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Medicines SET CategoryID = :CategoryID, MedicineName = :MedicineName, ' +
                  'GenericName = :GenericName, Manufacturer = :Manufacturer, Barcode = :Barcode, ' +
                  'UnitPrice = :UnitPrice, ReorderLevel = :ReorderLevel WHERE MedicineID = :MedicineID';
    Q.ParamByName('MedicineID').AsInteger := AMedicine.MedicineID;
    Q.ParamByName('CategoryID').AsInteger := AMedicine.CategoryID;
    Q.ParamByName('MedicineName').AsString := AMedicine.MedicineName;
    Q.ParamByName('GenericName').AsString := AMedicine.GenericName;
    Q.ParamByName('Manufacturer').AsString := AMedicine.Manufacturer;
    Q.ParamByName('Barcode').AsString := AMedicine.Barcode;
    Q.ParamByName('UnitPrice').AsFloat := AMedicine.UnitPrice;
    Q.ParamByName('ReorderLevel').AsFloat := AMedicine.ReorderLevel;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TMedicineRepository.DeleteMedicine(AMedicineID: Integer);
var
  Q: TFDQuery;
begin
  if AMedicineID <= 0 then
    raise Exception.Create('Invalid MedicineID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Medicines WHERE MedicineID = :MedicineID';
    Q.ParamByName('MedicineID').AsInteger := AMedicineID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

// ---- Categories ----

function TMedicineRepository.GetCategoryByID(ACategoryID: Integer): TCategory;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT CategoryID, CategoryName FROM Categories WHERE CategoryID = :CategoryID';
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TCategory.Create;
      Result.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Result.CategoryName := Q.FieldByName('CategoryName').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.GetAllCategories: TObjectList<TCategory>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TCategory>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName';
    Q.Open;
    while not Q.Eof do
    begin
      var Cat := TCategory.Create;
      Cat.CategoryID := Q.FieldByName('CategoryID').AsInteger;
      Cat.CategoryName := Q.FieldByName('CategoryName').AsString;
      Result.Add(Cat);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TMedicineRepository.InsertCategory(ACategory: TCategory): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if ACategory.CategoryName.Trim = '' then
    raise Exception.Create('Category name cannot be empty.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Categories (CategoryName) VALUES (:CategoryName); SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('CategoryName').AsString := ACategory.CategoryName;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TMedicineRepository.UpdateCategory(ACategory: TCategory);
var
  Q: TFDQuery;
begin
  if ACategory.CategoryID <= 0 then
    raise Exception.Create('CategoryID must be set.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Categories SET CategoryName = :CategoryName WHERE CategoryID = :CategoryID';
    Q.ParamByName('CategoryID').AsInteger := ACategory.CategoryID;
    Q.ParamByName('CategoryName').AsString := ACategory.CategoryName;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TMedicineRepository.DeleteCategory(ACategoryID: Integer);
var
  Q: TFDQuery;
begin
  if ACategoryID <= 0 then
    raise Exception.Create('Invalid CategoryID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Categories WHERE CategoryID = :CategoryID';
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.