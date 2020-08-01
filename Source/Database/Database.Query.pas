unit Database.Query;

interface

uses
  Base.Objects,
  Base.Value,
  Database.Condition,
  Database.Constraint,
  Database.Functions,
  Database.Group,
  Database.Join,
  Database.Limit,
  Database.Order,
  Database.Query.Types;

type
  TGroupAttr = Database.Group.TGroupAttr;
  TLimitAttr = Database.Limit.TLimitAttr;
  TOrderAttr = Database.Order.TOrderAttr;
  TValueKind = Base.Value.TValueKind;
  FunctionRepository = Database.Functions.FunctionRepository;
  ValueRepository = Base.Value.ValueRepository;

  IQuery = interface(IFrameworkInterface)
    ['{B90F310F-A40F-41A2-88D4-4930D146D724}']
    function GetCommand: String;
    function GetCommandType: TCommandType;
    function GetCreateAttr: TCreateAttributes;
    function GetDatabase: String;
    function GetEncoding: String;
    function GetFields: IList;
    function GetFieldsets: IList;
    function GetForeignKeys: IList;
    function GetFrom: IFrameworkInterface;
    function GetGroup: IList;
    function GetHaving: IConditions;
    function GetInherits: TTable;
    function GetIndexes: IList;
    function GetJoins: IList;
    function GetLimit: ILimit;
    function GetOrder: IList;
    function GetOwner: String;
    function GetPrimaryKey: IPrimaryKey;
    function GetSelectAttr: TSelectAttributes;
    function GetSelectExpressions: IList;
    function GetTable: TTable;
    function GetTemplate: String;
    function GetValues: IList;
    function GetWhere: IConditions;
    procedure SetCommand(const Value: String);

    property _CommandType: TCommandType read GetCommandType;
    property _Command: String read GetCommand write SetCommand;
    property _CreateAttr: TCreateAttributes read GetCreateAttr;
    property _Database: String read GetDatabase;
    property _Encoding: String read GetEncoding;
    property _Fields: IList read GetFields;
    property _Fieldsets: IList read GetFieldsets;
    property _ForeignKeys: IList read GetForeignKeys;
    property _From: IFrameworkInterface read GetFrom;
    property _Group: IList read GetGroup;
    property _Having: IConditions read GetHaving;
    property _Inherits: TTable read GetInherits;
    property _Indexes: IList read GetIndexes;
    property _Joins: IList read GetJoins;
    property _Limit: ILimit read GetLimit;
    property _Order: IList read GetOrder;
    property _Owner: String read GetOwner;
    property _PrimaryKey: IPrimaryKey read GetPrimaryKey;
    property _SelectAttr: TSelectAttributes read GetSelectAttr;
    property _SelectExpressions: IList read GetSelectExpressions;
    property _Table: TTable read GetTable;
    property _Template: String read GetTemplate;
    property _Values: IList read GetValues;
    property _Where: IConditions read GetWhere;

    function Create: IQuery;
    function Database(const Database: String): IQuery;
    function &With: IQuery;
    function Owner(const Username: String): IQuery;
    function Template(const Name: String): IQuery;
    function Encoding(const Name: String): IQuery;
    function IfNotExists: IQuery;
    function Inherits(const Table: TTable): IQuery;
    function Table(const Table: TTable): IQuery;
    function Temporary: IQuery;
    function Exists: IQuery;

    function Field(const Name: TField): IQuery;
    function BigInt: IQuery;
    function BigSerial: IQuery;
    function Bit: IQuery;
    function Blob: IQuery;
    function Bool: IQuery;
    function Char(const Size: Integer): IQuery;
    function Date: IQuery;
    function Datetime: IQuery;
    function Decimal(const Size, Precision: Integer): IQuery;
    function Double(const Size, Precision: Integer): IQuery;
    function Float(const Size, Precision: Integer): IQuery;
    function Int: IQuery;
    function Json: IQuery;
    function LongBlob: IQuery;
    function LongText: IQuery;
    function MediumBlob: IQuery;
    function MediumInt: IQuery;
    function Serial: IQuery;
    function SmallInt: IQuery;
    function Text: IQuery;
    function Time: IQuery;
    function Timestamp: IQuery;
    function TinyBlob: IQuery;
    function TinyInt: IQuery;
    function TinyText: IQuery;
    function Varchar(const Size: Integer): IQuery;
    function Default(const Value: IValue): IQuery; overload;
    function Default(const Expression: IFrameworkInterface): IQuery; overload;
    function DefaultNull: IQuery;
    function NotNull: IQuery;
    function Null: IQuery;

    function PrimaryKey(const Field: TField): IQuery; overload;
    function PrimaryKey(const Fields: TFieldList): IQuery; overload;
    function PrimaryKey(const Name: String; const Field: TField): IQuery; overload;
    function PrimaryKey(const Name: String; const Fields: TFieldList): IQuery; overload;
    function ForeignKey(const Field: TField): IQuery; overload;
    function ForeignKey(const Name: String; const Field: TField): IQuery; overload;
    function Reference(const Table: TTable; const Field: TField): IQuery; overload;
    function Unique(const Field: TField): IQuery; overload;
    function Unique(const Fields: TFieldList): IQuery; overload;
    function Unique(const Name: String; const Field: TField): IQuery; overload;
    function Unique(const Name: String; const Fields: TFieldList): IQuery; overload;

    function Insert: IQuery;
    function Into(const Table: TTable): IQuery; overload;
    function Into(const Table: TTable; const Fields: TFieldList): IQuery; overload;
    function Values(const Value: array of IValue): IQuery; overload;
    function Values(const Expressions: array of IFrameworkInterface): IQuery; overload;

    function Select(const Field: TField): IQuery; overload;
    function Select(const Fields: array of TField): IQuery; overload;
    function Select(const Expression: IFrameworkInterface): IQuery; overload;
    function Select(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Update(const Table: TTable): IQuery;
    function &Set(const Field, Value: TField): IQuery; overload;
    function &Set(const Field: TField; const Value: IValue): IQuery; overload;
    function &Set(const Field: TField; const Value: IFrameworkInterface): IQuery; overload;
    function All: IQuery;
    function Cache: IQuery;
    function Distinct: IQuery;
    function NoCache: IQuery;
    function From(const Table: TTable): IQuery; overload;
    function From(const Expression: IFrameworkInterface): IQuery; overload;
    function Join(const Table: TTable): IQuery;
    function JoinLeft(const Table: TTable): IQuery;
    function JoinRight(const Table: TTable): IQuery;
    function &On: IQuery;
    function Where: IQuery;
    function GroupBy(const Field: TField): IQuery; overload;
    function GroupBy(const Field: TField; const Attr: TGroupAttr): IQuery; overload;
    function GroupBy(const Fields: array of TField): IQuery; overload;
    function GroupBy(const Expression: IFrameworkInterface): IQuery; overload;
    function GroupBy(const Expression: IFrameworkInterface; const Attr: TGroupAttr): IQuery; overload;
    function GroupBy(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function OrderBy(const Field: TField): IQuery; overload;
    function OrderBy(const Field: TField; const Attr: TOrderAttr): IQuery; overload;
    function OrderBy(const Fields: array of TField): IQuery; overload;
    function OrderBy(const Expression: IFrameworkInterface): IQuery; overload;
    function OrderBy(const Expression: IFrameworkInterface; const Attr: TOrderAttr): IQuery; overload;
    function OrderBy(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Having: IQuery;
    function Limit(const Value: Integer): IQuery; overload;
    function Limit(const Value: Integer; const Attr: TLimitAttrs): IQuery; overload;
    function Limit(const Value: IValue): IQuery; overload;
    function Limit(const Value: IValue; const Attr: TLimitAttrs): IQuery; overload;
    function Limit(const Expression: IFrameworkInterface): IQuery; overload;
    function Limit(const Expression: IFrameworkInterface; const Attr: TLimitAttrs): IQuery; overload;
    function Offset(const Value: Integer): IQuery; overload;
    function Offset(const Value: IValue): IQuery; overload;
    function Offset(const Expression: IFrameworkInterface): IQuery; overload;

    function Between(const Field, FirstCompared, SecondCompared: TField): IQuery; overload;
    function Between(const Field: TField; const FirstCompared, SecondCompared: IValue): IQuery; overload;
    function Between(const Field: TField; const FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function Between(const Value, FirstCompared, SecondCompared: IValue): IQuery; overload;
    function Between(const Value: IValue; const FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function Between(const Expression, FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared, SecondCompared: TField): IQuery; overload;
    function BiggerThan(const FirstCompared: TField; const SecondCompared: IValue): IQuery; overload;
    function BiggerThan(const FirstCompared: TField; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IValue; const SecondCompared: IValue): IQuery; overload;
    function BiggerThan(const FirstCompared: IValue; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IFrameworkInterface; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IFrameworkInterface; const SecondCompared: IValue): IQuery; overload;
    function Equal(const FirstField, SecondField: TField): IQuery; overload;
    function Equal(const FirstValue, SecondValue: IValue): IQuery; overload;
    function Equal(const Field: TField; const Value: IValue): IQuery; overload;
    function Equal(const Field: TField; const Expression: IFrameworkInterface): IQuery; overload;
    function Equal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery; overload;
    function Unequal(const FirstField, SecondField: TField): IQuery; overload;
    function Unequal(const FirstValue, SecondValue: IValue): IQuery; overload;
    function Unequal(const Field: TField; const Value: IValue): IQuery; overload;
    function Unequal(const Field: TField; const Expression: IFrameworkInterface): IQuery; overload;
    function Unequal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery; overload;
    function Like(const FirstValue, SecondValue: IValue): IQuery;
    function StartWith(const FirstValue, SecondValue: IValue): IQuery;
    function FinishWith(const FirstValue, SecondValue: IValue): IQuery;
    function &In(const Field: TField; const List: array of IFrameworkInterface): IQuery; overload;
    function &In(const Value: IValue; const List: array of IFrameworkInterface): IQuery; overload;
    function &In(const Expression: IFrameworkInterface; const List: array of IFrameworkInterface): IQuery; overload;
    function &And: IQuery;
    function &Or: IQuery;
    function &Not: IQuery;
    function SortAsc: IQuery;
    function SortDesc: IQuery;

    function Avg(const Field: TField): IQuery; overload;
    function Avg(const Value: IValue): IQuery; overload;
    function Avg(const Expression: IFrameworkInterface): IQuery; overload;
    function Coalesce(const Fields: TFieldList): IQuery; overload;
    function Coalesce(const Values: array of IValue): IQuery; overload;
    function Coalesce(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Concat(const Field: TField): IQuery; overload;
    function Concat(const Fields: TFieldList): IQuery; overload;
    function Concat(const Value: IValue): IQuery; overload;
    function Concat(const Values: array of IValue): IQuery; overload;
    function Concat(const Expression: IFrameworkInterface): IQuery; overload;
    function Concat(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Count(const Field: TField): IQuery; overload;
    function Count(const Fields: TFieldList): IQuery; overload;
    function Count(const Value: IValue): IQuery; overload;
    function Count(const Values: array of IValue): IQuery; overload;
    function Count(const Expression: IFrameworkInterface): IQuery; overload;
    function Count(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Lower(const Field: TField): IQuery; overload;
    function Lower(const Value: IValue): IQuery; overload;
    function Lower(const Expression: IFrameworkInterface): IQuery; overload;
    function Max(const Field: TField): IQuery; overload;
    function Max(const Fields: TFieldList): IQuery; overload;
    function Max(const Value: IValue): IQuery; overload;
    function Max(const Values: array of IValue): IQuery; overload;
    function Max(const Expression: IFrameworkInterface): IQuery; overload;
    function Max(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Min(const Field: TField): IQuery; overload;
    function Min(const Fields: TFieldList): IQuery; overload;
    function Min(const Value: IValue): IQuery; overload;
    function Min(const Values: array of IValue): IQuery; overload;
    function Min(const Expression: IFrameworkInterface): IQuery; overload;
    function Min(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Sum(const Field: TField): IQuery; overload;
    function Sum(const Value: IValue): IQuery; overload;
    function Sum(const Expresion: IFrameworkInterface): IQuery; overload;
    function Upper(const Field: TField): IQuery; overload;
    function Upper(const Value: IValue): IQuery; overload;
    function Upper(const Expression: IFrameworkInterface): IQuery; overload;

    procedure Reset;
  end;

implementation

uses
  System.SysUtils,
  Database.Field,
  Database.Fieldset;

type
  TQuery = class(TFrameworkObject, IQuery)
  private
    FCommandType: TCommandType;
    FCommand: String;
    FSection: TSection;
    FCreateAttr: TCreateAttributes;
    FDatabase: String;
    FInherits: TTable;
    FSelectAttr: TSelectAttributes;
    FSelectExpressions: IList;
    FFrom: IFrameworkInterface;
    FWhere: IConditions;
    FHaving: IConditions;
    FJoins: IList;
    FGroup: IList;
    FOrder: IList;
    FLimit: ILimit;
    FTable: TTable;
    FFieldsets: IList;
    FFields: IList;
    FPrimaryKey: IPrimaryKey;
    FForeignKeys: IList;
    FIndexes: IList;
    FOwner,
    FTemplate,
    FEncoding: String;
    FValues: IList;
    function GetConditionsEditing: IConditions;
    function GetFieldEditing: IField;
    function GetCommand: String;
    function GetCommandType: TCommandType;
    function GetCreateAttr: TCreateAttributes;
    function GetDatabase: String;
    function GetEncoding: String;
    function GetFields: IList;
    function GetFieldsets: IList;
    function GetForeignKeys: IList;
    function GetFrom: IFrameworkInterface;
    function GetGroup: IList;
    function GetHaving: IConditions;
    function GetInherits: TTable;
    function GetIndexes: IList;
    function GetJoins: IList;
    function GetLimit: ILimit;
    function GetOrder: IList;
    function GetOwner: String;
    function GetPrimaryKey: IPrimaryKey;
    function GetSelectAttr: TSelectAttributes;
    function GetSelectExpressions: IList;
    function GetTable: TTable;
    function GetTemplate: String;
    function GetValues: IList;
    function GetWhere: IConditions;
    procedure SetCommand(const Value: String);
    procedure InsertFunction(const Value: IFunction);
  public
    constructor _Create;
    destructor Destroy; override;

    function Create: IQuery;
    function Database(const Database: String): IQuery;
    function &With: IQuery;
    function Owner(const Username: String): IQuery;
    function Template(const Name: String): IQuery;
    function Encoding(const Name: String): IQuery;
    function IfNotExists: IQuery;
    function Inherits(const Table: TTable): IQuery;
    function Table(const Table: TTable): IQuery;
    function Temporary: IQuery;
    function Exists: IQuery;

    function Field(const Name: TField): IQuery;
    function BigInt: IQuery;
    function BigSerial: IQuery;
    function Bit: IQuery;
    function Blob: IQuery;
    function Bool: IQuery;
    function Char(const Size: Integer): IQuery;
    function Date: IQuery;
    function Datetime: IQuery;
    function Decimal(const Size, Precision: Integer): IQuery;
    function Double(const Size, Precision: Integer): IQuery;
    function Float(const Size, Precision: Integer): IQuery;
    function Int: IQuery;
    function Json: IQuery;
    function LongBlob: IQuery;
    function LongText: IQuery;
    function MediumBlob: IQuery;
    function MediumInt: IQuery;
    function Serial: IQuery;
    function SmallInt: IQuery;
    function Text: IQuery;
    function Time: IQuery;
    function Timestamp: IQuery;
    function TinyBlob: IQuery;
    function TinyInt: IQuery;
    function TinyText: IQuery;
    function Varchar(const Size: Integer): IQuery;
    function Default(const Value: IValue): IQuery; overload;
    function Default(const Expression: IFrameworkInterface): IQuery; overload;
    function DefaultNull: IQuery;
    function NotNull: IQuery;
    function Null: IQuery;

    function PrimaryKey(const Field: TField): IQuery; overload;
    function PrimaryKey(const Fields: TFieldList): IQuery; overload;
    function PrimaryKey(const Name: String; const Field: TField): IQuery; overload;
    function PrimaryKey(const Name: String; const Fields: TFieldList): IQuery; overload;
    function ForeignKey(const Field: TField): IQuery; overload;
    function ForeignKey(const Name: String; const Field: TField): IQuery; overload;
    function Reference(const Table: TTable; const Field: TField): IQuery; overload;
    function Unique(const Field: TField): IQuery; overload;
    function Unique(const Fields: TFieldList): IQuery; overload;
    function Unique(const Name: String; const Field: TField): IQuery; overload;
    function Unique(const Name: String; const Fields: TFieldList): IQuery; overload;

    function Insert: IQuery;
    function Into(const Table: TTable): IQuery; overload;
    function Into(const Table: TTable; const Fields: TFieldList): IQuery; overload;
    function Values(const Value: array of IValue): IQuery; overload;
    function Values(const Expressions: array of IFrameworkInterface): IQuery; overload;

    function Select(const Field: TField): IQuery; overload;
    function Select(const Fields: array of TField): IQuery; overload;
    function Select(const Expression: IFrameworkInterface): IQuery; overload;
    function Select(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function All: IQuery;
    function Cache: IQuery;
    function Distinct: IQuery;
    function NoCache: IQuery;

    function Update(const Table: TTable): IQuery;
    function &Set(const Field, Value: TField): IQuery; overload;
    function &Set(const Field: TField; const Value: IValue): IQuery; overload;
    function &Set(const Field: TField; const Value: IFrameworkInterface): IQuery; overload;

    function From(const Table: TTable): IQuery; overload;
    function From(const Expression: IFrameworkInterface): IQuery; overload;
    function Join(const Table: TTable): IQuery;
    function JoinLeft(const Table: TTable): IQuery;
    function JoinRight(const Table: TTable): IQuery;
    function &On: IQuery;
    function Where: IQuery;
    function GroupBy(const Field: TField): IQuery; overload;
    function GroupBy(const Field: TField; const Attr: TGroupAttr): IQuery; overload;
    function GroupBy(const Fields: array of TField): IQuery; overload;
    function GroupBy(const Expression: IFrameworkInterface): IQuery; overload;
    function GroupBy(const Expression: IFrameworkInterface; const Attr: TGroupAttr): IQuery; overload;
    function GroupBy(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function OrderBy(const Field: TField): IQuery; overload;
    function OrderBy(const Field: TField; const Attr: TOrderAttr): IQuery; overload;
    function OrderBy(const Fields: array of TField): IQuery; overload;
    function OrderBy(const Expression: IFrameworkInterface): IQuery; overload;
    function OrderBy(const Expression: IFrameworkInterface; const Attr: TOrderAttr): IQuery; overload;
    function OrderBy(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Having: IQuery;
    function Limit(const Value: Integer): IQuery; overload;
    function Limit(const Value: Integer; const Attr: TLimitAttrs): IQuery; overload;
    function Limit(const Value: IValue): IQuery; overload;
    function Limit(const Value: IValue; const Attr: TLimitAttrs): IQuery; overload;
    function Limit(const Expression: IFrameworkInterface): IQuery; overload;
    function Limit(const Expression: IFrameworkInterface; const Attr: TLimitAttrs): IQuery; overload;
    function Offset(const Value: Integer): IQuery; overload;
    function Offset(const Value: IValue): IQuery; overload;
    function Offset(const Expression: IFrameworkInterface): IQuery; overload;

    function Between(const Field, FirstCompared, SecondCompared: TField): IQuery; overload;
    function Between(const Field: TField; const FirstCompared, SecondCompared: IValue): IQuery; overload;
    function Between(const Field: TField; const FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function Between(const Value, FirstCompared, SecondCompared: IValue): IQuery; overload;
    function Between(const Value: IValue; const FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function Between(const Expression, FirstCompared, SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared, SecondCompared: TField): IQuery; overload;
    function BiggerThan(const FirstCompared: TField; const SecondCompared: IValue): IQuery; overload;
    function BiggerThan(const FirstCompared: TField; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IValue; const SecondCompared: IValue): IQuery; overload;
    function BiggerThan(const FirstCompared: IValue; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IFrameworkInterface; const SecondCompared: IFrameworkInterface): IQuery; overload;
    function BiggerThan(const FirstCompared: IFrameworkInterface; const SecondCompared: IValue): IQuery; overload;
    function Equal(const FirstField, SecondField: TField): IQuery; overload;
    function Equal(const FirstValue, SecondValue: IValue): IQuery; overload;
    function Equal(const Field: TField; const Value: IValue): IQuery; overload;
    function Equal(const Field: TField; const Expression: IFrameworkInterface): IQuery; overload;
    function Equal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery; overload;
    function Unequal(const FirstField, SecondField: TField): IQuery; overload;
    function Unequal(const FirstValue, SecondValue: IValue): IQuery; overload;
    function Unequal(const Field: TField; const Value: IValue): IQuery; overload;
    function Unequal(const Field: TField; const Expression: IFrameworkInterface): IQuery; overload;
    function Unequal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery; overload;
    function Like(const FirstValue, SecondValue: IValue): IQuery;
    function StartWith(const FirstValue, SecondValue: IValue): IQuery;
    function FinishWith(const FirstValue, SecondValue: IValue): IQuery;
    function &In(const Field: TField; const List: array of IFrameworkInterface): IQuery; overload;
    function &In(const Value: IValue; const List: array of IFrameworkInterface): IQuery; overload;
    function &In(const Expression: IFrameworkInterface; const List: array of IFrameworkInterface): IQuery; overload;
    function &And: IQuery;
    function &Or: IQuery;
    function &Not: IQuery;
    function SortAsc: IQuery;
    function SortDesc: IQuery;

    function Avg(const Field: TField): IQuery; overload;
    function Avg(const Value: IValue): IQuery; overload;
    function Avg(const Expression: IFrameworkInterface): IQuery; overload;
    function Coalesce(const Fields: TFieldList): IQuery; overload;
    function Coalesce(const Values: array of IValue): IQuery; overload;
    function Coalesce(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Concat(const Field: TField): IQuery; overload;
    function Concat(const Fields: TFieldList): IQuery; overload;
    function Concat(const Value: IValue): IQuery; overload;
    function Concat(const Values: array of IValue): IQuery; overload;
    function Concat(const Expression: IFrameworkInterface): IQuery; overload;
    function Concat(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Count(const Field: TField): IQuery; overload;
    function Count(const Fields: TFieldList): IQuery; overload;
    function Count(const Value: IValue): IQuery; overload;
    function Count(const Values: array of IValue): IQuery; overload;
    function Count(const Expression: IFrameworkInterface): IQuery; overload;
    function Count(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Lower(const Field: TField): IQuery; overload;
    function Lower(const Value: IValue): IQuery; overload;
    function Lower(const Expression: IFrameworkInterface): IQuery; overload;
    function Max(const Field: TField): IQuery; overload;
    function Max(const Fields: TFieldList): IQuery; overload;
    function Max(const Value: IValue): IQuery; overload;
    function Max(const Values: array of IValue): IQuery; overload;
    function Max(const Expression: IFrameworkInterface): IQuery; overload;
    function Max(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Min(const Field: TField): IQuery; overload;
    function Min(const Fields: TFieldList): IQuery; overload;
    function Min(const Value: IValue): IQuery; overload;
    function Min(const Values: array of IValue): IQuery; overload;
    function Min(const Expression: IFrameworkInterface): IQuery; overload;
    function Min(const Expressions: array of IFrameworkInterface): IQuery; overload;
    function Sum(const Field: TField): IQuery; overload;
    function Sum(const Value: IValue): IQuery; overload;
    function Sum(const Expresion: IFrameworkInterface): IQuery; overload;
    function Upper(const Field: TField): IQuery; overload;
    function Upper(const Value: IValue): IQuery; overload;
    function Upper(const Expression: IFrameworkInterface): IQuery; overload;

    procedure Reset;
  end;

{ TQuery }

function TQuery.&And: IQuery;
begin
  GetConditionsEditing.&And;
  Result := Self;
end;

function TQuery.Avg(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Avg(Field));
  Result := Self;
end;

function TQuery.Avg(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Avg(Value));
  Result := Self;
end;

function TQuery.Avg(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Avg(Expression));
  Result := Self;
end;

function TQuery.&Or: IQuery;
begin
  GetConditionsEditing.&Or;
  Result := Self;
end;

function TQuery.OrderBy(const Field: TField;
  const Attr: TOrderAttr): IQuery;
var
  O: IOrder;
begin
  FSection := secOrderBy;

  O := Objects.New<IOrder>;
  O.SetValue(ValueRepository.Field(Field));
  O.SetAttr(Attr);

  FOrder.Add(O);
  O := nil;

  Result := Self;
end;

function TQuery.OrderBy(const Expression: IFrameworkInterface;
  const Attr: TOrderAttr): IQuery;
var
  O: IOrder;
begin
  FSection := secOrderBy;

  O := Objects.New<IOrder>;
  O.SetValue(Expression);
  O.SetAttr(Attr);

  FOrder.Add(O);
  O := nil;

  Result := Self;
end;

function TQuery.OrderBy(const Expression: IFrameworkInterface): IQuery;
var
  O: IOrder;
begin
  FSection := secOrderBy;

  O := Objects.New<IOrder>;
  O.SetValue(Expression);

  FOrder.Add(O);
  O := nil;

  Result := Self;
end;

function TQuery.OrderBy(const Expressions: array of IFrameworkInterface): IQuery;
var
  E: IFrameworkInterface;
begin
  FSection := secOrderBy;

  for E in Expressions do
    OrderBy(E);

  Result := Self;
end;

function TQuery.Owner(const Username: String): IQuery;
begin
  FOwner := Username;
  Result := Self;
end;

function TQuery.PrimaryKey(const Fields: TFieldList): IQuery;
begin
  FSection := secPrimaryKey;

  FPrimaryKey := Objects.New<IPrimaryKey>;
  FPrimaryKey.SetFields(Fields);

  Result := Self;
end;

function TQuery.PrimaryKey(const Field: TField): IQuery;
begin
  FSection := secPrimaryKey;

  FPrimaryKey := Objects.New<IPrimaryKey>;
  FPrimaryKey.SetFields([Field]);

  Result := Self;
end;

function TQuery.Offset(const Value: Integer): IQuery;
begin
  Result := Offset(ValueRepository.Int(Value));
end;

function TQuery.Offset(const Expression: IFrameworkInterface): IQuery;
begin
  FLimit.SetOffset(Expression);
  Result := Self;
end;

function TQuery.Offset(const Value: IValue): IQuery;
begin
  FLimit.SetOffset(Value);
  Result := Self;
end;

function TQuery.&On: IQuery;
begin
  Result := Self;
end;

function TQuery.&Not: IQuery;
begin
  GetConditionsEditing.&Not;
  Result := Self;
end;

function TQuery.NotNull: IQuery;
begin
  GetFieldEditing.SetNull(False);
  Result := Self;
end;

function TQuery.Null: IQuery;
begin
  GetFieldEditing.SetNull(True);
  Result := Self;
end;

function TQuery.&Set(const Field, Value: TField): IQuery;
var
  F: IFieldSet;
begin
  FSection := secSet;

  F := Objects.New<IFieldset>;
  F.SetField( ValueRepository.Field(Field) );
  F.SetValue( ValueRepository.Field(Value) );

  FFieldsets.Add(F);
  F := nil;

  Result := Self;
end;

function TQuery.&Set(const Field: TField; const Value: IValue): IQuery;
var
  F: IFieldSet;
begin
  FSection := secSet;

  F := Objects.New<IFieldset>;
  F.SetField( ValueRepository.Field(Field) );
  F.SetValue( Value );

  FFieldsets.Add(F);
  F := nil;

  Result := Self;
end;

function TQuery.&Set(const Field: TField; const Value: IFrameworkInterface): IQuery;
var
  F: IFieldSet;
begin
  FSection := secSet;

  F := Objects.New<IFieldset>;
  F.SetField( ValueRepository.Field(Field) );
  F.SetValue( Value );

  FFieldsets.Add(F);
  F := nil;

  Result := Self;
end;

function TQuery.&With: IQuery;
begin
  Result := Self;
end;

function TQuery.&In(const Field: TField;
  const List: array of IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.&In(ValueRepository.Field(Field), List);
  Result := Self;
end;

function TQuery.&In(const Expression: IFrameworkInterface;
  const List: array of IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.&In(Expression, List);
  Result := Self;
end;

function TQuery.All: IQuery;
begin
  FSelectAttr := FSelectAttr + [satAll];
  Result := Self;
end;

function TQuery.Between(const Value, FirstCompared,
  SecondCompared: IValue): IQuery;
begin
  GetConditionsEditing.Between(Value, FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.Between(const Field: TField; const FirstCompared,
  SecondCompared: IValue): IQuery;
begin
  GetConditionsEditing.Between(
    ValueRepository.Field(Field), FirstCompared, SecondCompared );
  Result := Self;
end;

function TQuery.Between(const Field, FirstCompared,
  SecondCompared: TField): IQuery;
begin
  GetConditionsEditing.Between( ValueRepository.Field(Field),
    ValueRepository.Field(FirstCompared), ValueRepository.Field(SecondCompared) );
  Result := Self;
end;

function TQuery.Between(const Field: TField; const FirstCompared,
  SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Between(
    ValueRepository.Field(Field), FirstCompared, SecondCompared );
  Result := Self;
end;

function TQuery.Between(const Expression, FirstCompared,
  SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Between(Expression, FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.Between(const Value: IValue; const FirstCompared,
  SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Between(Value, FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared: TField;
  const SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.BiggerThan(
    ValueRepository.Field(FirstCompared), SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared: TField;
  const SecondCompared: IValue): IQuery;
begin
  GetConditionsEditing.BiggerThan(
    ValueRepository.Field(FirstCompared), SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared,
  SecondCompared: TField): IQuery;
begin
  GetConditionsEditing.BiggerThan(
    ValueRepository.Field(FirstCompared),
    ValueRepository.Field(SecondCompared) );
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared,
  SecondCompared: IValue): IQuery;
begin
  GetConditionsEditing.BiggerThan(FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared: IFrameworkInterface;
  const SecondCompared: IValue): IQuery;
begin
  GetConditionsEditing.BiggerThan(FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared,
  SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.BiggerThan(FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.BiggerThan(const FirstCompared: IValue;
  const SecondCompared: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.BiggerThan(FirstCompared, SecondCompared);
  Result := Self;
end;

function TQuery.BigInt: IQuery;
begin
  GetFieldEditing.SetDataType(datBigInt);
  Result := Self;
end;

function TQuery.BigSerial: IQuery;
begin
  GetFieldEditing.SetDataType(datBigSerial);
  Result := Self;
end;

function TQuery.Bit: IQuery;
begin
  GetFieldEditing.SetDataType(datBit);
  Result := Self;
end;

function TQuery.Blob: IQuery;
begin
  GetFieldEditing.SetDataType(datBlob);
  Result := Self;
end;

function TQuery.Bool: IQuery;
begin
  GetFieldEditing.SetDataType(datBool);
  Result := Self;
end;

function TQuery.Cache: IQuery;
begin
  FSelectAttr := FSelectAttr + [satCache];
  Result := Self;
end;

function TQuery.Char(const Size: Integer): IQuery;
begin
  GetFieldEditing.SetDataType(datChar).SetSize(Size);
  Result := Self;
end;

function TQuery.Coalesce(const Fields: TFieldList): IQuery;
begin
  InsertFunction(FunctionRepository.Coalesce(Fields));
  Result := Self;
end;

function TQuery.Coalesce(const Values: array of IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Coalesce(Values));
  Result := Self;
end;

function TQuery.Coalesce(const Expressions: array of IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Coalesce(Expressions));
  Result := Self;
end;

function TQuery.Concat(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Value));
  Result := Self;
end;

function TQuery.Concat(const Fields: TFieldList): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Fields));
  Result := Self;
end;

function TQuery.Concat(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Field));
  Result := Self;
end;

function TQuery.Concat(const Expressions: array of IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Expressions));
  Result := Self;
end;

function TQuery.Concat(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Expression));
  Result := Self;
end;

function TQuery.Concat(const Values: array of IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Concat(Values));
  Result := Self;
end;

function TQuery.Count(const Values: array of IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Values));
  Result := Self;
end;

function TQuery.Count(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Expression));
  Result := Self;
end;

function TQuery.Count(const Expressions: array of IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Expressions));
  Result := Self;
end;

function TQuery.Create: IQuery;
begin
  FCommandType := ctCreate;
  FSection := secCreate;
  Result := Self;
end;

function TQuery.Count(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Field));
  Result := Self;
end;

function TQuery.Count(const Fields: TFieldList): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Fields));
  Result := Self;
end;

function TQuery.Count(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Count(Value));
  Result := Self;
end;

constructor TQuery._Create;
begin
  FCommandType := ctNone;
  FCommand := EmptyStr;
  FSection := secNone;
  FDatabase := EmptyStr;
  FInherits := EmptyStr;
  FTable := EmptyStr;
  FCreateAttr := [];
  FSelectAttr := [];
  FSelectExpressions := Objects.NewList;
  FJoins := Objects.NewList;
  FGroup := Objects.NewList;
  FOrder := Objects.NewList;
  FFieldsets := Objects.NewList;
  FWhere := Objects.New<IConditions>;
  FHaving := Objects.New<IConditions>;
  FLimit := nil;
  FFields := Objects.NewList;
  FForeignKeys := Objects.NewList;
  FIndexes := Objects.NewList;
  FValues := Objects.NewList;
end;

function TQuery.Database(const Database: String): IQuery;
begin
  FDatabase := Database;
  Result := Self;
end;

function TQuery.Date: IQuery;
begin
  GetFieldEditing.SetDataType(datDate);
  Result := Self;
end;

function TQuery.Datetime: IQuery;
begin
  GetFieldEditing.SetDataType(datDatetime);
  Result := Self;
end;

function TQuery.Decimal(const Size, Precision: Integer): IQuery;
begin
  GetFieldEditing.SetDataType(datDecimal)
    .SetSize(Size)
    .SetPrecision(Precision);
  Result := Self;
end;

function TQuery.Default(const Value: IValue): IQuery;
begin
  GetFieldEditing.SetDefault(Value);
  Result := Self;
end;

function TQuery.Default(const Expression: IFrameworkInterface): IQuery;
begin
  GetFieldEditing.SetDefault(Expression);
  Result := Self;
end;

function TQuery.DefaultNull: IQuery;
begin
  GetFieldEditing.SetNull(True);
  Result := Self;
end;

destructor TQuery.Destroy;
begin
  if Assigned(FSelectExpressions) then
    try
      FSelectExpressions.Clear;
      FSelectExpressions := nil;
    except end;

  if Assigned(FFrom) then
    try
      FFrom := nil;
    except end;

  if Assigned(FJoins) then
    try
      FJoins.Clear;
      FJoins := nil;
    except end;

  if Assigned(FWhere) then
    try
      FWhere := nil;
    except end;

  if Assigned(FGroup) then
    try
      FGroup.Clear;
      FGroup := nil;
    except end;

  if Assigned(FOrder) then
    try
      FOrder.Clear;
      FOrder := nil;
    except end;

  if Assigned(FLimit) then
    try
      FLimit := nil;
    except end;

  if Assigned(FFieldsets) then
    try
      FFieldsets.Clear;
      FFieldsets := nil;
    except end;

  if Assigned(FFields) then
    try
      FFields.Clear;
      FFields := nil;
    except end;

  if Assigned(FPrimaryKey) then
    try
      FPrimaryKey := nil;
    except end;

  if Assigned(FForeignKeys) then
    try
      FForeignKeys.Clear;
      FForeignKeys := nil;
    except end;

  if Assigned(FIndexes) then
    try
      FIndexes.Clear;
      FIndexes := nil;
    except end;

  if Assigned(FValues) then
    try
      FValues.Clear;
      FValues := nil;
    except end;

  inherited;
end;

function TQuery.Distinct: IQuery;
begin
  FSelectAttr := FSelectAttr + [satDistinct];
  Result := Self;
end;

function TQuery.Double(const Size, Precision: Integer): IQuery;
begin
  GetFieldEditing.SetDataType(datDouble)
    .SetSize(Size)
    .SetPrecision(Precision);
  Result := Self;
end;

function TQuery.Encoding(const Name: String): IQuery;
begin
  FEncoding := Name;
  Result := Self;
end;

function TQuery.Equal(const Field: TField;
  const Value: IValue): IQuery;
begin
  GetConditionsEditing.Equal( ValueRepository.Field(Field), Value );
  Result := Self;
end;

function TQuery.Equal(const FirstField, SecondField: TField): IQuery;
begin
  GetConditionsEditing.Equal(
    ValueRepository.Field(FirstField), ValueRepository.Field(SecondField) );
  Result := Self;
end;

function TQuery.Equal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Equal( FirstExpression, SecondExpression );
  Result := Self;
end;

function TQuery.Exists: IQuery;
begin
  FCommandType := ctExists;
  Result := Self;
end;

function TQuery.Equal(const Field: TField;
  const Expression: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Equal( ValueRepository.Field(Field), Expression );
  Result := Self;
end;

function TQuery.Equal(const FirstValue, SecondValue: IValue): IQuery;
begin
  GetConditionsEditing.Equal(FirstValue, SecondValue);
  Result := Self;
end;

function TQuery.Field(const Name: TField): IQuery;
var
  F: IField;
begin
  if FSection = secSelect then
    FSelectExpressions.Add(ValueRepository.Field(Name))
  else
    try
      F := Objects.New<IField>;
      F.SetName(Name);

      FFields.Add(F);
    finally
      F := nil;
    end;

  Result := Self;
end;

function TQuery.FinishWith(const FirstValue, SecondValue: IValue): IQuery;
begin
  GetConditionsEditing.FinishWith(FirstValue, SecondValue);
  Result := Self;
end;

function TQuery.Float(const Size, Precision: Integer): IQuery;
begin
  GetFieldEditing.SetDataType(datFloat)
    .SetSize(Size)
    .SetPrecision(Precision);
  Result := Self;
end;

function TQuery.ForeignKey(const Field: TField): IQuery;
var
  F: IForeignKey;
begin
  FSection := secForeignKey;

  F := Objects.New<IForeignKey>;
  F.SetField(Field);

  FForeignKeys.Add(F);
  F := nil;

  Result := Self;
end;

function TQuery.ForeignKey(const Name: String;
  const Field: TField): IQuery;
var
  F: IForeignKey;
begin
  FSection := secForeignKey;

  F := Objects.New<IForeignKey>;
  F.SetField(Field);
  F.SetName(Name);

  FForeignKeys.Add(F);
  F := nil;

  Result := Self;
end;

function TQuery.From(const Expression: IFrameworkInterface): IQuery;
begin
  FSection := secFrom;
  FFrom := Expression;
  Result := Self;
end;

function TQuery.From(const Table: TTable): IQuery;
begin
  FSection := secFrom;
  FFrom := ValueRepository.Table(Table);
  Result := Self;
end;

function TQuery.GroupBy(const Field: TField): IQuery;
var
  G: IGroup;
begin
  FSection := secGroupBy;

  G := Objects.New<IGroup>;
  G.SetValue( ValueRepository.Field(Field) );

  FGroup.Add(G);
  G := nil;

  Result := Self;
end;

function TQuery.GetCommand: String;
begin
  Result := FCommand;
end;

function TQuery.GetCommandType: TCommandType;
begin
  Result := FCommandType;
end;

function TQuery.GetConditionsEditing: IConditions;
begin
  case FSection of
    secJoin,
    secJoinLeft,
    secJoinRight:
      Result := (FJoins.Iterator.Last as IJoin).Conditions;

    secWhere:
      Result := FWhere;
  else
    Result := nil;
  end;
end;

function TQuery.GetCreateAttr: TCreateAttributes;
begin
  Result := FCreateAttr;
end;

function TQuery.GetDatabase: String;
begin
  Result := FDatabase;
end;

function TQuery.GetEncoding: String;
begin
  Result := FEncoding;
end;

function TQuery.GetFieldEditing: IField;
begin
  Result := nil;

  if FFields.Count > 0 then
    Result := FFields.Iterator.Last as IField;
end;

function TQuery.GetFields: IList;
begin
  Result := FFields;
end;

function TQuery.GetFieldsets: IList;
begin
  Result := FFieldsets;
end;

function TQuery.GetForeignKeys: IList;
begin
  Result := FForeignKeys;
end;

function TQuery.GetFrom: IFrameworkInterface;
begin
  Result := FFrom;
end;

function TQuery.GetGroup: IList;
begin
  Result := FGroup;
end;

function TQuery.GetHaving: IConditions;
begin
  Result := FHaving;
end;

function TQuery.GetIndexes: IList;
begin
  Result := FIndexes;
end;

function TQuery.GetInherits: TTable;
begin
  Result := FInherits;
end;

function TQuery.GetJoins: IList;
begin
  Result := FJoins;
end;

function TQuery.GetLimit: ILimit;
begin
  Result := FLimit;
end;

function TQuery.GetOrder: IList;
begin
  Result := FOrder;
end;

function TQuery.GetOwner: String;
begin
  Result := FOwner;
end;

function TQuery.GetPrimaryKey: IPrimaryKey;
begin
  Result := FPrimaryKey;
end;

function TQuery.GetSelectAttr: TSelectAttributes;
begin
  Result := FSelectAttr;
end;

function TQuery.GetSelectExpressions: IList;
begin
  Result := FSelectExpressions;
end;

function TQuery.GetTable: TTable;
begin
  Result := FTable;
end;

function TQuery.GetTemplate: String;
begin
  Result := FTemplate;
end;

function TQuery.GetValues: IList;
begin
  Result := FValues;
end;

function TQuery.GetWhere: IConditions;
begin
  Result := FWhere;
end;

function TQuery.GroupBy(const Fields: array of TField): IQuery;
var
  F: TField;
begin
  FSection := secGroupBy;

  for F in Fields do
    GroupBy(F);

  Result := Self;
end;

function TQuery.IfNotExists: IQuery;
begin
  FCreateAttr := FCreateAttr + [catIfNotExists];
  Result := Self;
end;

function TQuery.&In(const Value: IValue;
  const List: array of IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.&In(Value, List);
  Result := Self;
end;

function TQuery.Inherits(const Table: TTable): IQuery;
begin
  FInherits := Table;
  Result := Self;
end;

function TQuery.Insert: IQuery;
begin
  FCommandType := ctInsert;
  FSection := secInsert;
  Result := Self;
end;

procedure TQuery.InsertFunction(const Value: IFunction);
begin
  case FSection of
    secCreate: ;
    secSelect: Select(Value);
    secUpdate: ;
    secSet: ;
    secFrom: ;
    secJoin: ;
    secJoinLeft: ;
    secJoinRight: ;
    secWhere: ;
    secGroupBy: ;
    secHaving: ;
    secOrderBy: ;
    secLimit: ;
  end;
end;

function TQuery.Int: IQuery;
begin
  GetFieldEditing.SetDataType(datInt);
  Result := Self;
end;

function TQuery.Into(const Table: TTable): IQuery;
begin
  FSection := secInto;
  FTable := Table;
  Result := Self;
end;

function TQuery.Into(const Table: TTable;
  const Fields: TFieldList): IQuery;
var
  F: TField;
begin
  FSection := secInto;
  FTable := Table;

  for F in Fields do
    FFields.Add( ValueRepository.Field(F) );

  Result := Self;
end;

function TQuery.Join(const Table: TTable): IQuery;
var
  J: IJoin;
begin
  FSection := secJoin;

  J := Objects.New<IJoin>;
  J.SetTable(Table);

  FJoins.Add(J);
  J := nil;

  FJoins.Iterator.Last;
  Result := Self;
end;

function TQuery.JoinLeft(const Table: TTable): IQuery;
var
  J: IJoin;
begin
  FSection := secJoinLeft;

  J := Objects.New<IJoin>;
  J.SetAttr(jaLeft);
  J.SetTable(Table);

  FJoins.Add(J);
  J := nil;

  FJoins.Iterator.Last;

  Result := Self;
end;

function TQuery.JoinRight(const Table: TTable): IQuery;
var
  J: IJoin;
begin
  FSection := secJoinRight;

  J := Objects.New<IJoin>;
  J.SetAttr(jaRight);
  J.SetTable(Table);

  FJoins.Add(J);
  J := nil;

  FJoins.Iterator.Last;

  Result := Self;
end;

function TQuery.Json: IQuery;
begin
  GetFieldEditing.SetDataType(datJson);
  Result := Self;
end;

function TQuery.Like(const FirstValue, SecondValue: IValue): IQuery;
begin
  GetConditionsEditing.Like(FirstValue, SecondValue);
  Result := Self;
end;

function TQuery.Limit(const Value: Integer): IQuery;
begin
  Result := Limit(ValueRepository.Int(Value));
end;

function TQuery.Limit(const Expression: IFrameworkInterface): IQuery;
begin
  FSection := secLimit;
  FLimit := Objects.New<ILimit>;
  FLimit.SetRowCount(Expression);
  Result := Self;
end;

function TQuery.Limit(const Value: IValue): IQuery;
begin
  FSection := secLimit;
  FLimit := Objects.New<ILimit>;
  FLimit.SetRowCount(Value);
  Result := Self;
end;

function TQuery.NoCache: IQuery;
begin
  FSelectAttr := FSelectAttr + [satNoCache];
  Result := Self;
end;

function TQuery.OrderBy(const Field: TField): IQuery;
var
  O: IOrder;
begin
  FSection := secOrderBy;

  O := Objects.New<IOrder>;
  O.SetValue( ValueRepository.Field(Field) );

  FOrder.Add(O);
  O := nil;

  Result := Self;
end;

function TQuery.OrderBy(const Fields: array of TField): IQuery;
var
  F: TField;
begin
  FSection := secOrderBy;

  for F in Fields do
    OrderBy(F);

  Result := Self;
end;

function TQuery.Select(const Field: TField): IQuery;
begin
  FCommandType := ctSelect;
  FSection := secSelect;
  FSelectExpressions.Add(ValueRepository.Field(Field));
  Result := Self;
end;

function TQuery.Select(
  const Fields: array of TField): IQuery;
var
  F: TField;
begin
  FCommandType := ctSelect;
  FSection := secSelect;

  for F in Fields do
    Select(F);

  Result := Self;
end;

function TQuery.Select(const Expression: IFrameworkInterface): IQuery;
begin
  FCommandType := ctSelect;
  FSection := secSelect;

  FSelectExpressions.Add(Expression);
  Result := Self;
end;

function TQuery.Select(const Expressions: array of IFrameworkInterface): IQuery;
var
  E: IFrameworkInterface;
begin
  FCommandType := ctSelect;
  FSection := secSelect;

  for E in Expressions do
    FSelectExpressions.Add(E);

  Result := Self;
end;

function TQuery.Serial: IQuery;
begin
  GetFieldEditing.SetDataType(datSerial);
  Result := Self;
end;

procedure TQuery.SetCommand(const Value: String);
begin
  FCommand := Value;
end;

function TQuery.SmallInt: IQuery;
begin
  GetFieldEditing.SetDataType(datSmallInt);
  Result := Self;
end;

function TQuery.SortAsc: IQuery;
begin
  case FSection of
    secGroupBy: (FGroup.Iterator.Last as IGroup).SetAttr(gaAsc);
    secOrderBy: (FOrder.Iterator.Last as IOrder).SetAttr(oaAsc);
  end;
  Result := Self;
end;

function TQuery.SortDesc: IQuery;
begin
  case FSection of
    secGroupBy: (FGroup.Iterator.Last as IGroup).SetAttr(gaDesc);
    secOrderBy: (FOrder.Iterator.Last as IOrder).SetAttr(oaDesc);
  end;
  Result := Self;
end;

function TQuery.StartWith(const FirstValue, SecondValue: IValue): IQuery;
begin
  GetConditionsEditing.StartWith(FirstValue, SecondValue);
  Result := Self;
end;

function TQuery.Sum(const Expresion: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Sum(Expresion));
  Result := Self;
end;

function TQuery.Table(const Table: TTable): IQuery;
begin
  FTable := Table;
  Result := Self;
end;

function TQuery.Template(const Name: String): IQuery;
begin
  FTemplate := Name;
  Result := Self;
end;

function TQuery.Temporary: IQuery;
begin
  FCreateAttr := FCreateAttr + [catTemporary];
  Result := Self;
end;

function TQuery.Text: IQuery;
begin
  GetFieldEditing.SetDataType(datText);
  Result := Self;
end;

function TQuery.Time: IQuery;
begin
  GetFieldEditing.SetDataType(datTime);
  Result := Self;
end;

function TQuery.Timestamp: IQuery;
begin
  GetFieldEditing.SetDataType(datTimestamp);
  Result := Self;
end;

function TQuery.TinyBlob: IQuery;
begin
  GetFieldEditing.SetDataType(datTinyBlob);
  Result := Self;
end;

function TQuery.TinyInt: IQuery;
begin
  GetFieldEditing.SetDataType(datTinyInt);
  Result := Self;
end;

function TQuery.TinyText: IQuery;
begin
  GetFieldEditing.SetDataType(datTinyText);
  Result := Self;
end;

function TQuery.Sum(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Sum(Value));
  Result := Self;
end;

function TQuery.Sum(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Sum(Field));
  Result := Self;
end;

function TQuery.Unequal(const FirstValue, SecondValue: IValue): IQuery;
begin
  GetConditionsEditing.Unequal(FirstValue, SecondValue);
  Result := Self;
end;

function TQuery.Unique(const Fields: TFieldList): IQuery;
var
  U: IUnique;
begin
  FSection := secIndex;

  U := Objects.New<IUnique>('Unique');
  U.SetFields(Fields);

  FIndexes.Add(U);
  U := nil;

  Result := Self;
end;

function TQuery.Unique(const Field: TField): IQuery;
var
  U: IUnique;
begin
  FSection := secIndex;

  U := Objects.New<IUnique>('Unique');
  U.SetFields([Field]);

  FIndexes.Add(U);
  U := nil;

  Result := Self;
end;

function TQuery.Unequal(const Field: TField;
  const Value: IValue): IQuery;
begin
  GetConditionsEditing.Unequal( ValueRepository.Field(Field), Value );
  Result := Self;
end;

function TQuery.Unequal(const FirstField, SecondField: TField): IQuery;
begin
  GetConditionsEditing.Unequal(
    ValueRepository.Field(FirstField), ValueRepository.Field(SecondField) );
  Result := Self;
end;

function TQuery.Unequal(const FirstExpression, SecondExpression: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Unequal(FirstExpression, SecondExpression);
  Result := Self;
end;

function TQuery.Unequal(const Field: TField;
  const Expression: IFrameworkInterface): IQuery;
begin
  GetConditionsEditing.Unequal( ValueRepository.Field(Field), Expression );
  Result := Self;
end;

function TQuery.Unique(const Name: String;
  const Fields: TFieldList): IQuery;
var
  U: IUnique;
begin
  FSection := secIndex;

  U := Objects.New<IUnique>('Unique');
  U.SetFields(Fields);
  U.SetName(Name);

  FIndexes.Add(U);
  U := nil;

  Result := Self;
end;

function TQuery.Unique(const Name: String; const Field: TField): IQuery;
var
  U: IUnique;
begin
  FSection := secIndex;

  U := Objects.New<IUnique>('Unique');
  U.SetFields([Field]);
  U.SetName(Name);

  FIndexes.Add(U);
  U := nil;

  Result := Self;
end;

function TQuery.Update(const Table: TTable): IQuery;
begin
  FCommandType := ctUpdate;
  FSection := secUpdate;
  FTable := Table;
  Result := Self;
end;

function TQuery.Upper(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Upper(Field));
  Result := Self;
end;

function TQuery.Upper(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Upper(Value));
  Result := Self;
end;

function TQuery.Upper(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Upper(Expression));
  Result := Self;
end;

function TQuery.Values(const Value: array of IValue): IQuery;
var
  V: IValue;
begin
  FSection := secValues;

  for V in Value do
    FValues.Add( V );

  Result := Self;
end;

function TQuery.Values(
  const Expressions: array of IFrameworkInterface): IQuery;
var
  E: IFrameworkInterface;
begin
  FSection := secValues;

  for E in Expressions do
    FValues.Add( E );

  Result := Self;
end;

function TQuery.Varchar(const Size: Integer): IQuery;
begin
  GetFieldEditing.SetDataType(datVarchar).SetSize(Size);
  Result := Self;
end;

function TQuery.Where: IQuery;
begin
  FSection := secWhere;
  Result := Self;
end;

function TQuery.GroupBy(const Expression: IFrameworkInterface): IQuery;
var
  G: IGroup;
begin
  FSection := secGroupBy;

  G := Objects.New<IGroup>;
  G.SetValue(Expression);

  FGroup.Add(G);
  G := nil;

  Result := Self;
end;

function TQuery.GroupBy(const Expressions: array of IFrameworkInterface): IQuery;
var
  E: IFrameworkInterface;
begin
  FSection := secGroupBy;

  for E in Expressions do
    GroupBy(E);

  Result := Self;
end;

function TQuery.GroupBy(const Expression: IFrameworkInterface;
  const Attr: TGroupAttr): IQuery;
var
  G: IGroup;
begin
  FSection := secGroupBy;

  G := Objects.New<IGroup>;
  G.SetValue(Expression);
  G.SetAttr(Attr);

  FGroup.Add(G);
  G := nil;

  Result := Self;
end;

function TQuery.GroupBy(const Field: TField;
  const Attr: TGroupAttr): IQuery;
var
  G: IGroup;
begin
  FSection := secGroupBy;

  G := Objects.New<IGroup>;
  G.SetValue( ValueRepository.Field(Field) );
  G.SetAttr(Attr);

  FGroup.Add(G);
  G := nil;

  Result := Self;
end;

function TQuery.Having: IQuery;
begin
  FSection := secHaving;
  Result := Self;
end;

function TQuery.Limit(const Value: Integer;
  const Attr: TLimitAttrs): IQuery;
begin
  Result := Limit(ValueRepository.Int(Value), Attr);
end;

function TQuery.Limit(const Expression: IFrameworkInterface;
  const Attr: TLimitAttrs): IQuery;
begin
  FSection := secLimit;
  FLimit := Objects.New<ILimit>;
  FLimit.SetRowCount(Expression);
  FLimit.SetAttr(Attr);
  Result := Self;
end;

function TQuery.LongBlob: IQuery;
begin
  GetFieldEditing.SetDataType(datLongBlob);
  Result := Self;
end;

function TQuery.LongText: IQuery;
begin
  GetFieldEditing.SetDataType(datLongText);
  Result := Self;
end;

function TQuery.Lower(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Lower(Field));
  Result := Self;
end;

function TQuery.Lower(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Lower(Value));
  Result := Self;
end;

function TQuery.Lower(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Lower(Expression));
  Result := Self;
end;

function TQuery.Max(const Values: array of IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Values));
  Result := Self;
end;

function TQuery.Max(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Expression));
  Result := Self;
end;

function TQuery.Max(const Expressions: array of IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Expressions));
  Result := Self;
end;

function TQuery.MediumBlob: IQuery;
begin
  GetFieldEditing.SetDataType(datMediumBlob);
  Result := Self;
end;

function TQuery.MediumInt: IQuery;
begin
  GetFieldEditing.SetDataType(datMediumInt);
  Result := Self;
end;

function TQuery.Max(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Field));
  Result := Self;
end;

function TQuery.Max(const Fields: TFieldList): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Fields));
  Result := Self;
end;

function TQuery.Max(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Max(Value));
  Result := Self;
end;

function TQuery.Min(const Values: array of IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Values));
  Result := Self;
end;

function TQuery.Min(const Value: IValue): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Value));
  Result := Self;
end;

function TQuery.Min(const Expressions: array of IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Expressions));
  Result := Self;
end;

function TQuery.Min(const Expression: IFrameworkInterface): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Expression));
  Result := Self;
end;

function TQuery.Min(const Fields: TFieldList): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Fields));
  Result := Self;
end;

function TQuery.Min(const Field: TField): IQuery;
begin
  InsertFunction(FunctionRepository.Min(Field));
  Result := Self;
end;

function TQuery.Limit(const Value: IValue;
  const Attr: TLimitAttrs): IQuery;
begin
  FSection := secLimit;
  FLimit := Objects.New<ILimit>;
  FLimit.SetRowCount(Value);
  FLimit.SetAttr(Attr);
  Result := Self;
end;

function TQuery.PrimaryKey(const Name: String;
  const Fields: TFieldList): IQuery;
begin
  FSection := secPrimaryKey;

  FPrimaryKey := Objects.New<IPrimaryKey>;
  FPrimaryKey.SetName(Name);
  FPrimaryKey.SetFields(Fields);

  Result := Self;
end;

function TQuery.Reference(const Table: TTable;
  const Field: TField): IQuery;
begin
  (FForeignKeys.Iterator.Last as IForeignKey).Reference
    .SetTable(Table)
    .SetField(Field);

  Result := Self;
end;

procedure TQuery.Reset;
begin
  FCommandType := ctNone;
  FCommand := '';
  FSection := secNone;
  FCreateAttr := [];
  FDatabase := '';
  FInherits := '';
  FSelectAttr := [];
  FSelectExpressions.Clear;
  FFrom := nil;
  FWhere.List.Clear;
  FHaving.List.Clear;
  FJoins.Clear;
  FGroup.Clear;
  FOrder.Clear;
  FLimit := nil;
  FTable := '';
  FFieldsets.Clear;
  FFields.Clear;
  FPrimaryKey := nil;
  FForeignKeys := nil;
  FIndexes.Clear;
  FOwner := '';
  FTemplate := '';
  FEncoding := '';
  FValues.Clear;
end;

function TQuery.PrimaryKey(const Name: String;
  const Field: TField): IQuery;
begin
  FSection := secPrimaryKey;

  FPrimaryKey := Objects.New<IPrimaryKey>;
  FPrimaryKey.SetName(Name);
  FPrimaryKey.SetFields([Field]);

  Result := Self;
end;

initialization
  Objects.RegisterType<IQuery, TQuery>;

end.
