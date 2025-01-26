program frmLogin_p;

uses
  Forms,
  frmLogin_u in 'frmLogin_u.pas' {frmLogin},
  frmAdminlogin_u in 'frmAdminlogin_u.pas' {frmAdminLogin},
  dmRecords_u in 'dmRecords_u.pas' {DataModuleRecords: TDataModule},
  frmAdminNavigation_u in 'frmAdminNavigation_u.pas' {frmAdminNavigation},
  frmUserNavigation_u in 'frmUserNavigation_u.pas' {frmUserNavigation};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmAdminLogin, frmAdminLogin);
  Application.CreateForm(TDataModuleRecords, DataModuleRecords);
  Application.CreateForm(TfrmAdminNavigation, frmAdminNavigation);
  Application.CreateForm(TfrmUserNavigation, frmUserNavigation);
  Application.Run;
end.
