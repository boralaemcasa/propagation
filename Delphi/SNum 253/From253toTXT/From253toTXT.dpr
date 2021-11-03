program From253toTXT;

uses
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  SNum253 in 'SNum253.pas',
  SNum in 'SNum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'From 253 to TXT';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
