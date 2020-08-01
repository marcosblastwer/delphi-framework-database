unit Validation;

interface

uses
  Base.Objects,
  Validation.Rule;

type
  IValidation = interface(IFrameworkInterface)
    ['{4ADAB2E8-DDDE-45A0-8478-959BB825CF00}']
    function GetRules: IList<IRule>;
    property Rules: IList<IRule> read GetRules;
  end;

  TValidation = class(TFrameworkObject, IValidation)
  private
    FRules: IList<IRule>;
  protected
    procedure AddRule(const Rule: IRule);
    procedure AddRules(const Rules: array of IRule);
    function GetRules: IList<IRule>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property Rules: IList<IRule> read GetRules;
  end;

  Validations = class
  private
    class function Apply(const Rules: IList<IRule>; const Value: Variant; out ErrorMessage: String): Boolean; overload;
    class function Apply(const Rule: IRule; const Value: Variant): Boolean; overload;
    class function ApplyBetween(const Rule: IRule; const Value: Double): Boolean;
    class function ApplyContains(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMaxLength(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMaxOccurrence(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMaxOccurrenceAfter(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMaxOccurrenceBefore(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMinLength(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMinOccurrence(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMinOccurrenceAfter(const Rule: IRule; const Value: String): Boolean;
    class function ApplyMinOccurrenceBefore(const Rule: IRule; const Value: String): Boolean;
    class function ApplyNotContains(const Rule: IRule; const Value: String): Boolean;
    class function Occurrences(const Character: Char; const Source: String): Integer;
  public
    class procedure RegisterValidation<TInterface: IValidation; TImplementation: class>;
    class function &Try<TValidationType: IValidation>(const Value: Variant): Boolean; overload;
    class function &Try<TValidationType: IValidation>(const Value: Variant; out ErrorMessage: String): Boolean; overload;
  end;

implementation

uses
  Base.Converter,
  Base.Value;

{ Validations }

class function Validations.Apply(const Rules: IList<IRule>;
  const Value: Variant; out ErrorMessage: String): Boolean;
var
  R: IRule;
  Valid: Boolean;
begin
  Result := False;
  Valid := True;

  if Rules.Empty then
    Exit;

  for R in Rules.Items do
  begin
    Valid := Valid and Apply(R, Value);

    if not Valid then
    begin
      ErrorMessage := R.ErrorMessage;
      Break;
    end;
  end;
  Result := Valid;
end;

class function Validations.Apply(const Rule: IRule;
  const Value: Variant): Boolean;
begin
  Result := False;

  case Rule.Kind of
    rkBetween: Result := ApplyBetween(Rule, Double(Value));
    rkContains: Result := ApplyContains(Rule, String(Value));
    rkMaxLength: Result := ApplyMaxLength(Rule, String(Value));
    rkMinLength: Result := ApplyMinLength(Rule, String(Value));
    rkMaxOccurrence: Result := ApplyMaxOccurrence(Rule, String(Value));
    rkMaxOccurrenceAfter: Result := ApplyMaxOccurrenceAfter(Rule, String(Value));
    rkmaxOccurrenceBefore: Result := ApplyMaxOccurrenceBefore(Rule, String(Value));
    rkMinOccurrence: Result := ApplyMinOccurrence(Rule, String(Value));
    rkMinOccurrenceAfter: Result := ApplyMinOccurrenceAfter(Rule, String(Value));
    rkMinOccurrenceBefore: Result := ApplyMinOccurrenceBefore(Rule, String(Value));
    rkNotContain: Result := ApplyNotContains(Rule, String(Value));
  end;
end;

class function Validations.ApplyBetween(const Rule: IRule;
  const Value: Double): Boolean;
begin
  Result :=
    (Value >= Double(Rule.Values.First.Value)) and (Value <= Double(Rule.Values.Last.Value));
end;

class function Validations.ApplyContains(const Rule: IRule;
  const Value: String): Boolean;
var
  V: IValue;
begin
  Result := True;

  for V in Rule.Values.Items do
  begin
    Result := Result and (Pos(Value, String(V.Value)) > 0);

    if not Result then
      Break;
  end;
end;

class function Validations.ApplyMaxLength(const Rule: IRule;
  const Value: String): Boolean;
begin
  Result := Length(Value) <= Convert.ToInteger(String(Rule.Values.First.Value));
end;

class function Validations.ApplyMaxOccurrence(const Rule: IRule;
  const Value: String): Boolean;
begin
  Result := Occurrences(Convert.ToChar(String(Rule.Values.First.Value)), Value) <= Rule.Amount;
end;

class function Validations.ApplyMaxOccurrenceAfter(const Rule: IRule;
  const Value: String): Boolean;
var
  P: Integer;
  Sub: String;
begin
  P := Pos(String(Rule.Values.Get(1).Value), Value);
  Sub := Copy(Value, P + 1, Length(Value) - P);

  Result := Occurrences(Convert.ToChar(String(Rule.Values.Get(0).Value)), Sub) <= Rule.Amount;
end;

class function Validations.ApplyMaxOccurrenceBefore(const Rule: IRule;
  const Value: String): Boolean;
var
  P: Integer;
  Sub: String;
begin
  P := Pos(String(Rule.Values.Get(1).Value), Value);
  Sub := Copy(Value, 1, P - 1);

  Result := Occurrences(Convert.ToChar(String(Rule.Values.Get(0).Value)), Sub) <= Rule.Amount;
end;

class function Validations.ApplyMinLength(const Rule: IRule;
  const Value: String): Boolean;
begin
  Result := Length(Value) >= Convert.ToInteger(String(Rule.Values.First.Value));
end;

class function Validations.ApplyMinOccurrence(const Rule: IRule;
  const Value: String): Boolean;
begin
  Result := Occurrences(Convert.ToChar(String(Rule.Values.First.Value)), Value) >= Rule.Amount;
end;

class function Validations.ApplyMinOccurrenceAfter(const Rule: IRule;
  const Value: String): Boolean;
var
  P: Integer;
  Sub: String;
begin
  P := Pos(String(Rule.Values.Get(1).Value), Value);
  Sub := Copy(Value, P + 1, Length(Value) - P);

  Result := Occurrences(Convert.ToChar(String(Rule.Values.Get(0).Value)), Sub) >= Rule.Amount;
end;

class function Validations.ApplyMinOccurrenceBefore(const Rule: IRule;
  const Value: String): Boolean;
var
  P: Integer;
  Sub: String;
begin
  P := Pos(String(Rule.Values.Get(1).Value), Value);
  Sub := Copy(Value, 1, P - 1);

  Result := Occurrences(Convert.ToChar(String(Rule.Values.Get(0).Value)), Sub) >= Rule.Amount;
end;

class function Validations.ApplyNotContains(const Rule: IRule;
  const Value: String): Boolean;
var
  V: IValue;
begin
  Result := True;

  for V in Rule.Values.Items do
  begin
    Result := Result and (Pos(String(V.Value), Value) = 0);

    if not Result then
      Break;
  end;
end;

class function Validations.Occurrences(const Character: Char;
  const Source: String): Integer;
var
  I, Len: Integer;
  Sub: String;
begin
  Result := 0;
  Len := Length(Source);
  if (Len <= 0) or (Character = #0) then
    Exit;
  I := Pos(Character, Source);
  Sub := Source;
  while I > 0 do
  begin
    Result := Result + 1;
    Sub := Copy(Sub, I + 1, Length(Sub) - I);
    I := Pos(Character, Sub);
  end;
end;

class procedure Validations.RegisterValidation<TInterface, TImplementation>;
begin
  Objects.RegisterType<TInterface, TImplementation>;
end;

class function Validations.&Try<TValidationType>(const Value: Variant;
  out ErrorMessage: String): Boolean;
var
  Instance: TValidationType;
begin
  Result := False;

  Instance := Objects.New<TValidationType>;

  if Instance <> nil then
    Result := Apply(Instance.Rules, Value, ErrorMessage);
end;

class function Validations.&Try<TValidationType>(
  const Value: Variant): Boolean;
var
  S: String;
begin
  Result := &Try<TValidationType>(Value, S);
end;

{ TValidation }

procedure TValidation.AddRule(const Rule: IRule);
begin
  FRules.Add(Rule);
end;

procedure TValidation.AddRules(const Rules: array of IRule);
var
  R: IRule;
begin
  for R in Rules do
    FRules.Add(R);
end;

constructor TValidation.Create;
begin
  inherited;
  FRules := Objects.NewList<IRule>;
end;

destructor TValidation.Destroy;
begin
  if Assigned(FRules) then
    try
      FRules.Clear;
      FRules := nil;
    except end;

  inherited;
end;

function TValidation.GetRules: IList<IRule>;
begin
  Result := FRules;
end;

end.
