unit Database.Fieldset;

interface

uses
  Base.Objects,
  Base.Value;

type
  IFieldset = interface(IFrameworkInterface)
    ['{601B5681-69F2-419C-BCE0-61AE1C099978}']
    function GetField: IValue;
    function GetValue: IFrameworkInterface;
    function SetField(const AField: IValue): IFieldset;
    function SetValue(const AValue: IFrameworkInterface): IFieldset;
    property Field: IValue read GetField;
    property Value: IFrameworkInterface read GetValue;
  end;

implementation

type
  TFieldset = class(TFrameworkObject, IFieldset)
  private
    FField: IValue;
    FValue: IFrameworkInterface;
    function GetField: IValue;
    function GetValue: IFrameworkInterface;
    function SetField(const AField: IValue): IFieldset;
    function SetValue(const AValue: IFrameworkInterface): IFieldset;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TFieldset }

constructor TFieldset.Create;
begin
  inherited;
  FField := nil;
  FValue := nil;
end;

destructor TFieldset.Destroy;
begin
  if Assigned(FField) then
  begin
    try
      FField := nil;
    except end;
  end;

  if Assigned(FValue) then
  begin
    try
      FValue := nil;
    except end;
  end;

  inherited;
end;

function TFieldset.GetField: IValue;
begin
  Result := FField;
end;

function TFieldset.GetValue: IFrameworkInterface;
begin
  Result := FValue;
end;

function TFieldset.SetField(const AField: IValue): IFieldset;
begin
  FField := AField;
  Result := Self;
end;

function TFieldset.SetValue(const AValue: IFrameworkInterface): IFieldset;
begin
  FValue := AValue;
  Result := Self;
end;

initialization
  Objects.RegisterType<IFieldset, TFieldset>;

end.
