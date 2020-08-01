unit Service.Init.Charge;

interface

uses
  Base.Objects;

type
  ICharge = interface(IFrameworkInterface)
  ['{2DC90A4C-6F75-40B1-9C00-BC33C38BD5F6}']
    function Okay: Boolean;

    function GetSilenceMode: Boolean;
    procedure SetSilenceMode(const Value: Boolean);
    property SilenceMode: Boolean read GetSilenceMode write SetSilenceMode;
  end;

  TCharge = class(TFrameworkObject, ICharge)
  private
    FSilence: Boolean;
  protected
    function GetSilenceMode: Boolean;
    procedure SetSilenceMode(const Value: Boolean);
  public
    function Okay: Boolean; virtual; abstract;
  published
    property SilenceMode: Boolean read GetSilenceMode write SetSilenceMode;
  end;

implementation

{ TCharge }

function TCharge.GetSilenceMode: Boolean;
begin
  Result := FSilence;
end;

procedure TCharge.SetSilenceMode(const Value: Boolean);
begin
  FSilence := Value;
end;

end.
