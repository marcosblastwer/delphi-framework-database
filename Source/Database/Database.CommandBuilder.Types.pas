unit Database.CommandBuilder.Types;

interface

type
  TBooleanType = (boolDescribed, boolBit);

  TCommandSection = (
    csCreateAttr,
    csCreateObject,
    csField,
    csPrimaryKey,
    csForeignKey,
    csUnique,
    csSelectAttr,
    csSelectedFields,
    csFrom,
    csJoin,
    csInto,
    csWhere,
    csGroup,
    csHaving,
    csOrder,
    csLimit,
    csUpdate,
    csSetfield,
    csValues,
    csWith );
  TAssortment = array of Word;

  TCommandAssortment = record
    Create,
    Select,
    Update,
    Insert: TAssortment;
  end;

  TFormats = record
    &Boolean: TBooleanType;
    &Date,
    &Datetime,
    &Time: String;
  end;

  TCreateAttr = record
    Temporary,
    IfNotExists: String;
  end;

  TSelectAttr = record
    All,
    Cache,
    Distinct,
    NoCache: String;
  end;

  TOrderAttr = record
    Asc,
    Desc: String;
  end;

  TLimitAttr = record
    Bottom,
    Percent,
    Top: String;
  end;

  TCompareSyntaxes = record
    Between,
    BiggerThan,
    Equal,
    &In,
    Like,
    Null,
    SmallerThan,
    StartWith,
    FinishWith,
    Unequal: String;
  end;

  TFunctionSyntaxes = record
    Avg,
    Coalesce,
    Concat,
    Count,
    &If,
    Lower,
    Max,
    Min,
    Sum,
    Upper: String;
  end;

  TDatatypeSyntaxes = record
    &BigInt,
    &BigSerial,
    &Bit,
    &Blob,
    &Bool,
    &Char,
    &Date,
    &Datetime,
    &Decimal,
    &Double,
    &Float,
    &Int,
    &Json,
    &LongBlob,
    &LongText,
    &MediumBlob,
    &MediumInt,
    &Serial,
    &SmallInt,
    &Text,
    &Time,
    &Timestamp,
    &TinyBlob,
    &TinyInt,
    &TinyText,
    &Varchar: String;
  end;

  TDatatypeAttr = record
    Default,
    NotNull,
    Null: String;
  end;

  TWithAttr = record
    Encoding,
    Owner,
    Template,
    &With: String;
  end;

  TIndexSyntaxes = record
    ForeignKey,
    ForeignKeyWithName,
    PrimaryKey,
    PrimaryKeyWithName,
    Reference,
    Unique,
    UniqueWithName: String;
  end;

  TSyntaxes = record
    Comparisson: TCompareSyntaxes;
    CreateAttr: TCreateAttr;
    DataType: TDatatypeSyntaxes;
    DataTypeAttr: TDatatypeAttr;
    WithAttr: TWithAttr;
    Indexes: TIndexSyntaxes;
    &Function: TFunctionSyntaxes;
    LimitAttr: TLimitAttr;
    OrderAttr: TOrderAttr;
    SelectAttr: TSelectAttr;
    CreateDB,
    CreateTable,
    From,
    Join,
    JoinLeft,
    JoinRight,
    Where,
    Group,
    Having,
    Order,
    Between,
    Equal,
    &In,
    Like,
    Unequal,
    Limit,
    LimitOffset,
    Values: String;
  end;

  TQuoteMethod = function(const Value: String): String;

function DefaultQuote(const Value: String): String;

implementation

function DefaultQuote(const Value: String): String;
const
  QUOTE_CHAR = #39;
begin
  Result := QUOTE_CHAR + Value + QUOTE_CHAR;
end;

end.
