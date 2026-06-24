unit InventoryItem;

interface

uses
  System.SysUtils;

type
  TInventoryItem = class
  private
    FInventoryID: Integer;
    FMedicineID: Integer;
    FSupplierID: Integer;
    FBatchNumber: string;
    FQuantityInStock: Double;
    FManufacturingDate: TDateTime;
    FExpiryDate: TDateTime;
  public
    constructor Create; overload;
    constructor Create(AInventoryID, AMedicineID, ASupplierID: Integer;
      const ABatchNumber: string; AQuantityInStock: Double;
      AManufacturingDate, AExpiryDate: TDateTime); overload;

    function Validate: Boolean;
    function IsExpired: Boolean;
    function DaysUntilExpiry: Integer;

    property InventoryID: Integer read FInventoryID write FInventoryID;
    property MedicineID: Integer read FMedicineID write FMedicineID;
    property SupplierID: Integer read FSupplierID write FSupplierID;
    property BatchNumber: string read FBatchNumber write FBatchNumber;
    property QuantityInStock: Double read FQuantityInStock write FQuantityInStock;
    property ManufacturingDate: TDateTime read FManufacturingDate write FManufacturingDate;
    property ExpiryDate: TDateTime read FExpiryDate write FExpiryDate;
  end;

implementation

{ TInventoryItem }

constructor TInventoryItem.Create;
begin
  FInventoryID := 0;
end;

constructor TInventoryItem.Create(AInventoryID, AMedicineID, ASupplierID: Integer;
  const ABatchNumber: string; AQuantityInStock: Double;
  AManufacturingDate, AExpiryDate: TDateTime);
begin
  FInventoryID := AInventoryID;
  FMedicineID := AMedicineID;
  FSupplierID := ASupplierID;
  FBatchNumber := ABatchNumber;
  FQuantityInStock := AQuantityInStock;
  FManufacturingDate := AManufacturingDate;
  FExpiryDate := AExpiryDate;
end;

function TInventoryItem.Validate: Boolean;
begin
  Result := (FMedicineID > 0) and (FSupplierID > 0) and
            (FBatchNumber.Trim <> '') and (FQuantityInStock >= 0) and
            (FExpiryDate > Now);
end;

function TInventoryItem.IsExpired: Boolean;
begin
  Result := FExpiryDate < Now;
end;

function TInventoryItem.DaysUntilExpiry: Integer;
begin
  Result := Trunc(FExpiryDate - Now);
end;

end.