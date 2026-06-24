unit RepositoryBase;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
  dmDatabase, Logger;

type
  TRepositoryBase = class abstract
  private
    FConnection: TFDConnection;
    FTransaction: TFDTransaction;
  protected
    function GetConnection: TFDConnection;
    function GetTransaction: TFDTransaction;
    procedure LogError(const AMethod, AMessage: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure BeginTransaction;
    procedure CommitTransaction;
    procedure RollbackTransaction;

    property Connection: TFDConnection read GetConnection;
    property Transaction: TFDTransaction read GetTransaction;
  end;

implementation

{ TRepositoryBase }

constructor TRepositoryBase.Create;
begin
  inherited Create;
  FConnection := dmDatabase.dmDatabase.FDConnection;
  FTransaction := dmDatabase.dmDatabase.FDTransaction;
end;

destructor TRepositoryBase.Destroy;
begin
  inherited;
end;

function TRepositoryBase.GetConnection: TFDConnection;
begin
  if FConnection = nil then
    raise Exception.Create('Database connection not initialized.');
  Result := FConnection;
end;

function TRepositoryBase.GetTransaction: TFDTransaction;
begin
  if FTransaction = nil then
    raise Exception.Create('Transaction object not initialized.');
  Result := FTransaction;
end;

procedure TRepositoryBase.BeginTransaction;
begin
  if not GetTransaction.Active then
    GetTransaction.StartTransaction;
end;

procedure TRepositoryBase.CommitTransaction;
begin
  if GetTransaction.Active then
    GetTransaction.Commit;
end;

procedure TRepositoryBase.RollbackTransaction;
begin
  if GetTransaction.Active then
    GetTransaction.Rollback;
end;

procedure TRepositoryBase.LogError(const AMethod, AMessage: string);
begin
  TLogger.GetInstance.Log(Format('[%s] %s', [AMethod, AMessage]));
end;

end.