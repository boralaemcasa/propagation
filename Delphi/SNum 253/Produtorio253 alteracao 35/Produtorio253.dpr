program Produtorio253;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in '..\Produtorio\SNum.pas',
  SNum253 in 'SNum253.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Produtório 253';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
