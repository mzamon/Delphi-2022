unit Validation;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
  TValidation = class
  public
    class function IsValidEmail(const AEmail: string): Boolean;
    class function IsValidPhone(const APhone: string): Boolean;
    class function IsValidBarcode(const ABarcode: string): Boolean;
    class function IsValidDate(const ADate: TDateTime): Boolean;
  end;

implementation

{ TValidation }

class function TValidation.IsValidEmail(const AEmail: string): Boolean;
begin
  Result := TRegEx.IsMatch(AEmail, '^[\w\.\-]+@[a-zA-Z\d\-]+(\.[a-zA-Z\d\-]+)*\.[a-zA-Z]{2,}$');
end;

class function TValidation.IsValidPhone(const APhone: string): Boolean;
begin
  Result := TRegEx.IsMatch(APhone, '^[\d\+\-\(\)\s]+$');
end;

class function TValidation.IsValidBarcode(const ABarcode: string): Boolean;
begin
  Result := (ABarcode.Trim <> '') and (Length(ABarcode) <= 50);
end;

class function TValidation.IsValidDate(const ADate: TDateTime): Boolean;
begin
  Result := (ADate <> 0) and (not IsNan(ADate));
end;

end.