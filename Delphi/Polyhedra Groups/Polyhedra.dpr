program Polyhedra;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Polyhedra';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
