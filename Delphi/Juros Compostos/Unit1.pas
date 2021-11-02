unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
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
var x, soma, parcela, parcela2: currency;
  i: integer;
  data: TDate;
  y, m, d: word;
begin
  data := now;
  soma := 250;
  parcela := 250;
  memo1.lines.add(floattostr(soma) + ' em ' + datetostr(data));
  for i := 1 to 49 do
  begin
    parcela := parcela / 1.02;
    parcela2 := trunc(parcela * 100 + 1) / 100;
    soma := soma + parcela2;
    repeat
      data := data + 1;
      decodedate(data, y, m, d);
    until d = 20;
    memo1.lines.add(floattostr(parcela)
      + ' = ' + floattostr(parcela2)
      + ' em ' + datetostr(data));
  end;
  memo1.lines.add(floattostr(soma));
end;

end.

