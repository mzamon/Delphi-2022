unit AuditRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  RepositoryBase, AuditLog;

type
  TAuditRepository = class(TRepositoryBase)
  public
    function GetAuditByID(AAuditID: Integer): TAuditLog;
    function GetAuditsByUser(AUserID: Integer): TObjectList<TAuditLog>;
    function GetAuditsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TAuditLog>;
    function GetAllAudits: TObjectList<TAuditLog>;
    function InsertAudit(AAudit: TAuditLog): Integer; // returns new AuditID
    procedure DeleteAudit(AAuditID: Integer);
  end;

implementation

{ TAuditRepository }

function TAuditRepository.GetAuditByID(AAuditID: Integer): TAuditLog;
var
  Q: TFDQuery;
begin
  Result := nil;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT AuditID, UserID, Action, ActionDate, IPAddress FROM AuditLogs WHERE AuditID = :AuditID';
    Q.ParamByName('AuditID').AsInteger := AAuditID;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := TAuditLog.Create;
      Result.AuditID := Q.FieldByName('AuditID').AsInteger;
      Result.UserID := Q.FieldByName('UserID').AsInteger;
      Result.Action := Q.FieldByName('Action').AsString;
      Result.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Result.IPAddress := Q.FieldByName('IPAddress').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAuditsByUser(AUserID: Integer): TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT AuditID, UserID, Action, ActionDate, IPAddress FROM AuditLogs WHERE UserID = :UserID ORDER BY ActionDate DESC';
    Q.ParamByName('UserID').AsInteger := AUserID;
    Q.Open;
    while not Q.Eof do
    begin
      var Log := TAuditLog.Create;
      Log.AuditID := Q.FieldByName('AuditID').AsInteger;
      Log.UserID := Q.FieldByName('UserID').AsInteger;
      Log.Action := Q.FieldByName('Action').AsString;
      Log.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAuditsByDateRange(AStartDate, AEndDate: TDateTime): TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT AuditID, UserID, Action, ActionDate, IPAddress FROM AuditLogs ' +
                  'WHERE ActionDate BETWEEN :StartDate AND :EndDate ORDER BY ActionDate DESC';
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
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.GetAllAudits: TObjectList<TAuditLog>;
var
  Q: TFDQuery;
begin
  Result := TObjectList<TAuditLog>.Create(True);
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'SELECT AuditID, UserID, Action, ActionDate, IPAddress FROM AuditLogs ORDER BY ActionDate DESC';
    Q.Open;
    while not Q.Eof do
    begin
      var Log := TAuditLog.Create;
      Log.AuditID := Q.FieldByName('AuditID').AsInteger;
      Log.UserID := Q.FieldByName('UserID').AsInteger;
      Log.Action := Q.FieldByName('Action').AsString;
      Log.ActionDate := Q.FieldByName('ActionDate').AsDateTime;
      Log.IPAddress := Q.FieldByName('IPAddress').AsString;
      Result.Add(Log);
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TAuditRepository.InsertAudit(AAudit: TAuditLog): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'INSERT INTO AuditLogs (UserID, Action, ActionDate, IPAddress) ' +
                  'VALUES (:UserID, :Action, :ActionDate, :IPAddress); ' +
                  'SELECT SCOPE_IDENTITY() AS NewID';
    Q.ParamByName('UserID').AsInteger := AAudit.UserID;
    Q.ParamByName('Action').AsString := AAudit.Action;
    Q.ParamByName('ActionDate').AsDateTime := AAudit.ActionDate;
    Q.ParamByName('IPAddress').AsString := AAudit.IPAddress;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('NewID').AsInteger;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TAuditRepository.DeleteAudit(AAuditID: Integer);
var
  Q: TFDQuery;
begin
  if AAuditID <= 0 then
    raise Exception.Create('Invalid Audit ID.');
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.SQL.Text := 'DELETE FROM AuditLogs WHERE AuditID = :AuditID';
    Q.ParamByName('AuditID').AsInteger := AAuditID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.