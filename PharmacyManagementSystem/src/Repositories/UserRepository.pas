unit UserRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, User, Role;

type
  TUserRepository = class(TRepositoryBase)
  public
    function GetUserByID(AUserID: Integer): TUser;
    function GetUserByUsername(const AUsername: string): TUser;
    function GetUserByEmail(const AEmail: string): TUser;
    function GetAllUsers: TObjectList<TUser>;
    function InsertUser(AUser: TUser): Integer;
    procedure UpdateUser(AUser: TUser);
    procedure DeleteUser(AUserID: Integer);
    function AuthenticateUser(const AUsername: string): TUser;

    // Role helpers
    function GetRoleName(ARoleID: Integer): string;
    function GetRoleIDByName(const ARoleName: string): Integer;
    function GetAllRoles: TObjectList<TRole>;
  end;

implementation

{ TUserRepository }

function TUserRepository.GetUserByID(AUserID: Integer): TUser;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT UserID, Username, PasswordHash, FirstName, LastName, ' +
                  'Email, RoleID, IsActive, CreatedDate FROM Users WHERE UserID = :UserID';
    Q.ParamByName('UserID').AsInteger := AUserID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TUser.Create;
      Result.UserID := Q.FieldByName('UserID').AsInteger;
      Result.Username := Q.FieldByName('Username').AsString;
      Result.PasswordHash := Q.FieldByName('PasswordHash').AsString;
      Result.FirstName := Q.FieldByName('FirstName').AsString;
      Result.LastName := Q.FieldByName('LastName').AsString;
      Result.Email := Q.FieldByName('Email').AsString;
      Result.RoleID := Q.FieldByName('RoleID').AsInteger;
      Result.IsActive := Q.FieldByName('IsActive').AsBoolean;
      Result.CreatedDate := Q.FieldByName('CreatedDate').AsDateTime;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.GetUserByUsername(const AUsername: string): TUser;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT UserID, Username, PasswordHash, FirstName, LastName, ' +
                  'Email, RoleID, IsActive, CreatedDate FROM Users WHERE Username = :Username';
    Q.ParamByName('Username').AsString := AUsername;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TUser.Create;
      Result.UserID := Q.FieldByName('UserID').AsInteger;
      Result.Username := Q.FieldByName('Username').AsString;
      Result.PasswordHash := Q.FieldByName('PasswordHash').AsString;
      Result.FirstName := Q.FieldByName('FirstName').AsString;
      Result.LastName := Q.FieldByName('LastName').AsString;
      Result.Email := Q.FieldByName('Email').AsString;
      Result.RoleID := Q.FieldByName('RoleID').AsInteger;
      Result.IsActive := Q.FieldByName('IsActive').AsBoolean;
      Result.CreatedDate := Q.FieldByName('CreatedDate').AsDateTime;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.GetUserByEmail(const AEmail: string): TUser;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT UserID, Username, PasswordHash, FirstName, LastName, ' +
                  'Email, RoleID, IsActive, CreatedDate FROM Users WHERE Email = :Email';
    Q.ParamByName('Email').AsString := AEmail;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TUser.Create;
      Result.UserID := Q.FieldByName('UserID').AsInteger;
      Result.Username := Q.FieldByName('Username').AsString;
      Result.PasswordHash := Q.FieldByName('PasswordHash').AsString;
      Result.FirstName := Q.FieldByName('FirstName').AsString;
      Result.LastName := Q.FieldByName('LastName').AsString;
      Result.Email := Q.FieldByName('Email').AsString;
      Result.RoleID := Q.FieldByName('RoleID').AsInteger;
      Result.IsActive := Q.FieldByName('IsActive').AsBoolean;
      Result.CreatedDate := Q.FieldByName('CreatedDate').AsDateTime;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.GetAllUsers: TObjectList<TUser>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TUser>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT UserID, Username, PasswordHash, FirstName, LastName, ' +
                  'Email, RoleID, IsActive, CreatedDate FROM Users ORDER BY Username';
    Q.Open;
    while not Q.Eof do
    begin
      var User := TUser.Create;
      User.UserID := Q.FieldByName('UserID').AsInteger;
      User.Username := Q.FieldByName('Username').AsString;
      User.PasswordHash := Q.FieldByName('PasswordHash').AsString;
      User.FirstName := Q.FieldByName('FirstName').AsString;
      User.LastName := Q.FieldByName('LastName').AsString;
      User.Email := Q.FieldByName('Email').AsString;
      User.RoleID := Q.FieldByName('RoleID').AsInteger;
      User.IsActive := Q.FieldByName('IsActive').AsBoolean;
      User.CreatedDate := Q.FieldByName('CreatedDate').AsDateTime;
      Result.Add(User);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.InsertUser(AUser: TUser): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  if not AUser.Validate then
    raise Exception.Create('User data invalid.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO Users (Username, PasswordHash, FirstName, LastName, Email, RoleID, IsActive, CreatedDate) ' +
                  'VALUES (:Username, :PasswordHash, :FirstName, :LastName, :Email, :RoleID, :IsActive, :CreatedDate); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('Username').AsString := AUser.Username;
    Q.ParamByName('PasswordHash').AsString := AUser.PasswordHash;
    Q.ParamByName('FirstName').AsString := AUser.FirstName;
    Q.ParamByName('LastName').AsString := AUser.LastName;
    Q.ParamByName('Email').AsString := AUser.Email;
    Q.ParamByName('RoleID').AsInteger := AUser.RoleID;
    Q.ParamByName('IsActive').AsInteger := Ord(AUser.IsActive);
    Q.ParamByName('CreatedDate').AsDateTime := AUser.CreatedDate;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TUserRepository.UpdateUser(AUser: TUser);
var
  Q: TFDQuery;
begin
  if not AUser.Validate then
    raise Exception.Create('User data invalid.');
  if AUser.UserID <= 0 then
    raise Exception.Create('UserID must be set.');

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'UPDATE Users SET Username = :Username, PasswordHash = :PasswordHash, ' +
                  'FirstName = :FirstName, LastName = :LastName, Email = :Email, ' +
                  'RoleID = :RoleID, IsActive = :IsActive WHERE UserID = :UserID';
    Q.ParamByName('UserID').AsInteger := AUser.UserID;
    Q.ParamByName('Username').AsString := AUser.Username;
    Q.ParamByName('PasswordHash').AsString := AUser.PasswordHash;
    Q.ParamByName('FirstName').AsString := AUser.FirstName;
    Q.ParamByName('LastName').AsString := AUser.LastName;
    Q.ParamByName('Email').AsString := AUser.Email;
    Q.ParamByName('RoleID').AsInteger := AUser.RoleID;
    Q.ParamByName('IsActive').AsInteger := Ord(AUser.IsActive);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TUserRepository.DeleteUser(AUserID: Integer);
var
  Q: TFDQuery;
begin
  if AUserID <= 0 then
    raise Exception.Create('Invalid UserID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM Users WHERE UserID = :UserID';
    Q.ParamByName('UserID').AsInteger := AUserID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TUserRepository.AuthenticateUser(const AUsername: string): TUser;
begin
  Result := GetUserByUsername(AUsername);
  if (Result <> nil) and not Result.IsActive then
    FreeAndNil(Result);
end;

function TUserRepository.GetRoleName(ARoleID: Integer): string;
var
  Q: TFDQuery;
begin
  Result := '';
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT RoleName FROM Roles WHERE RoleID = :RoleID';
    Q.ParamByName('RoleID').AsInteger := ARoleID;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('RoleName').AsString;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.GetRoleIDByName(const ARoleName: string): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT RoleID FROM Roles WHERE RoleName = :RoleName';
    Q.ParamByName('RoleName').AsString := ARoleName;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('RoleID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TUserRepository.GetAllRoles: TObjectList<TRole>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TRole>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT RoleID, RoleName, Description FROM Roles ORDER BY RoleName';
    Q.Open;
    while not Q.Eof do
    begin
      var Role := TRole.Create;
      Role.RoleID := Q.FieldByName('RoleID').AsInteger;
      Role.RoleName := Q.FieldByName('RoleName').AsString;
      Role.Description := Q.FieldByName('Description').AsString;
      Result.Add(Role);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

end.