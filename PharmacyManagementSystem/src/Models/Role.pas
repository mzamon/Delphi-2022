unit Role;

interface

type
  TRole = class
  private
    FRoleID: Integer;
    FRoleName: string;
    FDescription: string;
  public
    constructor Create; overload;
    constructor Create(ARoleID: Integer; const ARoleName, ADescription: string); overload;

    property RoleID: Integer read FRoleID write FRoleID;
    property RoleName: string read FRoleName write FRoleName;
    property Description: string read FDescription write FDescription;
  end;

implementation

{ TRole }

constructor TRole.Create;
begin
  FRoleID := 0;
end;

constructor TRole.Create(ARoleID: Integer; const ARoleName, ADescription: string);
begin
  FRoleID := ARoleID;
  FRoleName := ARoleName;
  FDescription := ADescription;
end;

end.