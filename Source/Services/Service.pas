unit Service;

interface

uses
  Base.Objects,
  System.Generics.Collections;

type
  IService = interface(IFrameworkInterface)
  ['{163BA468-88EF-48C3-B735-8A6292A1F0EE}']
  end;
  TService = class(TFrameworkObject, IService)
  end;

  ISingleton = interface(IService)
  ['{65B00A88-8C54-4526-AB2C-AED295EE3B64}']
  end;
  TSingleton = class(TService, ISingleton)
  end;

  Services = class
  private
    class var
      Singletons: TDictionary<String, System.TObject>;
    type
      TContainerObject<TInterface: IFrameworkInterface> = class
      public
        Instance: TInterface;
      end;
    class procedure Initialize;
    class procedure Finalize;
    class function IsSingleton<TInterface: IService>: Boolean;
  public
    class procedure RegisterType<TInterface: IService; TImplementation: class>(const Name: String = '');
    class procedure Unregister<TInterface: IService>(const Name: String = '');
    class function Call<TInterface: IService>(const Name: String = ''): TInterface; overload;
  end;

  EUnregisteredSingletonException = class(EUnregisteredInterfaceException);

implementation

uses
  System.SysUtils;

{ Services }

class function Services.Call<TInterface>(const Name: String): TInterface;
var
  CObject: TContainerObject<TInterface>;
  Key: String;
  O: System.TObject;
begin
  Result := Default(TInterface);

  if Objects.New<TInterface>(Name).Support(ISingleton) then
  begin
    Key := Objects.GetTypeName<TInterface>;

    if not Singletons.TryGetValue(Key, O) then
    begin
      raise EUnregisteredSingletonException.Create(String(Key));
      Exit;
    end;
    CObject := TContainerObject<TInterface>(O);

    MonitorEnter(Singletons);
    try
      if CObject.Instance = nil then
        CObject.Instance := Objects.New<TInterface>(Key);

      Result := CObject.Instance;
    finally
      MonitorExit(Singletons);
    end;
  end
  else
    Result := Objects.New<TInterface>(Key);
end;

class procedure Services.Finalize;
var
  O: System.TObject;
begin
  for O in Singletons.Values do
  begin
    if O <> nil then
      try
        O.Free;
      except end;
  end;

  try
    Singletons.Clear;
    Singletons.Free;
    Singletons := nil;
  except end;
end;

class function Services.IsSingleton<TInterface>: Boolean;
begin
  Result := IFrameworkInterface(Objects.New<TInterface>).Support(ISingleton);
end;

class procedure Services.Initialize;
begin
  Singletons := TDictionary<String, System.TObject>.Create;
end;

class procedure Services.RegisterType<TInterface, TImplementation>(const Name: String = '');
var
  CObject: TContainerObject<TInterface>;
  O: TObject;
  Key: String;
begin
  Objects.RegisterType<TInterface, TImplementation>(Name);

  if IsSingleton<TInterface> then
  begin
    Key := Objects.GetTypeName<TInterface>;

    if Singletons.TryGetValue(Key, O) then
    begin
      raise EAlreadyRegisteredException.Create(Key);
      Exit;
    end;
    CObject := TContainerObject<TInterface>.Create;
    CObject.Instance := nil;
    Singletons.Add(Key, CObject);
  end;
end;

class procedure Services.Unregister<TInterface>(const Name: String = '');
var
  Key: String;
  O: TObject;
begin
  Objects.Unregister<TInterface>(Name);

  if IsSingleton<TInterface> then
  begin
    Key := Objects.GetTypeName<TInterface>;

    if Singletons.TryGetValue(Key, O) then
      TContainerObject<TInterface>(O).Instance := nil;

    Singletons.Remove(Objects.GetTypeName<TInterface>);
    try
      FreeAndNil(O);
    except end;
  end;
end;

initialization
  Services.Initialize;

finalization
  Services.Finalize;

end.
