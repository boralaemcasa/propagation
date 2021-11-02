program Plano;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
