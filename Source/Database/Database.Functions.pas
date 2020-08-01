unit Database.Functions;

interface

uses
  Base.Objects,
  Base.Value,
  Database.Query.Types;

type
  TFunctionType = (
    fNone,
    fAvg,
    fCoalesce,
    fConcat,
    fCount,
    fIf,
    fLower,
    fMax,
    fMin,
    fSum,
    fUpper );

  IFunction = interface(IFrameworkInterface)
    ['{0FC3B29D-A2B2-465F-94B8-9146634D81C5}']
    function Add(const Factor: IFrameworkInterface): IFunction;
    function GetFactors: IList;
    function GetType: TFunctionType;
    function SetFactors(const Value: IList): IFunction;
    function SetType(const Value: TFunctionType): IFunction;
    property &Type: TFunctionType read GetType;
    property Factors: IList read GetFactors;
  end;

  FunctionRepository = class
  private
    class function Instantiate(const &Type: TFunctionType): IFunction;
  public
    class function Avg(const Field: TField): IFunction; overload;
    class function Avg(const Value: IValue): IFunction; overload;
    class function Avg(const Expression: IFrameworkInterface): IFunction; overload;

    class function Coalesce(const Fields: TFieldList): IFunction; overload;
    class function Coalesce(const Values: array of IValue): IFunction; overload;
    class function Coalesce(const Expressions: array of IFrameworkInterface): IFunction; overload;

    class function Concat(const Field: TField): IFunction; overload;
    class function Concat(const Fields: TFieldList): IFunction; overload;
    class function Concat(const Value: IValue): IFunction; overload;
    class function Concat(const Values: array of IValue): IFunction; overload;
    class function Concat(const Expression: IFrameworkInterface): IFunction; overload;
    class function Concat(const Expressions: array of IFrameworkInterface): IFunction; overload;

    class function Count(const Field: TField): IFunction; overload;
    class function Count(const Fields: TFieldList): IFunction; overload;
    class function Count(const Value: IValue): IFunction; overload;
    class function Count(const Values: array of IValue): IFunction; overload;
    class function Count(const Expression: IFrameworkInterface): IFunction; overload;
    class function Count(const Expressions: array of IFrameworkInterface): IFunction; overload;

    class function Lower(const Field: TField): IFunction; overload;
    class function Lower(const Value: IValue): IFunction; overload;
    class function Lower(const Expression: IFrameworkInterface): IFunction; overload;

    class function Max(const Field: TField): IFunction; overload;
    class function Max(const Fields: TFieldList): IFunction; overload;
    class function Max(const Value: IValue): IFunction; overload;
    class function Max(const Values: array of IValue): IFunction; overload;
    class function Max(const Expression: IFrameworkInterface): IFunction; overload;
    class function Max(const Expressions: array of IFrameworkInterface): IFunction; overload;

    class function Min(const Field: TField): IFunction; overload;
    class function Min(const Fields: TFieldList): IFunction; overload;
    class function Min(const Value: IValue): IFunction; overload;
    class function Min(const Values: array of IValue): IFunction; overload;
    class function Min(const Expression: IFrameworkInterface): IFunction; overload;
    class function Min(const Expressions: array of IFrameworkInterface): IFunction; overload;

    class function Sum(const Field: TField): IFunction; overload;
    class function Sum(const Value: IValue): IFunction; overload;
    class function Sum(const Expresion: IFrameworkInterface): IFunction; overload;

    class function Upper(const Field: TField): IFunction; overload;
    class function Upper(const Value: IValue): IFunction; overload;
    class function Upper(const Expression: IFrameworkInterface): IFunction; overload;
  end;

implementation

type
  TFunction = class(TFrameworkObject, IFunction)
  private
    FType: TFunctionType;
    FFactors: IList;
    function Add(const Factor: IFrameworkInterface): IFunction;
    function GetFactors: IList;
    function GetType: TFunctionType;
    function SetFactors(const Value: IList): IFunction;
    function SetType(const Value: TFunctionType): IFunction;
  public
    constructor Create;
    destructor Destroy; override;

    function Avg(const Field: TField): IFunction; overload;
    function Avg(const Value: IValue): IFunction; overload;
    function Avg(const &Function: IFunction): IFunction; overload;

    function Coalesce(const Fields: TFieldList): IFunction; overload;
    function Coalesce(const Values: array of IValue): IFunction; overload;
    function Coalesce(const Functions: array of IFunction): IFunction; overload;

    function Count(const Field: TField): IFunction; overload;
    function Count(const Fields: TFieldList): IFunction; overload;
    function Count(const Value: IValue): IFunction; overload;
    function Count(const Values: array of IValue): IFunction; overload;
    function Count(const &Function: IFunction): IFunction; overload;
    function Count(const Functions: array of IFunction): IFunction; overload;

    function Max(const Field: TField): IFunction; overload;
    function Max(const Fields: TFieldList): IFunction; overload;
    function Max(const Value: IValue): IFunction; overload;
    function Max(const Values: array of IValue): IFunction; overload;
    function Max(const &Function: IFunction): IFunction; overload;
    function Max(const Functions: array of IFunction): IFunction; overload;

    function Min(const Field: TField): IFunction; overload;
    function Min(const Fields: TFieldList): IFunction; overload;
    function Min(const Value: IValue): IFunction; overload;
    function Min(const Values: array of IValue): IFunction; overload;
    function Min(const &Function: IFunction): IFunction; overload;
    function Min(const Functions: array of IFunction): IFunction; overload;

    function Sum(const Field: TField): IFunction; overload;
    function Sum(const Value: IValue): IFunction; overload;
    function Sum(const &Function: IFunction): IFunction; overload;
  end;

{ TFunction }

function TFunction.Avg(const Field: TField): IFunction;
begin
  FType := fAvg;

  FFactors.Add(ValueRepository.Field(Field));

  Result := Self;
end;

function TFunction.Add(const Factor: IFrameworkInterface): IFunction;
begin
  FFactors.Add(Factor);
end;

function TFunction.Avg(const &Function: IFunction): IFunction;
begin
  FType := fAvg;
  FFactors.Add(&Function);
  Result := Self;
end;

function TFunction.Avg(const Value: IValue): IFunction;
begin
  FType := fAvg;
  FFactors.Add(Value);
  Result := Self;
end;

function TFunction.Coalesce(const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  FType := fCoalesce;

  for F in Fields do
    FFactors.Add( ValueRepository.Field(F) );

  Result := Self;
end;

function TFunction.Coalesce(const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  FType := fCoalesce;

  for V in Values do
    FFactors.Add(V);

  Result := Self;
end;

function TFunction.Coalesce(
  const Functions: array of IFunction): IFunction;
var
  F: IFunction;
begin
  FType := fCoalesce;

  for F in Functions do
    FFactors.Add(F);

  Result := Self;
end;

function TFunction.Count(const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  FType := fCount;

  for F in Fields do
    FFactors.Add( ValueRepository.Field(F) );

  Result := Self;
end;

function TFunction.Count(const Field: TField): IFunction;
begin
  FType := fCount;

  FFactors.Add( ValueRepository.Field(Field) );

  Result := Self;
end;

function TFunction.Count(const Functions: array of IFunction): IFunction;
var
  F: IFunction;
begin
  FType := fCount;

  for F in Functions do
    FFactors.Add(F);

  Result := Self;
end;

function TFunction.Count(const Value: IValue): IFunction;
begin
  FType := fCount;
  FFactors.Add(Value);
  Result := Self;
end;

function TFunction.Count(const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  FType := fCount;

  for V in Values do
    FFactors.Add(V);

  Result := Self;
end;

function TFunction.Count(const &Function: IFunction): IFunction;
begin
  FType := fCount;
  FFactors.Add(&Function);
  Result := Self;
end;

constructor TFunction.Create;
begin
  FType := fNone;
  FFactors := Objects.NewList;
end;

destructor TFunction.Destroy;
begin
  if Assigned(FFactors) then
  begin
    try
      FFactors.Clear;
      FFactors := nil;
    except end;
  end;

  inherited;
end;

function TFunction.GetFactors: IList;
begin
  Result := FFactors;
end;

function TFunction.GetType: TFunctionType;
begin
  Result := FType;
end;

function TFunction.Max(const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  FType := fMax;

  for F in Fields do
    FFactors.Add( ValueRepository.Field(F) );

  Result := Self;
end;

function TFunction.Max(const Field: TField): IFunction;
begin
  FType := fMax;

  FFactors.Add( ValueRepository.Field(Field) );

  Result := Self;
end;

function TFunction.Max(const Functions: array of IFunction): IFunction;
var
  F: IFunction;
begin
  FType := fMax;

  for F in Functions do
    FFactors.Add(F);

  Result := Self;
end;

function TFunction.Min(const Value: IValue): IFunction;
begin
  FType := fMin;
  FFactors.Add(Value);
  Result := Self;
end;

function TFunction.Min(const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  FType := fMin;

  for F in Fields do
    FFactors.Add( ValueRepository.Field(F) );

  Result := Self;
end;

function TFunction.Min(const Field: TField): IFunction;
begin
  FType := fMin;

  FFactors.Add( ValueRepository.Field(Field) );

  Result := Self;
end;

function TFunction.Min(const Functions: array of IFunction): IFunction;
var
  F: IFunction;
begin
  FType := fMin;

  for F in Functions do
    FFactors.Add(F);

  Result := Self;
end;

function TFunction.Sum(const Field: TField): IFunction;
begin
  FType := fSum;

  FFactors.Add( ValueRepository.Field(Field) );

  Result := Self;
end;

function TFunction.Sum(const Value: IValue): IFunction;
begin
  FType := fSum;
  FFactors.Add(Value);
  Result := Self;
end;

function TFunction.SetFactors(const Value: IList): IFunction;
begin
  FFactors := Value;
  Result := Self;
end;

function TFunction.SetType(const Value: TFunctionType): IFunction;
begin
  FType := Value;
  Result := Self;
end;

function TFunction.Sum(const &Function: IFunction): IFunction;
begin
  FType := fSum;
  FFactors.Add(&Function);
  Result := Self;
end;

function TFunction.Min(const &Function: IFunction): IFunction;
begin
  FType := fMin;
  FFactors.Add(&Function);
  Result := Self;
end;

function TFunction.Min(const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  FType := fMin;

  for V in Values do
    FFactors.Add(V);

  Result := Self;
end;

function TFunction.Max(const Value: IValue): IFunction;
begin
  FType := fMax;
  FFactors.Add(Value);
  Result := Self;
end;

function TFunction.Max(const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  FType := fMax;

  for V in Values do
    FFactors.Add(V);

  Result := Self;
end;

function TFunction.Max(const &Function: IFunction): IFunction;
begin
  FType := fMax;
  FFactors.Add(&Function);
  Result := Self;
end;

{ FunctionRepository }

class function FunctionRepository.Avg(const Field: TField): IFunction;
begin
  Result := Instantiate(fAvg);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Avg(const Value: IValue): IFunction;
begin
  Result := Instantiate(fAvg);
  Result.Add(Value);
end;

class function FunctionRepository.Coalesce(
  const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  Result := Instantiate(fCoalesce);

  for F in Fields do
    Result.Add( ValueRepository.Field(F) );
end;

class function FunctionRepository.Coalesce(
  const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  Result := Instantiate(fCoalesce);

  for V in Values do
    Result.Add(V);
end;

class function FunctionRepository.Avg(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fAvg);
  Result.Add(Expression);
end;

class function FunctionRepository.Count(const Value: IValue): IFunction;
begin
  Result := Instantiate(fCount);
  Result.Add(Value);
end;

class function FunctionRepository.Count(
  const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  Result := Instantiate(fCount);

  for F in Fields do
    Result.Add( ValueRepository.Field(F) );
end;

class function FunctionRepository.Count(const Field: TField): IFunction;
begin
  Result := Instantiate(fCount);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Instantiate(
  const &Type: TFunctionType): IFunction;
begin
  Result := Objects.New<IFunction>;
  Result.SetType(&Type)
end;

class function FunctionRepository.Lower(const Field: TField): IFunction;
begin
  Result := Instantiate(fLower);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Lower(const Value: IValue): IFunction;
begin
  Result := Instantiate(fLower);
  Result.Add(Value);
end;

class function FunctionRepository.Lower(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fLower);
  Result.Add(Expression);
end;

class function FunctionRepository.Count(
  const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  Result := Instantiate(fCount);

  for V in Values do
    Result.Add(V);
end;

class function FunctionRepository.Max(
  const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  Result := Instantiate(fMax);

  for V in Values do
    Result.Add(V);
end;

class function FunctionRepository.Max(const Field: TField): IFunction;
begin
  Result := Instantiate(fMax);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Max(
  const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  Result := Instantiate(fMax);

  for F in Fields do
    Result.Add( ValueRepository.Field(F) );
end;

class function FunctionRepository.Max(const Value: IValue): IFunction;
begin
  Result := Instantiate(fMax);
  Result.Add(Value);
end;

class function FunctionRepository.Min(
  const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  Result := Instantiate(fMin);

  for V in Values do
    Result.Add(V);
end;

class function FunctionRepository.Min(const Field: TField): IFunction;
begin
  Result := Instantiate(fMin);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Min(
  const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  Result := Instantiate(fMin);

  for F in Fields do
    Result.Add( ValueRepository.Field(F) );
end;

class function FunctionRepository.Min(const Value: IValue): IFunction;
begin
  Result := Instantiate(fMin);
  Result.Add(Value);
end;

class function FunctionRepository.Sum(const Field: TField): IFunction;
begin
  Result := Instantiate(fSum);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Sum(const Value: IValue): IFunction;
begin
  Result := Instantiate(fSum);
  Result.Add(Value);
end;

class function FunctionRepository.Coalesce(
  const Expressions: array of IFrameworkInterface): IFunction;
var
  E: IFrameworkInterface;
begin
  Result := Instantiate(fCoalesce);

  for E in Expressions do
    Result.Add(E);
end;

class function FunctionRepository.Concat(const Value: IValue): IFunction;
begin
  Result := Instantiate(fConcat);
  Result.Add(Value);
end;

class function FunctionRepository.Concat(
  const Fields: TFieldList): IFunction;
var
  F: TField;
begin
  Result := Instantiate(fConcat);

  for F in Fields do
    Result.Add( ValueRepository.Field(F) );
end;

class function FunctionRepository.Concat(const Field: TField): IFunction;
begin
  Result := Instantiate(fConcat);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Concat(
  const Expressions: array of IFrameworkInterface): IFunction;
var
  E: IFrameworkInterface;
begin
  Result := Instantiate(fConcat);

  for E in Expressions do
    Result.Add(E);
end;

class function FunctionRepository.Concat(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fConcat);
  Result.Add(Expression);
end;

class function FunctionRepository.Concat(
  const Values: array of IValue): IFunction;
var
  V: IValue;
begin
  Result := Instantiate(fConcat);

  for V in Values do
    Result.Add(V);
end;

class function FunctionRepository.Count(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fCount);
  Result.Add(Expression);
end;

class function FunctionRepository.Count(
  const Expressions: array of IFrameworkInterface): IFunction;
var
  E: IFrameworkInterface;
begin
  Result := Instantiate(fCount);

  for E in Expressions do
    Result.Add(E);
end;

class function FunctionRepository.Max(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fMax);
  Result.Add(Expression);
end;

class function FunctionRepository.Max(
  const Expressions: array of IFrameworkInterface): IFunction;
var
  E: IFrameworkInterface;
begin
  Result := Instantiate(fMax);

  for E in Expressions do
    Result.Add(E);
end;

class function FunctionRepository.Min(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fMin);
  Result.Add(Expression);
end;

class function FunctionRepository.Min(
  const Expressions: array of IFrameworkInterface): IFunction;
var
  E: IFrameworkInterface;
begin
  Result := Instantiate(fMin);

  for E in Expressions do
    Result.Add(E);
end;

class function FunctionRepository.Sum(
  const Expresion: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fSum);
  Result.Add(Expresion);
end;

class function FunctionRepository.Upper(const Field: TField): IFunction;
begin
  Result := Instantiate(fUpper);
  Result.Add( ValueRepository.Field(Field) );
end;

class function FunctionRepository.Upper(const Value: IValue): IFunction;
begin
  Result := Instantiate(fUpper);
  Result.Add(Value);
end;

class function FunctionRepository.Upper(
  const Expression: IFrameworkInterface): IFunction;
begin
  Result := Instantiate(fUpper);
  Result.Add(Expression);
end;

initialization
  Objects.RegisterType<IFunction, TFunction>;

end.
