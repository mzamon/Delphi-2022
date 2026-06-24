unit MedicineService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Medicine, Category, MedicineRepository, AuditService, Constants;

type
  TMedicineService = class
  private
    FRepo: TMedicineRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetMedicineByID(AMedicineID: Integer): TMedicine;
    function GetMedicineByBarcode(const ABarcode: string): TMedicine;
    function GetAllMedicines: TObjectList<TMedicine>;
    function GetMedicinesByCategory(ACategoryID: Integer): TObjectList<TMedicine>;
    function AddMedicine(AMedicine: TMedicine; ALoggedInUserID: Integer): Integer;
    procedure UpdateMedicine(AMedicine: TMedicine; ALoggedInUserID: Integer);
    procedure DeleteMedicine(AMedicineID: Integer; ALoggedInUserID: Integer);

    // Categories
    function GetCategoryByID(ACategoryID: Integer): TCategory;
    function GetAllCategories: TObjectList<TCategory>;
    function AddCategory(ACategory: TCategory; ALoggedInUserID: Integer): Integer;
    procedure UpdateCategory(ACategory: TCategory; ALoggedInUserID: Integer);
    procedure DeleteCategory(ACategoryID: Integer; ALoggedInUserID: Integer);
  end;

implementation

{ TMedicineService }

constructor TMedicineService.Create;
begin
  FRepo := TMedicineRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TMedicineService.Destroy;
begin
  FRepo.Free;
  FAudit.Free;
  inherited;
end;

function TMedicineService.GetMedicineByID(AMedicineID: Integer): TMedicine;
begin
  Result := FRepo.GetMedicineByID(AMedicineID);
end;

function TMedicineService.GetMedicineByBarcode(const ABarcode: string): TMedicine;
begin
  Result := FRepo.GetMedicineByBarcode(ABarcode);
end;

function TMedicineService.GetAllMedicines: TObjectList<TMedicine>;
begin
  Result := FRepo.GetAllMedicines;
end;

function TMedicineService.GetMedicinesByCategory(ACategoryID: Integer): TObjectList<TMedicine>;
begin
  Result := FRepo.GetMedicinesByCategory(ACategoryID);
end;

function TMedicineService.AddMedicine(AMedicine: TMedicine; ALoggedInUserID: Integer): Integer;
begin
  Result := FRepo.InsertMedicine(AMedicine);
  if Result > 0 then
    FAudit.LogAction(ALoggedInUserID, AUDIT_MEDICINE_CREATE,
      Format('Added medicine "%s" (ID=%d)', [AMedicine.MedicineName, Result]), '');
end;

procedure TMedicineService.UpdateMedicine(AMedicine: TMedicine; ALoggedInUserID: Integer);
begin
  FRepo.UpdateMedicine(AMedicine);
  FAudit.LogAction(ALoggedInUserID, AUDIT_MEDICINE_UPDATE,
    Format('Updated medicine "%s" (ID=%d)', [AMedicine.MedicineName, AMedicine.MedicineID]), '');
end;

procedure TMedicineService.DeleteMedicine(AMedicineID: Integer; ALoggedInUserID: Integer);
var
  Med: TMedicine;
begin
  Med := FRepo.GetMedicineByID(AMedicineID);
  try
    FRepo.DeleteMedicine(AMedicineID);
    FAudit.LogAction(ALoggedInUserID, AUDIT_MEDICINE_DELETE,
      Format('Deleted medicine ID %d', [AMedicineID]), '');
  finally
    Med.Free;
  end;
end;

// ----- Categories -----

function TMedicineService.GetCategoryByID(ACategoryID: Integer): TCategory;
begin
  Result := FRepo.GetCategoryByID(ACategoryID);
end;

function TMedicineService.GetAllCategories: TObjectList<TCategory>;
begin
  Result := FRepo.GetAllCategories;
end;

function TMedicineService.AddCategory(ACategory: TCategory; ALoggedInUserID: Integer): Integer;
begin
  Result := FRepo.InsertCategory(ACategory);
  // Optional: audit
end;

procedure TMedicineService.UpdateCategory(ACategory: TCategory; ALoggedInUserID: Integer);
begin
  FRepo.UpdateCategory(ACategory);
end;

procedure TMedicineService.DeleteCategory(ACategoryID: Integer; ALoggedInUserID: Integer);
begin
  FRepo.DeleteCategory(ACategoryID);
end;

end.