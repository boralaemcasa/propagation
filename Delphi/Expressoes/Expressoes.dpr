program Expressoes;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Express�es';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
