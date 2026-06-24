unit WarehouseService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Warehouse, WarehouseRepository, AuditService;

type
  TWarehouseService = class
  private
    FRepo: TWarehouseRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetWarehouse(AID: Integer): TWarehouse;
    function GetAllWarehouses: TObjectList<TWarehouse>;
    function AddWarehouse(AWH: TWarehouse; AUserID: Integer): Integer;
    procedure UpdateWarehouse(AWH: TWarehouse; AUserID: Integer);
    procedure DeleteWarehouse(AID: Integer; AUserID: Integer);
  end;

implementation

{ TWarehouseService }

constructor TWarehouseService.Create;
begin
  inherited;
  FRepo := TWarehouseRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TWarehouseService.Destroy;
begin
  FRepo.Free;
  FAudit.Free;
  inherited;
end;

function TWarehouseService.GetWarehouse(AID: Integer): TWarehouse;
begin
  Result := FRepo.GetWarehouseByID(AID);
end;

function TWarehouseService.GetAllWarehouses: TObjectList<TWarehouse>;
begin
  Result := FRepo.GetAllWarehouses;
end;

function TWarehouseService.AddWarehouse(AWH: TWarehouse; AUserID: Integer): Integer;
begin
  Result := FRepo.InsertWarehouse(AWH);
  FAudit.LogAction(AUserID, Format('Added warehouse: %s', [AWH.WarehouseName]), '');
end;

procedure TWarehouseService.UpdateWarehouse(AWH: TWarehouse; AUserID: Integer);
begin
  FRepo.UpdateWarehouse(AWH);
  FAudit.LogAction(AUserID, Format('Updated warehouse: %s', [AWH.WarehouseName]), '');
end;

procedure TWarehouseService.DeleteWarehouse(AID: Integer; AUserID: Integer);
begin
  var WH := FRepo.GetWarehouseByID(AID);
  if WH <> nil then
  begin
    FRepo.DeleteWarehouse(AID);
    FAudit.LogAction(AUserID, Format('Deleted warehouse: %s', [WH.WarehouseName]), '');
    WH.Free;
  end;
end;

end.