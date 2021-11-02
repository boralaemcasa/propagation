program Fractions_n_dim;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in 'SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Fractions n dimensioned';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
