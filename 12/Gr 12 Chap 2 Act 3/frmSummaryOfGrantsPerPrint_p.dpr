program frmSummaryOfGrantsPerPrint_p;

uses
  Forms,
  frmSummaryOfGrantsPerPrint_u in 'frmSummaryOfGrantsPerPrint_u.pas' {frmSummaryOfGrantsPerPrint};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSummaryOfGrantsPerPrint, frmSummaryOfGrantsPerPrint);
  Application.Run;
end.
