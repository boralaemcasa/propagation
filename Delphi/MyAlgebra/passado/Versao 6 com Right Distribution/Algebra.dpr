program Algebra;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in '..\SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'My Algebra - Release with (a + b)c = ac + bc';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
