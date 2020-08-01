unit Database.ConnectionInfo;

interface

uses
  Base.Objects,
  Database.Drivers;

type
  IConnectionInfo = interface(IFrameworkInterface)
    ['{731AF1B7-E7C2-4507-BA78-D4896C7EF02E}']
    function GetDatabase: String;
    function GetDriver: TDatabaseDriver;
    function GetHost: String;
    function GetOSAuthentication: Boolean;
    function GetPassword: String;
    function GetUser: String;
    function GetPort: Integer;
    procedure SetDatabase(const Value: String);
    procedure SetDriver(const Value: TDatabaseDriver);
    procedure SetHost(const Value: String);
    procedure SetOSAuthentication(const Value: Boolean);
    procedure SetPassword(const Value: String);
    procedure SetUser(const Value: String);
    procedure SetPort(const Value: Integer);

    property Driver: TDatabaseDriver read GetDriver write SetDriver;
    property Database: String read GetDatabase write SetDatabase;
    property Host: String read GetHost write SetHost;
    property User: String read GetUser write SetUser;
    property Password: String read GetPassword write SetPassword;
    property Port: Integer read GetPort write SetPort;
    property OSAuthentication: Boolean read GetOSAuthentication write SetOSAuthentication;
  end;

implementation

type
  TConnectionInfo = class(TFrameworkObject, IConnectionInfo)
  private
    FDriver: TDatabaseDriver;
    FDatabase,
    FHost,
    FUser,
    FPassword: String;
    FOSAuthentication: Boolean;
    FPort: Integer;
    function GetDatabase: String;
    function GetDriver: TDatabaseDriver;
    function GetHost: String;
    function GetOSAuthentication: Boolean;
    function GetPassword: String;
    function GetUser: String;
    function GetPort: Integer;
    procedure SetDatabase(const Value: String);
    procedure SetDriver(const Value: TDatabaseDriver);
    procedure SetHost(const Value: String);
    procedure SetOSAuthentication(const Value: Boolean);
    procedure SetPassword(const Value: String);
    procedure SetUser(const Value: String);
    procedure SetPort(const Value: Integer);
  public
    constructor Create;
  end;

{ TConnectionInfo }

constructor TConnectionInfo.Create;
begin
  inherited;
  FDriver := ddNone;
  FDatabase := '';
  FHost := '';
  FUser := '';
  FPassword := '';
  FOSAuthentication := False;
  FPort := 0;
end;

function TConnectionInfo.GetDatabase: String;
begin
  Result := FDatabase;
end;

function TConnectionInfo.GetDriver: TDatabaseDriver;
begin
  Result := FDriver;
end;

function TConnectionInfo.GetHost: String;
begin
  Result := FHost;
end;

function TConnectionInfo.GetOSAuthentication: Boolean;
begin
  Result := FOSAuthentication;
end;

function TConnectionInfo.GetPassword: String;
begin
  Result := FPassword;
end;

function TConnectionInfo.GetPort: Integer;
begin
  Result := FPort;
end;

function TConnectionInfo.GetUser: String;
begin
  Result := FUser;
end;

procedure TConnectionInfo.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TConnectionInfo.SetDriver(const Value: TDatabaseDriver);
begin
  FDriver := Value;
end;

procedure TConnectionInfo.SetHost(const Value: String);
begin
  FHost := Value;
end;

procedure TConnectionInfo.SetOSAuthentication(const Value: Boolean);
begin
  FOSAuthentication := Value;
end;

procedure TConnectionInfo.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TConnectionInfo.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TConnectionInfo.SetUser(const Value: String);
begin
  FUser := Value;
end;

initialization
  Objects.RegisterType<IConnectionInfo, TConnectionInfo>;

end.
