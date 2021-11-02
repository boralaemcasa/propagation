program Cubo;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Cores in 'Cores.pas' {FormCores};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
