unit AuditLog;

interface

type
  TAuditLog = class
  private
    FAuditID: Integer;
    FUserID: Integer;
    FAction: string;
    FActionDate: TDateTime;
    FIPAddress: string;
  public
    constructor Create; overload;
    constructor Create(AAuditID, AUserID: Integer; const AAction: string;
      AActionDate: TDateTime; const AIPAddress: string); overload;

    property AuditID: Integer read FAuditID write FAuditID;
    property UserID: Integer read FUserID write FUserID;
    property Action: string read FAction write FAction;
    property ActionDate: TDateTime read FActionDate write FActionDate;
    property IPAddress: string read FIPAddress write FIPAddress;
  end;

implementation

uses
  System.SysUtils;

{ TAuditLog }

constructor TAuditLog.Create;
begin
  FAuditID := 0;
  FActionDate := Now;
end;

constructor TAuditLog.Create(AAuditID, AUserID: Integer; const AAction: string;
  AActionDate: TDateTime; const AIPAddress: string);
begin
  FAuditID := AAuditID;
  FUserID := AUserID;
  FAction := AAction;
  FActionDate := AActionDate;
  FIPAddress := AIPAddress;
end;

end.