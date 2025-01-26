unit frmUserNavigation_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmUserNavigation = class(TForm)
    pnlMain: TPanel;
    btnGetNewWork: TButton;
    btnSubmitWork: TButton;
    btnJoinVideoConference: TButton;
    imgDisplay: TImage;
    btnExit: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure btnJoinVideoConferenceClick(Sender: TObject);
    procedure btnSubmitWorkClick(Sender: TObject);
    procedure btnGetNewWorkClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUserNavigation: TfrmUserNavigation;

implementation

uses frmLogin_u;

{$R *.dfm}

procedure TfrmUserNavigation.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmUserNavigation.btnGetNewWorkClick(Sender: TObject);
var
  tfile : TextFile;
begin
  imgDisplay.Picture.LoadFromFile('bookworm.jpg');
  Sleep(300);

  ShowMessage('Please wait while we send a message to the admin to request new work!');

  AssignFile(tfile,'NEW WORK!' + '.txt');

  Append(tfile);

  CloseFile(tfile);//close file

end;

procedure TfrmUserNavigation.btnJoinVideoConferenceClick(Sender: TObject);
var
  sLink : string;
  sDirect : string;
begin
  imgDisplay.Picture.LoadFromFile('videocall.png');
  Sleep(300);

  sLink := 'https://us04web.zoom.us/j/75344780431?pwd=dDBic1FxZTVQNU5SSkJXK1FwdnBmQT09';
  sDirect :=  InputBox('PLEASE FOLLOW INSTRUCTIONS CLEARLY','To join the video conference please paste the following link into your local browser and the admin shall let you in shortly.',sLink);
  ShowMessage('Thank you! Enjoy your conference');
end;

procedure TfrmUserNavigation.btnSubmitWorkClick(Sender: TObject);
var
  sSubmit : string;
  tfile : TextFile;
begin
  imgDisplay.Picture.LoadFromFile('submitted.jpg');
  Sleep(300);

  sSubmit := InputBox('CAUTION!','Please paste your written work into this input box to be processed','PASTE HERE!');
  AssignFile(tfile,frmLogin.sUsername + '.txt');

  Append(tfile);
  Writeln(tfile,sSubmit);
  CloseFile(tfile);//close file
  ShowMessage('Work Submitted');
end;

procedure TfrmUserNavigation.FormActivate(Sender: TObject);
begin
  frmLogin.Hide;
  imgDisplay.Picture.LoadFromFile('Logo.jpg');
end;

end.
