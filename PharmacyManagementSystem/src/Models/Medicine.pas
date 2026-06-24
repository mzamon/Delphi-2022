unit Medicine;

interface

uses
  System.SysUtils;

type
  TMedicine = class
  private
    FMedicineID: Integer;
    FCategoryID: Integer;
    FMedicineName: string;
    FGenericName: string;
    FManufacturer: string;
    FBarcode: string;
    FUnitPrice: Double;
    FReorderLevel: Double;
  public
    constructor Create; overload;
    constructor Create(AMedicineID, ACategoryID: Integer; const AMedicineName, AGenericName,
      AManufacturer, ABarcode: string; AUnitPrice, AReorderLevel: Double); overload;

    function Validate: Boolean;

    property MedicineID: Integer read FMedicineID write FMedicineID;
    property CategoryID: Integer read FCategoryID write FCategoryID;
    property MedicineName: string read FMedicineName write FMedicineName;
    property GenericName: string read FGenericName write FGenericName;
    property Manufacturer: string read FManufacturer write FManufacturer;
    property Barcode: string read FBarcode write FBarcode;
    property UnitPrice: Double read FUnitPrice write FUnitPrice;
    property ReorderLevel: Double read FReorderLevel write FReorderLevel;
  end;

implementation

{ TMedicine }

constructor TMedicine.Create;
begin
  FMedicineID := 0;
end;

constructor TMedicine.Create(AMedicineID, ACategoryID: Integer; const AMedicineName,
  AGenericName, AManufacturer, ABarcode: string; AUnitPrice, AReorderLevel: Double);
begin
  FMedicineID := AMedicineID;
  FCategoryID := ACategoryID;
  FMedicineName := AMedicineName;
  FGenericName := AGenericName;
  FManufacturer := AManufacturer;
  FBarcode := ABarcode;
  FUnitPrice := AUnitPrice;
  FReorderLevel := AReorderLevel;
end;

function TMedicine.Validate: Boolean;
begin
  Result := (FCategoryID > 0) and (FMedicineName.Trim <> '') and
            (FUnitPrice >= 0) and (FReorderLevel >= 0);
end;

end.