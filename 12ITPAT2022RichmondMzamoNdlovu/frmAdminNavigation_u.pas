unit frmAdminNavigation_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, dmRecords_u, frmAdminlogin_u, frmLogin_u; //add data module

type
  TfrmAdminNavigation = class(TForm)
    pnlMain: TPanel;
    btnClose: TBitBtn;
    btnUsersView: TButton;
    btnAdminView: TButton;
    dbgrdAdmin: TDBGrid;
    btnCheckSubmission: TButton;
    btnAddNewAdmin: TButton;
    btnNewUser: TButton;
    btnbeginvideo: TButton;
    btnremoveuser: TButton;
    btnnewwork: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAdminViewClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnUsersViewClick(Sender: TObject);
    procedure btnCheckSubmissionClick(Sender: TObject);
    procedure btnAddNewAdminClick(Sender: TObject);
    procedure btnNewUserClick(Sender: TObject);
    procedure btnbeginvideoClick(Sender: TObject);
    procedure btnremoveuserClick(Sender: TObject);
    procedure btnnewworkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdminNavigation: TfrmAdminNavigation;

implementation

{$R *.dfm}

procedure TfrmAdminNavigation.btnAddNewAdminClick(Sender: TObject);
var
  sUsername : string;
  sPassword : string;
begin
  sUsername := InputBox('NEW ADMIN!','Please enter new username and new password','enter here');
  sPassword := InputBox('NEW ADMIN!','Please enter new username and new password','enter here');

  with DataModuleRecords do
    begin
      tblAdministratorLogin.Open;
      tblAdministratorLogin.Insert;
      tblAdministratorLogin['AministratorUserName'] := sUsername;
      tblAdministratorLogin['Password'] := sPassword;
      tblAdministratorLogin.Post;
      ShowMessage('new admin ' + sUsername + ' password   ' + sPassword + ' has been added');
    end;//with
end;

procedure TfrmAdminNavigation.btnAdminViewClick(Sender: TObject);
begin
  //connect dbgrid to data source
  dbgrdAdmin.DataSource := DataModuleRecords.dscLogin;

  with DataModuleRecords do
    begin
      {with qryAdmin do
      begin

      end;}
      qryAdmin.Close;
      qryAdmin.SQL.Clear;
      qryAdmin.SQL.Add ('SELECT * FROM tblAdministratorLogin');
      qryAdmin.Open;

    end; //with
end;

procedure TfrmAdminNavigation.btnbeginvideoClick(Sender: TObject);
var
  sLink : string;
begin
  ShowMessage('Please activate video conference by pasting this following link in your internet browswr!');

  sLink := InputBox('CAUTION!','PLEASE COPY THE LINK BELOW','https://askubuntu.com/questions/1410174/how-to-open-zoom-meeting-link-in-firefox-in-ubuntu-22-04');
end;

procedure TfrmAdminNavigation.btnCheckSubmissionClick(Sender: TObject);
var
  bYes  : Boolean;
begin
  bYes  := False;

  with DataModuleRecords do
    begin
      tblSchool.Open;
      tblSchool.First;

      while not tblSchool.Eof do
        begin
          bYes  := False;

          tblSchool.Next;
        end;
    end;
end;

procedure TfrmAdminNavigation.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmAdminNavigation.btnNewUserClick(Sender: TObject);
begin
  with DataModuleRecords do
    begin
      tblUserLogin.Open;
      tblUserLogin.Insert;
      tblUserLogin['UserName'] := frmLogin.sNEWUsername;
      tblUserLogin['Password'] := frmLogin.sNEWPassword;
      tblUserLogin['Surname'] := frmLogin.sSurname;
      tblUserLogin.Post;
      ShowMessage('new user ' + frmLogin.sSurname + ' of username ' + frmLogin.sNEWUsername + ' password   ' + frmLogin.sNEWPassword + ' has been added');
    end;//with
end;

procedure TfrmAdminNavigation.btnnewworkClick(Sender: TObject);
var
  sNew  : string;
  tfile : TextFile;
begin
  sNew  := InputBox('NEW WORK','PLEASE ENTER THE NEW WORK BELOW','');

  AssignFile(tfile,'NEWWORK');

  Reset(tfile);

  Writeln(tfile,sNew);

  CloseFile(tfile);

end;

procedure TfrmAdminNavigation.btnremoveuserClick(Sender: TObject);
var
  sDelete : string;
begin
  sDelete := InputBox('!','Insert the user you want to delete','');
  DataModuleRecords.tblUserLogin.DeleteRecords();
end;

procedure TfrmAdminNavigation.btnUsersViewClick(Sender: TObject);
begin
  dbgrdAdmin.DataSource := DataModuleRecords.dscRecords;
end;

procedure TfrmAdminNavigation.FormActivate(Sender: TObject);
begin
  frmAdminlogin.hide;
end;

end.
