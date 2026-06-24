unit SupplierService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Supplier, SupplierRepository, AuditService, Constants;

type
  TSupplierService = class
  private
    FRepo: TSupplierRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetSupplierByID(ASupplierID: Integer): TSupplier;
    function GetAllSuppliers: TObjectList<TSupplier>;
    function AddSupplier(ASupplier: TSupplier; ALoggedInUserID: Integer): Integer;
    procedure UpdateSupplier(ASupplier: TSupplier; ALoggedInUserID: Integer);
    procedure DeleteSupplier(ASupplierID: Integer; ALoggedInUserID: Integer);
  end;

implementation

{ TSupplierService }

constructor TSupplierService.Create;
begin
  FRepo := TSupplierRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TSupplierService.Destroy;
begin
  FRepo.Free;
  FAudit.Free;
  inherited;
end;

function TSupplierService.GetSupplierByID(ASupplierID: Integer): TSupplier;
begin
  Result := FRepo.GetSupplierByID(ASupplierID);
end;

function TSupplierService.GetAllSuppliers: TObjectList<TSupplier>;
begin
  Result := FRepo.GetAllSuppliers;
end;

function TSupplierService.AddSupplier(ASupplier: TSupplier; ALoggedInUserID: Integer): Integer;
begin
  Result := FRepo.InsertSupplier(ASupplier);
  // audit
end;

procedure TSupplierService.UpdateSupplier(ASupplier: TSupplier; ALoggedInUserID: Integer);
begin
  FRepo.UpdateSupplier(ASupplier);
end;

procedure TSupplierService.DeleteSupplier(ASupplierID: Integer; ALoggedInUserID: Integer);
begin
  FRepo.DeleteSupplier(ASupplierID);
end;

end.