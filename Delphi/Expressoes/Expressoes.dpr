program Expressoes;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Expressões';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
