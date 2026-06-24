unit Supplier;

interface

type
  TSupplier = class
  private
    FSupplierID: Integer;
    FCompanyName: string;
    FContactPerson: string;
    FPhone: string;
    FEmail: string;
  public
    constructor Create; overload;
    constructor Create(ASupplierID: Integer; const ACompanyName, AContactPerson,
      APhone, AEmail: string); overload;

    function Validate: Boolean;

    property SupplierID: Integer read FSupplierID write FSupplierID;
    property CompanyName: string read FCompanyName write FCompanyName;
    property ContactPerson: string read FContactPerson write FContactPerson;
    property Phone: string read FPhone write FPhone;
    property Email: string read FEmail write FEmail;
  end;

implementation

uses
  System.SysUtils;

{ TSupplier }

constructor TSupplier.Create;
begin
  FSupplierID := 0;
end;

constructor TSupplier.Create(ASupplierID: Integer; const ACompanyName, AContactPerson,
  APhone, AEmail: string);
begin
  FSupplierID := ASupplierID;
  FCompanyName := ACompanyName;
  FContactPerson := AContactPerson;
  FPhone := APhone;
  FEmail := AEmail;
end;

function TSupplier.Validate: Boolean;
begin
  Result := (FCompanyName.Trim <> '') and (FEmail.Trim <> '');
  // Additional email format validation can be added in Utilities/Validation
end;

end.