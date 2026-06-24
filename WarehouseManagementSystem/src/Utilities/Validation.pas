unit Validation;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
  TValidation = class
  public
    class function IsValidEmail(const AEmail: string): Boolean;
    class function IsValidSKU(const ASKU: string): Boolean;
    class function IsPositiveNumber(const AValue: Double): Boolean;
    class function IsValidPhone(const APhone: string): Boolean;
  end;

implementation

class function TValidation.IsValidEmail(const AEmail: string): Boolean;
begin
  Result := TRegEx.IsMatch(AEmail, '^[\w\.-]+@[\w\.-]+\.\w+$');
end;

class function TValidation.IsValidSKU(const ASKU: string): Boolean;
begin
  Result := Length(ASKU) > 0;
end;

class function TValidation.IsPositiveNumber(const AValue: Double): Boolean;
begin
  Result := AValue >= 0;
end;

class function TValidation.IsValidPhone(const APhone: string): Boolean;
begin
  Result := Length(APhone) >= 7; // simple check
end;

end.