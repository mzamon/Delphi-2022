unit clsBankAccount_u;

interface
type
  TBankAccount = class(TObject)
  private
      fAccNumber: string;
      fBalance: real;
  public
	    constructor Create(sAccNumber: string);
      procedure DepositAmount(rDepAmount: real);
		  procedure WithdrawAmount(rAmount: real);
      function GetAccNumber: string ;
      function GetBalance: real;
  end;
  
implementation
{ TBankAccount }

uses SysUtils;

constructor TBankAccount.Create(sAccNumber: string);
begin
  fAccNumber := sAccNumber;
  fBalance := 0;
end;

procedure TBankAccount.DepositAmount(rDepAmount:real);
begin
  if rDepAmount > 0 then
    fBalance := fBalance + rDepAmount;
end;

procedure TBankAccount.WithdrawAmount(rAmount:real);
begin
  if rAmount <= fBalance then
    fBalance := fBalance - rAmount;
end;

function TBankAccount.GetAccNumber:string;
begin
  result := fAccNumber;
end;

function TBankAccount.GetBalance:real;
begin
  result := fBalance;
end;

end.

