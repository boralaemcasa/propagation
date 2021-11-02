unit Principal;

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

function newton(n, p: integer): double;
var i: integer;
begin
//n! / [ p! (n - p)! ] = n(n-1)...(n-p+1) / p!
  result := 1.0;
  for i := 1 to p do
    result := result * (n - p + i) / i;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  x : array[0..6] of double;
  i: integer;
begin
  x[1] := newton(6, 1) * newton(59, 5) / newton(60, 6);
  x[2] := newton(6, 2) * newton(58, 4) / newton(60, 6);
  x[3] := newton(6, 3) * newton(57, 3) / newton(60, 6);
  x[4] := newton(6, 4) * newton(56, 2) / newton(60, 6);
  x[5] := newton(6, 5) * newton(55, 1) / newton(60, 6);
  x[6] := newton(6, 6) * newton(54, 0) / newton(60, 6);
  x[0] := 1 - x[1] - x[2] - x[3] - x[4] - x[5] - x[6];
  for i := 0 to 6 do
    memo1.lines.add(inttostr(i) + ' = ' + floattostr(x[i]) + ' [2] = ' + inttostr(1 + trunc(ln (1/x[i]) / ln(2))) + ' [6] = ' + inttostr(1 + trunc(ln (1/x[i]) / ln(6))));
end;

end.
