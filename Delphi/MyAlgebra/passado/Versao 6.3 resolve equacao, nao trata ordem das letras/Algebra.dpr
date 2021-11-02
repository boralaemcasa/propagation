program Algebra;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in '..\SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'My Algebra - Release with ax + b = 0';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.

