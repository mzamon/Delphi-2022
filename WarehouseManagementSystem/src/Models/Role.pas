unit Role;

interface

type
  TRole = class
  private
    FRoleID: Integer;
    FRoleName: string;
  public
    constructor Create; overload;
    constructor Create(ARoleID: Integer; const ARoleName: string); overload;

    property RoleID: Integer read FRoleID write FRoleID;
    property RoleName: string read FRoleName write FRoleName;
  end;

implementation

{ TRole }

constructor TRole.Create;
begin
  FRoleID := 0;
  FRoleName := '';
end;

constructor TRole.Create(ARoleID: Integer; const ARoleName: string);
begin
  FRoleID := ARoleID;
  FRoleName := ARoleName;
end;

end.