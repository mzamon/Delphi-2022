unit Category;

interface

type
  TCategory = class
  private
    FCategoryID: Integer;
    FCategoryName: string;
  public
    constructor Create; overload;
    constructor Create(ACategoryID: Integer; const ACategoryName: string); overload;

    property CategoryID: Integer read FCategoryID write FCategoryID;
    property CategoryName: string read FCategoryName write FCategoryName;
  end;

implementation

{ TCategory }

constructor TCategory.Create;
begin
  FCategoryID := 0;
end;

constructor TCategory.Create(ACategoryID: Integer; const ACategoryName: string);
begin
  FCategoryID := ACategoryID;
  FCategoryName := ACategoryName;
end;

end.