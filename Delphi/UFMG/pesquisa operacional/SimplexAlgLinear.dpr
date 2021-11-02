program SimplexAlgLinear;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in 'SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
