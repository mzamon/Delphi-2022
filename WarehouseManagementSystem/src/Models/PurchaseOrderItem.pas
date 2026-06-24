unit PurchaseOrderItem;

interface

type
  TPurchaseOrderItem = class
  private
    FPOItemID: Integer;
    FPOID: Integer;
    FItemID: Integer;
    FQuantity: Double;
    FUnitCost: Double;
  public
    constructor Create; overload;
    constructor Create(APOItemID, APOID, AItemID: Integer; AQuantity, AUnitCost: Double); overload;

    function Validate: Boolean;

    property POItemID: Integer read FPOItemID write FPOItemID;
    property POID: Integer read FPOID write FPOID;
    property ItemID: Integer read FItemID write FItemID;
    property Quantity: Double read FQuantity write FQuantity;
    property UnitCost: Double read FUnitCost write FUnitCost;
  end;

implementation

{ TPurchaseOrderItem }

constructor TPurchaseOrderItem.Create;
begin
  FPOItemID := 0;
  FPOID := 0;
  FItemID := 0;
  FQuantity := 0;
  FUnitCost := 0;
end;

constructor TPurchaseOrderItem.Create(APOItemID, APOID, AItemID: Integer;
  AQuantity, AUnitCost: Double);
begin
  FPOItemID := APOItemID;
  FPOID := APOID;
  FItemID := AItemID;
  FQuantity := AQuantity;
  FUnitCost := AUnitCost;
end;

function TPurchaseOrderItem.Validate: Boolean;
begin
  Result := (FPOID > 0) and (FItemID > 0) and (FQuantity > 0) and (FUnitCost >= 0);
end;

end.
