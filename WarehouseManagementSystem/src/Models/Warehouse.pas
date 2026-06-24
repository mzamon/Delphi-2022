unit Warehouse;

interface

type
  TWarehouse = class
  private
    FWarehouseID: Integer;
    FWarehouseName: string;
    FLocation: string;
  public
    constructor Create; overload;
    constructor Create(AWarehouseID: Integer; const AWarehouseName, ALocation: string); overload;

    function Validate: Boolean;

    property WarehouseID: Integer read FWarehouseID write FWarehouseID;
    property WarehouseName: string read FWarehouseName write FWarehouseName;
    property Location: string read FLocation write FLocation;
  end;

implementation

uses
  System.SysUtils;

{ TWarehouse }

constructor TWarehouse.Create;
begin
  FWarehouseID := 0;
end;

constructor TWarehouse.Create(AWarehouseID: Integer; const AWarehouseName, ALocation: string);
begin
  FWarehouseID := AWarehouseID;
  FWarehouseName := AWarehouseName;
  FLocation := ALocation;
end;

function TWarehouse.Validate: Boolean;
begin
  Result := (FWarehouseName.Trim <> '') and (FLocation.Trim <> '');
end;

end.