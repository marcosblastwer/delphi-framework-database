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
  inherited Create('Conex�o com o banco de dados n�o foi mapeada.');
end;

{ EDbExceptionNotConnected }

constructor EDbExceptionDisconnected.Create;
begin
  inherited Create('Conex�o com o banco de dados n�o foi estabelecida.');
end;

{ EDbExceptionUndefinedCommand }

constructor EDbExceptionUndefinedCommand.Create;
begin
  inherited Create('Comando n�o definido.');
end;

{ EDbExceptionDatabaseNotCreated }

constructor EDbExceptionDatabaseNotCreated.Create;
begin
  inherited Create('O Banco de dados n�o foi criado.');
end;

end.
