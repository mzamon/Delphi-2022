unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  AuthenticationService, frmLogin, frmUsers, frmInventory, frmSuppliers,
  frmWarehouses, frmPurchaseOrders, frmStockMovement, frmReports;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miLogout: TMenuItem;
    miExit: TMenuItem;
    miAdministration: TMenuItem;
    miUsers: TMenuItem;
    miInventory: TMenuItem;
    miItems: TMenuItem;
    miWarehouses: TMenuItem;
    miSuppliers: TMenuItem;
    miPurchaseOrders: TMenuItem;
    miStockMovements: TMenuItem;
    miReports: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    lblWelcome: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miLogoutClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miUsersClick(Sender: TObject);
    procedure miItemsClick(Sender: TObject);
    procedure miWarehousesClick(Sender: TObject);
    procedure miSuppliersClick(Sender: TObject);
    procedure miPurchaseOrdersClick(Sender: TObject);
    procedure miStockMovementsClick(Sender: TObject);
    procedure miReportsClick(Sender: TObject);
  private
    FAuthService: TAuthenticationService;
    procedure CheckUserRole;
  public
    property AuthService: TAuthenticationService read FAuthService;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FAuthService := TAuthenticationService.Create;
  if not FAuthService.IsLoggedIn then
  begin
    var frmLogin := TfrmLogin.Create(nil);
    try
      if not frmLogin.Login then
        Application.Terminate
      else
      begin
        // Set welcome message
        var User := FAuthService.GetCurrentUser;
        if User <> nil then
          lblWelcome.Caption := 'Welcome, ' + User.FullName;
        CheckUserRole;
      end;
    finally
      frmLogin.Free;
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FAuthService <> nil then
    FAuthService.Logout;
end;

procedure TfrmMain.CheckUserRole;
begin
  // Disable admin-only menus for non-admin users
  var User := FAuthService.GetCurrentUser;
  if User = nil then Exit;
  var Role := FAuthService.GetUserRepository.GetRoleName(User.RoleID);
  miUsers.Visible := (Role = 'Admin') or (Role = 'Manager');
  // can add more
end;

procedure TfrmMain.miLogoutClick(Sender: TObject);
begin
  FAuthService.Logout;
  // Re-login
  var frmLogin := TfrmLogin.Create(nil);
  try
    if not frmLogin.Login then
      Application.Terminate
    else
    begin
      var User := FAuthService.GetCurrentUser;
      if User <> nil then
        lblWelcome.Caption := 'Welcome, ' + User.FullName;
      CheckUserRole;
    end;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miUsersClick(Sender: TObject);
begin
  var frm := TfrmUsers.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miItemsClick(Sender: TObject);
begin
  var frm := TfrmInventory.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miWarehousesClick(Sender: TObject);
begin
  var frm := TfrmWarehouses.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miSuppliersClick(Sender: TObject);
begin
  var frm := TfrmSuppliers.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miPurchaseOrdersClick(Sender: TObject);
begin
  var frm := TfrmPurchaseOrders.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miStockMovementsClick(Sender: TObject);
begin
  var frm := TfrmStockMovement.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.miReportsClick(Sender: TObject);
begin
  var frm := TfrmReports.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.