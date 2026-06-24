unit PurchaseOrder;

interface

uses
  System.SysUtils, System.Generics.Collections,
  PurchaseOrderItem;

type
  TPurchaseOrderStatus = (posDraft, posSubmitted, posReceived, posCancelled);

  TPurchaseOrder = class
  private
    FPOID: Integer;
    FSupplierID: Integer;
    FCreatedBy: Integer;
    FOrderDate: TDateTime;
    FStatus: TPurchaseOrderStatus;
    FItems: TObjectList<TPurchaseOrderItem>;
    function GetTotalAmount: Double;
  public
    constructor Create; overload;
    constructor Create(APOID, ASupplierID, ACreatedBy: Integer; AOrderDate: TDateTime;
      AStatus: TPurchaseOrderStatus); overload;
    destructor Destroy; override;

    procedure AddItem(AItem: TPurchaseOrderItem);
    procedure RemoveItem(AIndex: Integer);
    function Validate: Boolean;

    property POID: Integer read FPOID write FPOID;
    property SupplierID: Integer read FSupplierID write FSupplierID;
    property CreatedBy: Integer read FCreatedBy write FCreatedBy;
    property OrderDate: TDateTime read FOrderDate write FOrderDate;
    property Status: TPurchaseOrderStatus read FStatus write FStatus;
    property Items: TObjectList<TPurchaseOrderItem> read FItems;
    property TotalAmount: Double read GetTotalAmount;
  end;

implementation

{ TPurchaseOrder }

constructor TPurchaseOrder.Create;
begin
  FPOID := 0;
  FOrderDate := Now;
  FStatus := posDraft;
  FItems := TObjectList<TPurchaseOrderItem>.Create(True);
end;

constructor TPurchaseOrder.Create(APOID, ASupplierID, ACreatedBy: Integer;
  AOrderDate: TDateTime; AStatus: TPurchaseOrderStatus);
begin
  FPOID := APOID;
  FSupplierID := ASupplierID;
  FCreatedBy := ACreatedBy;
  FOrderDate := AOrderDate;
  FStatus := AStatus;
  FItems := TObjectList<TPurchaseOrderItem>.Create(True);
end;

destructor TPurchaseOrder.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TPurchaseOrder.AddItem(AItem: TPurchaseOrderItem);
begin
  if AItem <> nil then
    FItems.Add(AItem);
end;

procedure TPurchaseOrder.RemoveItem(AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FItems.Count) then
    FItems.Delete(AIndex);
end;

function TPurchaseOrder.Validate: Boolean;
begin
  Result := (FSupplierID > 0) and (FCreatedBy > 0) and (FItems.Count > 0);
end;

function TPurchaseOrder.GetTotalAmount: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItems.Count - 1 do
    Result := Result + (FItems[I].Quantity * FItems[I].UnitCost);
end;

end.