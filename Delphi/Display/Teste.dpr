program Teste;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Displays in 'Displays.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
