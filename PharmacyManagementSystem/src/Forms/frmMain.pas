unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  AuthenticationService;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
  private
    FAuth: TAuthenticationService;
    procedure ShowForm(AFormClass: TFormClass);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  frmUsers, frmMedicines, frmInventory, frmSuppliers, frmPurchases,
  frmDispensing, frmExpiryTracking, frmReports, Constants;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FAuth := TAuthenticationService.Create;
  // Check role and enable/disable menu items
  if not FAuth.IsUserInRole(ROLE_ADMIN) then
    MenuItem2.Visible := False; // Users
  // etc.
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAuth.Free;
end;

procedure TfrmMain.ShowForm(AFormClass: TFormClass);
var
  F: TForm;
begin
  F := AFormClass.Create(Self);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TfrmMain.MenuItem2Click(Sender: TObject); // Users
begin
  ShowForm(TfrmUsers);
end;

procedure TfrmMain.MenuItem3Click(Sender: TObject); // Medicines
begin
  ShowForm(TfrmMedicines);
end;

procedure TfrmMain.MenuItem4Click(Sender: TObject); // Inventory
begin
  ShowForm(TfrmInventory);
end;

procedure TfrmMain.MenuItem5Click(Sender: TObject); // Suppliers
begin
  ShowForm(TfrmSuppliers);
end;

procedure TfrmMain.MenuItem6Click(Sender: TObject); // Purchases
begin
  ShowForm(TfrmPurchases);
end;

procedure TfrmMain.MenuItem7Click(Sender: TObject); // Dispensing
begin
  ShowForm(TfrmDispensing);
end;

procedure TfrmMain.MenuItem8Click(Sender: TObject); // Expiry Tracking
begin
  ShowForm(TfrmExpiryTracking);
end;

procedure TfrmMain.MenuItem9Click(Sender: TObject); // Reports
begin
  ShowForm(TfrmReports);
end;

procedure TfrmMain.MenuItem10Click(Sender: TObject); // Logout
begin
  FAuth.Logout;
  Close;
end;

procedure TfrmMain.MenuItem11Click(Sender: TObject); // Exit
begin
  Close;
end;

// Placeholder for other menu items
procedure TfrmMain.MenuItem12Click(Sender: TObject);
begin
end;

procedure TfrmMain.MenuItem13Click(Sender: TObject);
begin
end;

procedure TfrmMain.MenuItem14Click(Sender: TObject);
begin
end;

procedure TfrmMain.MenuItem15Click(Sender: TObject);
begin
end;

procedure TfrmMain.MenuItem16Click(Sender: TObject);
begin
end;

end.