unit frmSongs_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, Math;
const
  MAXSONGS  = 11;
type
  TfrmSongs = class(TForm)
    pnlDisplay: TPanel;
    redOutput: TRichEdit;
    btnPlaceSong: TButton;
    bmbClose: TBitBtn;
    lblSong: TLabel;
    edtSong: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure btnPlaceSongClick(Sender: TObject);
    procedure bmbCloseClick(Sender: TObject);

  private
  arrSongs  : array[1..MAXSONGS]of Integer;
  arrVotes  : array[1..2]of Integer;
  arrTotals  : array[1..2]of Integer;
  tFile : TextFile;
  iCount :  Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSongs: TfrmSongs;

implementation

{$R *.dfm}

procedure TfrmSongs.bmbCloseClick(Sender: TObject);
begin
  redOutput.Lines.Clear;
  Sleep(500);
  Application.Terminate;
end;

procedure TfrmSongs.btnPlaceSongClick(Sender: TObject);
var
  iInsertPos, K, iMost  : Integer;
  sNewSong  : string;
begin
  for K := 1 to 100 do
    arrVotes[K] := RandomRange(1,12);
  sNewSong  := edtSong.Text;

  //Count votes
  
end;

procedure TfrmSongs.FormActivate(Sender: TObject);
begin
  AssignFile(tFile, 'Songs.txt');
  Reset(tFile);
  icount := 0;
  redOutput.Lines.Add('List of songs');
  while not Eof(tfile) do
    begin
      Inc(iCount);
      Readln(tFile,arrSongs[iCount]);
      redOutput.Lines.Add(IntToStr(iCount)+'.' + #9 + arrSongs[iCount]);
    end;
    CloseFile(tFile);
end;

end.
