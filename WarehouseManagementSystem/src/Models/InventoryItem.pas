unit InventoryItem;

interface

type
  TInventoryItem = class
  private
    FItemID: Integer;
    FWarehouseID: Integer;
    FSKU: string;
    FItemName: string;
    FDescription: string;
    FQuantity: Double;
    FReorderLevel: Double;
    FUnitPrice: Double;
  public
    constructor Create; overload;
    constructor Create(AItemID, AWarehouseID: Integer; const ASKU, AItemName,
      ADescription: string; AQuantity, AReorderLevel, AUnitPrice: Double); overload;

    function Validate: Boolean;

    property ItemID: Integer read FItemID write FItemID;
    property WarehouseID: Integer read FWarehouseID write FWarehouseID;
    property SKU: string read FSKU write FSKU;
    property ItemName: string read FItemName write FItemName;
    property Description: string read FDescription write FDescription;
    property Quantity: Double read FQuantity write FQuantity;
    property ReorderLevel: Double read FReorderLevel write FReorderLevel;
    property UnitPrice: Double read FUnitPrice write FUnitPrice;
  end;

implementation

uses
  System.SysUtils;

{ TInventoryItem }

constructor TInventoryItem.Create;
begin
  FItemID := 0;
  FWarehouseID := 0;
  FQuantity := 0;
  FReorderLevel := 0;
  FUnitPrice := 0;
end;

constructor TInventoryItem.Create(AItemID, AWarehouseID: Integer; const ASKU,
  AItemName, ADescription: string; AQuantity, AReorderLevel, AUnitPrice: Double);
begin
  FItemID := AItemID;
  FWarehouseID := AWarehouseID;
  FSKU := ASKU;
  FItemName := AItemName;
  FDescription := ADescription;
  FQuantity := AQuantity;
  FReorderLevel := AReorderLevel;
  FUnitPrice := AUnitPrice;
end;

function TInventoryItem.Validate: Boolean;
begin
  Result := (FWarehouseID > 0) and (FSKU.Trim <> '') and (FItemName.Trim <> '') and
            (FQuantity >= 0) and (FReorderLevel >= 0) and (FUnitPrice >= 0);
end;

end.