program CuboChines;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Cores in 'Cores.pas' {FormCores};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Cubo Chin�s';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
