program Produtorio;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum253 in '..\Produtorio253\SNum253.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Produt�rio';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
