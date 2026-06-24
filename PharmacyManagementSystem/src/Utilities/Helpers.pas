unit Helpers;

interface

uses
  System.SysUtils, System.Classes;

type
  TDateTimeHelper = record
  public
    class function ToShortDateStr(const ADate: TDateTime): string; static;
    class function DaysBetweenDates(const ADate1, ADate2: TDateTime): Integer; static;
  end;

  TStringHelper = record
  public
    class function IsEmptyOrWhiteSpace(const AValue: string): Boolean; static;
    class function Truncate(const AValue: string; AMaxLength: Integer): string; static;
  end;

implementation

{ TDateTimeHelper }

class function TDateTimeHelper.ToShortDateStr(const ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', ADate);
end;

class function TDateTimeHelper.DaysBetweenDates(const ADate1, ADate2: TDateTime): Integer;
begin
  Result := Trunc(ADate2 - ADate1);
end;

{ TStringHelper }

class function TStringHelper.IsEmptyOrWhiteSpace(const AValue: string): Boolean;
begin
  Result := AValue.Trim = '';
end;

class function TStringHelper.Truncate(const AValue: string; AMaxLength: Integer): string;
begin
  if Length(AValue) > AMaxLength then
    Result := Copy(AValue, 1, AMaxLength) + '...'
  else
    Result := AValue;
end;

end.