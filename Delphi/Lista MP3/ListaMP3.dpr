program ListaMP3;

uses
  Forms,
  Principal in 'Principal.pas' {Form1};

{$R *.res}

begin
  randomize;
  Application.Initialize;
  Application.Title := 'Multiple';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
