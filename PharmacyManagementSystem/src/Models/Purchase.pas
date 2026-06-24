unit Purchase;

interface

uses
  System.SysUtils, System.Generics.Collections, PurchaseItem;

type
  TPurchase = class
  private
    FPurchaseID: Integer;
    FSupplierID: Integer;
    FPurchaseDate: TDateTime;
    FTotalAmount: Double;
    FCreatedBy: Integer;
    FItems: TObjectList<TPurchaseItem>;
    function GetTotalAmount: Double;
  public
    constructor Create; overload;
    constructor Create(APurchaseID, ASupplierID: Integer; APurchaseDate: TDateTime;
      ATotalAmount: Double; ACreatedBy: Integer); overload;
    destructor Destroy; override;

    procedure AddItem(AItem: TPurchaseItem);
    procedure RemoveItem(AIndex: Integer);
    function Validate: Boolean;

    property PurchaseID: Integer read FPurchaseID write FPurchaseID;
    property SupplierID: Integer read FSupplierID write FSupplierID;
    property PurchaseDate: TDateTime read FPurchaseDate write FPurchaseDate;
    property TotalAmount: Double read GetTotalAmount write FTotalAmount;
    property CreatedBy: Integer read FCreatedBy write FCreatedBy;
    property Items: TObjectList<TPurchaseItem> read FItems;
  end;

implementation

{ TPurchase }

constructor TPurchase.Create;
begin
  FPurchaseID := 0;
  FPurchaseDate := Now;
  FItems := TObjectList<TPurchaseItem>.Create(True);
end;

constructor TPurchase.Create(APurchaseID, ASupplierID: Integer; APurchaseDate: TDateTime;
  ATotalAmount: Double; ACreatedBy: Integer);
begin
  FPurchaseID := APurchaseID;
  FSupplierID := ASupplierID;
  FPurchaseDate := APurchaseDate;
  FTotalAmount := ATotalAmount;
  FCreatedBy := ACreatedBy;
  FItems := TObjectList<TPurchaseItem>.Create(True);
end;

destructor TPurchase.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TPurchase.AddItem(AItem: TPurchaseItem);
begin
  if AItem <> nil then
    FItems.Add(AItem);
end;

procedure TPurchase.RemoveItem(AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FItems.Count) then
    FItems.Delete(AIndex);
end;

function TPurchase.Validate: Boolean;
begin
  Result := (FSupplierID > 0) and (FCreatedBy > 0) and (FItems.Count > 0);
end;

function TPurchase.GetTotalAmount: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItems.Count - 1 do
    Result := Result + (FItems[I].Quantity * FItems[I].UnitCost);
end;

end.