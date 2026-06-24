unit AuthenticationService;

interface

uses
  System.SysUtils, User, UserRepository, Hashing, AuditService;

type
  TAuthenticationService = class
  private
    FUserRepo: TUserRepository;
    FCurrentUser: TUser;
    FAuditService: TAuditService;
  public
    constructor Create;
    destructor Destroy; override;
    function Login(const AUsername, APassword: string): Boolean;
    procedure Logout;
    function GetCurrentUser: TUser;
    function GetCurrentRoleID: Integer;
    function IsUserInRole(ARoleID: Integer): Boolean;
  end;

implementation

{ TAuthenticationService }

constructor TAuthenticationService.Create;
begin
  FUserRepo := TUserRepository.Create;
  FAuditService := TAuditService.Create;
  FCurrentUser := nil;
end;

destructor TAuthenticationService.Destroy;
begin
  FUserRepo.Free;
  FAuditService.Free;
  FCurrentUser.Free;
  inherited;
end;

function TAuthenticationService.Login(const AUsername, APassword: string): Boolean;
var
  User: TUser;
begin
  Result := False;
  User := FUserRepo.AuthenticateUser(AUsername);
  if User <> nil then
  begin
    // Verify password hash
    if THashing.VerifyPassword(APassword, User.PasswordHash) then
    begin
      FCurrentUser := User;
      FAuditService.LogAction(User.UserID, 'LOGIN', 'User logged in', '');
      Result := True;
    end
    else
    begin
      User.Free;
    end;
  end;
end;

procedure TAuthenticationService.Logout;
begin
  if FCurrentUser <> nil then
  begin
    FAuditService.LogAction(FCurrentUser.UserID, 'LOGOUT', 'User logged out', '');
    FreeAndNil(FCurrentUser);
  end;
end;

function TAuthenticationService.GetCurrentUser: TUser;
begin
  Result := FCurrentUser;
end;

function TAuthenticationService.GetCurrentRoleID: Integer;
begin
  if FCurrentUser <> nil then
    Result := FCurrentUser.RoleID
  else
    Result := 0;
end;

function TAuthenticationService.IsUserInRole(ARoleID: Integer): Boolean;
begin
  Result := (FCurrentUser <> nil) and (FCurrentUser.RoleID = ARoleID);
end;

end.