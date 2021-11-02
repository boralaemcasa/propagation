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
    function root(a, b: array of TVetorR; c: array of TComplex): TComplex;
    function polinomio(y: TComplex): TComplex;
    procedure SetConstCIm(index, j: integer);
  public
    iteracoes: integer;
    constante, erroAtual, erroDepois1, erroDepois2, z: extended;
    t: array[0..3] of extended;
    dRefidp, dImfidp, dRefidq, dImfidq: array[1..5] of extended;
    delta: array[1..(4 * 4 + 3 * 4 + 5 * 4 + 5 * 4)] of extended;
    shuffle: array[1..(4 * 4 + 3 * 4 + 5 * 4 + 5 * 4)] of integer;
    f, y: array[1..5] of TComplex;
    a, b: array of TVetorR;
    c: array of TVetorC;
    procedure LoopIncXJ(digit, v: integer; var xj: extended);
    procedure SetConstAB(index, j: integer; ch: char);
    function DeltaIsZero: boolean;
    procedure SetConstCRe(index, j: integer);
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
  if z.b = 1 then
    result := result + ' + i'
  else if z.b = -1 then
    result := result + ' - i'
  else if z.b < 0 then
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

function TFormPrincipal.root(a, b: array of TVetorR; c: array of TComplex): TComplex;
var
  f: array[1..4] of extended;
begin
  result.a := 0;
  result.b := 0;
  f[1] := hyperg(4, 3, a[0], b[0], z);
  f[2] := t[1] * hyperg(4, 3, a[1], b[1], z);
  f[3] := t[2] * hyperg(4, 3, a[2], b[2], z);
  f[4] := t[3] * hyperg(4, 3, a[3], b[3], z);
  result.a := c[0].a * f[1] + c[1].a * f[2] + c[2].a * f[3] + c[3].a * f[4];
  result.b := c[0].b * f[1] + c[1].b * f[2] + c[2].b * f[3] + c[3].b * f[4];
end;

function multiplica(z, w: TComplex): TComplex; // (za + zb i)(wa + wb i)
begin
  result.a := z.a * w.a - z.b * w.b;
  result.b := z.a * w.b + z.b * w.a;
end;

function TFormPrincipal.polinomio(y: TComplex): TComplex; // retorna erro = y^5 - y + t
var
  i: integer;
begin
  result := y;
  for i := 1 to 4 do
    result := multiplica(result, y);

  result.a := result.a - y.a + t[1];
  result.b := result.b - y.b;
end;

//  (p + qi)^5 - (p + qi) - t
//= p^5 + 5p^4 qi - 10p^3 q^2 - 10p^2q^3 i + 5pq^4 + q^5 i - p - qi - t = f.a + i f.b
//  f.a = p^5 - 10p^3 q^2 + 5pq^4 - p - t ==> d\dp = 5p^4 - 30p^2 q^2 + 5q^4 - 1
//  f.b = 5p^4 q - 10p^2q^3 + q^5 - q     ==> d\dp = 20p^3 q - 20pq^3

function dpre(p, q: extended): extended;
begin
  result := 5 * sqr(sqr(p)) - 30 * sqr(p) * sqr(q) + 5 * sqr(sqr(q)) - 1;
end;

function dpim(p, q: extended): extended;
begin
  result := 20 * p * q * (sqr(p) - sqr(q));
end;

//  f.a = p^5 - 10p^3 q^2 + 5pq^4 - p - t ==> d\dq = - 20p^3 q + 20pq^3
//  f.b = 5p^4 q - 10p^2q^3 + q^5 - q     ==> d\dq = 5p^4 - 30p^2q^2 + 5q^4 - 1

function dqre(p, q: extended): extended;
begin
  result := - dpim(p, q);
end;

function dqim(p, q: extended): extended;
begin
  result := dqre(p, q);
end;

function ajuste(c: extended; casas: integer): extended;
var i: integer;
begin
  result := -sgn(c);
  for i := 1 to casas do
    result := result / 10;
end;

procedure TFormPrincipal.btnExataClick(Sender: TObject);
var
  y, erro: TComplex;
  i: integer;
begin
  t[0] := 1;
  t[1] := 0.09;
  t[2] := sqr(t[1]);
  t[3] := t[1] * t[2];
  z := 3125/256 * t[1] * t[3];
  for i := 1 to 5 do
  begin
    y := root([aexato(1), aexato(2), aexato(3), aexato(4)], [bexato(1), bexato(2), bexato(3), bexato(4)], [cjexato(1,i), cjexato(2,i), cjexato(3,i), cjexato(4,i)]);
    erro := polinomio(y);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y) + ' ; erro = ' + complextostr(erro));
  end;
end;

function aleatorio(casas: integer): extended;
var i, n: integer;
begin
  n := 1;
  for i := 1 to casas do
    n := n * 10;
  result := (random(n - 1) + 1)/n;
end;

procedure xchg(var x, y: integer);
var tmp: integer;
begin
  tmp := x;
  x := y;
  y := tmp;
end;

procedure TFormPrincipal.btnGradienteClick(Sender: TObject);
var
  i, j, epoca, v, digit: integer;
  k: extended;
  ztemp: TComplex;
  s: string;
begin
{
  método do gradiente
  (f_1, ..., f10) = 0
  e = 0.5 ||f||^2;
  for j := 1 to 10 do
  begin
    x_j := aleatorio(3); // 3 casas
    delta_j := 7;
  end;
  for épocas := 1 to 50 do
    for j := 1 to 10 do
    begin
      const := de\dx_j;
      delta_j := ajuste(const, 3); // decidir se vamos andar 0 ou ± 0.001
      x_j := x_j + delta_j;
      if \vec delta = 0 then break;
    end;
  mais épocas para a 4a casa;
  mais épocas para a 5a casa;
  mais épocas para a 6a casa;
  mais épocas para a 7a casa;
  7 está bom.
}
  memo.clear;
  SetLength(a, 4);
  SetLength(b, 4);
  for i := 0 to 3 do
  begin
    SetLength(a[i], 4);
    SetVetorR(a[i], aexato(i + 1), 4);
    SetLength(b[i], 3);
    //SetVetorR(b[i], bexato(i + 1), 3);
    SetB(b[i], i); // tenta colocar aquela linha aqui procê ver o compiler erroAtualr: internal erroAtualr X865
  end;
  SetLength(c, 5);
  for i := 0 to 4 do
  begin
    SetLength(c[i], 4);
    SetVetorC(c[i], [cjexato(1, i + 1), cjexato(2, i + 1), cjexato(3, i + 1), cjexato(4, i + 1)], 4);
  end;
  for i := 0 to 3 do
  begin
    a[0,i] := aleatorio(3);
    a[1,i] := aleatorio(3);
    a[2,i] := aleatorio(3);
    a[3,i] := aleatorio(3);
  end;
  for i := 0 to 2 do
  begin
    b[0,i] := aleatorio(3);
    b[1,i] := aleatorio(3);
    b[2,i] := aleatorio(3);
    b[3,i] := aleatorio(3);
  end;
  for i := 0 to 4 do
  begin
    //c[i,0].a := aleatorio(3);
    //c[i,1].a := aleatorio(3);
    //c[i,2].a := aleatorio(3);
    //c[i,3].a := aleatorio(3);
  end;
  for i := 0 to 0 do
  begin
    //c[i,0].b := aleatorio(3);
    //c[i,1].b := aleatorio(3);
    //c[i,2].b := aleatorio(3);
    //c[i,3].b := aleatorio(3);
  end;

  t[0] := 1;
  t[1] := 0.09;
  t[2] := sqr(t[1]);
  t[3] := t[1] * t[2];
  z := 3125/256 * t[1] * t[3];

  erroAtual := 0;
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := polinomio(y[i]);
    erroAtual := erroAtual + sqr(f[i].a) + sqr(f[i].b);
  end; // inicializei erroAtual

  for v := 1 to 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 do
    delta[v] := 7;
  for digit := 1 to 5 do
    for epoca := 1 to 200 do
    begin
      for v := 1 to 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 do
        shuffle[v] := v;
      for v := 1 to 1000 do // mil embaralhadas
      begin
        i := random(4 * 4 + 3 * 4 + 5 * 4 + 5 * 4) + 1;
        j := random(4 * 4 + 3 * 4 + 5 * 4 + 5 * 4) + 1;
        xchg(shuffle[i], shuffle[j]);
      end;

      for v := 1 to 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 do // a1[4]..a4[4]  b1[3]...b4[3] c1re[5]..c4re[5] c1im[5]..c4im[5]
      begin
        iteracoes := 0;
        if shuffle[v] <= 4 then
        begin
          j := shuffle[v] - 1; // de \ da2 j
          SetConstAB(0, j, 'a');
          LoopIncXJ(digit, v, a[0,j]);
        end
        else if shuffle[v] <= 4 * 2 then
        begin
          j := shuffle[v] - 4 - 1; // de \ da4 j
          SetConstAB(1, j, 'a');
          LoopIncXJ(digit, v, a[1,j]);
        end
        else if shuffle[v] <= 4 * 3 then
        begin
          j := shuffle[v] - 4 * 2 - 1; // de \ da4 j
          SetConstAB(2, j, 'a');
          LoopIncXJ(digit, v, a[2,j]);
        end
        else if shuffle[v] <= 4 * 4 then
        begin
          j := shuffle[v] - 4 * 3 - 1; // de \ da4 j
          SetConstAB(3, j, 'a');
          LoopIncXJ(digit, v, a[3,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 then
        begin
          j := shuffle[v] - 4 * 4 - 1; // de \ db1 j
          SetConstAB(0, j, 'b');
          LoopIncXJ(digit, v, b[0,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 - 1; // de \ db2 j
          SetConstAB(1, j, 'b');
          LoopIncXJ(digit, v, b[1,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 2 - 1; // de \ db3 j
          SetConstAB(2, j, 'b');
          LoopIncXJ(digit, v, b[2,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 3 - 1; // de \ db4 j
          SetConstAB(3, j, 'b');
          LoopIncXJ(digit, v, b[3,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 1; // de \ dc1re j
          SetConstCRe(0, j);
          LoopIncXJ(digit, v, c[j,0].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 - 1; // de \ dc2re j
          SetConstCRe(1, j);
          LoopIncXJ(digit, v, c[j,1].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 2 - 1; // de \ dc3re j
          SetConstCRe(2, j);
          LoopIncXJ(digit, v, c[j,2].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 3 - 1; // de \ dc4re j
          SetConstCRe(3, j);
          LoopIncXJ(digit, v, c[j,3].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 1; // de \ dcim1 j
          SetConstCIm(0, j);
          LoopIncXJ(digit, v, c[j,0].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 - 1; // de \ dcim2 j
          SetConstCIm(1, j);
          LoopIncXJ(digit, v, c[j,1].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 * 2 - 1; // de \ dcim3 j
          SetConstCIm(2, j);
          LoopIncXJ(digit, v, c[j,2].b);
        end
        else // if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 * 3 - 1; // de \ dcim4 j
          SetConstCIm(3, j);
          LoopIncXJ(digit, v, c[j,3].b);
        end;
        delta[shuffle[v]] := delta[shuffle[v]] * iteracoes;
        if erroDepois1 < erroAtual then
        begin
          memo.lines.add('digit = ' + inttostr(digit) + ' ; época = ' + inttostr(epoca)+ ' ; v = ' + inttostr(shuffle[v]) + ' ; Raiz do erro = ' + floattostr(sqrt(erroDepois1)));
          erroAtual := erroDepois1;
        end;
        if DeltaIsZero then
          break;
      end;
    end;

  for j := 1 to 4 do
  begin
    s := '';
    for i := 0 to 3 do
      s := s + 'a' + inttostr(j) + '_' + inttostr(i) + ' = ' + floattostr(a[j-1,i]) + ' ; ';
    memo.lines.add(s);
    s := '';
    for i := 0 to 2 do
      s := s + 'b' + inttostr(j) + '_' + inttostr(i) + ' = ' + floattostr(b[j-1,i]) + ' ; ';
    memo.lines.add(s);
  end;

  for j := 1 to 4 do
  begin
    s := '';
    for i := 1 to 5 do
      s := s + 'c' + inttostr(j) + '_' + inttostr(i) + ' = ' + complextostr(c[i-1,j-1]) + ' ; ';
    memo.lines.add(s);
  end;

  k := 0;
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := polinomio(y[i]);
    k := k + sqr(f[i].a) + sqr(f[i].b);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y[i]) + ' ; erro = ' + complextostr(f[i]));
  end;
  memo.lines.add('Raiz do erro Quadrático = ' + floattostr(sqrt(k)));
end;

function TFormPrincipal.DeltaIsZero: boolean;
var v: integer;
begin
  result := true;
  for v := 1 to 4 * 4 + 3 * 4 + 5 * 4 do
    if delta[v] <> 0 then
    begin
      result := false;
      exit;
    end;
end;

procedure TFormPrincipal.SetConstAB(index, j: integer; ch: char);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := polinomio(y[i]);
    dRefidp[i] := dpre(y[i].a, y[i].b);
    dImfidp[i] := dpim(y[i].a, y[i].b);
    dRefidq[i] := dqre(y[i].a, y[i].b);
    dImfidq[i] := dqim(y[i].a, y[i].b);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if ch = 'b' then
      k := t[index] * dhdbn(4, 3, a[index], b[index], z, j)
    else // 'a'
      k := t[index] * dhdan(4, 3, a[index], b[index], z, j);
    ztemp.a := f[i].a * (dRefidp[i] * c[i-1,index].a + dRefidq[i] * c[i-1,index].b) * k; // Re f * (dR\dp * dp\daj + dR\dq * dq\daj)
    ztemp.b := f[i].b * (dImfidp[i] * c[i-1,index].a + dImfidq[i] * c[i-1,index].b) * k; // Im f * (dI\dp * dp\daj + dI\dq * dq\daj)
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

procedure TFormPrincipal.LoopIncXJ(digit, v: integer; var xj: extended);
var i: integer;
begin
  delta[shuffle[v]] := ajuste(constante, digit);
  erroDepois1 := erroAtual;
  repeat
    xj := xj + delta[shuffle[v]];
    erroDepois2 := 0;
    for i := 1 to 5 do
    begin
      y[i] := root(a, b, c[i-1]);
      f[i] := polinomio(y[i]);
      erroDepois2 := erroDepois2 + sqr(f[i].a) + sqr(f[i].b);
    end;
    if erroDepois2 >= erroDepois1 then
    begin
      xj := xj - delta[shuffle[v]];
      break;
    end;
    erroDepois1 := erroDepois2;
    inc(iteracoes);
  until iteracoes = 5;
end;

procedure TFormPrincipal.SetConstCRe(index, j: integer);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := polinomio(y[i]);
    dRefidp[i] := dpre(y[i].a, y[i].b);
    dImfidp[i] := dpim(y[i].a, y[i].b);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if i = j then
      k := t[index] * hyperg(4, 3, a[index], b[index], z) // dp \ d cre j
    else
      k := 0;
    ztemp.a := dRefidp[i] * k; // + dRefidq[i] * dqdcre[j]; // Re f * (dR\dp * dp\dcrej + dR\dq * dq\dcrej)
    ztemp.b := dImfidp[i] * k; // + dImfidq[i] * dqdcre[j];
    constante := constante + f[i].a * ztemp.a + f[i].b * ztemp.b;
  end;
end;

procedure TFormPrincipal.SetConstCIm(index, j: integer);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := polinomio(y[i]);
    dRefidq[i] := dqre(y[i].a, y[i].b);
    dImfidq[i] := dqim(y[i].a, y[i].b);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if i = j then
      k := t[index] * hyperg(4, 3, a[index], b[index], z) // dq \ dcim j
    else
      k := 0;
    ztemp.a := dRefidq[i] * k;  // Re f * (dR\dp * dp\dcimj + dR\dq * dq\dcimj)
    ztemp.b := dImfidq[i] * k;
    constante := constante + f[i].a * ztemp.a + f[i].b * ztemp.b;
  end;
end;

end.
