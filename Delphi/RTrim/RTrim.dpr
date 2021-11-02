program RTrim;

uses
  Forms,
  Principal in 'Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Right Trim';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
