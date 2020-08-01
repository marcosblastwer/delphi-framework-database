unit Entity;

interface

uses
  Base.Argument, Base.Objects, Base.Value, Database, Database.Query, System.SysUtils;

type
{$M+}
{$TYPEINFO ON}

  IEntity = interface(IFrameworkInterface)
    ['{08E53832-B924-4570-B4D0-F06D1063C7B0}']
  end;

  TEntity = class(TFrameworkObject, IEntity)
  end;

  TCustomHandle = (WithDeleted);
  TCustomHandles = set of TCustomHandle;

  IEntityRepository = interface(IFrameworkInterface)
    ['{9F5CA6DD-E9BA-4F4D-A4CE-900666B042A3}']
    function BuildQuery(const Handles: TCustomHandles): IQuery;
    function Map(const Data: TDBData): IEntity;
    function Save(Entity: IEntity): Boolean;
  end;

  Repository = class
  private
    class var
      FDatabase: IDatabase;
    class function CreateRepository<TInterface: IEntity>: IEntityRepository;
    class function GetRepositoryName<TInterface: IEntity>: String;
    class function PrepareArgValue(const ArgValue: TArgumentValue): IValue;
    class procedure PrepareArgs(var Query: IQuery; const Args: array of TArgument);
    class procedure SetDatabase(const Value: IDatabase); static;
  public
    class procedure RegisterType<TInterface: IEntity; TImplementation: class; TRepository: class>;
    class procedure Unregister<TInterface: IEntity; TImplementation: class; TRepository: class>;
    class function Find<TInterface: IEntity>(const Args: array of TArgument; const Handles: TCustomHandles = []): TInterface;
    class function Save<TInterface: IEntity>(const Entity: IEntity; const Handles: TCustomHandles = []): Boolean;
    class function Search<TInterface: IEntity>(const Args: array of TArgument; const Handles: TCustomHandles = []): IList<TInterface>;
    class property Database: IDatabase read FDatabase write SetDatabase;
  end;

  EEntityRepositoryNotRegisteredException = class(Exception)
    constructor Create(const EntityName: String);
  end;

  EInvalidDatabaseConnectionException = class(Exception)
    constructor Create;
  end;

  EUndefinedQueryException = class(Exception)
    constructor Create;
  end;

function Argument: TArgument;

implementation

uses
  Base.Converter;

function Argument: TArgument;
begin
  Result := Base.Argument.Argument;
end;

{ EEntityRepositoryNotRegisteredException }

constructor EEntityRepositoryNotRegisteredException.Create(
  const EntityName: String);
begin
  inherited Create('The Implementation registered for type ' +
    EntityName + ' does not contains a repository.');
end;

{ Repository }

class function Repository.CreateRepository<TInterface>: IEntityRepository;
var
  ERepository: IEntityRepository;
begin
  Result := nil;
  ERepository := Objects.New<IEntityRepository>(GetRepositoryName<TInterface>);
  if ERepository = nil then
    raise EEntityRepositoryNotRegisteredException.Create(Objects.GetTypeName<TInterface>)
  else
    Result := ERepository;
end;

class function Repository.Find<TInterface>(const Args: array of TArgument;
  const Handles: TCustomHandles): TInterface;
var
  ERepository: IEntityRepository;
  Query: IQuery;
  Dataset: TDBData;
begin
  Result := nil;

  ERepository := CreateRepository<TInterface>;

  Query := ERepository.BuildQuery(Handles);
  if Query = nil then
    raise EUndefinedQueryException.Create;

  PrepareArgs(Query, Args);

  Dataset := FDatabase.Get(Query);

  if Dataset <> nil then
    try
      if not Dataset.IsEmpty then
        Result := TInterface(ERepository.Map(Dataset));
    finally
      Dataset.Free;
    end;
end;

class function Repository.GetRepositoryName<TInterface>: String;
begin
  Result := Objects.GetTypeName<TInterface> + 'Repository';
end;

class procedure Repository.PrepareArgs(var Query: IQuery;
  const Args: array of TArgument);
var
  A: TArgument;
begin
  if (Length(Args) > 0) and Query._Where.List.Empty then
    Query.Where;

  for A in Args do
  begin
    if not Query._Where.List.Empty then
      Query.&And;

    case A.Condition of
      cnBetween:
        Query.Between(A.PropertyName, PrepareArgValue(A.Values[0]), PrepareArgValue(A.Values[1]));

      cnEndsWith:
        Query.FinishWith(ValueRepository.Field(A.PropertyName), PrepareArgValue(A.Values[0]));

      cnEqual:
        Query.Equal(A.PropertyName, PrepareArgValue(A.Values[0]));

      cnLike:
        Query.Like(ValueRepository.Field(A.PropertyName), PrepareArgValue(A.Values[0]));

      cnStartsWith:
        Query.StartWith(ValueRepository.Field(A.PropertyName), PrepareArgValue(A.Values[0]));

      cnUnequal:
        Query.Unequal(A.PropertyName, PrepareArgValue(A.Values[0]));
    end;
  end;
end;

class function Repository.PrepareArgValue(
  const ArgValue: TArgumentValue): IValue;
begin
  case ArgValue.DataType of
    dtBoolean: Result := ValueRepository.Boolean(Boolean(ArgValue.Content));
    dtChar: Result := ValueRepository.Char(Convert.ToChar(String(ArgValue.Content)));
    dtDateTime: Result := ValueRepository.DateTime(Extended(ArgValue.Content));
    dtDouble: Result := ValueRepository.Float(Extended(ArgValue.Content));
    dtInteger: Result := ValueRepository.Int(Convert.ToInteger(String(ArgValue.Content)));
    dtString: Result := ValueRepository.String(String(ArgValue.Content));
  end;
end;

class procedure Repository.RegisterType<TInterface, TImplementation, TRepository>;
begin
  Objects.RegisterType<TInterface, TImplementation>;
  Objects.RegisterType<IEntityRepository, TRepository>(GetRepositoryName<TInterface>);
end;

class function Repository.Save<TInterface>(const Entity: IEntity;
  const Handles: TCustomHandles): Boolean;
begin
  Result := CreateRepository<TInterface>.Save(Entity);
end;

class function Repository.Search<TInterface>(
  const Args: array of TArgument;
  const Handles: TCustomHandles): IList<TInterface>;
var
  ERepository: IEntityRepository;
  Query: IQuery;
  Dataset: TDBData;
begin
  Result := Objects.NewList<TInterface>;

  ERepository := CreateRepository<TInterface>;

  Query := ERepository.BuildQuery(Handles);
  if Query = nil then
    raise EUndefinedQueryException.Create;

  PrepareArgs(Query, Args);

  Dataset := FDatabase.Get(Query);

  if Dataset <> nil then
    try
      Dataset.First;
      while not Dataset.Eof do
      begin
        Result.Add( TInterface(ERepository.Map(Dataset)) );
        Dataset.Next;
      end;
    finally
      Dataset.Free;
    end;
end;

class procedure Repository.SetDatabase(const Value: IDatabase);
begin
  if FDatabase <> nil then
  begin
    FDatabase.Disconnect;
    FDatabase := nil;
  end;
  FDatabase := Value;
end;

class procedure Repository.Unregister<TInterface, TImplementation, TRepository>;
begin
  objects.Unregister<TInterface>;
  Objects.Unregister<IEntityRepository>(GetRepositoryName<TInterface>);
end;

{ EInvalidDatabaseConnectionException }

constructor EInvalidDatabaseConnectionException.Create;
begin
  inherited Create('The entered database is invalid or the connection has not been established.');
end;

{ EUndefinedQueryException }

constructor EUndefinedQueryException.Create;
begin
  inherited Create('The query was not defined by the entity repository.');
end;

end.

