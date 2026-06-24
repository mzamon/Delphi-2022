unit frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, AuthenticationService;

type
  TfrmLogin = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuthService: TAuthenticationService;
  public
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses
  frmMain;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if FAuthService.Login(edtUsername.Text, edtPassword.Text) then
  begin
    ModalResult := mrOk;
    // Main form will be shown after this modal closes
  end
  else
    ShowMessage('Invalid username or password.');
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FAuthService := TAuthenticationService.Create;
end;

end.