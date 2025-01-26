program frmEmployee_p;

uses
  Forms,
  frmEmployee_u in 'frmEmployee_u.pas' {frmEmployee};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmEmployee, frmEmployee);
  Application.Run;
end.
