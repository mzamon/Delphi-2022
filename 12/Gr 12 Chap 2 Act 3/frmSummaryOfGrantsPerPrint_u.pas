unit frmSummaryOfGrantsPerPrint_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmSummaryOfGrantsPerPrint = class(TForm)
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSummaryOfGrantsPerPrint: TfrmSummaryOfGrantsPerPrint;

implementation

{$R *.dfm}

procedure TfrmSummaryOfGrantsPerPrint.FormActivate(Sender: TObject);
var
  sPath : string;
begin
  with dmDataModule do
    begin
      conCds.Close;
      sPath := ExtractFilePath(Application.ExeName);
      conCDs.connectionstring := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + 'CD_database.mdb; Mode=ReadWrite;Persist Security Info=False';
      conCDs.LoginPrompt := False;
      conCDs.open();
      tblowners
    end;

end.
