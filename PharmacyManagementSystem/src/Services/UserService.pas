unit UserService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  User, Role, UserRepository, AuditService;

type
  TUserService = class
  private
    FRepo: TUserRepository;
    FAudit: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;

    function GetUserByID(AUserID: Integer): TUser;
    function GetUserByUsername(const AUsername: string): TUser;
    function GetAllUsers: TObjectList<TUser>;
    function AddUser(AUser: TUser; const APassword: string; ALoggedInUserID: Integer): Integer;
    procedure UpdateUser(AUser: TUser; ALoggedInUserID: Integer);
    procedure DeleteUser(AUserID: Integer; ALoggedInUserID: Integer);
    function GetRoles: TObjectList<TRole>;
  end;

implementation

uses
  Hashing, Constants;

{ TUserService }

constructor TUserService.Create;
begin
  FRepo := TUserRepository.Create;
  FAudit := TAuditService.Create;
end;

destructor TUserService.Destroy;
begin
  FRepo.Free;
  FAudit.Free;
  inherited;
end;

function TUserService.GetUserByID(AUserID: Integer): TUser;
begin
  Result := FRepo.GetUserByID(AUserID);
end;

function TUserService.GetUserByUsername(const AUsername: string): TUser;
begin
  Result := FRepo.GetUserByUsername(AUsername);
end;

function TUserService.GetAllUsers: TObjectList<TUser>;
begin
  Result := FRepo.GetAllUsers;
end;

function TUserService.AddUser(AUser: TUser; const APassword: string; ALoggedInUserID: Integer): Integer;
begin
  // Hash password
  AUser.PasswordHash := THashing.HashPassword(APassword);
  Result := FRepo.InsertUser(AUser);
  if Result > 0 then
    FAudit.LogAction(ALoggedInUserID, AUDIT_USER_CREATE,
      Format('Created user %s (ID=%d)', [AUser.Username, Result]), '');
end;

procedure TUserService.UpdateUser(AUser: TUser; ALoggedInUserID: Integer);
begin
  FRepo.UpdateUser(AUser);
  FAudit.LogAction(ALoggedInUserID, AUDIT_USER_UPDATE,
    Format('Updated user %s (ID=%d)', [AUser.Username, AUser.UserID]), '');
end;

procedure TUserService.DeleteUser(AUserID: Integer; ALoggedInUserID: Integer);
var
  User: TUser;
begin
  User := FRepo.GetUserByID(AUserID);
  try
    FRepo.DeleteUser(AUserID);
    FAudit.LogAction(ALoggedInUserID, AUDIT_USER_DELETE,
      Format('Deleted user ID %d', [AUserID]), '');
  finally
    User.Free;
  end;
end;

function TUserService.GetRoles: TObjectList<TRole>;
begin
  Result := FRepo.GetAllRoles;
end;

end.