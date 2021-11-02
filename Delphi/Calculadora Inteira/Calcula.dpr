program calcula;

uses
  Forms,
  calc in 'calc.pas' {Form1},
  SNum in '..\SNum.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
