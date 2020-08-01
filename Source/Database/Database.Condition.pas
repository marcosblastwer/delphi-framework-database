unit Database.Condition;

interface

uses
  Base.Objects;

type
  TCompare = (
    comNone,
    comBetween,
    comBiggerThan,
    comEqual,
    comIn,
    comLike,
    comNull,
    comSmallerThan,
    comStartWith,
    comFinishWith,
    comUnequal );

  TJunction = (
    juNone,
    juAnd,
    juOr );
  TJunctions = array of TJunction;

  TConditionAttribute = (
    caNone,
    caNot );

  ICondition = interface(IFrameworkInterface)
    ['{53207A23-27CD-415A-B8C1-F71C2081A5BB}']
    function Add(const Value: IFrameworkInterface): ICondition; overload;
    function Add(const Values: array of IFrameworkInterface): ICondition; overload;
    function GetAttr: TConditionAttribute;
    function GetCompare: TCompare;
    function GetValues: IList;
    function SetAttr(const AAttr: TConditionAttribute): ICondition;
    function SetCompare(const ACompare: TCompare): ICondition;
    function SetValues(const AValues: IList): ICondition;
    property Attr: TConditionAttribute read GetAttr;
    property Compare: TCompare read GetCompare;
    property Values: IList read GetValues;
  end;

  IConditions = interface(IFrameworkInterface)
    ['{93166A56-66BD-4E3B-8857-DE799027FC0A}']
    function GetJunctions: TJunctions;
    function GetList: IList;
    property List: IList read GetList;
    property Junctions: TJunctions read GetJunctions;

    function Between(const Value, FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function BiggerThan(const FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function Equal(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function Unequal(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function Like(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function SmallerThan(const FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function StartWith(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function FinishWith(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function &In(const Value: IFrameworkInterface; const List: array of IFrameworkInterface): IConditions;
    function &And: IConditions;
    function &Or: IConditions;
    function &Not: IConditions;
  end;

implementation

type
  TCondition = class(TFrameworkObject, ICondition)
  private
    FAttr: TConditionAttribute;
    FCompare: TCompare;
    FValues: IList;
    function GetAttr: TConditionAttribute;
    function GetCompare: TCompare;
    function GetValues: IList;
    function SetAttr(const AAttr: TConditionAttribute): ICondition;
    function SetCompare(const ACompare: TCompare): ICondition;
    function SetValues(const AValues: IList): ICondition;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Value: IFrameworkInterface): ICondition; overload;
    function Add(const Values: array of IFrameworkInterface): ICondition; overload;
  end;

  TConditions = class(TFrameworkObject, IConditions)
  private
    FList: IList;
    FJunctions: TJunctions;
    FAttr: TConditionAttribute;
    function Instantiate: ICondition;
    function GetJunctions: TJunctions;
    function GetList: IList;
  public
    constructor Create;
    destructor Destroy; override;
    function Between(const Value, FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function BiggerThan(const FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function Equal(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function Unequal(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function Like(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function SmallerThan(const FirstCompared, SecondCompared: IFrameworkInterface): IConditions;
    function StartWith(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function FinishWith(const FirstValue, SecondValue: IFrameworkInterface): IConditions;
    function &In(const Value: IFrameworkInterface; const List: array of IFrameworkInterface): IConditions;
    function &And: IConditions;
    function &Or: IConditions;
    function &Not: IConditions;
  end;

{ TCondition }

function TCondition.Add(const Value: IFrameworkInterface): ICondition;
begin
  FValues.Add(Value);
  Result := Self;
end;

function TCondition.Add(const Values: array of IFrameworkInterface): ICondition;
var
  O: IFrameworkInterface;
begin
  for O in Values do
    FValues.Add(O);
  Result := Self;
end;

constructor TCondition.Create;
begin
  inherited;
  FAttr := caNone;
  FCompare := comNone;
  FValues := Objects.NewList;
end;

destructor TCondition.Destroy;
begin
  if Assigned(FValues) then
  begin
    FValues.Clear;
    FValues := nil;
  end;

  inherited;
end;

function TCondition.GetAttr: TConditionAttribute;
begin
  Result := FAttr;
end;

function TCondition.GetCompare: TCompare;
begin
  Result := FCompare;
end;

function TCondition.GetValues: IList;
begin
  Result := FValues;
end;

function TCondition.SetAttr(const AAttr: TConditionAttribute): ICondition;
begin
  FAttr := AAttr;
  Result := Self;
end;

function TCondition.SetCompare(const ACompare: TCompare): ICondition;
begin
  FCompare := ACompare;
  Result := Self;
end;

function TCondition.SetValues(const AValues: IList): ICondition;
begin
  FValues := AValues;
  Result := Self;
end;

{ TConditions }

function TConditions.&Not: IConditions;
begin
  FAttr := caNot;
  Result := Self;
end;

function TConditions.&And: IConditions;
begin
  FAttr := caNone;
  SetLength(FJunctions, Length(FJunctions) +1);
  FJunctions[Length(FJunctions) -1] := juAnd;
  Result := Self;
end;

function TConditions.Between(const Value, FirstCompared,
  SecondCompared: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comBetween).Add([Value, FirstCompared, SecondCompared]) );
  FAttr := caNone;
  Result := Self;
end;

function TConditions.BiggerThan(const FirstCompared,
  SecondCompared: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comBiggerThan).Add([FirstCompared, SecondCompared]));
  FAttr := caNone;
  Result := Self;
end;

function TConditions.&In(const Value: IFrameworkInterface;
  const List: array of IFrameworkInterface): IConditions;
var
  Condition: ICondition;
  O: IFrameworkInterface;
begin
  Condition := Instantiate.SetCompare(comIn);
  try
    for O in List do
      Condition.Add(O);

    FList.Add(Condition);
  finally
    Condition := nil;
  end;

  FAttr := caNone;
  Result := Self;
end;

function TConditions.Instantiate: ICondition;
begin
  Result := Objects.New<ICondition>;
  Result.SetAttr(FAttr);
end;

function TConditions.&Or: IConditions;
begin
  FAttr := caNone;
  SetLength(FJunctions, Length(FJunctions) +1);
  FJunctions[Length(FJunctions)] := juOr;
  Result := Self;
end;

constructor TConditions.Create;
begin
  SetLength(FJunctions, 0);
  FList := Objects.NewList;
end;

destructor TConditions.Destroy;
begin
  SetLength(FJunctions, 0);

  if Assigned(FList) then
  begin
    FList.Clear;
    FList := nil;
  end;

  inherited;
end;

function TConditions.Equal(const FirstValue,
  SecondValue: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comEqual).Add([FirstValue, SecondValue]) );
  FAttr := caNone;
  Result := Self;
end;

function TConditions.FinishWith(const FirstValue,
  SecondValue: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comFinishWith).Add([FirstValue, SecondValue]) );
  FAttr := caNone;
  Result := Self;
end;

function TConditions.GetJunctions: TJunctions;
begin
  Result := FJunctions;
end;

function TConditions.GetList: IList;
begin
  Result := FList;
end;

function TConditions.Like(const FirstValue,
  SecondValue: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comLike).Add([FirstValue, SecondValue]) );
  FAttr := caNone;
  Result := Self;
end;

function TConditions.SmallerThan(const FirstCompared,
  SecondCompared: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comSmallerThan).Add([FirstCompared, SecondCompared]));
  FAttr := caNone;
  Result := Self;
end;

function TConditions.StartWith(const FirstValue,
  SecondValue: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comStartWith).Add([FirstValue, SecondValue]) );
  FAttr := caNone;
  Result := Self;
end;

function TConditions.Unequal(const FirstValue,
  SecondValue: IFrameworkInterface): IConditions;
begin
  FList.Add(
    Instantiate.SetCompare(comUnequal).Add([FirstValue, SecondValue]) );
  FAttr := caNone;
  Result := Self;
end;

initialization
  Objects.RegisterType<ICondition, TCondition>;
  Objects.RegisterType<IConditions, TConditions>;

end.
