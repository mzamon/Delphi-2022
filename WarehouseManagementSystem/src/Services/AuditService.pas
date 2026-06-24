unit AuditService;

interface

uses
  System.SysUtils, AuditLog, AuditRepository;

type
  TAuditService = class
  private
    FRepo: TAuditRepository;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LogAction(AUserID: Integer; const AAction: string; const AIP: string = '');
    function GetAuditLogs: TObjectList<TAuditLog>;
  end;

implementation

{ TAuditService }

constructor TAuditService.Create;
begin
  inherited;
  FRepo := TAuditRepository.Create;
end;

destructor TAuditService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TAuditService.LogAction(AUserID: Integer; const AAction: string; const AIP: string = '');
var
  Log: TAuditLog;
begin
  Log := TAuditLog.Create;
  Log.UserID := AUserID;
  Log.Action := AAction;
  Log.ActionDate := Now;
  Log.IPAddress := AIP;
  FRepo.InsertAudit(Log);
  Log.Free;
end;

function TAuditService.GetAuditLogs: TObjectList<TAuditLog>;
begin
  Result := FRepo.GetAllAudits;
end;

end.