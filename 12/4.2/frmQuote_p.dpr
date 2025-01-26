program frmQuote_p;

uses
  Forms,
  frmQuote_u in 'frmQuote_u.pas' {frmQuote},
  clsQuote_u in 'clsQuote_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmQuote, frmQuote);
  Application.Run;
end.
