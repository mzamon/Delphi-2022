unit frmQuote_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, clsQuote_u, XPMan;

type
  TfrmQuote = class(TForm)
    pnlInput: TPanel;
    lblLength: TLabel;
    edtLength: TEdit;
    pnlOutput: TPanel;
    bmbGenerateQuote: TBitBtn;
    bmbReset: TBitBtn;
    bmbClose: TBitBtn;
    lblWidth: TLabel;
    edtWidth: TEdit;
    redOutput: TRichEdit;
    procedure bmbResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bmbCloseClick(Sender: TObject);
    procedure bmbGenerateQuoteClick(Sender: TObject);
  private
     objQuote : TQuoteCalculator;
  public
    { Public declarations }
  end;

var
  frmQuote: TfrmQuote;

implementation

{$R *.dfm}

procedure TfrmQuote.bmbCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmQuote.bmbGenerateQuoteClick(Sender: TObject);
var
  rLength : string;
begin
  with clsQuote_u do
  begin
    SetLength(rLength);
    edtWidth.Text := rLength;
  end;

  redOutput.Lines.Add('Quote for tiling a room');
end;

procedure TfrmQuote.bmbResetClick(Sender: TObject);
begin
  edtLength.Clear;
  edtWidth.Clear;
  redOutput.Clear;
  edtLength.SetFocus;
end;

procedure TfrmQuote.FormCreate(Sender: TObject);
begin
   redOutput.Paragraph.Tabcount := 1;
   redOutput.Paragraph.Tab[0] := 200;
   redOutput.SelAttributes.Name := 'Lucida Console';
   redOutput.SelAttributes.Size := 10;
end;

end.
