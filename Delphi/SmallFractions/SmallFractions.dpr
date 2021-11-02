program SmallFractions;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Small Fractions';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
