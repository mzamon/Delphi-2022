unit AuditRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client,
  RepositoryBase, AuditLog;

type
  TAuditRepository = class(TRepositoryBase)
  public
    procedure LogAction(AUserID: Integer; const AAction, ADetails, AIPAddress: string);
    function GetAuditLogs(ALimit: Integer = 100): TObjectList<TAuditLog>;
    function GetAuditLogsByUser(AUserID: Integer; ALimit: Integer = 100): TObjectList<TAuditLog>;
    function GetAuditLogsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TAuditLog>;
  end;

implementation

{ TAuditRepository }

procedure TAuditRepository.LogAction(AUserID: Integer; const AAction, ADetails, AIPAddress: string);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO AuditLogs (UserID, Action, ActionDate, Details, IPAddress) ' +
                  'VALUES (:UserID, :Action, GETDATE(), :Details, :IPAddress)';
    Q.ParamByName('UserID').AsInteger := AUserID;
    Q.ParamByName('Action').AsString := AAction;
    Q.ParamByName('Details').AsString := ADetails;
    Q.ParamByName('IPAddress').AsString := AIPAddress;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAuditLogs(ALimit: Integer): TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT TOP :Limit AuditID, UserID, Action, ActionDate, Details, IPAddress ' +
                  'FROM AuditLogs ORDER BY ActionDate DESC';
    Q.ParamByName('Limit').AsInteger := ALimit;
    Q.Open;
    while not Q.Eof do
    begin
      var Log := TAuditLog.Create;
      Log.AuditID := Q.FieldByName('AuditID').AsInteger;
      Log.UserID := Q.FieldByName('UserID').AsInteger;
      Log.Action := Q.FieldByName('Action').AsString;
      Log.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Log.Details := Q.FieldByName('Details').AsString;
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAuditLogsByUser(AUserID: Integer; ALimit: Integer): TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT TOP :Limit AuditID, UserID, Action, ActionDate, Details, IPAddress ' +
                  'FROM AuditLogs WHERE UserID = :UserID ORDER BY ActionDate DESC';
    Q.ParamByName('Limit').AsInteger := ALimit;
    Q.ParamByName('UserID').AsInteger := AUserID;
    Q.Open;
    while not Q.Eof do
    begin
      var Log := TAuditLog.Create;
      Log.AuditID := Q.FieldByName('AuditID').AsInteger;
      Log.UserID := Q.FieldByName('UserID').AsInteger;
      Log.Action := Q.FieldByName('Action').AsString;
      Log.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Log.Details := Q.FieldByName('Details').AsString;
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAuditLogsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT AuditID, UserID, Action, ActionDate, Details, IPAddress ' +
                  'FROM AuditLogs WHERE ActionDate BETWEEN :StartDate AND :EndDate ORDER BY ActionDate DESC';
    Q.ParamByName('StartDate').AsDateTime := AStartDate;
    Q.ParamByName('EndDate').AsDateTime := AEndDate;
    Q.Open;
    while not Q.Eof do
    begin
      var Log := TAuditLog.Create;
      Log.AuditID := Q.FieldByName('AuditID').AsInteger;
      Log.UserID := Q.FieldByName('UserID').AsInteger;
      Log.Action := Q.FieldByName('Action').AsString;
      Log.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Log.Details := Q.FieldByName('Details').AsString;
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

end.