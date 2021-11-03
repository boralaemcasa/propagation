program Previsoes;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in '..\Produtorio\SNum.pas',
  SNum253 in '..\Produtorio253\SNum253.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Previsões';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
