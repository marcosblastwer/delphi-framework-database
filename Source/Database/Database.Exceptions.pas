unit Database.Exceptions;

interface

uses
  System.SysUtils;

type
  EDbExceptionUnmappedConnection = class(Exception)
    constructor Create;
  end;

  EDbExceptionDisconnected = class(Exception)
    constructor Create;
  end;

  EDbExceptionUndefinedCommand = class(Exception)
    constructor Create;
  end;

  EDbExceptionDatabaseNotCreated = class(Exception)
    constructor Create;
  end;

implementation

{ EDbExceptionUnmappedConnection }

constructor EDbExceptionUnmappedConnection.Create;
begin
  inherited Create('Conexão com o banco de dados não foi mapeada.');
end;

{ EDbExceptionNotConnected }

constructor EDbExceptionDisconnected.Create;
begin
  inherited Create('Conexão com o banco de dados não foi estabelecida.');
end;

{ EDbExceptionUndefinedCommand }

constructor EDbExceptionUndefinedCommand.Create;
begin
  inherited Create('Comando não definido.');
end;

{ EDbExceptionDatabaseNotCreated }

constructor EDbExceptionDatabaseNotCreated.Create;
begin
  inherited Create('O Banco de dados não foi criado.');
end;

end.
