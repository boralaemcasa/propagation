program Plano2;

uses
  Forms,
  Principal2 in 'Principal2.pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.

