program FindInFiles;

uses
  Forms,
  Principal in 'Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Find In Files';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
