program frmBankAccount_p;

uses
  Forms,
  frmBankAccount_u in 'frmBankAccount_u.pas' {frmBankAccount};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBankAccount, frmBankAccount);
  Application.Run;
end.
