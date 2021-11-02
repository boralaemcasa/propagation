program Fatorador64;

uses
  Forms,
  Principal in 'Principal.pas' {Form1},
  SNum2 in '..\SNum2.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
