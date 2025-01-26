unit frmCompetition_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmCompetition = class(TForm)
    redOutput: TRichEdit;
    btnReadDisplay: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnReadDisplayClick(Sender: TObject);
const
  MAX = 20;
type
  TArrNumbers = array[1..MAX] of Integer;
  private
    arrWithDup : TArrNumbers;
    iCount  : Integer;
    procedure Display (sHeading : string; arrDisplay  : TArrNumbers; iNoOfElements  : Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCompetition: TfrmCompetition;

implementation

{$R *.dfm}

procedure TfrmCompetition.btnReadDisplayClick(Sender: TObject);
var
  tfNumbers : TextFile;
begin
  AssignFile(tfNumbers,'Numbers.txt');
  Reset(tfNumbers);
  iCount  := 1;
  while not Eof(tfNumbers) and (iCount <= MAX) do
    begin
      iCount  :=  iCount + 1;
      Readln(tfNumbers, arrWithDup[iCount]);

    end;//While

  Display('Original list: ', arrWithDup, icount);

  CloseFile(tfNumbers);
end;

procedure TfrmCompetition.Display(sHeading: string; arrDisplay: TArrNumbers;
  iNoOfElements: Integer);
var
  K : Integer;
begin
 /////
  redOutput.Lines.Clear;
  redOutput.Lines.Add(sHeading);
  for K := 1 to iNoOfElements do
    redOutput.Lines.Add(IntToStr(arrDisplay[K]));
 ////
 end;

procedure TfrmCompetition.FormActivate(Sender: TObject);
begin
  redOutput.Lines.Clear;
end;

end.
