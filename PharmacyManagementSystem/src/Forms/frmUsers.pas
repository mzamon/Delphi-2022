unit frmUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons,
  User, UserService, AuditService;

type
  TfrmUsers = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    FService: TUserService;
    FUsers: TObjectList<TUser>;
    procedure LoadUsers;
    function GetSelectedUser: TUser;
  public
  end;

var
  frmUsers: TfrmUsers;

implementation

{$R *.dfm}

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  FService := TUserService.Create;
  FUsers := TObjectList<TUser>.Create(False);
  LoadUsers;
end;

procedure TfrmUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FUsers.Free;
end;

procedure TfrmUsers.LoadUsers;
begin
  FUsers.Clear;
  FUsers.AddRange(FService.GetAllUsers);
  // Refresh grid (would need a DataSource)
end;

function TfrmUsers.GetSelectedUser: TUser;
begin
  Result := nil;
end;

procedure TfrmUsers.btnAddClick(Sender: TObject);
begin
  // Show user edit dialog
end;

procedure TfrmUsers.btnEditClick(Sender: TObject);
var
  User: TUser;
begin
  User := GetSelectedUser;
  if User <> nil then
    // edit
end;

procedure TfrmUsers.btnDeleteClick(Sender: TObject);
var
  User: TUser;
begin
  User := GetSelectedUser;
  if User <> nil then
    if MessageDlg('Delete user?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteUser(User.UserID, 1); // log with admin user ID
      LoadUsers;
    end;
end;

procedure TfrmUsers.btnRefreshClick(Sender: TObject);
begin
  LoadUsers;
end;

end.