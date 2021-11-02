unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TComplex = record // a + bi
    a, b: extended;
  end;
  TVetorR = array of extended;
  TVetorC = array of TComplex;

  TFormPrincipal = class(TForm)
    btnExata: TButton;
    Memo: TMemo;
    btnGradiente: TButton;
    procedure btnExataClick(Sender: TObject);
    procedure btnGradienteClick(Sender: TObject);
  private
  public
    t: extended;
    a_find, b_find: array of TVetorR;
    c_find: array of TVetorC;
    f, y: array[1..5] of TComplex;
    grada2, grada4: array[0..3] of double;
    gradb2, gradb4: array[0..2] of double;
    gradc2, gradc4: array[1..5] of double;
    function alpha(constante: extended; efetivar, mostrar: boolean; epoca: integer): double;
  end;

var
  FormPrincipal: TFormPrincipal;

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

function hyperg(p, q: integer; a, b: TVetorR; x: extended): extended;
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

function dhdan(p, q: integer; a, b: TVetorR; x: extended; n: integer): extended;
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

function dhdbn(p, q: integer; a, b: TVetorR; x: extended; n: integer): extended;
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

procedure SetVetorR(var v: TVetorR; c: array of extended; n: integer); overload;
var i: integer;
begin
  for i := 0 to n - 1 do
    v[i] := c[i];
end;

procedure SetVetorC(var v: TVetorC; c: array of TComplex; n: integer);
var i: integer;
begin
  for i := 0 to n - 1 do
    v[i] := c[i];
end;

function aexato(n: integer): TVetorR;
begin
  SetLength(result, 4);
  case n of
    2: SetVetorR(result, [1/5,2/5,3/5,4/5], 4);
    3: SetVetorR(result, [9/20, 13/20, 17/20, 21/20], 4);
    4: SetVetorR(result, [7/10, 9/10, 11/10, 13/10], 4);
    else SetVetorR(result, [-1/20, 3/20, 7/20, 11/20], 4);
  end;
end;

function bexato(n: integer): TVetorR;
begin
  SetLength(result, 3);
  case n of
    2: SetVetorR(result, [1/2,3/4,5/4], 3);
    3: SetVetorR(result, [3/4, 5/4, 3/2], 3);
    4: SetVetorR(result, [5/4,3/2,7/4], 3);
    else SetVetorR(result, [1/4, 1/2, 3/4], 3);
  end;
end;

function cjexato(j, n: integer): TComplex;
begin
  result.a := 0;
  result.b := 0;
  if j = 1 then
    case n of
      2: result.a := 1;
      3: result.a := -1;
      4: result.b := 1;
      5: result.b := -1;
    end;

  if j = 2 then
  begin
    if n = 1 then
      result.a := 1
    else result.a := -1/4;
  end;

  if j = 3 then
    case n of
      2: result.a := -5/32;
      3: result.a := 5/32;
      4: result.b := 5/32;
      5: result.b := -5/32;
    end;

  if j = 4 then
    case n of
      2, 3: result.a := -5/32;
      4, 5: result.a := 5/32;
      else result.a := 0;
    end;
end;

procedure SetB(var b: TVetorR; i: integer);
begin
  SetVetorR(b, bexato(i + 1), 3);
end;

function root(t: extended; a, b: array of TVetorR; c: array of TComplex): TComplex;
var
  z: extended;
  f: array[1..4] of extended;
begin
  result.a := 0;
  result.b := 0;
  z := 3125/256 * sqr(sqr(t));
  f[1] := hyperg(4, 3, a[0], b[0], z);
  f[2] := t * hyperg(4, 3, a[1], b[1], z);
  f[3] := sqr(t) * hyperg(4, 3, a[2], b[2], z);
  f[4] := sqr(t) * t * hyperg(4, 3, a[3], b[3], z);
  result.a := c[0].a * f[1] + c[1].a * f[2] + c[2].a * f[3] + c[3].a * f[4];
  result.b := c[0].b * f[1] + c[1].b * f[2] + c[2].b * f[3] + c[3].b * f[4];
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

function TFormPrincipal.alpha(constante: extended; efetivar, mostrar: boolean; epoca: integer): double;
var
  i: integer;
  a, b: array of TVetorR;
  c: array of TVetorC;
begin
  SetLength(a, 4);
  SetLength(b, 4);
  for i := 0 to 3 do
  begin
    SetLength(a[i], 4);
    SetVetorR(a[i], a_find[i], 4); // - 0 * constante * grad
    SetLength(b[i], 3);
    SetVetorR(b[i], b_find[i], 3);
  end;
  SetLength(c, 5);
  for i := 0 to 4 do
  begin
    SetLength(c[i], 4);
    SetVetorC(c[i], c_find[i], 4);
  end;
  for i := 0 to 3 do
  begin
    a[1,i] := a_find[1,i] - constante * sgn(grada2[i])/10000;
    a[3,i] := a_find[3,i] - constante * sgn(grada4[i])/10000;
  end;
  for i := 0 to 2 do
  begin
    b[1,i] := b_find[1,i] - constante * sgn(gradb2[i])/10000;
    b[3,i] := b_find[3,i] - constante * sgn(gradb4[i])/10000;
  end;
  for i := 0 to 4 do
  begin
    //c[i,1].a := c_find[i,1].a - constante * sgn(gradc2[i + 1])/10000;
    //c[i,3].a := c_find[i,3].a - constante * gradc4[i + 1];
  end;

  if efetivar then
  begin
    for i := 0 to 3 do
    begin
      SetVetorR(a_find[i], a[i], 4);
      SetVetorR(b_find[i], b[i], 3);
    end;
    for i := 0 to 4 do
      SetVetorC(c_find[i], c[i], 4);
  end;

  if mostrar then
  begin
    memo.lines.add('época = ' + inttostr(epoca)+ ' ; alpha = ' + floattostr(constante));
    for i := 0 to 3 do
      memo.lines.add('a2_' + inttostr(i) + ' = ' + floattostr(a[1,i]));
    for i := 0 to 2 do
      memo.lines.add('b2_' + inttostr(i) + ' = ' + floattostr(b[1,i]));
    for i := 1 to 5 do
      memo.lines.add('c2_' + inttostr(i) + ' = ' + complextostr(c[i-1,1]));
    for i := 0 to 3 do
      memo.lines.add('a4_' + inttostr(i) + ' = ' + floattostr(a[3,i]));
    for i := 0 to 2 do
      memo.lines.add('b4_' + inttostr(i) + ' = ' + floattostr(b[3,i]));
    for i := 1 to 5 do
      memo.lines.add('c4_' + inttostr(i) + ' = ' + complextostr(c[i-1,3]));
  end;

  result := 0;
  for i := 1 to 5 do
  begin
    y[i] := root(t, a, b, c[i-1]);
    f[i] := polinomio(y[i], t);
    result := result + sqr(f[i].a) + sqr(f[i].b);
    if mostrar then
      memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y[i]) + ' ; erro = ' + complextostr(f[i]));
  end;

  if mostrar then
    memo.lines.add('Raiz do Erro Quadrático = ' + floattostr(sqrt(result)));
end;

procedure TFormPrincipal.btnExataClick(Sender: TObject);
var
  t: extended;
  y, erro: TComplex;
  i, j: integer;
begin
  t := 0.09;
  for i := 1 to 5 do
  begin
    y := root(t, [aexato(1), aexato(2), aexato(3), aexato(4)], [bexato(1), bexato(2), bexato(3), bexato(4)], [cjexato(1,i), cjexato(2,i), cjexato(3,i), cjexato(4,i)]);
    erro := polinomio(y, t);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y) + ' ; erro = ' + complextostr(erro));
  end;
end;

procedure TFormPrincipal.btnGradienteClick(Sender: TObject);
var
  k, erro, temp, z: extended;
  dRefidp, dImfidp: array[1..5] of double;
  i, j, epoca: integer;
  ztemp: TComplex;
begin
  memo.clear;
  SetLength(a_find, 4);
  SetLength(b_find, 4);
  for i := 0 to 3 do
  begin
    SetLength(a_find[i], 4);
    SetVetorR(a_find[i], aexato(i + 1), 4);
    SetLength(b_find[i], 3);
    //SetVetorR(b_find[i], bexato(i + 1), 3);
    SetB(b_find[i], i); // tenta colocar aquela linha aqui procê ver o compiler error: internal error X865
  end;
  SetLength(c_find, 5);
  for i := 0 to 4 do
  begin
    SetLength(c_find[i], 4);
    SetVetorC(c_find[i], [cjexato(1, i + 1), cjexato(2, i + 1), cjexato(3, i + 1), cjexato(4, i + 1)], 4);
  end;
  for i := 0 to 3 do
  begin
    a_find[1,i] := random;
    a_find[3,i] := random;
  end;
  for i := 0 to 2 do
  begin
    b_find[1,i] := random;
    b_find[3,i] := random;
  end;
  for i := 0 to 4 do
  begin
    //c_find[i,1].a := random;
    //c_find[i,3].a := random;
  end;

  t := 0.09;
  z := 3125/256 * sqr(sqr(t));
  erro := 1e100;
  for epoca := 1 to 1000 do
  begin
    for i := 1 to 5 do
    begin
      y[i] := root(t, a_find, b_find, c_find[i-1]);
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
        k := c_find[i-1,1].a * t * dhdan(4, 3, a_find[1], b_find[1], z, j); // dp \ daj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqda[j]; // Re f * (dR\dp * dp\daj + dR\dq * dq\daj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqda[j];
        grada2[j] := grada2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
        k := c_find[i-1,3].a * t * sqr(t) * dhdan(4, 3, a_find[3], b_find[3], z, j); // dp \ daj
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
        k := c_find[i-1,1].a * t * dhdbn(4, 3, a_find[1], b_find[1], z, j); // dp \ dbj
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdb[j]; // Re f * (dR\dp * dp\dbj + dR\dq * dq\dbj)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdb[j];
        gradb2[j] := gradb2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
        k := c_find[i-1,3].a * t * sqr(t) * dhdbn(4, 3, a_find[3], b_find[3], z, j); // dp \ dbj
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
          k := t * hyperg(4, 3, a_find[1], b_find[1], z) // dp \ d c2 j
        else
          k := 0;
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdc2[j]; // Re f * (dR\dp * dp\dc2j + dR\dq * dq\dc2j)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdc2[j];
        gradc2[j] := gradc2[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
      end;

      gradc4[j] := 0;
      for i := 1 to 5 do
      begin
        if i = j then
          k := t * sqr(t) * hyperg(4, 3, a_find[3], b_find[3], z) // dp \ d c2 j
        else
          k := 0;
        ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdc2[j]; // Re f * (dR\dp * dp\dc2j + dR\dq * dq\dc2j)
        ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdc2[j];
        gradc4[j] := gradc4[j] + f[i].a * ztemp.a + f[i].b * ztemp.b;
      end;
    end;

    // esse alfa aqui é pequeno em C e grande em A
    // tem que ser trocado para uma constante em cada dimensão
    temp := alpha(1, true, false, epoca);
    if (temp > erro) or (temp < 1e-20) then
      break;
    erro := temp;
  end;
  temp := alpha(0, false, true, epoca);
end;

end.
