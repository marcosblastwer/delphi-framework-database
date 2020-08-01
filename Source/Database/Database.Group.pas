unit Database.Group;

interface

uses
  Base.Objects;

type
  TGroupAttr = (
    gaNone,
    gaAsc,
    gaDesc );

  IGroup = interface(IFrameworkInterface)
    ['{60BBB931-8DFA-4115-A3B4-336063379B84}']
    function GetAttr: TGroupAttr;
    function GetValue: IFrameworkInterface;
    function SetAttr(const Value: TGroupAttr): IGroup;
    function SetValue(const AValue: IFrameworkInterface): IGroup;
    property Attr: TGroupAttr read GetAttr;
    property Value: IFrameworkInterface read GetValue;
  end;

implementation

type
  TGroup = class(TFrameworkObject, IGroup)
  private
    FAttr: TGroupAttr;
    FValue: IFrameworkInterface;
    function GetAttr: TGroupAttr;
    function GetValue: IFrameworkInterface;
    function SetAttr(const Value: TGroupAttr): IGroup;
    function SetValue(const AValue: IFrameworkInterface): IGroup;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TGroup }

constructor TGroup.Create;
begin
  inherited;
  FAttr := gaNone;
  FValue := nil;
end;

destructor TGroup.Destroy;
begin
  if Assigned(FValue) then
  begin
    try
      FValue := nil;
    except end;
  end;

  inherited;
end;

function TGroup.GetAttr: TGroupAttr;
begin
  Result := FAttr;
end;

function TGroup.GetValue: IFrameworkInterface;
begin
  Result := FValue;
end;

function TGroup.SetAttr(const Value: TGroupAttr): IGroup;
begin
  FAttr := Value;
  Result := Self;
end;

function TGroup.SetValue(const AValue: IFrameworkInterface): IGroup;
begin
  FValue := AValue;
  Result := Self;
end;

initialization
  Objects.RegisterType<IGroup, TGroup>;

end.
