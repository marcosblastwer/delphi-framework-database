unit Database.Join;

interface

uses
  Base.Objects,
  Database.Condition,
  Database.Query.Types;

type
  TJoinAttribute = (
    jaNone,
    jaLeft,
    jaRight );

  IJoin = interface(IFrameworkInterface)
    ['{2BC285BD-A89B-4668-9134-B7DD0BE38CA9}']
    function GetAttr: TJoinAttribute;
    function GetConditions: IConditions;
    function GetTable: TTable;
    function SetAttr(const AAttr: TJoinAttribute): IJoin;
    function SetConditions(const AConditions: IConditions): IJoin;
    function SetTable(const ATable: TTable): IJoin;
    property Attr: TJoinAttribute read GetAttr;
    property Table: TTable read GetTable;
    property Conditions: IConditions read GetConditions;
  end;

implementation

type
  TJoin = class(TFrameworkObject, IJoin)
  private
    FAttr: TJoinAttribute;
    FTable: TTable;
    FConditions: IConditions;
    function GetAttr: TJoinAttribute;
    function GetConditions: IConditions;
    function GetTable: TTable;
    function SetAttr(const AAttr: TJoinAttribute): IJoin;
    function SetConditions(const AConditions: IConditions): IJoin;
    function SetTable(const ATable: TTable): IJoin;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TJoin }

constructor TJoin.Create;
begin
  FAttr := jaNone;
  FTable := '';
  FConditions := Objects.New<IConditions>;
end;

destructor TJoin.Destroy;
begin
  if Assigned(FConditions) then
  begin
    try
      FConditions := nil;
    except end;
  end;

  inherited;
end;

function TJoin.GetAttr: TJoinAttribute;
begin
  Result := FAttr;
end;

function TJoin.GetConditions: IConditions;
begin
  Result := FConditions;
end;

function TJoin.GetTable: TTable;
begin
  Result := FTable;
end;

function TJoin.SetAttr(const AAttr: TJoinAttribute): IJoin;
begin
  FAttr := AAttr;
  Result := Self;
end;

function TJoin.SetConditions(const AConditions: IConditions): IJoin;
begin
  FConditions := AConditions;
end;

function TJoin.SetTable(const ATable: TTable): IJoin;
begin
  FTable := ATable;
  Result := Self;
end;

initialization
  Objects.RegisterType<IJoin, TJoin>;

end.
