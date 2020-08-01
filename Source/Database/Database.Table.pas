unit Database.Table;

interface

uses
  Base.Objects,
  Database.Constraint,
  Database.Field;

type
  ITable = interface(IFrameworkInterface)
    ['{38EC0172-6C9D-4D73-9B88-3F2351A76420}']
    function GetFields: IList<IField>;
    function GetForeignKeys: IList<IForeignKey>;
    function GetIndexes: IList<IUnique>;
    function GetName: String;
    function GetPrimaryKey: IPrimaryKey;
    function SetFields(const Values: Array of IField): ITable;
    function SetForeignKeys(const Values: Array of IForeignKey): ITable;
    function SetIndexes(const Values: Array of IUnique): ITable;
    function SetName(const Value: String): ITable;
    function SetPrimaryKey(const Value: IPrimaryKey): ITable;

    property Name: String read GetName;
    property Fields: IList<IField> read GetFields;
    property PrimaryKey: IPrimaryKey read GetPrimaryKey;
    property ForeignKeys: IList<IForeignKey> read GetForeignKeys;
    property Indexes: IList<IUnique> read GetIndexes;
  end;

implementation

type
  TTable = class(TFrameworkObject, ITable)
  private
    FName: String;
    FFields: IList<IField>;
    FPrimaryKey: IPrimaryKey;
    FForeignKeys: IList<IForeignKey>;
    FIndexes: IList<IUnique>;
    function GetFields: IList<IField>;
    function GetForeignKeys: IList<IForeignKey>;
    function GetIndexes: IList<IUnique>;
    function GetName: String;
    function GetPrimaryKey: IPrimaryKey;
    function SetFields(const Values: Array of IField): ITable;
    function SetForeignKeys(const Values: Array of IForeignKey): ITable;
    function SetIndexes(const Values: Array of IUnique): ITable;
    function SetName(const Value: String): ITable;
    function SetPrimaryKey(const Value: IPrimaryKey): ITable;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TTable }

constructor TTable.Create;
begin
  inherited;

  FFields := Objects.NewList<IField>;
  FForeignKeys := Objects.NewList<IForeignKey>;
  FIndexes := Objects.NewList<IUnique>;
end;

destructor TTable.Destroy;
begin
  if Assigned(FFields) then
    try
      FFields.Clear;
      FFields := nil;
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

  inherited;
end;

function TTable.GetFields: IList<IField>;
begin
  Result := FFields;
end;

function TTable.GetForeignKeys: IList<IForeignKey>;
begin
  Result := FForeignKeys;
end;

function TTable.GetIndexes: IList<IUnique>;
begin
  Result := FIndexes;
end;

function TTable.GetName: String;
begin
  Result := FName;
end;

function TTable.GetPrimaryKey: IPrimaryKey;
begin
  Result := FPrimaryKey;
end;

function TTable.SetFields(const Values: array of IField): ITable;
var
  F: IField;
begin
  for F in Values do
    FFields.Add(F);

  Result := Self;
end;

function TTable.SetForeignKeys(const Values: array of IForeignKey): ITable;
var
  F: IForeignKey;
begin
  for F in Values do
    FForeignKeys.Add(F);

  Result := Self;
end;

function TTable.SetIndexes(const Values: array of IUnique): ITable;
var
  U: IUnique;
begin
  for U in Values do
    FIndexes.Add(U);

  Result := Self;
end;

function TTable.SetName(const Value: String): ITable;
begin
  FName := Value;
  Result := Self;
end;

function TTable.SetPrimaryKey(const Value: IPrimaryKey): ITable;
begin
  FPrimaryKey := Value;
  Result := Self;
end;

initialization
  Objects.RegisterType<ITable, TTable>;

end.
