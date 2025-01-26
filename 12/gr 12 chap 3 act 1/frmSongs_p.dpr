program frmSongs_p;

uses
  Forms,
  frmSongs_u in 'frmSongs_u.pas' {frmSongs};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSongs, frmSongs);
  Application.Run;
end.
