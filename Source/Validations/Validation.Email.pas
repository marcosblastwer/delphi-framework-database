unit Validation.Email;

interface

uses
  Validation;

type
  ValidateEmail = interface(IValidation)
    ['{08251CDB-8AE2-4B45-845A-5F4AB8B80CE4}']
  end;

implementation

uses
  Validation.Rule;

type
  TValidateEmail = class(TValidation, ValidateEmail)
    constructor Create; override;
  end;

{ TValidateEmail }

constructor TValidateEmail.Create;
const
  ACCENTUATION_CHARS: array of Char =
    ['´', '`', '^', '~', 'á', 'à', 'ã', 'â', 'ä', 'Á',
     'À', 'Ã', 'Â', 'Ä', 'é', 'è', 'É', 'È', 'í', 'ì',
     'Í', 'Ì', 'ó', 'ò', 'ö', 'õ', 'ô', 'Ó', 'Ò', 'Ö',
     'Õ', 'Ô', 'ú', 'ù', 'ü', 'Ú', 'Ù', 'Ü', 'ç', 'Ç',
     'ñ', 'Ñ', 'ë', 'Ë', 'ê', 'Ê', 'ï', 'Ï', 'î', 'Î',
     'û', 'Û'];
  SPECIAL_CHARS: array of Char =
    ['¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª', 'º', '¿',
     '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '‡', '¡',
     '¢', '¤', '¥', '§', '©', '«', '¬', '¯', '±', 'Ñ',
     '²', '³', 'µ', '¶', '·', '¸', '¹', '»', '¼', '½',
     '¾', 'Ï', 'Ð', '°', '^', '~', 'š', 'Š', '‰', 'ƒ',
     '€', '“', '”', 'Å', '‘'];
begin
  inherited;

  AddRules([
    Rule.MinLength(8),
    Rule.MinOccurrence('@', 1),
    Rule.MaxOccurrence('@', 1),
    Rule.MinOccurrence('.', 1).After('@'),
    Rule.NotContains(ACCENTUATION_CHARS),
    Rule.NotContains(' '),
    Rule.NotContains(SPECIAL_CHARS) ]);
end;

initialization
  Validations.RegisterValidation<ValidateEmail, TValidateEmail>;

end.
