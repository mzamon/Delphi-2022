unit Helpers;

interface

uses
  System.SysUtils, System.Classes;

type
  THelpers = class
  public
    class function FormatCurrency(const AValue: Double): string;
    class function DateTimeToStr(const ADateTime: TDateTime): string;
  end;

implementation

class function THelpers.FormatCurrency(const AValue: Double): string;
begin
  Result := FormatFloat('$#,##0.00', AValue);
end;

class function THelpers.DateTimeToStr(const ADateTime: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', ADateTime);
end;

end.