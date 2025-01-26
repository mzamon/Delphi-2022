unit frmLogin_u;
//Richmond Mzamo Ndlovu 12E PAT 2022
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, frmAdminlogin_u, frmUserNavigation_u, dmRecords_u,
  jpeg;

type
  TfrmLogin = class(TForm)
    pnlLogin: TPanel;
    lblHeading: TLabel;
    ledUserName: TLabeledEdit;
    ledPassword: TLabeledEdit;
    btnContinue: TBitBtn;
    btnTerminate: TBitBtn;
    btnHelp: TBitBtn;
    btnAdministrator: TButton;
    imgDisplay: TImage;
    procedure btnTerminateClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure ContactAministrator {(sText  : string)};
    procedure btnAdministratorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
  private
  //private variables
    sPassword : string;
    sName     : string;
    icount  : Byte;
    { Private declarations }
  public
    sUsername : string;
    sNewUsername  : string;
    sNewPassword  : string;
    sSurname  : string;
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnAdministratorClick(Sender: TObject);
const
  PASSWORD  = 12345;
var
  sPassword : string;
begin
  //encrypt button!
  sPassword := InputBox('PASSWORD','Please enter password','Enter here to continue');

  if sPassword = IntToStr(PASSWORD) then
    begin
      frmAdminLogin.Show;
    end
  else
    begin
      Inc(icount);
      ShowMessage('INCORRECT PASSWORD!' + #13 + '(' + IntToStr(icount) + ')');
      Exit;
    end;

  if icount > 3 then
    Application.Terminate;

 // frmLogin.Hide;
end;

procedure TfrmLogin.btnContinueClick(Sender: TObject);
var
  sUsername : string;
  sPassword : string;
  bUser  : Boolean;
begin
  bUser  := False; //Initialise found
  sUsername := ledUserName.Text;
  sPassword := ledPassword.Text;


  with DataModuleRecords do
    begin
      tblUserLogin.Open;
      tblUserLogin.First;

      while not tblUserLogin.Eof do
        begin
          if (tblUserLogin['UserName'] = sUsername) and (tblUserLogin['Password'] = sPassword) then
            bUser  := True; //Set true when found

          tblUserLogin.Next;
        end; //while

    end; //with

    if bUser = False then
      ShowMessage('Username' + #32 + sUsername + #32 + 'Password ' + sPassword + ' are incorrect! TRY AGAIN!')
    else
      if bUser = True then
      begin
        //Add code for user navigation here
        frmUserNavigation.ShowModal;
        frmLogin.Hide;
      end;
end;

procedure TfrmLogin.btnHelpClick(Sender: TObject);
var
  sNew  : string;
  tFile : TextFile;
begin
  //sNew := Length(1);
  ShowMessage('Please enter username and password! If admin, proceed using aministrator button.');
  //Determine if user has a valid account
  sNew  := InputBox('CAUTION!','Do you have a valid account. Indicates with Yes(Y) or No(N)','N');

  if sNew = 'N' then
    begin
        ContactAministrator;
        AssignFile(tFile,sNewUsername);
        Append(tFile);
        Writeln(sNewUsername);
        Writeln(sNewPassword);
        Writeln(sName);
        Writeln(sSurname + '#');
        CloseFile(tFile); //close file
    end
  else
      begin
        ShowMessage('Pleas login on your account');
        Exit;
      end; //if



end;

procedure TfrmLogin.btnTerminateClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.ContactAministrator;
var
  sInitial  : ShortString;
begin
  //Get the information required from the user
  sName := InputBox('MESSAGE TO ADMIN!','Please enter your name','Koos');
  sInitial := UpCase(sName[1]);
  sSurname  :=  InputBox('MESSAGE TO ADMIN!','Please enter your surname','Koekemooi');
  sNewPassword := 'Password123';
  sNewUsername := sSurname + sInitial; //KOOSK
  ShowMessage('Your credentials will be as followed:' + #13 + 'Username is:' + #9
              + sNewUsername + #13 + 'Default password will be' + #32 + sNewPassword);
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  icount  := 0;
  imgDisplay.Picture.LoadFromFile('Logo.jpg');
end;

end.
