unit AuthenticationService;

interface

uses
  System.SysUtils, User, UserRepository, Hashing, AuditService;

type
  TAuthenticationService = class
  private
    FUserRepo: TUserRepository;
    FAuditService: TAuditService;
    FCurrentUser: TUser;
  public
    constructor Create;
    destructor Destroy; override;

    function Login(const AUsername, APassword: string): Boolean;
    procedure Logout;
    function IsLoggedIn: Boolean;
    function GetCurrentUser: TUser;

    function GetUserRepository: TUserRepository;
  end;

implementation

{ TAuthenticationService }

constructor TAuthenticationService.Create;
begin
  inherited Create;
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
  User := FUserRepo.GetUserByUsername(AUsername);
  if User = nil then
    Exit;

  // Verify password hash using Hashing unit (THashing.VerifyPassword)
  if THashing.VerifyPassword(APassword, User.PasswordHash) then
  begin
    FCurrentUser := User;
    Result := True;
    // Log the login action
    FAuditService.LogAction(User.UserID, 'User logged in', '');
  end
  else
  begin
    User.Free;
    // Could log failed login attempt
  end;
end;

procedure TAuthenticationService.Logout;
begin
  if FCurrentUser <> nil then
  begin
    FAuditService.LogAction(FCurrentUser.UserID, 'User logged out', '');
    FreeAndNil(FCurrentUser);
  end;
end;

function TAuthenticationService.IsLoggedIn: Boolean;
begin
  Result := FCurrentUser <> nil;
end;

function TAuthenticationService.GetCurrentUser: TUser;
begin
  Result := FCurrentUser;
end;

function TAuthenticationService.GetUserRepository: TUserRepository;
begin
  Result := FUserRepo;
end;

end.