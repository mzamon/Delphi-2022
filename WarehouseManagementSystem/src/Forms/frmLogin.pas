unit frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AuthenticationService, Constants;

type
  TfrmLogin = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    btnCancel: TButton;
    lblUsername: TLabel;
    lblPassword: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuthService: TAuthenticationService;
  public
    function Login: Boolean;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FAuthService := TAuthenticationService.Create;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if FAuthService.Login(edtUsername.Text, edtPassword.Text) then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    ShowMessage('Invalid username or password.');
    edtPassword.Clear;
    edtPassword.SetFocus;
  end;
end;

function TfrmLogin.Login: Boolean;
begin
  Result := ShowModal = mrOk;
end;

end.