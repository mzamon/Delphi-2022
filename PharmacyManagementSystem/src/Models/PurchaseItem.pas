unit PurchaseItem;

interface

type
  TPurchaseItem = class
  private
    FPurchaseItemID: Integer;
    FPurchaseID: Integer;
    FMedicineID: Integer;
    FQuantity: Double;
    FUnitCost: Double;
  public
    constructor Create; overload;
    constructor Create(APurchaseItemID, APurchaseID, AMedicineID: Integer;
      AQuantity, AUnitCost: Double); overload;

    function Validate: Boolean;

    property PurchaseItemID: Integer read FPurchaseItemID write FPurchaseItemID;
    property PurchaseID: Integer read FPurchaseID write FPurchaseID;
    property MedicineID: Integer read FMedicineID write FMedicineID;
    property Quantity: Double read FQuantity write FQuantity;
    property UnitCost: Double read FUnitCost write FUnitCost;
  end;

implementation

{ TPurchaseItem }

constructor TPurchaseItem.Create;
begin
  FPurchaseItemID := 0;
end;

constructor TPurchaseItem.Create(APurchaseItemID, APurchaseID, AMedicineID: Integer;
  AQuantity, AUnitCost: Double);
begin
  FPurchaseItemID := APurchaseItemID;
  FPurchaseID := APurchaseID;
  FMedicineID := AMedicineID;
  FQuantity := AQuantity;
  FUnitCost := AUnitCost;
end;

function TPurchaseItem.Validate: Boolean;
begin
  Result := (FPurchaseID > 0) and (FMedicineID > 0) and (FQuantity > 0) and (FUnitCost >= 0);
end;

end.