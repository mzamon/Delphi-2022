program frmCompetition_p;

uses
  Forms,
  frmCompetition_u in 'frmCompetition_u.pas' {frmCompetition};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompetition, frmCompetition);
  Application.Run;
end.
