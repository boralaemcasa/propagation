program Lambert;

uses
  Forms,
  Principal in 'Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
