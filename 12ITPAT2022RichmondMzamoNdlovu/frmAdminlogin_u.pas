unit frmAdminlogin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, dmRecords_u;//, frmAdminNavigation_u;

type
  TfrmAdminLogin = class(TForm)
    pnlLogin: TPanel;
    lblHeading: TLabel;
    ledUserName: TLabeledEdit;
    ledPassword: TLabeledEdit;
    btnContinue: TBitBtn;
    btnTerminate: TBitBtn;
    btnHelp: TBitBtn;
    btnUserScreen: TButton;
    procedure btnTerminateClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnUserScreenClick(Sender: TObject);
  private
    icount  : Byte;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdminLogin: TfrmAdminLogin;

implementation

uses frmLogin_u, frmAdminNavigation_u;

{$R *.dfm}

procedure TfrmAdminLogin.btnContinueClick(Sender: TObject);
var
  sUsername : string;
  sPassword : string;
  bAdmin  : Boolean;
begin
  bAdmin  := False; //Initialise found
  sUsername := ledUserName.Text;
  sPassword := ledPassword.Text;

  with DataModuleRecords do
    begin
      tblAdministratorLogin.Open;
      tblAdministratorLogin.First;

      while not tblAdministratorLogin.Eof do
        begin
          if (tblAdministratorLogin['AministratorUserName'] = sUsername) and (tblAdministratorLogin['Password'] = sPassword) then
            bAdmin  := True; //Set true when found

          tblAdministratorLogin.Next;
        end;  //wile
    end;  //with

    if bAdmin = False then
      begin
        ShowMessage('Username' + #32 + sUsername + #32 + 'Password ' + sPassword + ' are incorrect! TRY AGAIN!');
        //When icount >= 3 terminate
        Inc(icount);
      end
    else
      if bAdmin = True then
      begin
        //Add code for admin navigation here
        frmAdminNavigation.ShowModal;
      end;

    //When icount >= 3 terminate
    if icount >= 3 then
    begin
      ShowMessage('Wrong deatails entered to many times! Thank you for using MZAM!');
      Application.Terminate;
    end;
end;

procedure TfrmAdminLogin.btnHelpClick(Sender: TObject);
begin
  ShowMessage('Pleas loginto your Administrator account')
end;

procedure TfrmAdminLogin.btnTerminateClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmAdminLogin.btnUserScreenClick(Sender: TObject);
begin
  frmAdminLogin.Close;
  frmLogin.Show;
end;

procedure TfrmAdminLogin.FormActivate(Sender: TObject);
begin
  icount  := 0;
  frmLogin.Hide;
end;

end.
