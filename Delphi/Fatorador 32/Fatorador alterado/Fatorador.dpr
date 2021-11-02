program Fatorador;

uses
  Forms,
  Principal in 'Principal.pas' {Form1},
  SNum in 'SNum.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
