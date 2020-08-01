unit Service.Init;

interface

uses
  Base.Objects,
  Service,
  Service.Init.Charge;

type
  IInitiator = interface(IService)
  ['{93AE321C-FAE2-401F-8FB9-567859202D74}']
    function Fill(Charge: ICharge): IInitiator; overload;
    function Fill(Charge: array of ICharge): IInitiator; overload;
    function Okay: Boolean;
  end;

  TInitiator = class(TService, IInitiator)
  private
    FCharges: IList<ICharge>;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function Fill(Charge: ICharge): IInitiator; overload;
    function Fill(Charges: array of ICharge): IInitiator; overload;
    function Okay: Boolean; virtual;
  end;

implementation

{ TInitiator }

constructor TInitiator.Create;
begin
  FCharges := Objects.NewList<ICharge>;
end;

destructor TInitiator.Destroy;
begin
  try
    FCharges.Clear;
    FCharges := nil;
  except end;

  inherited;
end;

function TInitiator.Fill(Charge: ICharge): IInitiator;
begin
  FCharges.Add(Charge);
  Result := Self;
end;

function TInitiator.Fill(Charges: array of ICharge): IInitiator;
var
  C: ICharge;
begin
  for C in Charges do
    FCharges.Add(C);

  Result := Self;
end;

function TInitiator.Okay: Boolean;
var
  C: ICharge;
begin
  Result := True;

  for C in FCharges.Items do
    Result := Result and C.Okay;
end;

initialization
  Services.RegisterType<IInitiator, TInitiator>;

end.
