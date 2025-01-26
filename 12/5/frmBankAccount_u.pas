unit frmBankAccount_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, clsBankAccount_u, Math;

type
  TfrmBankAccount = class(TForm)
    pnlBankAccount: TPanel;
    btnClose: TBitBtn;
    btnReset: TBitBtn;
    grpTransactions: TGroupBox;
    grpViewInformation: TGroupBox;
    ledAmount: TLabeledEdit;
    btnDeposit: TButton;
    btnWithdraw: TButton;
    memDisplay: TMemo;
    edtAccountNumber: TEdit;
    lblAccountNumber: TLabel;
    btnBalance: TButton;
    btnCreate: TButton;
    btnDetails: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
  private
    fAccNumber  : string;
    fBalance  : Real;
    objBankAcc: TBankAccount ;
    { Private declarations }
  public
    constructor create(sAccNumber : string);
    procedure DepositAmount(rDepAmount  : Real);
    procedure WithdrawAmount(rAmount  : Real);
    function GetAccNumber: string;
    function GetBalance: real;
    { Public declarations }
  end;

var
  frmBankAccount: TfrmBankAccount;

implementation

{$R *.dfm}

procedure TfrmBankAccount.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmBankAccount.btnCreateClick(Sender: TObject);
begin
  grpViewInformation.Show;
  grpTransactions.Show;

  objBankAcc  := TBankAccount.Create(edtAccountNumber);
  GetAccNumber;

  { With obj do
    begin
      rde
    end;  }
end;

procedure TfrmBankAccount.btnDetailsClick(Sender: TObject);
begin
  btnBalance.Enabled  := True;
  memDisplay.Lines.Add('Bank Account Details' + #13);
  memDisplay.Lines.Add('Account Number: ' + fAccNumber);
end;

procedure TfrmBankAccount.btnResetClick(Sender: TObject);
begin
  grpViewInformation.Hide;
  grpTransactions.Hide;
  memDisplay.Lines.Clear;
  edtAccountNumber.Clear;
  objBankAcc.Free;
  edtAccountNumber.SetFocus;//End line
end;

constructor TfrmBankAccount.create(sAccNumber: string);
begin
  fAccNumber  := sAccNumber;
  fBalance  := 0;
end;

procedure TfrmBankAccount.DepositAmount(rDepAmount: Real);
begin
  if rDepAmount > 0 then
    fBalance  := fBalance + rDepAmount;
end;

procedure TfrmBankAccount.FormActivate(Sender: TObject);
begin
  edtAccountNumber.Clear;
  grpViewInformation.Hide;
  grpTransactions.Hide;
  btnBalance.Enabled  := False;
  edtAccountNumber.SetFocus;//End line
end;

function TfrmBankAccount.GetAccNumber: string;
begin
  Result  :=  fAccNumber;
end;

function TfrmBankAccount.GetBalance: real;
begin
  Result  := fBalance;
end;

procedure TfrmBankAccount.WithdrawAmount(rAmount: Real);
begin
  if rAmount > 0 then
    fBalance  := fBalance - rAmount;
end;

end.
