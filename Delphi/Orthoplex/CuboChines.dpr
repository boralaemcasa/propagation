program CuboChines;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sat�lite';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
