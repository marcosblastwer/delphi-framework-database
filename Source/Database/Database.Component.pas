unit Database.Component;

interface

uses
  Database.Component.Types,

  //System.Classes,
  //System.SysUtils,
  //Data.DB,
  //FireDAC.Stan.Intf,
  //FireDAC.Stan.Option,
  //FireDAC.Stan.Error,
  //FireDAC.UI.Intf,
  //FireDAC.Phys.Intf,
  //FireDAC.Stan.Def,
  //FireDAC.Stan.Pool,
  //FireDAC.Stan.Async,
  //FireDAC.Phys,
  //FireDAC.ConsoleUI.Wait,
  //FireDAC.Stan.Param,
  //FireDAC.DatS,
  //FireDAC.DApt.Intf,
  //FireDAC.DApt,
  //FireDAC.VCLUI.Wait,
  //FireDAC.Comp.UI,
  //FireDAC.Comp.DataSet,
  Base.Objects,
  Database.Drivers;

type
  IComponents = interface(IFrameworkInterface)
    ['{5741496F-BAFF-46A3-A71D-ECFB3056A0EB}']
    function GetConnection: TDBConnection;
    function GetProcedure: TDBStoredProcedure;
    function GetProvider: TDBDataProvider;
    function GetQuery: TDBData;
    function GetTransaction: TDBTransaction;
    procedure SetConnection(const Value: TDBConnection);
    procedure SetProcedure(const Value: TDBStoredProcedure);
    procedure SetProvider(const Value: TDBDataProvider);
    procedure SetQuery(const Value: TDBData);
    procedure SetTransaction(const Value: TDBTransaction);
    property Connection: TDBConnection read GetConnection write SetConnection;
    property Provider: TDBDataProvider read GetProvider write SetProvider;
    property Query: TDBData read GetQuery write SetQuery;
    property &Procedure: TDBStoredProcedure read GetProcedure write SetProcedure;
    property Transaction: TDBTransaction read GetTransaction write SetTransaction;
  end;

  Components = class
    class function Invoke(const Driver: TDatabaseDriver): IComponents;
  end;

implementation

uses
  Firedac.Phys.PG,
  Firedac.Phys.PGDef,
  System.SysUtils;

type
  TComponents = class(TFrameworkObject, IComponents)
  private
    FConnection: TDBConnection;
    FQuery: TDBData;
    FProcedure: TDBStoredProcedure;
    FProvider: TDBDataProvider;
    FTransaction: TDBTransaction;
  protected
    function GetConnection: TDBConnection;
    function GetProcedure: TDBStoredProcedure;
    function GetProvider: TDBDataProvider;
    function GetQuery: TDBData;
    function GetTransaction: TDBTransaction;
    procedure SetConnection(const Value: TDBConnection);
    procedure SetProcedure(const Value: TDBStoredProcedure);
    procedure SetProvider(const Value: TDBDataProvider);
    procedure SetQuery(const Value: TDBData);
    procedure SetTransaction(const Value: TDBTransaction);
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

{ TComponentsMariaDb = class(TComponents, IComponents)
  end;

  TComponentsMSServer = class(TComponents, IComponents)
  end;

  TComponentsMySql = class(TComponents, IComponents)
  end; }

  TComponentsPostgre = class(TComponents, IComponents)
  private
    FDriver: TFDPhysPgDriverLink;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

{ TComponents }

constructor TComponents.Create;
begin
  FConnection := TDBConnection.Create(nil);
  FQuery := TDBData.Create(nil);
  FProcedure := TDBStoredProcedure.Create(nil);
  FProvider := TDBDataProvider.Create(nil);
  FTransaction := TDBTransaction.Create(nil);
end;

destructor TComponents.Destroy;
begin
  if Assigned(FConnection) and FConnection.Connected then
    try
      FConnection.Connected := False;
    except end;

  if Assigned(FProcedure) then
    try
      FreeAndNil(FProcedure);
    except end;

  if Assigned(FTransaction) then
    try
      FreeAndNil(FTransaction);
    except end;

  if Assigned(FQuery) then
    try
      FreeAndNil(FQuery);
    except end;

  if Assigned(FProvider) then
    try
      FreeAndNil(FProvider);
    except end;

  if Assigned(FConnection) then
    try
      FreeAndNil(FConnection);
    except end;

  inherited;
end;

function TComponents.GetConnection: TDBConnection;
begin
  Result := FConnection;
end;

function TComponents.GetProcedure: TDBStoredProcedure;
begin
  Result := FProcedure;
end;

function TComponents.GetProvider: TDBDataProvider;
begin
  Result := FProvider;
end;

function TComponents.GetQuery: TDBData;
begin
  Result := FQuery;
end;

function TComponents.GetTransaction: TDBTransaction;
begin
  Result := FTransaction;
end;

procedure TComponents.SetConnection(const Value: TDBConnection);
begin
  FConnection := Value;
end;

procedure TComponents.SetProcedure(const Value: TDBStoredProcedure);
begin
  FProcedure := Value;
end;

procedure TComponents.SetProvider(const Value: TDBDataProvider);
begin
  FProvider := Value;
end;

procedure TComponents.SetQuery(const Value: TDBData);
begin
  FQuery := Value;
end;

procedure TComponents.SetTransaction(const Value: TDBTransaction);
begin
  FTransaction := Value;
end;

{ Components }

class function Components.Invoke(const Driver: TDatabaseDriver): IComponents;
begin
  case Driver of
  { ddMariaDb: Result := TComponentsMariaDb.Create;
    ddMSServer: Result := TComponentsMSServer.Create;
    ddMySql: Result := TComponentsMySql.Create; }
    ddPostgre: Result := TComponentsPostgre.Create;
  else
    Result := nil;
  end;
end;

{ TComponentsPostgre }

constructor TComponentsPostgre.Create;
begin
  inherited;
  FConnection.DriverName := 'Pg';
  FDriver := TFDPhysPgDriverLink.Create(nil);
end;

destructor TComponentsPostgre.Destroy;
begin
  if Assigned(FDriver) then
    try
      FDriver.Free;
      FDriver := nil;
    except end;

  inherited;
end;

end.
