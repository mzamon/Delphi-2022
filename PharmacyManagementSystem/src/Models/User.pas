unit User;

interface

uses
  System.SysUtils;

type
  TUser = class
  private
    FUserID: Integer;
    FUsername: string;
    FPasswordHash: string;
    FFirstName: string;
    FLastName: string;
    FEmail: string;
    FRoleID: Integer;
    FIsActive: Boolean;
    FCreatedDate: TDateTime;
  public
    constructor Create; overload;
    constructor Create(AUserID: Integer; const AUsername, APasswordHash, AFirstName,
      ALastName, AEmail: string; ARoleID: Integer; AIsActive: Boolean; ACreatedDate: TDateTime); overload;

    function Validate: Boolean;
    function FullName: string;

    property UserID: Integer read FUserID write FUserID;
    property Username: string read FUsername write FUsername;
    property PasswordHash: string read FPasswordHash write FPasswordHash;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property Email: string read FEmail write FEmail;
    property RoleID: Integer read FRoleID write FRoleID;
    property IsActive: Boolean read FIsActive write FIsActive;
    property CreatedDate: TDateTime read FCreatedDate write FCreatedDate;
  end;

implementation

{ TUser }

constructor TUser.Create;
begin
  FUserID := 0;
  FIsActive := True;
  FCreatedDate := Now;
end;

constructor TUser.Create(AUserID: Integer; const AUsername, APasswordHash, AFirstName,
  ALastName, AEmail: string; ARoleID: Integer; AIsActive: Boolean; ACreatedDate: TDateTime);
begin
  FUserID := AUserID;
  FUsername := AUsername;
  FPasswordHash := APasswordHash;
  FFirstName := AFirstName;
  FLastName := ALastName;
  FEmail := AEmail;
  FRoleID := ARoleID;
  FIsActive := AIsActive;
  FCreatedDate := ACreatedDate;
end;

function TUser.Validate: Boolean;
begin
  Result := (FUsername.Trim <> '') and (FFirstName.Trim <> '') and
            (FLastName.Trim <> '') and (FEmail.Trim <> '') and (FRoleID > 0);
end;

function TUser.FullName: string;
begin
  Result := Trim(FFirstName + ' ' + FLastName);
end;

end.
