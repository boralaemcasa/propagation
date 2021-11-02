program GD;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Geometria Diferencial';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
