unit Database.Query.Types;

interface

uses
  Base.Value;

type
  TField = type string;
  TFieldList = array of TField;
  TTable = type string;

  TCommandType = (
    ctNone,
    ctCreate,
    ctDelete,
    ctDrop,
    ctExists,
    ctInsert,
    ctReplace,
    ctSelect,
    ctUpdate );

  TDataType = (
    Undefined,
    datBigInt,
    datBigSerial,
    datBit,
    datBlob,
    datBool,
    datChar,
    datDate,
    datDatetime,
    datDecimal,
    datDouble,
    datFloat,
    datInt,
    datJson,
    datLongBlob,
    datLongText,
    datMediumBlob,
    datMediumInt,
    datSerial,
    datSmallInt,
    datText,
    datTime,
    datTimestamp,
    datTinyBlob,
    datTinyInt,
    datTinyText,
    datVarchar );

  TSection = (
    secNone,
    secCreate,
    secPrimaryKey,
    secForeignKey,
    secIndex,
    secInsert,
    secInto,
    secValues,
    secSelect,
    secUpdate,
    secSet,
    secFrom,
    secJoin,
    secJoinLeft,
    secJoinRight,
    secWhere,
    secGroupBy,
    secHaving,
    secOrderBy,
    secLimit );

  TSelectAttribute = (
    satAll,
    satDistinct,
    satCache,
    satNoCache );
  TSelectAttributes = set of TSelectAttribute;

  TCreateAttribute = (
    catTemporary,
    catIfNotExists );
  TCreateAttributes = set of TCreateAttribute;

implementation

end.
