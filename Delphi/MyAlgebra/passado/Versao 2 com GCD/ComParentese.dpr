program ComParentese;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum in '..\SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'My Algebra - Release With gcd';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
