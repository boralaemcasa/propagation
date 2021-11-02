unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TComplex = record // a + bi
    a, b: extended;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function complexToStr(z: TComplex): string;
begin
  if (z.a = 0) and (z.b = 0) then
  begin
    result := '0';
    exit;
  end;
  if z.a <> 0 then
    result := floattostr(z.a)
  else
    result := '';
  if z.b < 0 then
    result := result + ' - ' + floattostr(-z.b) + ' i'
  else if z.b > 0 then
  begin
    if z.a <> 0 then
      result := result + ' + ';
    result := result + floattostr(z.b) + ' i';
  end;
end;

function sgn(x: extended): extended;
begin
  if x > 0 then
    result := 1
  else if x < 0 then
    result := -1
  else
    result := 0;
end;

function hyperg(p, q: integer; a, bb: array of extended; x: extended): extended;
var
  termo: extended;
  i, j: integer;
  b: array of extended;
begin
  SetLength(b, q);
  for i := 0 to q - 1 do
    b[i] := bb[i];

  result := 1;
  termo := 1;
  for i := 0 to 100 do
  begin
    for j := 0 to p - 1 do
      termo := termo * (a[j] + i);
    for j := 0 to q - 1 do
    begin
      termo := termo / b[j];
      b[j] := b[j] + 1;
    end;
    termo := termo * x / (i + 1); // fatorial
    result := result + termo;
  end;
end;

function dhdan(p, q: integer; a, bb: array of extended; x: extended; n: integer): extended;
var
  termo: extended;
  i, j: integer;
  b: array of extended;
begin
  SetLength(b, q);
  for i := 0 to q - 1 do
    b[i] := bb[i];

  result := 0;
  termo := 1;
  for i := 0 to 100 do
  begin
    for j := 0 to p - 1 do
      termo := termo * (a[j] + i);
    for j := 0 to q - 1 do
    begin
      termo := termo / b[j];
      b[j] := b[j] + 1;
    end;
    termo := termo * x / (i + 1); // fatorial
    for j := 0 to i do
      result := result + termo/(a[n] + j);
  end;
end;

function c2(n: integer): extended;
begin
  if n = 1 then
    result := 1
  else result := -1/4;
end;

function root(n: integer; t: extended; a: array of extended): TComplex;
var
  c: array[1..4] of extended;
  z, f: extended;
begin
  case n of
    1: c[1] := 0;
    2: c[1] := 1;
    3: c[1] := -1;
    4: c[1] := 1;
    5: c[1] := -1;
  end;

  c[2] := c2(n);

  case n of
    1: c[3] := 0;
    2: c[3] := -5/32;
    3: c[3] := 5/32;
    4: c[3] := 5/32;
    5: c[3] := -5/32;
  end;

  case n of
    1: c[4] := 0;
    2: c[4] := -5/32;
    3: c[4] := -5/32;
    4: c[4] := 5/32;
    5: c[4] := 5/32;
  end;

  result.a := 0;
  result.b := 0;
  z := 3125/256 * sqr(sqr(t));
  f := c[1] * hyperg(4, 3, [-1/20, 3/20, 7/20, 11/20], [1/4, 1/2, 3/4], z);
  if n <= 3 then
    result.a := f
  else
    result.b := f;

  result.a := result.a + c[2] * t * hyperg(4, 3, a, [1/2,3/4,5/4], z);

  f := c[3] * sqr(t) * hyperg(4, 3, [9/20, 13/20, 17/20, 21/20], [3/4, 5/4, 3/2], z);
  if n <= 3 then
    result.a := result.a + f
  else
    result.b := result.b + f;

  result.a := result.a + c[4] * sqr(t) * t * hyperg(4, 3, [7/10, 9/10, 11/10, 13/10], [5/4,3/2,7/4], z);
end;

function multiplica(z, w: TComplex): TComplex; // (za + zb i)(wa + wb i)
begin
  result.a := z.a * w.a - z.b * w.b;
  result.b := z.a * w.b + z.b * w.a;
end;

function polinomio(y: TComplex; t: extended): TComplex; // retorna erro = y^5 - y + t
var
  i: integer;
begin
  result := y;
  for i := 1 to 4 do
    result := multiplica(result, y);

  result.a := result.a - y.a + t;
  result.b := result.b - y.b;
end;

function polinomioLinha(y: TComplex): TComplex; // retorna 5y^4 - 1
var
  i: integer;
begin
  result := y;
  for i := 1 to 3 do
    result := multiplica(result, y);

  result.a := 5 * result.a - 1;
  result.b := 5 * result.b;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  t: extended;
  y, erro: TComplex;
  i: integer;
begin
  t := 0.09;
  for i := 1 to 5 do
  begin
    y := root(i, t, [1/5,2/5,3/5,4/5]);
    erro := polinomio(y, t);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y) + ' ; erro = ' + complextostr(erro));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  c: array[0..3] of extended;
  k, k2, middle, t: extended;
  f, y, dfidyi: array[1..5] of TComplex;
  grad: array[0..3] of double;
  ztemp: TComplex;
  i, j: integer;
  s: string;

procedure alpha(constante: extended);
var
  i: integer;
  a: array[0..3] of extended;
begin
  for i := 0 to 3 do
    a[i] := c[i] - constante * grad[i];

  s := 'alpha = ' + floattostr(constante) + #13#10;
  for i := 0 to 3 do
    s := s + 'a_' + inttostr(i) + ' = ' + floattostr(a[i]) + ' ; ';
  memo.lines.add(s);

  for i := 1 to 5 do
  begin
    y[i] := root(i, t, a);
    f[i] := polinomio(y[i], t);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y[i]) + ' ; erro = ' + complextostr(f[i]));
  end;
end;

begin
  memo.clear;
  c[0] := random;
  c[1] := random;
  c[2] := random;
  c[3] := random;
  t := 0.09;
  for i := 1 to 5 do
  begin
    y[i] := root(i, t, c);
    f[i] := polinomio(y[i], t);
    dfidyi[i] := polinomioLinha(y[i]);
  end;
  for j := 0 to 3 do
  begin
    grad[j] := 0;
    //grad[j].b := 0;
    for i := 1 to 5 do
    begin
      k := c2(i) * t * dhdan(4, 3, c, [1/2,3/4,5/4], 3125/256 * sqr(sqr(t)), j); // dyi \ daj
      ztemp := multiplica(f[i], dfidyi[i]);
      grad[j] := grad[j] + ztemp.a * k;
      //grad[j].b := grad[j].b + ztemp.b * k;
    end;
  end;

  k2 := 1;
  repeat
    k2 := k2 * 10;
    alpha(k2);
  until f[1].a < 0;
  k := k2/10;

  memo.Clear;
  alpha(k);
  alpha(k2);
  for i := 1 to 50 do
  begin
    middle := (k + k2)/2;
    alpha(middle);
    if f[1].a > 0 then
      k := middle
    else
      k2 := middle;
  end;

  memo.lines.add('*****************');
  alpha(k);
end;

end.
