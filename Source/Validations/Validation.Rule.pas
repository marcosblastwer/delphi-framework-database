unit Validation.Rule;

interface

uses
  Base.Objects,
  Base.Value;

type
  TRuleKind = (
    rkNone,
    rkBetween,
    rkContains,
    rkMaxLength,
    rkMinLength,
    rkMaxOccurrence,
    rkMaxOccurrenceAfter,
    rkmaxOccurrenceBefore,
    rkMinOccurrence,
    rkMinOccurrenceAfter,
    rkMinOccurrenceBefore,
    rkNotContain );

  IRule = interface(IFrameworkInterface)
    ['{80DCD008-0A01-49FB-ABF9-2751038FDE23}']
    function After(const Character: Char): IRule;
    function Before(const Character: Char): IRule;
    function WithErrorMessage(const Value: String): IRule;
    function GetAmount: Integer;
    function GetErrorMessage: String;
    function GetKind: TRuleKind;
    function GetValues: IList<IValue>;
    property Kind: TRuleKind read GetKind;
    property Values: IList<IValue> read GetValues;
    property Amount: Integer read GetAmount;
    property ErrorMessage: String read GetErrorMessage;
  end;

  Rule = class
    class function Between(const FirstValue, SecondValue: Integer): IRule; overload;
    class function Between(const FirstDate, SecondDate: TDateTime): IRule; overload;
    class function Contains(const Character: Char): IRule; overload;
    class function Contains(const Chars: array of Char): IRule; overload;
    class function Contains(const Text: String): IRule; overload;
    class function Contains(const Texts: array of String): IRule; overload;
    class function MaxLength(const Value: Integer): IRule;
    class function MaxOccurrence(const Character: Char; const Max: Integer): IRule;
    class function MinLength(const Value: Integer): IRule;
    class function MinOccurrence(const Character: Char; const Min: Integer): IRule;
    class function NotContains(const Character: Char): IRule; overload;
    class function NotContains(const Chars: array of Char): IRule; overload;
    class function NotContains(const Text: String): IRule; overload;
    class function NotContains(const Texts: array of String): IRule; overload;
  end;

implementation

uses
  System.SysUtils;

type
  TRule = class(TFrameworkObject, IRule)
  private
    FAmount: Integer;
    FErrorMessage: String;
    FKind: TRuleKind;
    FValues: IList<IValue>;
    function After(const Character: Char): IRule;
    function Before(const Character: Char): IRule;
    function WithErrorMessage(const Value: String): IRule;
    function GetAmount: Integer;
    function GetErrorMessage: String;
    function GetKind: TRuleKind;
    function GetValues: IList<IValue>;
  public
    constructor Create(const AKind: TRuleKind; const AValues: array of IValue); overload;
    constructor Create(const AKind: TRuleKind; const AValue: IValue; const AAmount: Integer); overload;
    constructor Create(const AKind: TRuleKind; const AValue, APointValue: IValue; const AAmount: Integer); overload;
    destructor Destroy; override;
  end;

{ TRule }

constructor TRule.Create(const AKind: TRuleKind; const AValues: array of IValue);
var
  I: IValue;
begin
  FKind := AKind;
  FValues := Objects.NewList<IValue>;
  FAmount := -1;

  for I in AValues do
    FValues.Add(I);
end;

constructor TRule.Create(const AKind: TRuleKind; const AValue: IValue;
  const AAmount: Integer);
begin
  FKind := AKind;
  FAmount := AAmount;
  FValues := Objects.NewList<IValue>;
  FValues.Add(AValue);
end;

function TRule.After(const Character: Char): IRule;
begin
  case FKind of
    rkMaxOccurrence:
      FKind := rkMaxOccurrenceAfter;
    rkMinOccurrence:
      FKind := rkMinOccurrenceAfter;
  end;
  FValues.Add(ValueRepository.Char(Character));
  Result := Self;
end;

function TRule.Before(const Character: Char): IRule;
begin
  case FKind of
    rkMaxOccurrence,
    rkMaxOccurrenceAfter:
      FKind := rkmaxOccurrenceBefore;
    rkMinOccurrence,
    rkMinOccurrenceAfter:
      FKind := rkMinOccurrenceBefore;
  end;
  FValues.Add(ValueRepository.Char(Character));
  Result := Self;
end;

constructor TRule.Create(const AKind: TRuleKind; const AValue,
  APointValue: IValue; const AAmount: Integer);
begin
  FKind := AKind;
  FAmount := AAmount;
  FValues := Objects.NewList<IValue>;
  FValues.Add(AValue);
end;

destructor TRule.Destroy;
begin
  if Assigned(FValues) then
    try
      FValues.Clear;
      FValues := nil;
    except end;

  inherited;
end;

function TRule.WithErrorMessage(const Value: String): IRule;
begin
  FErrorMessage := Value;
  Result := Self;
end;

function TRule.GetAmount: Integer;
begin
  Result := FAmount;
end;

function TRule.GetErrorMessage: String;
begin
  Result := FErrorMessage;
end;

function TRule.GetKind: TRuleKind;
begin
  Result := FKind;
end;

function TRule.GetValues: IList<IValue>;
begin
  Result := FValues;
end;

{ RuleRepository }

class function Rule.Between(const FirstValue,
  SecondValue: Integer): IRule;
begin
  Result := TRule.Create(rkBetween,
    [ ValueRepository.Int(FirstValue), ValueRepository.Int(SecondValue) ]);
end;

class function Rule.Between(const FirstDate,
  SecondDate: TDateTime): IRule;
begin
  Result := TRule.Create(rkBetween,
    [ ValueRepository.DateTime(FirstDate), ValueRepository.DateTime(SecondDate) ]);
end;

class function Rule.Contains(const Chars: array of Char): IRule;
var
  A: array of IValue;
  I, Size: Integer;
begin
  Size := Length(Chars);

  SetLength(A, Size);

  for I := 0 to Size -1 do
    A[I] := ValueRepository.Char( Chars[I] );

  Result := TRule.Create(rkContains, A);
end;

class function Rule.Contains(const Character: Char): IRule;
begin
  Result := TRule.Create(rkContains, [ValueRepository.Char(Character)]);
end;

class function Rule.Contains(
  const Texts: array of String): IRule;
var
  A: array of IValue;
  I, Size: Integer;
begin
  Size := Length(Texts);

  SetLength(A, Size);

  for I := 0 to Size -1 do
    A[I] := ValueRepository.String( Texts[I] );

  Result := TRule.Create(rkContains, A);
end;

class function Rule.MaxLength(const Value: Integer): IRule;
begin
  Result := TRule.Create(rkMaxLength, [ValueRepository.Int(Value)]);
end;

class function Rule.MaxOccurrence(const Character: Char;
  const Max: Integer): IRule;
begin
  Result := TRule.Create(rkMaxOccurrence, ValueRepository.Char(Character), Max);
end;

class function Rule.MinLength(const Value: Integer): IRule;
begin
  Result := TRule.Create(rkMinLength, [ValueRepository.Int(Value)]);
end;

class function Rule.MinOccurrence(const Character: Char;
  const Min: Integer): IRule;
begin
  Result := TRule.Create(rkMinOccurrence, ValueRepository.Char(Character), Min);
end;

class function Rule.NotContains(
  const Chars: array of Char): IRule;
var
  A: array of IValue;
  I, Size: Integer;
begin
  Size := Length(Chars);

  SetLength(A, Size);

  for I := 0 to Size -1 do
    A[I] := ValueRepository.Char( Chars[I] );

  Result := TRule.Create(rkNotContain, A);
end;

class function Rule.NotContains(const Character: Char): IRule;
begin
  Result := TRule.Create(rkNotContain, [ValueRepository.Char(Character)]);
end;

class function Rule.NotContains(
  const Texts: array of String): IRule;
var
  A: array of IValue;
  I, Size: Integer;
begin
  Size := Length(Texts);

  SetLength(A, Size);

  for I := 0 to Size -1 do
    A[I] := ValueRepository.String( Texts[I] );

  Result := TRule.Create(rkNotContain, A);
end;

class function Rule.NotContains(const Text: String): IRule;
begin
  Result := TRule.Create(rkNotContain, [ValueRepository.String(Text)]);
end;

class function Rule.Contains(const Text: String): IRule;
begin
  Result := TRule.Create(rkContains, [ValueRepository.String(Text)]);
end;

initialization
  Objects.RegisterType<IRule, TRule>;

end.
