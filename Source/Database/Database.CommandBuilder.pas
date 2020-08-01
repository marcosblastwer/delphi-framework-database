unit Database.CommandBuilder;

interface

uses
  Base.Objects,
  Database.Drivers,
  Database.Query;

type
  ICommandBuilder = interface(IFrameworkInterface)
    ['{9BDCB49A-A4C9-4604-BA95-7BB9A333048C}']
    function Prepare(Query: IQuery): Boolean;
  end;

  CommandBuilder = class
    class function Invoke(const Driver: TDatabaseDriver): ICommandBuilder;
  end;

implementation

uses
  System.SysUtils,
  Base.Value,
  Database.CommandBuilder.Types,
  Database.Condition,
  Database.Constraint,
  Database.Field,
  Database.Fieldset,
  Database.Functions,
  Database.Join,
  Database.Limit,
  Database.Order,
  Database.Query.Types;

type
  TCommandBuilder = class(TFrameworkObject, ICommandBuilder)
  private
    FCommandAssortment: TCommandAssortment;
    FFormats: TFormats;
    FSyntaxes: TSyntaxes;
    FQuoteMethod: TQuoteMethod;
    function GetQuery: IQuery;
  protected
    FQuerys: IList;
    procedure Include(const Value: String); overload;
    procedure Include(const Value: Integer); overload;
    procedure Include(const Value: IValue); overload;
    procedure Include(const FieldList: TFieldList); overload;
    procedure IncludeAssortment(var AssortmentArray: TAssortment; const Section: TCommandSection);

    procedure GenerateCommand(const AssortmentArray: TAssortment);
    procedure GenerateCommandSection(const Section: TCommandSection);

    function GetExpression(const Param: IFrameworkInterface): String;
    function GetCondition(const Param: ICondition): String;
    function GetConditions(const Param: IConditions): String;
    function GetFunction(const Param: IFunction): String;
    function GetList(const Param: IList): String; overload;
    function GetList(const Param: TFieldList): String; overload;
    function GetValue(const Param: IValue): String;

    function GetCreateAttr: String;
    function GetCreateObject: String;
    function GetField: String;
    function GetFieldsets: String;
    function GetForeignKey: String;
    function GetFrom: String;
    function GetGroup: String;
    function GetHaving: String;
    function GetInto: String;
    function GetJoin: String;
    function GetLimit: String;
    function GetOrder: String;
    function GetPrimaryKey: String;
    function GetSelectAttr: String;
    function GetSelectedFields: String;
    function GetUnique: String;
    function GetUpdate: String;
    function GetValues: String;
    function GetWith: String;
    function GetWhere: String;

    procedure Initialize; virtual;
    procedure InitializeCommandAssortment; virtual;
    procedure InitializeCommandAssortmentCreate; virtual;
    procedure InitializeCommandAssortmentInsert; virtual;
    procedure InitializeCommandAssortmentSelect; virtual;
    procedure InitializeCommandAssortmentUpdate; virtual;
    procedure InitializeFormats; virtual;
    procedure InitializeSyntaxes; virtual;
    procedure InitializeSyntaxesComparisson; virtual;
    procedure InitializeSyntaxesCreate; virtual;
    procedure InitializeSyntaxesCreateAttr; virtual;
    procedure InitializeSyntaxesDatatype; virtual;
    procedure InitializeSyntaxesDatatypeAttr; virtual;
    procedure InitializeSyntaxesFunction; virtual;
    procedure InitializeSyntaxesIndexes; virtual;
    procedure InitializeSyntaxesLimitAttr; virtual;
    procedure InitializeSyntaxesOrderAttr; virtual;
    procedure InitializeSyntaxesSelectAttr; virtual;
    procedure InitializeSyntaxesWith; virtual;

    procedure PrepareCreate;
    procedure PrepareDelete;
    procedure PrepareDrop;
    procedure PrepareInsert;
    procedure PrepareReplace;
    procedure PrepareSelect;
    procedure PrepareUpdate;

    property Formats: TFormats read FFormats write FFormats;
    property Syntaxes: TSyntaxes read FSyntaxes write FSyntaxes;
    property QuoteMethod: TQuoteMethod read FQuoteMethod write FQuoteMethod;
  public
    constructor Create;
    destructor Destroy; override;

    function Prepare(Query: IQuery): Boolean;
  end;

{ TCommandBuilderMariaDb = class(TCommandBuilder)
  end;

  TCommandBuilderMSServer = class(TCommandBuilder)
  end;

  TCommandBuilderMySql = class(TCommandBuilder)
  end; }

  TCommandBuilderPostgre = class(TCommandBuilder)
  end;

{ TCommandBuilder }

constructor TCommandBuilder.Create;
begin
  inherited;

  FQuerys := Objects.NewList;
  FQuoteMethod := DefaultQuote;

  Initialize;
end;

destructor TCommandBuilder.Destroy;
begin
  if Assigned(FQuerys) then
  begin
    try
      FQuerys.Clear;
      FQuerys := nil;
    except end;
  end;

  inherited;
end;

procedure TCommandBuilder.GenerateCommand(
  const AssortmentArray: TAssortment);
var
  S: Word;
begin
  for S in AssortmentArray do
    GenerateCommandSection(TCommandSection(S));
end;

procedure TCommandBuilder.GenerateCommandSection(
  const Section: TCommandSection);
begin
  case Section of
    csCreateAttr:     Include(GetCreateAttr);
    csCreateObject:   Include(GetCreateObject);
    csField:          Include(GetField);
    csForeignKey:     Include(GetForeignKey);
    csFrom:           Include(GetFrom);
    csGroup:          Include(GetGroup);
    csHaving:         Include(GetHaving);
    csInto:           Include(GetInto);
    csJoin:           Include(GetJoin);
    csLimit:          Include(GetLimit);
    csOrder:          Include(GetOrder);
    csPrimaryKey:     Include(GetPrimaryKey);
    csSelectAttr:     Include(GetSelectAttr);
    csSelectedFields: Include(GetSelectedFields);
    csSetfield:       Include(GetFieldsets);
    csUnique:         Include(GetUnique);
    csUpdate:         Include(GetUpdate);
    csValues:         Include(GetValues);
    csWhere:          Include(GetWhere);
    csWith:           Include(GetWith);
  end;
end;

function TCommandBuilder.GetCondition(const Param: ICondition): String;
var
  L: IList;
begin
  Result := EmptyStr;

  case Param.Compare of
    comBetween:
      Result := Format(FSyntaxes.Comparisson.Between,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Get(1) as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comBiggerThan:
      Result := Format(FSyntaxes.Comparisson.BiggerThan,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comEqual:
      Result := Format(FSyntaxes.Comparisson.Equal,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comIn:
      begin
        L := Objects.NewList;
        try
          Param.Values.Iterator.First;
          while Param.Values.Iterator.Next do
            L.Add(Param.Values.Iterator.CurrentItem);

          Result := Format(FSyntaxes.Comparisson.&In,
            [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
             GetList(L)] );
        finally
          L.Clear;
          L := nil;
        end;
      end;

    comLike:
      Result := Format(FSyntaxes.Comparisson.Like,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comNull:
      Result := Format(FSyntaxes.Comparisson.Null,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface)] );

    comSmallerThan:
      Result := Format(FSyntaxes.Comparisson.SmallerThan,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comStartWith:
      Result := Format(FSyntaxes.Comparisson.StartWith,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comFinishWith:
      Result := Format(FSyntaxes.Comparisson.FinishWith,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );

    comUnequal:
      Result := Format(FSyntaxes.Comparisson.Unequal,
        [GetExpression(Param.Values.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Values.Iterator.Last as IFrameworkInterface)] );
  end;

  if (caNot in [Param.Attr]) and (Result.Trim <> '') then
    Result := 'NOT(' + Result + ')';
end;

function TCommandBuilder.GetConditions(const Param: IConditions): String;
begin
  Result := EmptyStr;

  Param.List.Iterator.Reset;
  while Param.List.Iterator.Next do
  begin
    Result := Trim(Result) + ' ' +
      GetCondition(Param.List.Iterator.CurrentItem as ICondition);

    if (Param.List.Iterator.GetIndex >= 0) and
       (Param.List.Iterator.GetIndex < Length(Param.Junctions)) then
    begin
      case Param.Junctions[Param.List.Iterator.GetIndex] of
        juAnd: Result := Trim(Result) + ' AND';
        juOr: Result := Trim(Result) + ' OR';
      end;
    end;
  end;
end;

function TCommandBuilder.GetCreateAttr: String;
begin
  Result := EmptyStr;

  if catTemporary in GetQuery._CreateAttr then
    Result := FSyntaxes.CreateAttr.Temporary;

  if catIfNotExists in GetQuery._CreateAttr then
    Result := Trim(Result) + ' ' + FSyntaxes.CreateAttr.IfNotExists;

  Result := Trim(Result);
end;

function TCommandBuilder.GetCreateObject: String;
begin
  Result := EmptyStr;

  if Trim(GetQuery._Database) <> '' then
    Result := Format(FSyntaxes.CreateDB, [GetQuery._Database])
  else if Trim(GetQuery._Table) <> '' then
    Result := Format(FSyntaxes.CreateTable, [GetQuery._Table]);

  Result := Trim(Result);
end;

function TCommandBuilder.GetExpression(const Param: IFrameworkInterface): String;
begin
  Result := EmptyStr;

  if not Assigned(Param) then
    Exit;

  if Param.Support(IValue) then
    Result := GetValue(Param as IValue)
  else if Param.Support(IFunction) then
    Result := GetFunction(Param as IFunction)
  else if Param.Support(ICondition) then
    Result := GetCondition(Param as ICondition)
  else if Param.Support(IQuery) then
  begin
    if Prepare(Param as IQuery) then
      Result := '(' + (Param as IQuery)._Command + ')';
  end;
end;

function TCommandBuilder.GetField: String;
var
  F: IField;
  Expr,
  ExprDefault,
  ExprNull,
  ExprType: String;
begin
  Result := EmptyStr;

  if GetQuery._Fields.Count <= 0 then
    Exit;

  Result := '(';

  GetQuery._Fields.Iterator.Reset;
  while GetQuery._Fields.Iterator.Next do
  begin
    Expr := EmptyStr;
    F := GetQuery._Fields.Iterator.CurrentItem as IField;

    Expr := F.Name;

    case F.DataType of
      datBigInt: ExprType := FSyntaxes.DataType.BigInt;
      datBigSerial: ExprType := FSyntaxes.DataType.BigSerial;
      datBit: ExprType := FSyntaxes.DataType.Bit;
      datBlob: ExprType := FSyntaxes.DataType.Blob;
      datBool: ExprType := FSyntaxes.DataType.Bool;
      datChar: ExprType := Format(FSyntaxes.DataType.Char, [F.Size]);
      datDate: ExprType := FSyntaxes.DataType.Date;
      datDatetime: ExprType := FSyntaxes.DataType.Datetime;
      datDecimal: ExprType := Format(FSyntaxes.DataType.Decimal, [F.Size, F.Precision]);
      datDouble: ExprType := Format(FSyntaxes.DataType.Double, [F.Size, F.Precision]);
      datFloat: ExprType := Format(FSyntaxes.DataType.Float, [F.Size, F.Precision]);
      datInt: ExprType := FSyntaxes.DataType.Int;
      datJson: ExprType := FSyntaxes.DataType.Json;
      datLongBlob: ExprType := FSyntaxes.DataType.LongBlob;
      datLongText: ExprType := FSyntaxes.DataType.LongText;
      datMediumBlob: ExprType := FSyntaxes.DataType.MediumBlob;
      datMediumInt: ExprType := FSyntaxes.DataType.MediumInt;
      datSerial: ExprType := FSyntaxes.DataType.Serial;
      datSmallInt: ExprType := FSyntaxes.DataType.SmallInt;
      datText: ExprType := FSyntaxes.DataType.Text;
      datTime: ExprType := FSyntaxes.DataType.Time;
      datTimestamp: ExprType := FSyntaxes.DataType.Timestamp;
      datTinyBlob: ExprType := FSyntaxes.DataType.TinyBlob;
      datTinyInt: ExprType := FSyntaxes.DataType.TinyInt;
      datTinyText: ExprType := FSyntaxes.DataType.TinyText;
      datVarchar: ExprType := Format(FSyntaxes.DataType.Varchar, [F.Size]);
    end;

    if F.Null then
      ExprNull := FSyntaxes.DataTypeAttr.Null
    else
      ExprNull := FSyntaxes.DataTypeAttr.NotNull;

    if Assigned(F.Default) then
      ExprDefault := Format(FSyntaxes.DataTypeAttr.Default, [GetExpression(F.Default)]);

    if ExprType.Trim <> '' then
      Expr := Expr + ' ' + ExprType;

    if ExprNull.Trim <> '' then
      Expr := Expr + ' ' + ExprNull;

    if ExprDefault.Trim <> '' then
      Expr := Expr + ' ' + ExprDefault;

    if Expr.Trim <> '' then
      Result := Result + Expr + ',';

    F := nil;
  end;

  if Result[High(Result)] = ',' then
    Result[High(Result)] := ' ';

  Result := Trim(Result);
end;

function TCommandBuilder.GetFieldsets: String;
var
  F: IFieldset;
  Expr: String;
begin
  Result := EmptyStr;
  Expr := EmptyStr;

  GetQuery._Fieldsets.Iterator.Reset;
  while GetQuery._Fieldsets.Iterator.Next do
  begin
    F := GetQuery._Fieldsets.Iterator.CurrentItem as IFieldset;
    try
      Expr := GetValue(F.Field) + '=' + GetExpression(F.Value);

      if Result.Trim = '' then
        Result := Expr
      else
        Result := Result + ',' + Expr;
    finally
      F := nil;
      Expr := EmptyStr;
    end;
  end;
  Result := Trim(Result);

  if Result.Trim <> '' then
    Result := 'SET ' + Result;
end;

function TCommandBuilder.GetForeignKey: String;
var
  ForeignKey: IForeignKey;
  Expr: String;
begin
  Result := EmptyStr;

  if not Assigned(GetQuery._ForeignKeys) then
    Exit;

  if GetQuery._ForeignKeys.Empty then
    Exit;

  GetQuery._ForeignKeys.Iterator.Reset;
  while GetQuery._ForeignKeys.Iterator.Next do
  begin
    Expr := EmptyStr;
    ForeignKey := nil;

    ForeignKey := GetQuery._ForeignKeys.Iterator.CurrentItem as IForeignKey;

    if not Assigned(ForeignKey) then
      Continue;

    if ForeignKey.Name.Trim = '' then
      Expr := Format(FSyntaxes.Indexes.ForeignKey, [ForeignKey.Field])
    else
      Expr := Format(FSyntaxes.Indexes.ForeignKeyWithName, [ForeignKey.Name, ForeignKey.Field]);

    if Expr.Trim = '' then
      Continue;

    if not Assigned(ForeignKey.Reference) then
      Continue;

    Expr := Expr + ' ' +
      Format(FSyntaxes.Indexes.Reference, [ForeignKey.Reference.Table, ForeignKey.Reference.Field]) + ' ';

    Result := Result + Expr + ',';
  end;

  if Result[High(Result)] = ',' then
    Result[High(Result)] := ' ';

  Result := Trim(Result);

  if Result <> '' then
    Result := ',' + Result;
end;

function TCommandBuilder.GetFrom: String;
begin
  Result := EmptyStr;

  if Assigned(GetQuery._From) then
    Result := Format(FSyntaxes.From, [GetExpression(GetQuery._From)]);
end;

function TCommandBuilder.GetFunction(const Param: IFunction): String;
begin
  Result := EmptyStr;

  case Param.&Type of
    fAvg:
      Result := Format(FSyntaxes.&Function.Avg,
        [GetExpression(Param.Factors.Iterator.First as IFrameworkInterface)] );

    fCoalesce:
      Result := Format(FSyntaxes.&Function.Coalesce,
        [GetList(Param.Factors)] );

    fConcat:
      Result := Format(FSyntaxes.&Function.Concat,
        [GetList(Param.Factors)] );

    fCount:
      Result := Format(FSyntaxes.&Function.Count,
        [GetList(Param.Factors)] );

    fIf:
      Result := Format(FSyntaxes.&Function.&If,
        [GetExpression(Param.Factors.Iterator.First as IFrameworkInterface),
         GetExpression(Param.Factors.Iterator.Get(1) as IFrameworkInterface),
         GetExpression(Param.Factors.Iterator.Last as IFrameworkInterface)] );

    fLower:
      Result := Format(FSyntaxes.&Function.&Lower,
        [GetList(Param.Factors)]);

    fMax:
      Result := Format(FSyntaxes.&Function.Max,
        [GetList(Param.Factors)] );

    fMin:
      Result := Format(FSyntaxes.&Function.Min,
        [GetList(Param.Factors)] );

    fSum:
      Result := Format(FSyntaxes.&Function.Sum,
        [GetList(Param.Factors)] );
  end;
end;

function TCommandBuilder.GetGroup: String;
begin
  Result := EmptyStr;

  if not GetQuery._Group.Empty then
    Result := Format(FSyntaxes.Group, [GetList(GetQuery._Group)]);
end;

function TCommandBuilder.GetHaving: String;
begin
  Result := EmptyStr;

  if not GetQuery._Having.List.Empty then
    Result := Format(FSyntaxes.Having, [GetConditions(GetQuery._Having)]);
end;

function TCommandBuilder.GetInto: String;
begin
  Result := EmptyStr;

  if Trim(GetQuery._Table) <> '' then
    Result := Trim(GetQuery._Table);

  if not GetQuery._Fields.Empty then
    Result := Result + ' (' + GetList(GetQuery._Fields) + ')';
end;

function TCommandBuilder.GetJoin: String;
var
  J: IJoin;
  Syntax: String;
begin
  Result := EmptyStr;

  GetQuery._Joins.Iterator.Reset;
  while GetQuery._Joins.Iterator.Next do
  begin
    J := GetQuery._Joins.Iterator.CurrentItem as IJoin;

    if not Assigned(J) then
      Continue;

    case J.Attr of
      jaNone: Syntax := FSyntaxes.Join;
      jaLeft: Syntax := FSyntaxes.JoinLeft;
      jaRight: Syntax := FSyntaxes.JoinRight;
    end;

    Result := Trim(Result) + ' ' +
      Format(Syntax, [J.Table, GetConditions(J.Conditions)]);

    J := nil;
  end;
end;

function TCommandBuilder.GetLimit: String;
var
  Attr, Expr, Offset, OffsetExpr: String;
  A: TLimitAttr;
begin
  Result := EmptyStr;

  if Assigned(GetQuery._Limit) then
  begin
    Attr := EmptyStr;
    Expr := EmptyStr;
    Offset := EmptyStr;

    for A in GetQuery._Limit.Attr do
      case A of
        laBottom: Attr := Trim(Attr) + ' ' + FSyntaxes.LimitAttr.Bottom + ' ';
        laPercent: Attr := Trim(Attr) + ' ' + FSyntaxes.LimitAttr.Percent + ' ';
        laTop: Attr := Trim(Attr) + ' ' + FSyntaxes.LimitAttr.Top + ' ';
      end;

    Attr := Trim(Attr);
    Expr := GetExpression(GetQuery._Limit.RowCount);
    OffsetExpr := GetExpression(GetQuery._Limit.Offset);

    if OffsetExpr.Trim <> '' then
      Offset := Format(FSyntaxes.LimitOffset, [OffsetExpr]);

    if Expr.Trim <> '' then
      Result := Format(FSyntaxes.Limit, [Attr, Expr, Offset]);
  end;
end;

function TCommandBuilder.GetList(const Param: TFieldList): String;
var
  F: TField;
begin
  Result := EmptyStr;

  if Length(Param) = 0 then
    Exit;

  for F in Param do
    if Trim(F) <> '' then
      Result := Result + F + ',';

  if Result[High(Result)] = ',' then
    Result[High(Result)] := ' ';

  Result := Trim(Result);
end;

function TCommandBuilder.GetList(const Param: IList): String;
var
  Expr: String;
begin
  Result := EmptyStr;

  Param.Iterator.Reset;
  while Param.Iterator.Next do
  begin
    Expr := GetExpression(
      Param.Iterator.CurrentItem as IFrameworkInterface);

    if Expr.Trim <> '' then
      Result := Trim(Result) + ' ' + Expr + ' ,';
  end;

  if Result[High(Result)] = ',' then
    Result[High(Result)] := ' ';

  Result := Trim(Result);
end;

function TCommandBuilder.GetOrder: String;
var
  Expr, Exprs: String;
  Order: IOrder;
begin
  Result := EmptyStr;
  Exprs := EmptyStr;

  GetQuery._Order.Iterator.Reset;
  while GetQuery._Order.Iterator.Next do
  begin
    Order := GetQuery._Order.Iterator.CurrentItem as IOrder;

    Expr := GetExpression(Order.Value).Trim;

    if Expr <> '' then
      case Order.Attr of
        oaAsc:
          Expr := Expr + ' ' + FSyntaxes.OrderAttr.Asc;
        oaDesc:
          Expr := Expr + ' ' + FSyntaxes.OrderAttr.Desc;
      end;

    if Expr.Trim <> '' then
      Exprs := Exprs + ' ' + Expr + ' ,';

    Order := nil;
  end;

  if Exprs[High(Exprs)] = ',' then
    Exprs[High(Exprs)] := ' ';

  Exprs := Trim(Exprs);

  if Exprs <> '' then
    Result := Format(FSyntaxes.Order, [Exprs]);
end;

function TCommandBuilder.GetPrimaryKey: String;
begin
  Result := EmptyStr;

  if not Assigned(GetQuery._PrimaryKey) then
    Exit;

  if Trim(GetQuery._PrimaryKey.Name) = '' then
    Result := Format(FSyntaxes.Indexes.PrimaryKey, [GetList(GetQuery._PrimaryKey.Fields)])
  else
    Result := Format(FSyntaxes.Indexes.PrimaryKeyWithName,
      [GetQuery._PrimaryKey.Name, GetList(GetQuery._PrimaryKey.Fields)]);

  if Result.Trim <> '' then
    Result := ',' + Result;
end;

function TCommandBuilder.GetQuery: IQuery;
begin
  Result := nil;

  if not FQuerys.Empty then
    Result := FQuerys.Iterator.Last as IQuery;
end;

function TCommandBuilder.GetSelectAttr: String;
begin
  Result := EmptyStr;

  if satAll in GetQuery._SelectAttr then
    Result := FSyntaxes.SelectAttr.All;

  if satDistinct in GetQuery._SelectAttr then
    Result := Trim(Result) + ' ' + FSyntaxes.SelectAttr.Distinct + ' ';

  if satCache in GetQuery._SelectAttr then
    Result := Trim(Result) + ' ' + FSyntaxes.SelectAttr.Cache + ' ';

  if satNoCache in GetQuery._SelectAttr then
    Result := Trim(Result) + ' ' + FSyntaxes.SelectAttr.NoCache + ' ';

  Result := Trim(Result);
end;

function TCommandBuilder.GetSelectedFields: String;
begin
  Result := GetList(GetQuery._SelectExpressions);
end;

function TCommandBuilder.GetUnique: String;
var
  Unique: IUnique;
  Expr: String;
begin
  Result := EmptyStr;

  if not Assigned(GetQuery._Indexes) then
    Exit;

  if GetQuery._Indexes.Empty then
    Exit;

  GetQuery._Indexes.Iterator.Reset;
  while GetQuery._Indexes.Iterator.Next do
  begin
    Expr := EmptyStr;
    Unique := nil;

    Unique := GetQuery._Indexes.Iterator.CurrentItem as IUnique;

    if not Assigned(Unique) then
      Continue;

    if Trim(Unique.Name) = '' then
      Expr := Format(FSyntaxes.Indexes.Unique, [GetList(Unique.Fields)])
    else
      Expr := Format(FSyntaxes.Indexes.UniqueWithName, [Unique.Name, GetList(Unique.Fields)]);

    if Expr.Trim = '' then
      Continue;

    Result := Result + Expr + ',';
  end;

  if Result[High(Result)] = ',' then
    Result[High(Result)] := ' ';

  Result := Trim(Result);

  if Result.Trim <> '' then
    Result := ',' + Result;
end;

function TCommandBuilder.GetUpdate: String;
begin
  Result := Trim(GetQuery._Table);
end;

function TCommandBuilder.GetValue(const Param: IValue): String;
begin
  Result := EmptyStr;

  case Param.Kind of
    vkBoolean:
      begin
        if FFormats.Boolean = boolDescribed then
          Result := BoolToStr(Boolean(Param.Value), True)
        else
          Result := BoolToStr(Boolean(Param.Value));
      end;

    vkChar,
    vkStr:
      Result := FQuoteMethod(String(Param.Value));

    vkDate:
      Result := FQuoteMethod(FormatDatetime(FFormats.Date, TDate(Param.Value)));

    vkDateTime:
      Result := FQuoteMethod(FormatDatetime(FFormats.Datetime, TDatetime(Param.Value)));

    vkField,
    vkTable:
      Result := String(Param.Value);

    vkInt:
      Result := Integer(Param.Value).ToString;

    vkTime:
      Result := FQuoteMethod(FormatDatetime(FFormats.Time, TDate(Param.Value)));
  end;
end;

function TCommandBuilder.GetValues: String;
begin
  Result := EmptyStr;

  if not GetQuery._Values.Empty then
    Result := Format(FSyntaxes.Values, ['(' + GetList(GetQuery._Values) + ')']);
end;

function TCommandBuilder.GetWhere: String;
begin
  Result := EmptyStr;

  if not GetQuery._Where.List.Empty then
    Result := Format(FSyntaxes.Where, [GetConditions(GetQuery._Where)]);
end;

function TCommandBuilder.GetWith: String;
var
  Encoding,
  Owner,
  Template: String;
begin
  if Trim(GetQuery._Encoding) <> '' then
    Encoding := Format(FSyntaxes.WithAttr.Encoding, [GetQuery._Encoding]);

  if Trim(GetQuery._Owner) <> '' then
    Owner := Format(FSyntaxes.WithAttr.Owner, [GetQuery._Owner]);

  if Trim(GetQuery._Template) <> '' then
    Template := Format(FSyntaxes.WithAttr.Template, [GetQuery._Template]);

  if (Trim(Encoding) <> '') or (Trim(Owner) <> '') or (Trim(Template) <> '') then
    Result := Format(FSyntaxes.WithAttr.&With, [Encoding + ' ' + Owner + ' ' + Template]);

  Result := Trim(Result);
end;

procedure TCommandBuilder.Include(const FieldList: TFieldList);
var
  F: TField;
  Value: String;
begin
  Value := EmptyStr;

  for F in FieldList do
    Value := Value + F + ',';

  if Value[High(Value)] = ',' then
    Value[High(Value)] := ' ';

  Include(Value);
end;

procedure TCommandBuilder.IncludeAssortment(
  var AssortmentArray: TAssortment; const Section: TCommandSection);
var
  Size: Integer;
begin
  Size := Length(AssortmentArray);
  SetLength(AssortmentArray, Size +1);
  AssortmentArray[Size] := Ord(Section);
end;

procedure TCommandBuilder.Initialize;
begin
  InitializeCommandAssortment;
  InitializeFormats;
  InitializeSyntaxes;
end;

procedure TCommandBuilder.InitializeCommandAssortment;
begin
  InitializeCommandAssortmentCreate;
  InitializeCommandAssortmentInsert;
  InitializeCommandAssortmentSelect;
  InitializeCommandAssortmentUpdate;
end;

procedure TCommandBuilder.InitializeCommandAssortmentCreate;
begin
  SetLength(FCommandAssortment.Create, 0);
  IncludeAssortment(FCommandAssortment.Create, csCreateAttr);
  IncludeAssortment(FCommandAssortment.Create, csCreateObject);
  IncludeAssortment(FCommandAssortment.Create, csWith);
  IncludeAssortment(FCommandAssortment.Create, csField);
  IncludeAssortment(FCommandAssortment.Create, csPrimaryKey);
  IncludeAssortment(FCommandAssortment.Create, csForeignKey);
  IncludeAssortment(FCommandAssortment.Create, csUnique);
end;

procedure TCommandBuilder.InitializeCommandAssortmentInsert;
begin
  SetLength(FCommandAssortment.Insert, 0);
  IncludeAssortment(FCommandAssortment.Insert, csInto);
  IncludeAssortment(FCommandAssortment.Insert, csValues);
end;

procedure TCommandBuilder.InitializeCommandAssortmentSelect;
begin
  SetLength(FCommandAssortment.Select, 0);
  IncludeAssortment(FCommandAssortment.Select, csSelectAttr);
  IncludeAssortment(FCommandAssortment.Select, csSelectedFields);
  IncludeAssortment(FCommandAssortment.Select, csFrom);
  IncludeAssortment(FCommandAssortment.Select, csJoin);
  IncludeAssortment(FCommandAssortment.Select, csWhere);
  IncludeAssortment(FCommandAssortment.Select, csGroup);
  IncludeAssortment(FCommandAssortment.Select, csHaving);
  IncludeAssortment(FCommandAssortment.Select, csOrder);
  IncludeAssortment(FCommandAssortment.Select, csLimit);
end;

procedure TCommandBuilder.InitializeCommandAssortmentUpdate;
begin
  SetLength(FCommandAssortment.Update, 0);
  IncludeAssortment(FCommandAssortment.Update, csUpdate);
  IncludeAssortment(FCommandAssortment.Update, csSetfield);
  IncludeAssortment(FCommandAssortment.Update, csFrom);
  IncludeAssortment(FCommandAssortment.Update, csJoin);
  IncludeAssortment(FCommandAssortment.Update, csWhere);
  IncludeAssortment(FCommandAssortment.Update, csOrder);
  IncludeAssortment(FCommandAssortment.Update, csLimit);
end;

procedure TCommandBuilder.InitializeFormats;
begin
  with FFormats do
  begin
    &Boolean := boolDescribed;
    &Date := 'yyyy-mm-dd';
    &Datetime := 'yyyy-mm-dd hh:nn:ss';
    &Time := 'hh:nn:ss';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxes;
begin
  InitializeSyntaxesComparisson;
  InitializeSyntaxesCreate;
  InitializeSyntaxesCreateAttr;
  InitializeSyntaxesDatatype;
  InitializeSyntaxesDatatypeAttr;
  InitializeSyntaxesFunction;
  InitializeSyntaxesIndexes;
  InitializeSyntaxesLimitAttr;
  InitializeSyntaxesOrderAttr;
  InitializeSyntaxesSelectAttr;
  InitializeSyntaxesWith;

  with FSyntaxes do
  begin
    From := 'FROM %s';
    Join := 'JOIN %s ON %s';
    JoinLeft := 'LEFT JOIN %s ON %s';
    JoinRight := 'RIGHT JOIN %s ON %s';
    Where := 'WHERE %s';
    Group := 'GROUP BY %s';
    Having := 'HAVING %s';
    Order := 'ORDER BY %s';
    Between := '%s BETWEEN %s AND %s';
    Equal := '%s = %s';
    &In := '%s IN (%s)';
    Like := '%s LIKE %s';
    Unequal := '%s <> %s';
    Limit := 'LIMIT %s %s %s';
    LimitOffset := 'OFFSET %s';
    Values := 'VALUES %s';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesComparisson;
begin
  with FSyntaxes.Comparisson do
  begin
    Between := '%s BETWEEN %s AND %s';
    BiggerThan := '%s > %s';
    Equal := '%s = %s';
    &In := '%s IN (%s)';
    Like := '%s LIKE ' + FQuoteMethod('%%%s%%');
    Null := '%s IS NULL';
    SmallerThan := '%s < %s';
    StartWith := '%s LIKE ' + FQuoteMethod('%s%%');
    FinishWith := '%s LIKE ' + FQuoteMethod('%%%s');
    Unequal := '%s <> %s';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesCreate;
begin
  FSyntaxes.CreateDB := 'DATABASE %s';
  FSyntaxes.CreateTable := 'TABLE %s';
end;

procedure TCommandBuilder.InitializeSyntaxesCreateAttr;
begin
  FSyntaxes.CreateAttr.Temporary := 'TEMPORARY';
  FSyntaxes.CreateAttr.IfNotExists := 'IF NOT EXISTS';
end;

procedure TCommandBuilder.InitializeSyntaxesDatatype;
begin
  with FSyntaxes.DataType do
  begin
    &BigInt := 'BIGINT';
    &BigSerial := 'BIGSERIAL';
    &Bit := 'BIT';
    &Blob := 'BLOB';
    &Bool := 'BOOL';
    &Char := 'CHAR(%d)';
    &Date := 'DATE';
    &Datetime := 'DATETIME';
    &Decimal := 'NUMERIC(%d,%d)';
    &Double := 'NUMERIC(%d,%d)';
    &Float := 'NUMERIC(%d,%d)';
    &Int := 'INT';
    &Json := 'JSON';
    &LongBlob := 'LONGBLOB';
    &LongText := 'LONGTEXT';
    &MediumBlob := 'MEDIUMBLOB';
    &MediumInt := 'MEDIUMINT';
    &Serial := 'SERIAL';
    &SmallInt := 'SMALLINT';
    &Text := 'TEXT';
    &Time := 'TIME';
    &Timestamp := 'TIMESTAMP';
    &TinyBlob := 'TINYBLOB';
    &TinyInt := 'TINYINT';
    &TinyText := 'TINYTEXT';
    &Varchar := 'VARCHAR(%d)';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesDatatypeAttr;
begin
  with FSyntaxes.DataTypeAttr do
  begin
    Default := 'DEFAULT %s';
    NotNull := 'NOT NULL';
    Null := 'NULL';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesFunction;
begin
  with FSyntaxes.&Function do
  begin
    Avg := 'AVG(%s)';
    Coalesce := 'COALESCE(%s)';
    Count := 'COUNT(%s)';
    &If := 'IF(%s, %s, %s)';
    Lower := 'LOWER(%s)';
    Max := 'MAX(%s)';
    Min := 'MIN(%s)';
    Sum := 'SUM(%s)';
    Upper := 'UPPER(%s)';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesIndexes;
begin
  with FSyntaxes.Indexes do
  begin
    PrimaryKey := 'PRIMARY KEY (%s)';
    PrimaryKeyWithName := 'CONSTRAINT %s PRIMARY KEY (%s)';
    ForeignKey := 'FOREIGN KEY (%s)';
    ForeignKeyWithName := 'CONSTRAINT %s FOREIGN KEY (%s)';
    Reference := 'REFERENCES %s (%s)';
    Unique := 'UNIQUE (%s)';
    UniqueWithName := 'CONSTRAINT %s UNIQUE (%s)';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesLimitAttr;
begin
  with FSyntaxes.LimitAttr do
  begin
    Bottom := 'BOTTOM';
    Percent := 'PERCENT';
    Top := 'TOP';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesOrderAttr;
begin
  FSyntaxes.OrderAttr.Asc := 'ASC';
  FSyntaxes.OrderAttr.Desc := 'DESC';
end;

procedure TCommandBuilder.InitializeSyntaxesSelectAttr;
begin
  with FSyntaxes.SelectAttr do
  begin
    All := 'ALL';
    Cache := 'SQL_CACHE';
    Distinct := 'DISTINCT';
    NoCache := 'SQL_NO_CACHE';
  end;
end;

procedure TCommandBuilder.InitializeSyntaxesWith;
begin
  with FSyntaxes.WithAttr do
  begin
    Encoding := 'ENCODING %s';
    Owner := 'OWNER %s';
    Template := 'TEMPLATE %s';
    &With := 'WITH %s';
  end;
end;

procedure TCommandBuilder.Include(const Value: Integer);
begin
  Include(Value.ToString);
end;

procedure TCommandBuilder.Include(const Value: IValue);
begin
  Include(GetValue(Value));
end;

procedure TCommandBuilder.Include(const Value: String);
begin
  if Trim(Value) <> '' then
    GetQuery._Command := Trim(GetQuery._Command) + ' ' + Trim(Value);
end;

function TCommandBuilder.Prepare(Query: IQuery): Boolean;
begin
  Query._Command := EmptyStr;
  FQuerys.Add(Query);

  try
    case Query._CommandType of
      ctCreate: PrepareCreate;
      ctDelete: PrepareDelete;
      ctDrop: PrepareDrop;
      ctInsert: PrepareInsert;
      ctReplace: PrepareReplace;
      ctSelect: PrepareSelect;
      ctUpdate: PrepareUpdate;
    end;
  finally
    Query._Command := GetQuery._Command;
    FQuerys.Delete(FQuerys.Count -1);
  end;

  Result := Trim(Query._Command) <> '';

  if FQuerys.Empty then
    FQuerys.Iterator.Reset;
end;

procedure TCommandBuilder.PrepareCreate;
begin
  Include('CREATE');
  GenerateCommand(FCommandAssortment.Create);

  FQuerys.Iterator.First;

  if Trim(GetQuery._Table) <> '' then
    Include(')');
end;

procedure TCommandBuilder.PrepareDelete;
begin
  Include('DELETE');
end;

procedure TCommandBuilder.PrepareDrop;
begin
  Include('DROP');
end;

procedure TCommandBuilder.PrepareInsert;
begin
  Include('INSERT INTO');
  GenerateCommand(FCommandAssortment.Insert);
end;

procedure TCommandBuilder.PrepareReplace;
begin
  Include('REPLACE INTO');
end;

procedure TCommandBuilder.PrepareSelect;
begin
  Include('SELECT');
  GenerateCommand(FCommandAssortment.Select);
end;

procedure TCommandBuilder.PrepareUpdate;
begin
  Include('UPDATE');
  GenerateCommand(FCommandAssortment.Update);
end;

{ CommandBuilder }

class function CommandBuilder.Invoke(
  const Driver: TDatabaseDriver): ICommandBuilder;
begin
  case Driver of
  { ddMariaDb: Result := Objects.Invoke<ICommandBuilder>;
    ddMSServer: Result := Objects.Invoke<ICommandBuilder>;
    ddMySql: Result := Objects.Invoke<ICommandBuilder>; }
    ddPostgre: Result := Objects.New<ICommandBuilder>;
  else
    Result := nil;
  end;
end;

initialization
{ Objects.RegisterType<ICommandBuilder, TCommandBuilderMariaDb>;
  Objects.RegisterType<ICommandBuilder, TCommandBuilderMSServer>;
  Objects.RegisterType<ICommandBuilder, TCommandBuilderMySql>; }
  Objects.RegisterType<ICommandBuilder, TCommandBuilderPostgre>;

end.
