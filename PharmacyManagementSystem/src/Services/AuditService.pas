unit AuditService;

interface

uses
  System.SysUtils, AuditRepository;

type
  TAuditService = class
  private
    FRepo: TAuditRepository;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LogAction(AUserID: Integer; const AAction, ADetails, AIPAddress: string);
  end;

implementation

{ TAuditService }

constructor TAuditService.Create;
begin
  FRepo := TAuditRepository.Create;
end;

destructor TAuditService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TAuditService.LogAction(AUserID: Integer; const AAction, ADetails, AIPAddress: string);
begin
  FRepo.LogAction(AUserID, AAction, ADetails, AIPAddress);
end;

end.