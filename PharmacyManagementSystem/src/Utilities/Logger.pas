unit Logger;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.SyncObjs;

type
  TLogger = class
  private
    class var FInstance: TLogger;
    class var FCriticalSection: TCriticalSection;
    FLogFile: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: TLogger;
    procedure Log(const AMessage: string);
    procedure SetLogFile(const AFileName: string);
  end;

implementation

{ TLogger }

constructor TLogger.Create;
begin
  inherited Create;
  FLogFile := 'pharmacy_log.txt';
end;

destructor TLogger.Destroy;
begin
  inherited;
end;

class function TLogger.GetInstance: TLogger;
begin
  if FInstance = nil then
  begin
    FCriticalSection := TCriticalSection.Create;
    FCriticalSection.Enter;
    try
      if FInstance = nil then
        FInstance := TLogger.Create;
    finally
      FCriticalSection.Leave;
    end;
  end;
  Result := FInstance;
end;

procedure TLogger.Log(const AMessage: string);
var
  LogEntry: string;
begin
  LogEntry := Format('[%s] %s', [DateTimeToStr(Now), AMessage]);
  TFile.AppendAllText(FLogFile, LogEntry + sLineBreak);
end;

procedure TLogger.SetLogFile(const AFileName: string);
begin
  FLogFile := AFileName;
end;

initialization
  TLogger.FInstance := nil;

finalization
  TLogger.FInstance.Free;
  TLogger.FCriticalSection.Free;

end.