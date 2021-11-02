unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var k: int64;
    theta, epsilon: double;
begin
  epsilon := pi / strtoint64(edit1.text);
  k := 0;
  repeat
    inc(k);
    if k mod 16 = 0 then
    begin
      caption := inttostr(k);
      application.ProcessMessages;
    end;
    theta := 2 * k * pi * pi;
    theta := theta - trunc(theta / (2 * pi)) * 2 * pi;
    if theta < epsilon then
    begin
      caption := inttostr(k);
      exit;
    end;

    theta := -2 * k * pi * pi;
    theta := theta - trunc(theta / (2 * pi)) * 2 * pi + 2 * pi;
    if theta < epsilon then
    begin
      caption := inttostr(-k);
      exit;
    end;

  until k > 1000000000;
end;

end.
