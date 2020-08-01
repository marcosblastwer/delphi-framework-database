unit Database.Order;

interface

uses
  Base.Objects;

type
  TOrderAttr = (
    oaNone,
    oaAsc,
    oaDesc );

  IOrder = interface(IFrameworkInterface)
    ['{60BBB931-8DFA-4115-A3B4-336063379B84}']
    function GetAttr: TOrderAttr;
    function GetValue: IFrameworkInterface;
    function SetAttr(const Value: TOrderAttr): IOrder;
    function SetValue(const AValue: IFrameworkInterface): IOrder;
    property Attr: TOrderAttr read GetAttr;
    property Value: IFrameworkInterface read GetValue;
  end;

implementation

type
  TOrder = class(TFrameworkObject, IOrder)
  private
    FAttr: TOrderAttr;
    FValue: IFrameworkInterface;
    function GetAttr: TOrderAttr;
    function GetValue: IFrameworkInterface;
    function SetAttr(const Value: TOrderAttr): IOrder;
    function SetValue(const AValue: IFrameworkInterface): IOrder;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TOrder }

constructor TOrder.Create;
begin
  inherited;
  FAttr := oaNone;
  FValue := nil;
end;

destructor TOrder.Destroy;
begin
  if Assigned(FValue) then
  begin
    try
      FValue := nil;
    except end;
  end;

  inherited;
end;

function TOrder.GetAttr: TOrderAttr;
begin
  Result := FAttr;
end;

function TOrder.GetValue: IFrameworkInterface;
begin
  Result := FValue;
end;

function TOrder.SetAttr(const Value: TOrderAttr): IOrder;
begin
  FAttr := Value;
  Result := Self;
end;

function TOrder.SetValue(const AValue: IFrameworkInterface): IOrder;
begin
  FValue := AValue;
  Result := Self;
end;

end.
