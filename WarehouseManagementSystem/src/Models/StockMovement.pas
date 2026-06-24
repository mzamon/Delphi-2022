unit StockMovement;

interface

type
  TStockMovementType = (smtIn, smtOut, smtAdjust);

  TStockMovement = class
  private
    FMovementID: Integer;
    FItemID: Integer;
    FWarehouseID: Integer;
    FMovementType: TStockMovementType;
    FQuantity: Double;
    FMovementDate: TDateTime;
    FUserID: Integer;
    FReference: string;
  public
    constructor Create; overload;
    constructor Create(AMovementID, AItemID, AWarehouseID: Integer;
      AMovementType: TStockMovementType; AQuantity: Double;
      AMovementDate: TDateTime; AUserID: Integer; const AReference: string); overload;

    function Validate: Boolean;

    property MovementID: Integer read FMovementID write FMovementID;
    property ItemID: Integer read FItemID write FItemID;
    property WarehouseID: Integer read FWarehouseID write FWarehouseID;
    property MovementType: TStockMovementType read FMovementType write FMovementType;
    property Quantity: Double read FQuantity write FQuantity;
    property MovementDate: TDateTime read FMovementDate write FMovementDate;
    property UserID: Integer read FUserID write FUserID;
    property Reference: string read FReference write FReference;
  end;

implementation

uses
  System.SysUtils;

{ TStockMovement }

constructor TStockMovement.Create;
begin
  FMovementID := 0;
  FMovementDate := Now;
end;

constructor TStockMovement.Create(AMovementID, AItemID, AWarehouseID: Integer;
  AMovementType: TStockMovementType; AQuantity: Double; AMovementDate: TDateTime;
  AUserID: Integer; const AReference: string);
begin
  FMovementID := AMovementID;
  FItemID := AItemID;
  FWarehouseID := AWarehouseID;
  FMovementType := AMovementType;
  FQuantity := AQuantity;
  FMovementDate := AMovementDate;
  FUserID := AUserID;
  FReference := AReference;
end;

function TStockMovement.Validate: Boolean;
begin
  Result := (FItemID > 0) and (FWarehouseID > 0) and (FUserID > 0) and (FQuantity <> 0);
end;

end.