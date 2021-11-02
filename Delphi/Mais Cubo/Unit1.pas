unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
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

function binom(n, p: integer): integer;
var j: integer;
    r: double;
begin
  r := 1;
  for j := 1 to p do
    r := r * (n - (j - 1)) / j;
  result := round(r);
end;

function pow(x, y: double): double;
begin
  result := exp(y * ln(x));
end;

procedure TForm1.Button1Click(Sender: TObject);
var a: array[0..19, 0..19] of integer;
    n, p: byte;
    s: string;
begin
  a[0,0] := 2;
  for n := 1 to 19 do
  begin
    a[n,0] := a[n - 1, 0] * 2;
    a[n,n] := 2 * (n + 1);
    if n > 1 then
      for p := 1 to n - 1 do
        a[n, p] := a[n-1, p-1] + 2 * a[n - 1, p];
  end;

  memo.clear;
  for n := 3 to 19 do
  begin
    memo.lines.add(floatToStr(a[n, 3] / pow(2, n-2) / (n + 1)  ));
  end;

end;

end.
