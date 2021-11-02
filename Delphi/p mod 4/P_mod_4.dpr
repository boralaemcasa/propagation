program P_mod_4;

uses
  Forms,
  Principal in 'Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
