unit clsEmployee_u;

interface

uses
  SysUtils ;

const
  MaxHours = 160 ;

type
   TEmployee = class(TObject)
   private
    fName : string ;
    fHours: Integer;
    fRatePerHour : Real;
public
    constructor Create(sName: string; iHours: Integer ; rRatePerHour: Real) ;
    function CalcBasicSalary: Real ;
    function CalcBonus : Real ;
    function CalcTotalSalary : Real ;
    function ToString : string ;

end;

implementation

{ TEmployee }

function TEmployee.CalcBasicSalary: Real;
begin
  Result:= fHours*fRatePerHour ;
end;

function TEmployee.CalcBonus: Real;
var
  iHoursExceed : Integer;
begin
   if (fHours > MaxHours) then
   begin
     iHoursExeed := fHours - MaxHours;
     iHoursExceed := iHours - MaxHours ;
   end
   else  iHoursExceed := 0;

   Result:= 2*fRatePerHour*iHoursExceed ;
end;

function TEmployee.CalcTotalSalary: Real;
begin
   Result:= CalcBasicSalary + CalcBonus ;
end;

constructor TEmployee.Create(sName: string; iHours: Integer;
  rRatePerHour: Real);
begin

   fName := sName ;
   fRatePerHour:= rRatePerHour ;
   fHours := iHours;
end;

function TEmployee.ToString: string;
begin
   Result:=
end;

end.
