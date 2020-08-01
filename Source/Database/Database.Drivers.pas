unit Database.Drivers;

interface

type
  TDatabaseDriver = (ddNone, ddMariaDb, ddMSServer, ddMySql, ddPostgre);

  DriverMapper = class
    class function ToString(const Driver: TDatabaseDriver): String; reintroduce;
  end;

implementation

{ DriverMapper }

class function DriverMapper.ToString(const Driver: TDatabaseDriver): String;
begin
  Result := '';

  case Driver of
    ddMariaDb: Result := 'MariaDB';
    ddMSServer: Result := 'Microsoft SQL Server';
    ddMySql: Result := 'MySQL';
    ddPostgre: Result := 'Postgre SQL';
  end;
end;

end.
