unit Database;

interface

uses
  Base.Objects,
  Base.Value,
  Database.Component.Types,
  Database.ConnectionInfo,
  Database.Functions,
  Database.Group,
  Database.Limit,
  Database.Order,
  Database.Query;

type
  IQuery = Database.Query.IQuery;
  TGroupAttr = Database.Group.TGroupAttr;
  TLimitAttr = Database.Limit.TLimitAttr;
  TOrderAttr = Database.Order.TOrderAttr;
  TValueKind = Base.Value.TValueKind;
  FunctionRepository = Database.Functions.FunctionRepository;
  ValueRepository = Base.Value.ValueRepository;
  TDBData = Database.Component.Types.TDBData;

  IDatabase = interface(IFrameworkInterface)
    ['{2AB5A539-6E25-4AED-9890-2205EE227333}']
    function Connect(const ConnectionInfo: IConnectionInfo): Boolean;
    function GetConnected: Boolean;
    function GetServerDate: TDateTime;
    function GetValue(Query: IQuery): Variant; overload;
    function GetValue(Query: IQuery; const DefaultValue: Variant): Variant; overload;
    function Get(Query: IQuery): TDBData;
    function Test(const ConnectionInfo: IConnectionInfo): Boolean;
    procedure Disconnect;
    procedure Execute(Query: IQuery);
    property Connected: Boolean read GetConnected;
  end;

implementation

uses
  Database.CommandBuilder,
  Database.Component,
  Database.Exceptions,
  System.SysUtils,
  System.Variants;

type
  TDatabase = class(TFrameworkObject, IDatabase)
  private
    FComponents: IComponents;
    FCommandBuilder: ICommandBuilder;
    function GetConnected: Boolean;
    function GetFDQuery: TDBData;
    function InstantiatedCommandBuilder: Boolean;
    function InstantiatedComponents: Boolean;
    procedure BeforeCommunication;
    procedure BeforeExecute(Query: IQuery);
    procedure MapComponents(const ConnectionInfo: IConnectionInfo; var Instance: IComponents);
  public
    constructor Create;
    destructor Destroy; override;
    function Connect(const ConnectionInfo: IConnectionInfo): Boolean;
    function GetServerDate: TDateTime;
    function GetValue(Query: IQuery): Variant; overload;
    function GetValue(Query: IQuery; const DefaultValue: Variant): Variant; overload;
    function Get(Query: IQuery): TDBData;
    function Test(const ConnectionInfo: IConnectionInfo): Boolean;
    procedure Disconnect;
    procedure Execute(Query: IQuery);
  end;

{ TDatabase }

procedure TDatabase.BeforeCommunication;
begin
  if not (InstantiatedComponents and InstantiatedCommandBuilder) then
    raise EDbExceptionUnmappedConnection.Create;

  if not GetConnected then
    raise EDbExceptionDisconnected.Create;
end;

procedure TDatabase.BeforeExecute(Query: IQuery);
begin
  if not FCommandBuilder.Prepare(Query) then
    raise EDbExceptionUndefinedCommand.Create;
end;

constructor TDatabase.Create;
begin
  FComponents := nil;
  FCommandBuilder := nil;
end;

destructor TDatabase.Destroy;
begin
  Disconnect;
  inherited;
end;

procedure TDatabase.Execute(Query: IQuery);
var
  Q: TDBData;
begin
  BeforeCommunication;
  BeforeExecute(Query);

  Q := GetFDQuery;
  try
    Q.SQL.Add(Query._Command);
    Q.ExecSQL;
  finally
    FreeAndNil(Q);
  end;
end;

procedure TDatabase.Disconnect;
begin
  if Assigned(FComponents) then
    try
      if FComponents.Connection.Connected then
        FComponents.Connection.Connected := False;
      FComponents := nil;
    except end;

  if Assigned(FCommandBuilder) then
    try
      FCommandBuilder := nil;
    except end;
end;

function TDatabase.Get(Query: IQuery): TDBData;
begin
  BeforeCommunication;
  BeforeExecute(Query);

  Result := GetFDQuery;
  Result.SQL.Add(Query._Command);
  Result.Open;
  Result.CachedUpdates := False;
end;

function TDatabase.GetConnected: Boolean;
begin
  Result := False;

  if InstantiatedComponents then
    Result := FComponents.Connection.Connected;
end;

function TDatabase.GetFDQuery: TDBData;
begin
  Result := TDBData.Create(nil);
  Result.CachedUpdates := False;
  Result.Connection := FComponents.Connection;
  Result.SQL.Clear;
end;

function TDatabase.GetServerDate: TDateTime;
var
  Data: TDBData;
  Q: IQuery;
begin
  Result := Now;
  Q := Objects.New<IQuery>;
  Q.Select('CURRENT_TIME_STAMP');
  Data := Get(Q);
  if Assigned(Data) then
    try
      Result := Data.Fields[0].AsDateTime;
    finally
      FreeAndNil(Data);
    end;
end;

function TDatabase.GetValue(Query: IQuery;
  const DefaultValue: Variant): Variant;
begin
  Result := GetValue(Query);

  if Result = null then
    Result := DefaultValue;
end;

function TDatabase.GetValue(Query: IQuery): Variant;
var
  Q: TDBData;
begin
  Result := null;

  BeforeCommunication;
  BeforeExecute(Query);

  Q := GetFDQuery;
  try
    Q.SQL.Add(Query._Command);
    Q.Open;
    Q.CachedUpdates := False;

    if not Q.IsEmpty then
      Result := Q.Fields[0].AsVariant;
  finally
    FreeAndNil(Q);
  end;
end;

function TDatabase.Connect(const ConnectionInfo: IConnectionInfo): Boolean;
begin
  Result := False;

  if Assigned(ConnectionInfo) then
  begin
    MapComponents(ConnectionInfo, FComponents);

    if InstantiatedComponents then
    begin
      FComponents.Connection.Connected := True;
      Result := FComponents.Connection.Connected;
    end;

    if Result then
      FCommandBuilder := CommandBuilder.Invoke(ConnectionInfo.Driver);
  end;

  if not (Result and InstantiatedComponents and InstantiatedCommandBuilder) then
    raise EDbExceptionUnmappedConnection.Create;
end;

function TDatabase.InstantiatedCommandBuilder: Boolean;
begin
  Result := Assigned(FCommandBuilder);
end;

function TDatabase.InstantiatedComponents: Boolean;
begin
  Result := Assigned(FComponents);
end;

procedure TDatabase.MapComponents(const ConnectionInfo: IConnectionInfo;
  var Instance: IComponents);
begin
  Instance := Components.Invoke(ConnectionInfo.Driver);

  if not Assigned(Instance) then
    Exit;

  with Instance.Connection.Params do
  begin
    Add('Server=' + ConnectionInfo.Host);
    Add('Port=' + ConnectionInfo.Port.ToString);
    Add('Database=' + ConnectionInfo.Database);
    Add('User_name=' + ConnectionInfo.User);
    Add('Password=' + ConnectionInfo.Password);
  end;
end;

function TDatabase.Test(const ConnectionInfo: IConnectionInfo): Boolean;
var
  C: IComponents;
begin
  if not Assigned(ConnectionInfo) then
    raise EDbExceptionUnmappedConnection.Create;

  MapComponents(ConnectionInfo, C);

  if Assigned(C) then
    try
      try
        C.Connection.Connected := True;
      except
        on E:Exception do
          if Pos('does not exist', E.Message) > 0 then
            raise EDbExceptionDatabaseNotCreated.Create
          else
            raise;
      end;
      Result := C.Connection.Connected;
    finally
      C.Connection.Connected := False;
      C := nil;
    end
  else
    raise EDbExceptionUnmappedConnection.Create;
end;

initialization
  Objects.RegisterType<IDatabase, TDatabase>;

end.
