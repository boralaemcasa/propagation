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
  public
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

function hyperg(p, q: integer; a, b: array of extended; x: extended): extended;
var
  termo: extended;
  i, j: integer;
begin
  result := 1;
  termo := 1;
  for i := 0 to 100 do
  begin
    for j := 0 to p - 1 do
      termo := termo * (a[j] + i);
    for j := 0 to q - 1 do
      termo := termo / (b[j] + i);
    termo := termo * x / (i + 1); // fatorial
    result := result + termo;
  end;
end;

function dhdan(p, q: integer; a, b: array of extended; x: extended; n: integer): extended;
var
  termo: extended;
  i, j: integer;
begin
  result := 0;
  termo := 1;
  for i := 0 to 100 do
  begin
    for j := 0 to p - 1 do
      termo := termo * (a[j] + i);
    for j := 0 to q - 1 do
      termo := termo / (b[j] + i);
    termo := termo * x / (i + 1); // fatorial
    for j := 0 to i do
      result := result + termo/(a[n] + j);
  end;
end;

function dhdbn(p, q: integer; a, b: array of extended; x: extended; n: integer): extended;
var
  termo: extended;
  i, j: integer;
begin
  result := 0;
  termo := -1; // - 1 / pi^2
  for i := 0 to 100 do
  begin
    for j := 0 to p - 1 do
      termo := termo * (a[j] + i);
    for j := 0 to q - 1 do
      termo := termo / (b[j] + i);
    termo := termo * x / (i + 1) / sqr(b[n] + i); // fatorial
    for j := 0 to i do
      result := result + termo/(b[n] + j);
  end;
end;

function c2exato(n: integer): extended;
begin
  if n = 1 then
    result := 1
  else result := -1/4;
end;

function c4exato(n: integer): extended;
begin
  case n of
    2, 3: result := -5/32;
    4, 5: result := 5/32;
    else result := 0;
  end;
end;

function root(n: integer; t: extended; a2, b2: array of extended; c2: extended;
              a4, b4: array of extended; c4: extended): TComplex;
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

  c[2] := c2;

  case n of
    1: c[3] := 0;
    2: c[3] := -5/32;
    3: c[3] := 5/32;
    4: c[3] := 5/32;
    5: c[3] := -5/32;
  end;

  c[4] := c4;

  result.a := 0;
  result.b := 0;
  z := 3125/256 * sqr(sqr(t));
  f := c[1] * hyperg(4, 3, [-1/20, 3/20, 7/20, 11/20], [1/4, 1/2, 3/4], z);
  if n <= 3 then
    result.a := f
  else
    result.b := f;

  result.a := result.a + c[2] * t * hyperg(4, 3, a2, b2, z);

  f := c[3] * sqr(t) * hyperg(4, 3, [9/20, 13/20, 17/20, 21/20], [3/4, 5/4, 3/2], z);
  if n <= 3 then
    result.a := result.a + f
  else
    result.b := result.b + f;

  result.a := result.a + c[4] * sqr(t) * t * hyperg(4, 3, a4, b4, z);
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

//  (p + qi)^5 - (p + qi) - t
//= p^5 + 5p^4 qi - 10p^3 q^2 - 10p^2q^3 i + 5pq^4 + q^5 i - p - qi - t = f.a + i f.b
//  f.a = p^5 - 10p^3 q^2 + 5pq^4 - p - t ==> d\dp = 5p^4 - 30p^2 q^2 + 5q^4 - 1
//  f.b = 5p^4 q - 10p^2q^3 + q^5 - q     ==> d\dp = 20p^3 q - 20pq^3

function pqre(p, q: extended): extended;
begin
  result := 5 * sqr(sqr(p)) - 30 * sqr(p) * sqr(q) + 5 * sqr(sqr(q)) - 1;
end;

function pqim(p, q: extended): extended;
begin
  result := 20 * p * q * (sqr(p) - sqr(q));
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
    y := root(i, t, [1/5,2/5,3/5,4/5], [1/2,3/4,5/4], c2exato(i), [7/10, 9/10, 11/10, 13/10], [5/4,3/2,7/4], c4exato(i));
    erro := polinomio(y, t);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y) + ' ; erro = ' + complextostr(erro));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  a2_find, a4_find: array[0..3] of extended;
  b2_find, b4_find: array[0..2] of extended;
  c2_find, c4: array[1..5] of extended;
  k, t, erro, temp, z: extended;
  f, y: array[1..5] of TComplex;
  grada2, grada4: array[0..3] of double;
  gradb2, gradb4: array[0..2] of double;
  gradc2, dRefidp, dImfidp: array[1..5] of double;
  i, j, epoca, minEpoca: integer;
  ztemp: TComplex;

function alpha(constante: extended; efetivar, mostrar: boolean): double;
var
  i: integer;
  a2, a4: array[0..3] of extended;
  b2, b4: array[0..2] of extended;
  c2: array[1..5] of extended;
begin
  for i := 0 to 3 do
  begin
    a2[i] := a2_find[i] - constante * grada2[i];
    a4[i] := a4_find[i] - constante * grada4[i];
    if efetivar then
    begin
      a2_find[i] := a2[i];
      a4_find[i] := a4[i];
    end;
  end;
  for i := 0 to 2 do
  begin
    b2[i] := b2_find[i] - constante * gradb2[i];
    b4[i] := b4_find[i] - constante * gradb4[i];
    if efetivar then
    begin
      b2_find[i] := b2[i];
      b4_find[i] := b4[i];
    end;
  end;
  for i := 1 to 5 do
  begin
    c2[i] := c2_find[i] - constante * gradc2[i];
    if efetivar then
      c2_find[i] := c2[i];
  end;

  if mostrar then
  begin
    memo.lines.add('época = ' + inttostr(epoca)+ ' ; alpha = ' + floattostr(constante));
    for i := 0 to 3 do
      memo.lines.add('a2_' + inttostr(i) + ' = ' + floattostr(a2[i]));
    for i := 0 to 2 do
      memo.lines.add('b2_' + inttostr(i) + ' = ' + floattostr(b2[i]));
    for i := 1 to 5 do
      memo.lines.add('c2_' + inttostr(i) + ' = ' + floattostr(c2[i]));
    for i := 0 to 3 do
      memo.lines.add('a4_' + inttostr(i) + ' = ' + floattostr(a4[i]));
    for i := 0 to 2 do
      memo.lines.add('b4_' + inttostr(i) + ' = ' + floattostr(b4[i]));
  end;

  result := 0;
  for i := 1 to 5 do
  begin
    y[i] := root(i, t, a2, b2, c2[i], a4, b4, c4[i]);
    f[i] := polinomio(y[i], t);
    result := result + sqr(f[i].a) + sqr(f[i].b);
    if mostrar then
      memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y[i]) + ' ; erro = ' + complextostr(f[i]));
  end;

  if mostrar then
    memo.lines.add('Raiz do Erro Quadrático = ' + floattostr(sqrt(result)));
end;

begin
  memo.clear;
  for i := 0 to 3 do
  begin
    a2_find[i] := random; //(i+1)/5;
    a4_find[i] := random; //(2*i + 7)/10;
  end;
  //b2_find[0] := 1/2;
  //b2_find[1] := 3/4;
  //b2_find[2] := 5/4;
  for i := 0 to 2 do
  begin
    b2_find[i] := random;
    b4_find[i] := random; //(i+5)/4;
  end;
  for i := 1 to 5 do
  begin
    c2_find[i] := random;
    c4[i] := c4exato(i);
  end;
  t := 0.09;
  z := 3125/256 * sqr(sqr(t));
  erro := 1e100;
  for epoca := 1 to 500 do
  begin
    for i := 1 to 5 do
    begin
      y[i] := root(i, t, a2_find, b2_find, c2_find[i], a4_find, b4_find, c4[i]);
      f[i] := polinomio(y[i], t);
      dRefidp[i] := pqre(y[i].a, y[i].b);
      dImfidp[i] := pqim(y[i].a, y[i].b);
    end;
    for j := 0 to 3 do
    begin
      grada2[j] := 0;
      grada4[j] := 0;
      for i := 1 to 5 do
      begin
        k := c2_find[i] * t * dhdan(4, 3, a2_find, b2_find, z, j); // dp \ daj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqda[j]; // Re f * (dR\dp * dp\daj + dR\dq * dq\daj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqda[j];
        grada2[j] := grada2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
        k := c4[i] * t * sqr(t) * dhdan(4, 3, a4_find, b4_find, z, j); // dp \ daj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqda[j]; // Re f * (dR\dp * dp\daj + dR\dq * dq\daj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqda[j];
        grada4[j] := grada4[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
      end;
    end;

    for j := 0 to 2 do
    begin
      gradb2[j] := 0;
      gradb4[j] := 0;
      for i := 1 to 5 do
      begin
        k := c2_find[i] * t * dhdbn(4, 3, a2_find, b2_find, z, j); // dp \ dbj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdb[j]; // Re f * (dR\dp * dp\dbj + dR\dq * dq\dbj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdb[j];
        gradb2[j] := gradb2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
        k := c4[i] * t * sqr(t) * dhdbn(4, 3, a4_find, b4_find, z, j); // dp \ dbj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdb[j]; // Re f * (dR\dp * dp\dbj + dR\dq * dq\dbj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdb[j];
        gradb4[j] := gradb4[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
      end;
    end;

    for j := 1 to 5 do
    begin
      gradc2[j] := 0;
      for i := 1 to 5 do
      begin
        if i = j then
          k := t * hyperg(4, 3, a2_find, b2_find, z) // dp \ d c2 j
        else
          k := 0;
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdc2[j]; // Re f * (dR\dp * dp\dc2j + dR\dq * dq\dc2j)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdc2[j];
        gradc2[j] := gradc2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
      end;
    end;

    temp := alpha(10, true, false);
    if (temp > erro)  then
      break;
    erro := temp;
  end;
  temp := alpha(0, false, true);
end;

end.
