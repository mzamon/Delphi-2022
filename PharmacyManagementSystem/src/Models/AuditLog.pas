unit AuditLog;

interface

uses
  System.SysUtils;

type
  TAuditLog = class
  private
    FAuditID: Integer;
    FUserID: Integer;
    FAction: string;
    FActionDate: TDateTime;
    FDetails: string;
    FIPAddress: string;
  public
    constructor Create; overload;
    constructor Create(AAuditID, AUserID: Integer; const AAction: string;
      AActionDate: TDateTime; const ADetails, AIPAddress: string); overload;

    property AuditID: Integer read FAuditID write FAuditID;
    property UserID: Integer read FUserID write FUserID;
    property Action: string read FAction write FAction;
    property ActionDate: TDateTime read FActionDate write FActionDate;
    property Details: string read FDetails write FDetails;
    property IPAddress: string read FIPAddress write FIPAddress;
  end;

implementation

{ TAuditLog }

constructor TAuditLog.Create;
begin
  FAuditID := 0;
  FActionDate := Now;
end;

constructor TAuditLog.Create(AAuditID, AUserID: Integer; const AAction: string;
  AActionDate: TDateTime; const ADetails, AIPAddress: string);
begin
  FAuditID := AAuditID;
  FUserID := AUserID;
  FAction := AAction;
  FActionDate := AActionDate;
  FDetails := ADetails;
  FIPAddress := AIPAddress;
end;

end.