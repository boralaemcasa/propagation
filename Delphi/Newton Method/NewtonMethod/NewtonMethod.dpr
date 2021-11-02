program NewtonMethod;

uses
  Forms,
  SNum in 'SNum.pas',
  Principal_Sextic in 'Principal_Sextic.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Pi';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
