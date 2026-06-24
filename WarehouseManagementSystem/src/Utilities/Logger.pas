unit Logger;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils;

type
  TLogger = class
  private
    class var FInstance: TLogger;
    FLogFile: string;
  public
    constructor Create;
    class function GetInstance: TLogger;
    procedure Log(const AMessage: string);
  end;

implementation

{ TLogger }

constructor TLogger.Create;
begin
  inherited;
  FLogFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'wms.log');
end;

class function TLogger.GetInstance: TLogger;
begin
  if FInstance = nil then
    FInstance := TLogger.Create;
  Result := FInstance;
end;

procedure TLogger.Log(const AMessage: string);
var
  F: TextFile;
begin
  AssignFile(F, FLogFile);
  if FileExists(FLogFile) then Append(F) else Rewrite(F);
  Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + AMessage);
  CloseFile(F);
end;

end.