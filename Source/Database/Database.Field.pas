unit Database.Field;

interface

uses
  Base.Objects,
  Database.Query.Types;

type
  IField = interface(IFrameworkInterface)
    ['{6FB979B1-8BBB-4ACC-B264-300B62ADA520}']
    function GetDataType: TDataType;
    function GetDefault: IFrameworkInterface;
    function GetName: String;
    function GetNull: Boolean;
    function GetPrecision: Integer;
    function GetSize: Integer;
    function SetDataType(const Value: TDataType): IField;
    function SetDefault(const Value: IFrameworkInterface): IField;
    function SetName(const Value: String): IField;
    function SetNull(const Value: Boolean): IField;
    function SetPrecision(const Value: Integer): IField;
    function SetSize(const Value: Integer): IField;

    property Name: String read GetName;
    property DataType: TDataType read GetDataType;
    property Null: Boolean read GetNull;
    property &Default: IFrameworkInterface read GetDefault;
    property Size: Integer read GetSize;
    property Precision: Integer read GetPrecision;
  end;

implementation

type
  TField = class(TFrameworkObject, IField)
  private
    FName: String;
    FDataType: TDataType;
    FNull: Boolean;
    FDefault: IFrameworkInterface;
    FSize,
    FPrecision: Integer;
    function GetDataType: TDataType;
    function GetDefault: IFrameworkInterface;
    function GetName: String;
    function GetNull: Boolean;
    function GetPrecision: Integer;
    function GetSize: Integer;
    function SetDataType(const Value: TDataType): IField;
    function SetDefault(const Value: IFrameworkInterface): IField;
    function SetName(const Value: String): IField;
    function SetNull(const Value: Boolean): IField;
    function SetPrecision(const Value: Integer): IField;
    function SetSize(const Value: Integer): IField;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TField }

constructor TField.Create;
begin
  inherited;
  FName := '';
  FNull := True;
  FDefault := nil;
  FSize := -1;
  FPrecision := -1;
end;

destructor TField.Destroy;
begin
  if Assigned(FDefault) then
  begin
    try
      FDefault := nil;
    except end;
  end;

  inherited;
end;

function TField.GetDataType: TDataType;
begin
  Result := FDataType;
end;

function TField.GetDefault: IFrameworkInterface;
begin
  Result := FDefault;
end;

function TField.GetName: String;
begin
  Result := FName;
end;

function TField.GetNull: Boolean;
begin
  Result := FNull;
end;

function TField.GetPrecision: Integer;
begin
  Result := FPrecision;
end;

function TField.GetSize: Integer;
begin
  Result := FSize;
end;

function TField.SetDataType(const Value: TDataType): IField;
begin
  FDataType := Value;
  Result := Self;
end;

function TField.SetDefault(const Value: IFrameworkInterface): IField;
begin
  FDefault := Value;
  Result := Self;
end;

function TField.SetName(const Value: String): IField;
begin
  FName := Value;
  Result := Self;
end;

function TField.SetNull(const Value: Boolean): IField;
begin
  FNull := Value;
  Result := Self;
end;

function TField.SetPrecision(const Value: Integer): IField;
begin
  FPrecision := Value;
  Result := Self;
end;

function TField.SetSize(const Value: Integer): IField;
begin
  FSize := Value;
  Result := Self;
end;

initialization
  Objects.RegisterType<IField, TField>;

end.
