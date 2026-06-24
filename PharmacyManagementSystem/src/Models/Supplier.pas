unit Supplier;

interface

type
  TSupplier = class
  private
    FSupplierID: Integer;
    FSupplierName: string;
    FContactPerson: string;
    FPhone: string;
    FEmail: string;
    FAddress: string;
  public
    constructor Create; overload;
    constructor Create(ASupplierID: Integer; const ASupplierName, AContactPerson,
      APhone, AEmail, AAddress: string); overload;

    function Validate: Boolean;

    property SupplierID: Integer read FSupplierID write FSupplierID;
    property SupplierName: string read FSupplierName write FSupplierName;
    property ContactPerson: string read FContactPerson write FContactPerson;
    property Phone: string read FPhone write FPhone;
    property Email: string read FEmail write FEmail;
    property Address: string read FAddress write FAddress;
  end;

implementation

uses
  System.SysUtils;

{ TSupplier }

constructor TSupplier.Create;
begin
  FSupplierID := 0;
end;

constructor TSupplier.Create(ASupplierID: Integer; const ASupplierName, AContactPerson,
  APhone, AEmail, AAddress: string);
begin
  FSupplierID := ASupplierID;
  FSupplierName := ASupplierName;
  FContactPerson := AContactPerson;
  FPhone := APhone;
  FEmail := AEmail;
  FAddress := AAddress;
end;

function TSupplier.Validate: Boolean;
begin
  Result := (FSupplierName.Trim <> '') and (FEmail.Trim <> '');
end;

end.