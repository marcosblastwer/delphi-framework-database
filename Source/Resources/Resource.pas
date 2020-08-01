unit Resource;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

type
  TResourceType =
    (BMP, GIF, ICO, JPG, PNG, SVG);

  TResource = record
    Hash: String;
    Path: String;
    ResourceType: TResourceType;
  end;

  Resources = class
  private
    type
      TContainerObject = record
      public
        Hash: String;
        ResourceType: TResourceType;
      end;
    class var
      Container: TDictionary<String, TContainerObject>;
  private
    const
      _PATH_NAME = 'resources';
    class function CopyFile(const Source, Destination: String): Boolean;
    class function GetExtension(const ResourceType: TResourceType): String;
    class function GetPath: String;
    class function GetPathRaw: String;
    class procedure Finalize;
    class procedure Initialize;
  public
    class function Invoke(const Hash: String): TResource; overload;
    class procedure &Register(const AResourceType: TResourceType; const Hash: String);
  end;

  EUnregisteredResource = class(Exception)
    constructor Create(const ResourceName: String);
  end;

  EUnableTOFindResource = class(Exception)
    constructor Create(const ResourceName: String);
  end;

implementation

uses
  Tools.Path,
  Winapi.Windows;

{ Resources }

class function Resources.CopyFile(const Source,
  Destination: String): Boolean;
var
  FullDestination: String;
begin
  if not FileExists(Source) then
    raise Exception.Create('Source file does not exist.');

  Winapi.Windows.CopyFile(PChar(Source), PChar(Destination), True);

  if ExtractFileName(Destination).Trim = '' then
    FullDestination := IncludeTrailingPathDelimiter(Destination) + ExtractFileName(Source)
  else
    FullDestination := Destination;
  Result := FileExists(FullDestination);
end;

class procedure Resources.Finalize;
begin
  if Assigned(Container) then
    FreeAndNil(Container);
end;

class function Resources.GetExtension(
  const ResourceType: TResourceType): String;
begin
  case ResourceType of
    BMP: Result := '.bmp';
    GIF: Result := '.gif';
    ICO: Result := '.ico';
    JPG: Result := '.jpg';
    PNG: Result := '.png';
    SVG: Result := '.svg';
  end;
end;

class function Resources.GetPath: String;
begin
  Result := IncludeTrailingPathDelimiter(Paths.GetTemporaryPath + _PATH_NAME);
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

class function Resources.GetPathRaw: String;
begin
  Result := IncludeTrailingPathDelimiter(Paths.GetPath + _PATH_NAME);
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

class procedure Resources.Initialize;
begin
  Container := TDictionary<String, TContainerObject>.Create;
end;

class function Resources.Invoke(const Hash: String): TResource;
var
  Ext, Filename, FilenameRaw: String;
  O: TContainerObject;
begin
  if Container.TryGetValue(Hash, O) then
  begin
    Ext := GetExtension(O.ResourceType);
    Filename := GetPath + Hash + Ext;

    if not FileExists(Filename) then
    begin
      FilenameRaw := GetPathRaw + Hash;

      if not FileExists(FilenameRaw) then
        raise EUnregisteredResource.Create(Hash);

      CopyFile(FilenameRaw, Filename);

      if not FileExists(Filename) then
        raise EUnableTOFindResource.Create(Hash);
    end;
    Result.Hash := Hash;
    Result.Path := Filename;
    Result.ResourceType := O.ResourceType;
  end
  else
    raise EUnregisteredResource.Create(Hash);
end;

class procedure Resources.Register(const AResourceType: TResourceType;
  const Hash: String);
var
  O: TContainerObject;
begin
  if Container.TryGetValue(Hash, O) then
  begin
    O.Hash := Hash;
    O.ResourceType := AResourceType;
    Container.AddOrSetValue(Hash, O);
  end
  else
  begin
    O.Hash := Hash;
    O.ResourceType := AResourceType;
    Container.Add(Hash, O);
  end;
end;

{ EUnableFindResource }

constructor EUnableTOFindResource.Create(const ResourceName: String);
begin
  inherited Create('Could not find the requested resource or copy the file in the operating system.' +
    #13 + 'Resource: ' + ResourceName);
end;

{ EUnregisteredResource }

constructor EUnregisteredResource.Create(const ResourceName: String);
begin
  inherited Create('Resource not registered.' + #13 + 'Resource: ' + ResourceName);
end;

initialization
  Resources.Initialize;

finalization
  Resources.Finalize;

end.
