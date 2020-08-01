unit Database.Constraint;

interface

uses
  Base.Objects,
  Database.Query.Types;

type
  IConstraint = interface(IFrameworkInterface)
    ['{0F885C22-53D2-4C43-8FDA-ECDBDE2EF541}']
    function GetName: String;
    function SetName(const Value: String): IConstraint;
    property Name: String read GetName;
  end;

  IReference = interface(IFrameworkInterface)
    ['{DC6387F2-AB06-4C08-A1DA-C8F75BC08EEA}']
    function GetField: TField;
    function GetTable: TTable;
    function SetField(const Value: TField): IReference;
    function SetTable(const Value: TTable): IReference;
    property Table: TTable read GetTable;
    property Field: TField read GetField;
  end;

  IPrimaryKey = interface(IConstraint)
    ['{52C69FC7-4321-4200-A327-2116722FC685}']
    function GetFields: TFieldList;
    function SetFields(const Value: TFieldList): IConstraint;
    property Fields: TFieldList read GetFields;
  end;

  IForeignKey = interface(IConstraint)
    ['{F2D97F50-07FD-414A-A714-2073E66FEC25}']
    function GetField: TField;
    function SetField(const Value: TField): IForeignKey;
    function GetReference: IReference;
    property Field: TField read GetField;
    property Reference: IReference read GetReference;
  end;

  IUnique = interface(IConstraint)
    ['{1FFCD0EB-0DDF-4706-9F34-A28FD6D025AF}']
    function GetFields: TFieldList;
    function SetFields(const Value: TFieldList): IConstraint;
    property Fields: TFieldList read GetFields;
  end;

implementation

type
  TConstraint = class(TFrameworkObject, IConstraint)
  private
    FFields: TFieldList;
    FName: String;
  protected
    function GetFields: TFieldList;
    function GetName: String;
    function SetFields(const Value: TFieldList): IConstraint;
    function SetName(const Value: String): IConstraint;
  end;

  TPrimaryKey = class(TConstraint, IPrimaryKey)
  end;

  TUnique = class(TConstraint, IUnique)
  end;

  TForeignKey = class(TConstraint, IForeignKey)
  private
    FField: TField;
    FReference: IReference;
    function GetField: TField;
    function GetReference: IReference;
    function SetField(const Value: TField): IForeignKey;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TReference = class(TFrameworkObject, IReference)
  private
    FField: TField;
    FTable: TTable;
    function GetField: TField;
    function GetTable: TTable;
    function SetField(const Value: TField): IReference;
    function SetTable(const Value: TTable): IReference;
  end;

{ TConstraint }

function TConstraint.GetFields: TFieldList;
begin
  Result := FFields;
end;

function TConstraint.GetName: String;
begin
  Result := FName;
end;

function TConstraint.SetFields(const Value: TFieldList): IConstraint;
begin
  FFields := Value;
  Result := Self;
end;

function TConstraint.SetName(const Value: String): IConstraint;
begin
  FName := Value;
  Result := Self;
end;

{ TReference }

function TReference.GetField: TField;
begin
  Result := FField;
end;

function TReference.GetTable: TTable;
begin
  Result := FTable;
end;

function TReference.SetField(const Value: TField): IReference;
begin
  FField := Value;
  Result := Self;
end;

function TReference.SetTable(const Value: TTable): IReference;
begin
  FTable := Value;
  Result := Self;
end;

{ TForeignKey }

constructor TForeignKey.Create;
begin
  inherited;
  FReference := Objects.New<IReference>;
end;

destructor TForeignKey.Destroy;
begin
  if Assigned(FReference) then
    try
      FReference := nil;
    except end;

  inherited;
end;

function TForeignKey.GetField: TField;
begin
  Result := FField;
end;

function TForeignKey.GetReference: IReference;
begin
  Result := FReference;
end;

function TForeignKey.SetField(const Value: TField): IForeignKey;
begin
  FField := Value;
  Result := Self;
end;

initialization
  Objects.RegisterType<IPrimaryKey, TPrimaryKey>;
  Objects.RegisterType<IForeignKey, TForeignKey>;
  Objects.RegisterType<IUnique, TUnique>;
  Objects.RegisterType<IReference, TReference>;

end.
