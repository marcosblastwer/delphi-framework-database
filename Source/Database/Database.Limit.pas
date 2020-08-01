unit Database.Limit;

interface

uses
  Base.Objects;

type
  TLimitAttr = (
    laBottom,
    laPercent,
    laTop );
  TLimitAttrs = set of TLimitAttr;


  ILimit = interface(IFrameworkInterface)
    ['{B2D61A52-9693-40A4-A00B-00D3823AD7DB}']
    function GetAttr: TLimitAttrs;
    function GetOffset: IFrameworkInterface;
    function GetRowCount: IFrameworkInterface;
    function SetAttr(const Value: TLimitAttr): ILimit; overload;
    function SetAttr(const Value: TLimitAttrs): ILimit; overload;
    function SetRowCount(const Value: IFrameworkInterface): ILimit;
    function SetOffset(const Value: IFrameworkInterface): ILimit;
    property Attr: TLimitAttrs read GetAttr;
    property RowCount: IFrameworkInterface read GetRowCount;
    property Offset: IFrameworkInterface read GetOffset;
  end;

implementation

type
  TLimit = class(TFrameworkObject, ILimit)
  private
    FAttr: TLimitAttrs;
    FRowCount,
    FOffset: IFrameworkInterface;
    function GetAttr: TLimitAttrs;
    function GetOffset: IFrameworkInterface;
    function GetRowCount: IFrameworkInterface;
    function SetAttr(const Value: TLimitAttr): ILimit; overload;
    function SetAttr(const Value: TLimitAttrs): ILimit; overload;
    function SetRowCount(const Value: IFrameworkInterface): ILimit;
    function SetOffset(const Value: IFrameworkInterface): ILimit;
  public
    constructor Create;
  end;

{ TLimit }

constructor TLimit.Create;
begin
  inherited;
  FAttr := [];
  FRowCount := nil;
  FOffset := nil;
end;

function TLimit.GetAttr: TLimitAttrs;
begin
  Result := FAttr;
end;

function TLimit.GetOffset: IFrameworkInterface;
begin
  Result := FOffset;
end;

function TLimit.GetRowCount: IFrameworkInterface;
begin
  Result := FRowCount;
end;

function TLimit.SetAttr(const Value: TLimitAttr): ILimit;
begin
  FAttr := FAttr + [Value];
  Result := Self;
end;

function TLimit.SetAttr(const Value: TLimitAttrs): ILimit;
begin
  FAttr := Value;
  Result := Self;
end;

function TLimit.SetOffset(const Value: IFrameworkInterface): ILimit;
begin
  FOffset := Value;
  Result := Self;
end;

function TLimit.SetRowCount(const Value: IFrameworkInterface): ILimit;
begin
  FRowCount := Value;
  Result := Self;
end;

initialization
  Objects.RegisterType<ILimit, TLimit>;

end.
