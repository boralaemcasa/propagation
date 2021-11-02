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
    btnChecar: TButton;
    btnCancel: TButton;
    procedure btnExataClick(Sender: TObject);
    procedure btnGradienteClick(Sender: TObject);
    procedure btnChecarClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    function CalcularErro(show: boolean): extended;
  public
    cancelar: boolean;
    iteracoes: integer;
    constante, erroAtual, erroDepois1, erroDepois2, lnt0, lnt1, z1, z2, t0, t1: extended;
    gc: array[0..1] of extended;
    ge: array[0..3] of extended;
    tt: array[0..5] of extended;
    delta: array[1..294] of extended;
    shuffle: array[1..294] of integer;
    f, y, yexato: array[1..6] of TComplex;
    a, b: array of TVetorR;
    cre, cim: array[0..5, 0..5] of extended;
    function DeltaIsZero: boolean;
    procedure IncrementXJ(digit, v: integer; var xj: extended; zz: boolean = false);
    procedure SetConstAB(index, j: integer; ch: char);
    procedure SetConstCRe(index, j: integer);
    procedure SetConstCIm(index, j: integer);
    procedure SetConstGC(n: integer);
    procedure SetConstGE(n: integer);
    function root(ccre, ccim: array of extended): TComplex;
    function erroPolinomial(y: TComplex): TComplex;
    function erroAproximado(i: integer): TComplex;
    function hyperg(a1, a2, a3, b1, b2, b3: TVetorR): extended;
    function dhdan(index: integer; a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
    function dhdbn(index: integer; a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
    function dhdgcn(a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
    function dhdgen(a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

function complexToStr(za, zb: extended): string; overload;
begin
  if (za = 0) and (zb = 0) then
  begin
    result := '0';
    exit;
  end;
  if za <> 0 then
    result := floattostr(za)
  else
    result := '';
  if zb = 1 then
    result := result + ' + i'
  else if zb = -1 then
    result := result + ' - i'
  else if zb < 0 then
    result := result + ' - ' + floattostr(-zb) + ' i'
  else if zb > 0 then
  begin
    if za <> 0 then
      result := result + ' + ';
    result := result + floattostr(zb) + ' i';
  end;
end;

function complexToStr(zz: TComplex): string; overload;
begin
  result := complexToStr(zz.a, zz.b);
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

function pow(x, y: extended): extended;
var n: integer;
begin
  result := 0;
  if x > 0 then
    result := exp(y * ln(x))
  else if x < 0 then
  begin
    n := round(y);
    if abs(n - y) < 1e-6 then
    begin
      if n mod 2 = 0 then
        result := exp(y * ln(-x))
      else
        result := - exp(y * ln(-x))
    end;
  end;
end;

function fatorial(n: integer): extended;
var i: integer;
begin
  result := 1;
  for i := 2 to n do
    result := result * i;
end;

function PochHammer(a: extended; n: integer): extended;
var i: integer;
begin
  result := 1;
  for i := 0 to n - 1 do
     result := result * (a + i);
end;

function TFormPrincipal.hyperg(a1, a2, a3, b1, b2, b3: TVetorR): extended;
var
  termo: extended;
  i, j, k: integer;
begin
  result := 0;
  for j := 0 to 100 do
    for i := 0 to 100 do
    begin
      termo := pow(z1, i)/fatorial(i);
      termo := termo * pow(z2, j)/fatorial(j);
      for k := 0 to 5 do
        termo := termo * PochHammer(a1[k], i + j)/PochHammer(b1[k], i + j);
      for k := 0 to 5 do
        termo := termo * PochHammer(a2[k], i)/PochHammer(b2[k], i);
      for k := 0 to 5 do
        termo := termo * PochHammer(a3[k], j)/PochHammer(b3[k], j);
      result := result + termo;
      if abs(termo) < 1e-11 then
        break;
    end;
end;

function TFormPrincipal.dhdan(index: integer; a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
var
  termo, st, an: extended;
  i, j, k, max: integer;
begin
  result := 0;
  case index mod 3 of
    1: an := a2[n];
    2: an := a3[n];
    else an := a1[n];
  end;
  for j := 0 to 100 do
    for i := 0 to 100 do
    begin
      termo := pow(z1, i)/fatorial(i);
      termo := termo * pow(z2, j)/fatorial(j);
      for k := 0 to 5 do
        termo := termo * PochHammer(a1[k], i + j)/PochHammer(b1[k], i + j);
      for k := 0 to 5 do
        termo := termo * PochHammer(a2[k], i)/PochHammer(b2[k], i);
      for k := 0 to 5 do
        termo := termo * PochHammer(a3[k], j)/PochHammer(b3[k], j);
      case index mod 3 of
        1: max := i - 1; // i = 2 has k = 0 or k = 1
        2: max := j - 1;
        else max := i + j - 1;
      end;
      st := 0;
      for k := 0 to max do
        st := st + termo/(an + k);
      result := result + st;
      if abs(st) < 1e-11 then
        break;
    end;
end;

function TFormPrincipal.dhdbn(index: integer; a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
var
  termo, st, an: extended;
  i, j, k, max: integer;
begin
  result := 0;
  case index mod 3 of
    1: an := a2[n];
    2: an := a3[n];
    else an := a1[n];
  end;
  for j := 0 to 100 do
    for i := 0 to 100 do
    begin
      termo := pow(z1, i)/fatorial(i);
      termo := termo * pow(z2, j)/fatorial(j);
      for k := 0 to 5 do
      begin
        termo := termo * PochHammer(a1[k], i + j)/PochHammer(b1[k], i + j);
      end;
      for k := 0 to 5 do
        termo := termo * PochHammer(a2[k], i)/PochHammer(b2[k], i);
      for k := 0 to 5 do
        termo := termo * PochHammer(a3[k], j)/PochHammer(b3[k], j);
      case index mod 3 of
        1: max := i; // i = 2 has k = 0 or k = 1
        2: max := j;
        else max := i + j;
      end;
      st := 1/PochHammer(an, max);
      termo := -termo * sqr(st); // derivative of c/P = - c/P^2 * derivative of P
      st := 0;
      for k := 0 to max - 1 do
        st := st + termo/(an + k);
      result := result + st;
      if abs(st) < 1e-11 then
        break;
    end;
end;

procedure SetVetorR(var v: TVetorR; cc: array of extended; n: integer); overload;
var i: integer;
begin
  for i := 0 to n - 1 do
    v[i] := cc[i];
end;        

procedure SetVetorC(var v: TVetorC; cc: array of TComplex; n: integer);
var i: integer;
begin
  for i := 0 to n - 1 do
    v[i] := cc[i];
end;

function TFormPrincipal.root(ccre, ccim: array of extended): TComplex;
var
  f: array[1..6] of extended;
  i: integer;
begin
  result.a := 0;
  result.b := 0;
  f[1] := tt[0] * hyperg(a[ 0], a[ 1], a[ 2], b[ 0], b[ 1], b[ 2]);
  f[2] := tt[1] * hyperg(a[ 3], a[ 4], a[ 5], b[ 3], b[ 4], b[ 5]);
  f[3] := tt[2] * hyperg(a[ 6], a[ 7], a[ 8], b[ 6], b[ 7], b[ 8]);
  f[4] := tt[3] * hyperg(a[ 9], a[10], a[11], b[ 9], b[10], b[11]);
  f[5] := tt[4] * hyperg(a[12], a[13], a[14], b[12], b[13], b[14]);
  f[6] := tt[5] * hyperg(a[15], a[16], a[17], b[15], b[16], b[17]);
  for i := 0 to 5 do
  begin
    result.a := result.a + ccre[i] * f[i + 1];
    result.b := result.b + ccim[i] * f[i + 1];
  end;
end;

function multiplica(zz, w: TComplex): TComplex; // (za + zb i)(wa + wb i)
begin
  result.a := zz.a * w.a - zz.b * w.b;
  result.b := zz.a * w.b + zz.b * w.a;
end;

function TFormPrincipal.erroPolinomial(y: TComplex): TComplex; // retorns error = y^6 - y^2 + t1 * y + t0
var
  i: integer;
  yy: TComplex;
begin
  yy := multiplica(y, y);
  result := yy;
  for i := 1 to 4 do
    result := multiplica(result, y);

  result.a := result.a - yy.a + t1 * y.a + t0;
  result.b := result.b - yy.b + t1 * y.b + t0;
end;

function TFormPrincipal.erroAproximado(i: integer): TComplex; // returns error = y - y_0
begin
  result.a := y[i].a - yexato[i].a;
end;

function ajuste(cc: extended; casas: integer): extended;
var i: integer;
begin
  result := -sgn(cc);
  for i := 1 to casas do
    result := result / 10;
end;

procedure TFormPrincipal.btnExataClick(Sender: TObject);
var i: integer;
begin
  t0 := 0.091; // 13 * 7
  t1 := 0.088; // 11 * 8
  // y^6 - y^2 + t_1 y + t_0 = 0 from wolfram alpha
  for i := 1 to 6 do
  begin
    yexato[i].a := 0;
    yexato[i].b := 0;
  end;
  yexato[1].a := -0.989937;
  yexato[2].a := -0.643921;
  yexato[3].a := -0.102471; yexato[3].b := + 1.16016;
  yexato[4].a := -0.102471; yexato[4].b := - 1.16016;
  yexato[5].a :=  0.919399; yexato[5].b := + 0.455114;
  yexato[6].a :=  0.919399; yexato[5].b := - 0.455114;
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

function TFormPrincipal.CalcularErro(show: boolean): extended;
var i: integer;
begin
  result := 0;
  for i := 1 to 6 do
  begin
    y[i] := root(cre[i-1], cim[i-1]);
    f[i] := erroAproximado(i);
    result := result + sqr(f[i].a) + sqr(f[i].b);
    if show then
      memo.lines.add('y_' + inttostr(i) + '(t0) = ' + complextostr(y[i]) + ' ; error = ' + complextostr(f[i]));
  end;
  if show then
    memo.lines.add('Square root of quadratic error = ' + floattostr(sqrt(result)));
end;

procedure TFormPrincipal.btnGradienteClick(Sender: TObject);
var
  i, j, epoca, v, digit: integer;
  s: string;
begin
  btnExataClick(Sender);
  btnExata.Enabled := false;
  btnGradiente.Enabled := false;
  btnChecar.Enabled := false;
  cancelar := false;
  memo.clear;
  SetLength(a, 18);
  SetLength(b, 18);
  for i := 0 to 17 do
  begin
    SetLength(a[i], 6);
    SetLength(b[i], 6);
  end;
  for j := 0 to 17 do
    for i := 0 to 5 do
      a[j,i] := aleatorio(3);
  for j := 0 to 17 do
    for i := 0 to 5 do
      b[j,i] := aleatorio(3);
  for j := 0 to 5 do
    for i := 0 to 5 do
    begin
      cre[j,i] := aleatorio(3);
      cim[j,i] := aleatorio(3);
    end;

  lnt0 := ln(t0);
  lnt1 := ln(t1);
  tt[0] := exp(0 * lnt0) * exp(0 * lnt1);
  tt[1] := exp(0 * lnt0) * exp(1 * lnt1);
  tt[2] := exp(1 * lnt0) * exp(0 * lnt1);
  tt[3] := exp(0 * lnt0) * exp(2 * lnt1);
  tt[4] := exp(1 * lnt0) * exp(1 * lnt1);
  tt[5] := exp(2 * lnt0) * exp(0 * lnt1);

  gc[0] := aleatorio(3);
  gc[1] := aleatorio(3);
  for i := 0 to 3 do
    ge[i] := random(5) + 1;

  z1 := gc[0] * exp(ge[0] * lnt0) * exp(ge[1] * lnt1);
  z2 := gc[1] * exp(ge[2] * lnt0) * exp(ge[3] * lnt1);

  erroAtual := CalcularErro(false);

  for digit := 0 to 0 do
    for epoca := 1 to 100 do
    begin
      for v := 1 to 294 do
      begin
        delta[v] := 7;
        shuffle[v] := v;
      end;
      for v := 1 to 1000 do
      begin
        i := random(294) + 1;
        j := random(294) + 1;
        xchg(shuffle[i], shuffle[j]);
      end;

      for v := 1 to 294 do // a[18*6]  b[18*6] cre[6*6] cim[6*6] gc[2] ge[4]
      begin
        iteracoes := 0;
        if shuffle[v] <= 6 then
        begin
          j := shuffle[v] - 1; // de \ da1 j
          SetConstAB(0, j, 'a');
          IncrementXJ(digit, v, a[0,j]);
        end
        else if shuffle[v] <= 6 * 2 then
        begin
          j := shuffle[v] - 6 - 1; // de \ da2 j
          SetConstAB(1, j, 'a');
          IncrementXJ(digit, v, a[1,j]);
        end
        else if shuffle[v] <= 6 * 3 then
        begin
          j := shuffle[v] - 6 * 2 - 1; // de \ da3 j
          SetConstAB(2, j, 'a');
          IncrementXJ(digit, v, a[2,j]);
        end
        else if shuffle[v] <= 6 * 4 then
        begin
          j := shuffle[v] - 6 * 3 - 1; // de \ da4 j
          SetConstAB(3, j, 'a');
          IncrementXJ(digit, v, a[3,j]);
        end
        else if shuffle[v] <= 6 * 5 then
        begin
          j := shuffle[v] - 6 * 4 - 1; // de \ da5 j
          SetConstAB(4, j, 'a');
          IncrementXJ(digit, v, a[4,j]);
        end
        else if shuffle[v] <= 6 * 6 then
        begin
          j := shuffle[v] - 6 * 5 - 1; // de \ da6 j
          SetConstAB(5, j, 'a');
          IncrementXJ(digit, v, a[5,j]);
        end
        else if shuffle[v] <= 6 * 7 then
        begin
          j := shuffle[v] - 6 * 6 - 1; // de \ da7 j
          SetConstAB(6, j, 'a');
          IncrementXJ(digit, v, a[6,j]);
        end
        else if shuffle[v] <= 6 * 8 then
        begin
          j := shuffle[v] - 6 * 7 - 1; // de \ da8 j
          SetConstAB(7, j, 'a');
          IncrementXJ(digit, v, a[7,j]);
        end
        else if shuffle[v] <= 6 * 9 then
        begin
          j := shuffle[v] - 6 * 8 - 1; // de \ da9 j
          SetConstAB(8, j, 'a');
          IncrementXJ(digit, v, a[8,j]);
        end
        else if shuffle[v] <= 6 * 10 then
        begin
          j := shuffle[v] - 6 * 9 - 1; // de \ da10 j
          SetConstAB(9, j, 'a');
          IncrementXJ(digit, v, a[9,j]);
        end
        else if shuffle[v] <= 6 * 11 then
        begin
          j := shuffle[v] - 6 * 10 - 1; // de \ da11 j
          SetConstAB(10, j, 'a');
          IncrementXJ(digit, v, a[10,j]);
        end
        else if shuffle[v] <= 6 * 12 then
        begin
          j := shuffle[v] - 6 * 11 - 1; // de \ da12 j
          SetConstAB(11, j, 'a');
          IncrementXJ(digit, v, a[11,j]);
        end
        else if shuffle[v] <= 6 * 13 then
        begin
          j := shuffle[v] - 6 * 12 - 1; // de \ da13 j
          SetConstAB(12, j, 'a');
          IncrementXJ(digit, v, a[12,j]);
        end
        else if shuffle[v] <= 6 * 14 then
        begin
          j := shuffle[v] - 6 * 13 - 1; // de \ da14 j
          SetConstAB(13, j, 'a');
          IncrementXJ(digit, v, a[13,j]);
        end
        else if shuffle[v] <= 6 * 15 then
        begin
          j := shuffle[v] - 6 * 14 - 1; // de \ da15 j
          SetConstAB(14, j, 'a');
          IncrementXJ(digit, v, a[14,j]);
        end
        else if shuffle[v] <= 6 * 16 then
        begin
          j := shuffle[v] - 6 * 15 - 1; // de \ da16 j
          SetConstAB(15, j, 'a');
          IncrementXJ(digit, v, a[15,j]);
        end
        else if shuffle[v] <= 6 * 17 then
        begin
          j := shuffle[v] - 6 * 16 - 1; // de \ da17 j
          SetConstAB(16, j, 'a');
          IncrementXJ(digit, v, a[16,j]);
        end
        else if shuffle[v] <= 6 * 18 then
        begin
          j := shuffle[v] - 6 * 17 - 1; // de \ da18 j
          SetConstAB(17, j, 'a');
          IncrementXJ(digit, v, a[17,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 then
        begin
          j := shuffle[v] - 6 * 18 - 1; // de \ db1 j
          SetConstAB(0, j, 'b');
          IncrementXJ(digit, v, b[0,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 2 then
        begin
          j := shuffle[v] - 6 * 18 - 6 - 1; // de \ db2 j
          SetConstAB(1, j, 'b');
          IncrementXJ(digit, v, b[1,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 3 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 2 - 1; // de \ db3 j
          SetConstAB(2, j, 'b');
          IncrementXJ(digit, v, b[2,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 4 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 3 - 1; // de \ db4 j
          SetConstAB(3, j, 'b');
          IncrementXJ(digit, v, b[3,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 5 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 4 - 1; // de \ db5 j
          SetConstAB(4, j, 'b');
          IncrementXJ(digit, v, b[4,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 6 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 5 - 1; // de \ db6 j
          SetConstAB(5, j, 'b');
          IncrementXJ(digit, v, b[5,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 7 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 6 - 1; // de \ db7 j
          SetConstAB(6, j, 'b');
          IncrementXJ(digit, v, b[6,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 8 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 7 - 1; // de \ db8 j
          SetConstAB(7, j, 'b');
          IncrementXJ(digit, v, b[7,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 9 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 8 - 1; // de \ db9 j
          SetConstAB(8, j, 'b');
          IncrementXJ(digit, v, b[8,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 10 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 9 - 1; // de \ db10 j
          SetConstAB(9, j, 'b');
          IncrementXJ(digit, v, b[9,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 11 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 10 - 1; // de \ db11 j
          SetConstAB(10, j, 'b');
          IncrementXJ(digit, v, b[10,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 12 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 11 - 1; // de \ db12 j
          SetConstAB(11, j, 'b');
          IncrementXJ(digit, v, b[11,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 13 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 12 - 1; // de \ db13 j
          SetConstAB(12, j, 'b');
          IncrementXJ(digit, v, b[12,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 14 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 13 - 1; // de \ db14 j
          SetConstAB(13, j, 'b');
          IncrementXJ(digit, v, b[13,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 15 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 14 - 1; // de \ db15 j
          SetConstAB(14, j, 'b');
          IncrementXJ(digit, v, b[14,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 16 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 15 - 1; // de \ db16 j
          SetConstAB(15, j, 'b');
          IncrementXJ(digit, v, b[15,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 17 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 16 - 1; // de \ db17 j
          SetConstAB(16, j, 'b');
          IncrementXJ(digit, v, b[16,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 17 - 1; // de \ db18 j
          SetConstAB(17, j, 'b');
          IncrementXJ(digit, v, b[17,j]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 1; // de \ dc1re j
          SetConstCRe(0, j);
          IncrementXJ(digit, v, cre[j,0]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 2 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 - 1; // de \ dc2re j
          SetConstCRe(1, j);
          IncrementXJ(digit, v, cre[j,1]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 3 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 2 - 1; // de \ dc3re j
          SetConstCRe(2, j);
          IncrementXJ(digit, v, cre[j,2]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 4 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 3 - 1; // de \ dc4re j
          SetConstCRe(3, j);
          IncrementXJ(digit, v, cre[j,3]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 5 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 4 - 1; // de \ dc5re j
          SetConstCRe(4, j);
          IncrementXJ(digit, v, cre[j,4]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 5 - 1; // de \ dc6re j
          SetConstCRe(5, j);
          IncrementXJ(digit, v, cre[j,5]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 1; // de \ dc1Im j
          SetConstCIm(0, j);
          IncrementXJ(digit, v, cIm[j,0]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 2 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 - 1; // de \ dc2Im j
          SetConstCIm(1, j);
          IncrementXJ(digit, v, cIm[j,1]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 3 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 2 - 1; // de \ dc3Im j
          SetConstCIm(2, j);
          IncrementXJ(digit, v, cIm[j,2]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 4 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 3 - 1; // de \ dc4Im j
          SetConstCIm(3, j);
          IncrementXJ(digit, v, cIm[j,3]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 5 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 4 - 1; // de \ dc5Im j
          SetConstCIm(4, j);
          IncrementXJ(digit, v, cIm[j,4]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 6 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 5 - 1; // de \ dc6Im j
          SetConstCIm(5, j);
          IncrementXJ(digit, v, cIm[j,5]);
        end
        else if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 6 + 2 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 6 - 1; // de \ dgc j
          SetConstGC(j);
          IncrementXJ(digit, v, gc[j], true);
        end
        else // if shuffle[v] <= 6 * 18 + 6 * 18 + 6 * 6 + 6 * 6 + 2 + 4 then
        begin
          j := shuffle[v] - 6 * 18 - 6 * 18 - 6 * 6 - 6 * 6 - 2 - 1; // de \ dge j
          SetConstGE(j);
          IncrementXJ(0, v, ge[j], true);
        end;
        delta[shuffle[v]] := delta[shuffle[v]] * iteracoes;
        if erroDepois1 < erroAtual then
        begin
          //if (v = 1) and (epoca mod 10 = 0) then
            memo.lines.add('digit = ' + inttostr(digit) + ' ; epoch = ' + inttostr(epoca)+ ' ; v = ' + inttostr(v) + ' ; Square root of quadratic error = ' + floattostr(sqrt(erroDepois1)));
          erroAtual := erroDepois1;
        end;
        Application.ProcessMessages;
        if cancelar then
          exit;
      end;
      if DeltaIsZero then
        break; // digit++;
    end;

  for j := 1 to 18 do
  begin
    s := '';
    for i := 0 to 5 do
      s := s + 'a' + inttostr(j) + '_' + inttostr(i) + ' = ' + floattostr(a[j-1,i]) + ' ; ';
    memo.lines.add(s);
    s := '';
    for i := 0 to 5 do
      s := s + 'b' + inttostr(j) + '_' + inttostr(i) + ' = ' + floattostr(b[j-1,i]) + ' ; ';
    memo.lines.add(s);
  end;

  for j := 1 to 6 do
  begin
    s := '';
    for i := 1 to 6 do
      s := s + 'c' + inttostr(j) + '_' + inttostr(i) + ' = ' + complextostr(cre[i-1,j-1], cim[i-1,j-1]) + ' ; ';
    memo.lines.add(s);
  end;

  s := '';
  for i := 1 to 4 do
    s := s + 'ge' + inttostr(i) + ' = ' + floattostr(ge[i-1]) + ' ; ';
  memo.lines.add(s);
  memo.lines.add('gc1 = ' + floattostr(gc[0]) + ' ; gc2 = ' + floattostr(gc[1]));
  CalcularErro(true);
  btnExata.Enabled := true;
  btnGradiente.Enabled := true;
  btnChecar.Enabled := true;
  btnChecarClick(Sender);
end;

function TFormPrincipal.DeltaIsZero: boolean;
var v: integer;
begin
  result := true;
  for v := 1 to 294 do
    if delta[v] <> 0 then
    begin
      result := false;
      exit;
    end;
end;

// de \ daindex j
// de \ dbindex j
procedure TFormPrincipal.SetConstAB(index, j: integer; ch: char);
var
  i, iab: integer;
  k: extended;
  ztemp: TComplex;
begin
  CalcularErro(false);
  iab := index;
  while iab mod 3 > 0 do
    dec(iab);
  constante := 0;
  for i := 1 to 6 do
  begin
    if ch = 'b' then
      k := tt[iab div 3] * dhdbn(index, a[iab], a[iab + 1], a[iab + 2], b[iab], b[iab + 1], b[iab + 2], j)
    else // 'a'
      k := tt[iab div 3] * dhdan(index, a[iab], a[iab + 1], a[iab + 2], b[iab], b[iab + 1], b[iab + 2], j);
    ztemp.a := f[i].a * cre[i-1,iab div 3] * k; // p * dp\daj
    ztemp.b := f[i].b * cim[i-1,iab div 3] * k; // q * dq\daj
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

procedure TFormPrincipal.IncrementXJ(digit, v: integer; var xj: extended; zz: boolean = false);
begin
  erroDepois1 := erroAtual;
  delta[shuffle[v]] := ajuste(constante, digit);
  if zz and (digit = 0) and (xj + delta[shuffle[v]] < 0) then
    delta[shuffle[v]] := 0; // ge >= 0
  if delta[shuffle[v]] = 0 then
    exit;
  repeat
    xj := xj + delta[shuffle[v]];
    if zz then
    begin
      z1 := gc[0] * exp(ge[0] * lnt0) * exp(ge[1] * lnt1);
      z2 := gc[1] * exp(ge[2] * lnt0) * exp(ge[3] * lnt1);
    end;
    erroDepois2 := CalcularErro(false);
    if (erroDepois2 > erroDepois1) or (erroDepois2 = erroDepois1) and (abs(constante) < 1e120) then
    begin
      xj := xj - delta[shuffle[v]];
      if zz then
      begin
        z1 := gc[0] * exp(ge[0] * lnt0) * exp(ge[1] * lnt1);
        z2 := gc[1] * exp(ge[2] * lnt0) * exp(ge[3] * lnt1);
      end;
      break;
    end;
    inc(iteracoes);
    if erroDepois2 = erroDepois1 then
      break;
    erroDepois1 := erroDepois2;
  until iteracoes = 5;
end;

// de \ d cre index j
procedure TFormPrincipal.SetConstCRe(index, j: integer);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  CalcularErro(false);
  constante := 0;
  for i := 1 to 6 do
  begin
    if i = j then
      k := tt[index] * hyperg(a[3 * index], a[3 * index + 1], a[3 * index + 2], b[3 * index], b[3 * index + 1], b[3 * index + 2])
    else
      k := 0;
    ztemp.a := f[i].a * k; // p * dp\d cre j
    ztemp.b := 0;          // q * dq\d cre j
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

// de \ dcim index j
procedure TFormPrincipal.SetConstCIm(index, j: integer);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  CalcularErro(false);
  constante := 0;
  for i := 1 to 6 do
  begin
    if i = j then
      k := tt[index] * hyperg(a[3 * index], a[3 * index + 1], a[3 * index + 2], b[3 * index], b[3 * index + 1], b[3 * index + 2])
    else
      k := 0;
    ztemp.a := 0;          // p * dp\d cim j
    ztemp.b := f[i].b * k; // q * dq\d cim j
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

// de \ dgc n
procedure TFormPrincipal.SetConstGC(n: integer);
var
  i, j: integer;
  k: extended;
  ztemp: TComplex;
begin
  CalcularErro(false);
  constante := 0;
  for i := 1 to 6 do
    for j := 0 to 5 do
    begin
      k := tt[j] * dhdgcn(a[3 * j], a[3 * j + 1], a[3 * j + 2], b[3 * j], b[3 * j + 1], b[3 * j + 2], n);
      ztemp.a := f[i].a * cre[i-1,j] * k; // p * dp\dgc
      ztemp.b := f[i].b * cim[i-1,j] * k; // q * dq\dgc
      constante := constante + ztemp.a + ztemp.b;
    end;
end;

//*** de \ dge n
procedure TFormPrincipal.SetConstGE(n: integer);
var
  i, j: integer;
  k: extended;
  ztemp: TComplex;
begin
  CalcularErro(false);
  constante := 0;
  for i := 1 to 6 do
    for j := 0 to 5 do
    begin
      k := tt[j] * dhdgen(a[3 * j], a[3 * j + 1], a[3 * j + 2], b[3 * j], b[3 * j + 1], b[3 * j + 2], n);
      ztemp.a := f[i].a * cre[i-1,j] * k; // p * dp\dge
      ztemp.b := f[i].b * cim[i-1,j] * k; // q * dq\dge
      constante := constante + ztemp.a + ztemp.b;
    end;
end;

const
  points = 16;
  tinitial = 0.1;
  step = 2 * tinitial/points;

procedure TFormPrincipal.btnChecarClick(Sender: TObject);
begin
{
  t1[1] := - tinitial;
  while t1[1] < tinitial do
  begin
    t0[1] := - tinitial;
    while t0[1] < tinitial do
    begin

    //*** using the numbers found (by gradient method)
    //*** solve y^6 - y^2 + t1 * y + t0 = 0

      t0[1] := t0[1] + step;
    end;
    t1[1] := t1[1] + step;
  end;
}
end;

function TFormPrincipal.dhdgcn(a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
var
  termo: extended;
  i, j, k: integer;
begin
  result := 0;
  for j := 0 to 100 do
    for i := 0 to 100 do
      if (i <> 0) or (j <> 0) then // d const = 0
      begin
        termo := pow(z1, i)/fatorial(i);               // d z1 \ d gc0 = (cx)' = c  = z1/gc[0]
        termo := termo * pow(z2, j)/fatorial(j)/gc[n]; // z1 is constant in relation to gc1
        for k := 0 to 5 do
          termo := termo * PochHammer(a1[k], i + j)/PochHammer(b1[k], i + j);
        for k := 0 to 5 do
          termo := termo * PochHammer(a2[k], i)/PochHammer(b2[k], i);
        for k := 0 to 5 do
          termo := termo * PochHammer(a3[k], j)/PochHammer(b3[k], j);
        result := result + termo;
        if abs(termo) < 1e-11 then
          break;
      end;
end;

function TFormPrincipal.dhdgen(a1, a2, a3, b1, b2, b3: TVetorR; n: integer): extended;
var
  termo: extended;
  i, j, k: integer;
begin
  result := 0;
  for j := 0 to 100 do
    for i := 0 to 100 do
      if (i <> 0) or (j <> 0) then // d const = 0
      begin
        termo := pow(z1, i)/fatorial(i);                     // d z1^i \ d ge0 = (C t^x)^i' = (C t^x)^i i ln x = z1 * ln(ge[0]) * i
        termo := termo * pow(z2, j)/fatorial(j) * ln(ge[n]); // z1 is constant in relation to gc2 or gc3
        if n <= 1 then
          termo := termo * i
        else
          termo := termo * j;
        for k := 0 to 5 do
          termo := termo * PochHammer(a1[k], i + j)/PochHammer(b1[k], i + j);
        for k := 0 to 5 do
          termo := termo * PochHammer(a2[k], i)/PochHammer(b2[k], i);
        for k := 0 to 5 do
          termo := termo * PochHammer(a3[k], j)/PochHammer(b3[k], j);
        result := result + termo;
        if abs(termo) < 1e-11 then
          break;
      end;
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
  memo.lines.add('*** cancelled by the user. ***');
  btnExata.Enabled := true;
  btnGradiente.Enabled := true;
  btnChecar.Enabled := true;
end;

end.
