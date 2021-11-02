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
    btnCancel: TButton;
    procedure btnExataClick(Sender: TObject);
    procedure btnGradienteClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
  public
    cancelar: boolean;
    iteracoes: integer;
    constante, erroAtual, erroDepois1, erroDepois2, gc, ge, lnt, z: extended;
    t: array[0..3] of extended;
    delta: array[1..70] of extended;
    shuffle: array[1..70] of integer;
    f, y, yexato: array[1..5] of TComplex;
    a, b: array of TVetorR;
    c: array of TVetorC;
    function DeltaIsZero: boolean;
    procedure IncrementXJ(digit, v: integer; var xj: extended; zz: boolean = false);
    procedure SetConstAB(index, j: integer; ch: char);
    procedure SetConstCRe(index, j: integer);
    procedure SetConstCIm(index, j: integer);
    procedure SetConstGC;
    procedure SetConstGE;
    function root(a, b: array of TVetorR; c: array of TComplex): TComplex;
    function erroPolinomial(y: TComplex): TComplex;
    function erroAproximado(i: integer): TComplex;
    function hyperg(p, q: integer; a, b: TVetorR): extended;
    function dhdan(p, q: integer; a, b: TVetorR; n: integer): extended;
    function dhdbn(p, q: integer; a, b: TVetorR; n: integer): extended;
    function dhdgc(p, q: integer; a, b: TVetorR): extended;
    function dhdge(p, q: integer; a, b: TVetorR): extended;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

const
  GCExato = 3125/256;
  GEExato = 4;

function complexToStr(zz: TComplex): string;
begin
  if (zz.a = 0) and (zz.b = 0) then
  begin
    result := '0';
    exit;
  end;
  if zz.a <> 0 then
    result := floattostr(zz.a)
  else
    result := '';
  if zz.b = 1 then
    result := result + ' + i'
  else if zz.b = -1 then
    result := result + ' - i'
  else if zz.b < 0 then
    result := result + ' - ' + floattostr(-zz.b) + ' i'
  else if zz.b > 0 then
  begin
    if zz.a <> 0 then
      result := result + ' + ';
    result := result + floattostr(zz.b) + ' i';
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

function TFormPrincipal.hyperg(p, q: integer; a, b: TVetorR): extended;
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
    termo := termo * z / (i + 1); // factorial
    result := result + termo;
  end;
end;

function TFormPrincipal.dhdan(p, q: integer; a, b: TVetorR; n: integer): extended;
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
    termo := termo * z / (i + 1); // factorial
    for j := 0 to i do
      result := result + termo/(a[n] + j);
  end;
end;

function TFormPrincipal.dhdbn(p, q: integer; a, b: TVetorR; n: integer): extended;
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
    termo := termo * z / (i + 1) / sqr(b[n] + i); // factorial
    for j := 0 to i do
      result := result + termo/(b[n] + j);
  end;
end;

function TFormPrincipal.dhdgc(p, q: integer; a, b: TVetorR): extended;
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
    // k = i + 1 ; dz^k \ dgc = k * z^k / gc
    termo := termo * z / gc;
    result := result + termo;
  end;
end;

function TFormPrincipal.dhdge(p, q: integer; a, b: TVetorR): extended;
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
    // k = i + 1 ; dz^k \ dge = z^k * k * ln t
    termo := termo * z * lnt;
    result := result + termo;
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
  f[1] := hyperg(4, 3, a[0], b[0]);
  f[2] := t[1] * hyperg(4, 3, a[1], b[1]);
  f[3] := t[2] * hyperg(4, 3, a[2], b[2]);
  f[4] := t[3] * hyperg(4, 3, a[3], b[3]);
  result.a := c[0].a * f[1] + c[1].a * f[2] + c[2].a * f[3] + c[3].a * f[4];
  result.b := c[0].b * f[1] + c[1].b * f[2] + c[2].b * f[3] + c[3].b * f[4];
end;

function multiplica(zz, w: TComplex): TComplex; // (za + zb i)(wa + wb i)
begin
  result.a := zz.a * w.a - zz.b * w.b;
  result.b := zz.a * w.b + zz.b * w.a;
end;

function TFormPrincipal.erroPolinomial(y: TComplex): TComplex; // returns error = y^5 - y + t
var
  i: integer;
begin
  result := y;
  for i := 1 to 4 do
    result := multiplica(result, y);

  result.a := result.a - y.a + t[1];
  result.b := result.b - y.b;
end;

function TFormPrincipal.erroAproximado(i: integer): TComplex; // returns error = y - yexact
begin
  result.a := y[i].a - yexato[i].a;
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
  i: integer;
  erro: extended;
begin
  t[0] := 1;
  t[1] := 0.09;
  t[2] := sqr(t[1]);
  t[3] := t[1] * t[2];
  gc := GCExato;
  ge := GEExato;
  lnt := ln(t[1]);
  z := gc * exp(ge * lnt);
  erro := 0;
  for i := 1 to 5 do
  begin
    yexato[i] := root([aexato(1), aexato(2), aexato(3), aexato(4)], [bexato(1), bexato(2), bexato(3), bexato(4)], [cjexato(1,i), cjexato(2,i), cjexato(3,i), cjexato(4,i)]);
    f[i] := erroPolinomial(yexato[i]);
    erro := erro + sqr(f[i].a) + sqr(f[i].b);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(yexato[i]) + ' ; error = ' + complextostr(f[i]));
  end;
  memo.lines.add('Square root of quadratic error = ' + floattostr(sqrt(erro)));
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
  s: string;
begin
  btnExataClick(Sender); // initialize yexact
  btnExata.Enabled := false;
  btnGradiente.Enabled := false;
  cancelar := false;
{
  Gradient Method
  (f_1, ..., f10) = 0
  e = 0.5 ||f||^2;
  for j := 1 to 10 do
  begin
    x_j := aleatorio(3); // 3 digits
    delta_j := 7;
  end;
  for épocas := 1 to 50 do
    for j := 1 to 10 do
    begin
      const := de\dx_j;
      delta_j := ajuste(const, 3); // to decide whether we gonna walk 0 or ± 0.001
      x_j := x_j + delta_j;
      if \vec delta = 0 then break;
    end;
  more epochs for 4th digit;
  more epochs for 5th digit;
  more epochs for 6th digit;
  more epochs for 7th digit;
  7 is good.
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
    SetB(b[i], i); // try to copy that line here for you to see the compiler error: internal error X865
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
    c[i,0].a := aleatorio(3);
    c[i,1].a := aleatorio(3);
    c[i,2].a := aleatorio(3);
    c[i,3].a := aleatorio(3);
  end;
  for i := 0 to 0 do
  begin
    //c[i,0].b := aleatorio(3);
    //c[i,1].b := aleatorio(3);
    //c[i,2].b := aleatorio(3);
    //c[i,3].b := aleatorio(3);
  end;

  //gc := aleatorio(3);
  //ge := aleatorio(3);
  //z := gc * exp(ge * lnt);

  erroAtual := 0;
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
    erroAtual := erroAtual + sqr(f[i].a) + sqr(f[i].b);
  end; // we have initialized erroAtual (current error, not actual error)

  for digit := 0 to 6 do
    for epoca := 1 to 5000 do
    begin
      for v := 1 to 70 do
      begin
        delta[v] := 7;
        shuffle[v] := v;
      end;
      for v := 1 to 1000 do // one thousand shufflings
      begin
        i := random(70) + 1;
        j := random(70) + 1;
        xchg(shuffle[i], shuffle[j]);
      end;

      for v := 1 to 70 do // a1[4]..a4[4]  b1[3]...b4[3] c1re[5]..c4re[5] c1im[5]..c4im[5] gc ge
      begin
        iteracoes := 0;
        if shuffle[v] <= 4 then
        begin
          j := shuffle[v] - 1; // de \ da1 j
          SetConstAB(0, j, 'a');
          IncrementXJ(digit, v, a[0,j]);
        end
        else if shuffle[v] <= 4 * 2 then
        begin
          j := shuffle[v] - 4 - 1; // de \ da2 j
          SetConstAB(1, j, 'a');
          IncrementXJ(digit, v, a[1,j]);
        end
        else if shuffle[v] <= 4 * 3 then
        begin
          j := shuffle[v] - 4 * 2 - 1; // de \ da3 j
          SetConstAB(2, j, 'a');
          IncrementXJ(digit, v, a[2,j]);
        end
        else if shuffle[v] <= 4 * 4 then
        begin
          j := shuffle[v] - 4 * 3 - 1; // de \ da4 j
          SetConstAB(3, j, 'a');
          IncrementXJ(digit, v, a[3,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 then
        begin
          j := shuffle[v] - 4 * 4 - 1; // de \ db1 j
          SetConstAB(0, j, 'b');
          IncrementXJ(digit, v, b[0,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 - 1; // de \ db2 j
          SetConstAB(1, j, 'b');
          IncrementXJ(digit, v, b[1,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 2 - 1; // de \ db3 j
          SetConstAB(2, j, 'b');
          IncrementXJ(digit, v, b[2,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 3 - 1; // de \ db4 j
          SetConstAB(3, j, 'b');
          IncrementXJ(digit, v, b[3,j]);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 1; // de \ dc1re j
          SetConstCRe(0, j);
          IncrementXJ(digit, v, c[j,0].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 - 1; // de \ dc2re j
          SetConstCRe(1, j);
          IncrementXJ(digit, v, c[j,1].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 2 - 1; // de \ dc3re j
          SetConstCRe(2, j);
          IncrementXJ(digit, v, c[j,2].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 3 - 1; // de \ dc4re j
          SetConstCRe(3, j);
          IncrementXJ(digit, v, c[j,3].a);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 1; // de \ dcim1 j
          SetConstCIm(0, j);
          IncrementXJ(digit, v, c[j,0].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 2 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 - 1; // de \ dcim2 j
          SetConstCIm(1, j);
          IncrementXJ(digit, v, c[j,1].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 3 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 * 2 - 1; // de \ dcim3 j
          SetConstCIm(2, j);
          IncrementXJ(digit, v, c[j,2].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 then
        begin
          j := shuffle[v] - 4 * 4 - 3 * 4 - 5 * 4 - 5 * 3 - 1; // de \ dcim4 j
          SetConstCIm(3, j);
          IncrementXJ(digit, v, c[j,3].b);
        end
        else if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 + 1 then
        begin
          SetConstGC;
          IncrementXJ(digit, v, gc, true);
        end
        else // if shuffle[v] <= 4 * 4 + 3 * 4 + 5 * 4 + 5 * 4 + 2 then
        begin
          SetConstGE;
          IncrementXJ(digit, v, ge, true);
        end;
        delta[shuffle[v]] := delta[shuffle[v]] * iteracoes;
        if erroDepois1 < erroAtual then
        begin
          if (v = 1) and (epoca mod 10 = 0) then
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
    f[i] := erroAproximado(i);
    k := k + sqr(f[i].a) + sqr(f[i].b);
    memo.lines.add('y_' + inttostr(i) + '(t) = ' + complextostr(y[i]) + ' ; error = ' + complextostr(f[i]));
  end;
  memo.lines.add('gc = ' + floattostr(gc) + ' ; ge = ' + floattostr(ge) + ' ; Square root of quadratic error = ' + floattostr(sqrt(k)));
  btnExata.Enabled := true;
  btnGradiente.Enabled := true;
end;

function TFormPrincipal.DeltaIsZero: boolean;
var v: integer;
begin
  result := true;
  for v := 1 to 70 do
    if delta[v] <> 0 then
    begin
      result := false;
      exit;
    end;
end;

// de \ daindex j
// de \ dbindex j
// when deriving in relation to some a or b, we always have one only term.
procedure TFormPrincipal.SetConstAB(index, j: integer; ch: char);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if ch = 'b' then
      k := t[index] * dhdbn(4, 3, a[index], b[index], j)
    else // 'a'
      k := t[index] * dhdan(4, 3, a[index], b[index], j);
    ztemp.a := f[i].a * c[i-1,index].a * k; // p * dp\daj
    ztemp.b := f[i].b * c[i-1,index].b * k; // q * dq\daj
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

procedure TFormPrincipal.IncrementXJ(digit, v: integer; var xj: extended; zz: boolean = false);
var i: integer;
begin
  erroDepois1 := erroAtual;
  delta[shuffle[v]] := ajuste(constante, digit);
  if delta[shuffle[v]] = 0 then
    exit;
  repeat
    xj := xj + delta[shuffle[v]];
    if zz then
      z := gc * exp(ge * lnt);
    erroDepois2 := 0;
    for i := 1 to 5 do
    begin
      y[i] := root(a, b, c[i-1]);
      f[i] := erroAproximado(i);
      erroDepois2 := erroDepois2 + sqr(f[i].a) + sqr(f[i].b);
    end;
    if (erroDepois2 > erroDepois1) or (erroDepois2 = erroDepois1) and (abs(constante) < 1e120) then
    begin
      xj := xj - delta[shuffle[v]];
      if zz then
        z := gc * exp(ge * lnt);
      break;
    end;
    inc(iteracoes);
    if erroDepois2 = erroDepois1 then
      break;
    erroDepois1 := erroDepois2;
  until iteracoes = 5;
end;

// de \ d cre index j
// when deriving f_i, we always get zero if i <> j.
// if i = j, then it will remain one only term for derivating: d (cf) \ dc
procedure TFormPrincipal.SetConstCRe(index, j: integer);
var
  i: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if i = j then
      k := t[index] * hyperg(4, 3, a[index], b[index]) // dp \ d cre index j
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
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
  end;
  constante := 0;
  for i := 1 to 5 do
  begin
    if i = j then
      k := t[index] * hyperg(4, 3, a[index], b[index]) // dq \ dcim index j
    else
      k := 0;
    ztemp.a := 0;          // p * dp\d cim j
    ztemp.b := f[i].b * k; // q * dq\d cim j
    constante := constante + ztemp.a + ztemp.b;
  end;
end;

// de \ dgc
procedure TFormPrincipal.SetConstGC;
var
  i, j: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
  end;
  constante := 0;
  for i := 1 to 5 do
    for j := 0 to 3 do
    begin
      k := t[j] * dhdgc(4, 3, a[j], b[j]);
      ztemp.a := f[i].a * c[i-1,j].a * k; // p * dp\dgc
      ztemp.b := f[i].b * c[i-1,j].b * k; // q * dq\dgc
      constante := constante + ztemp.a + ztemp.b;
    end;
end;

// de \ dge
procedure TFormPrincipal.SetConstGE;
var
  i, j: integer;
  k: extended;
  ztemp: TComplex;
begin
  for i := 1 to 5 do
  begin
    y[i] := root(a, b, c[i-1]);
    f[i] := erroAproximado(i);
  end;
  constante := 0;
  for i := 1 to 5 do
    for j := 0 to 3 do
    begin
      k := t[j] * dhdge(4, 3, a[j], b[j]);
      ztemp.a := f[i].a * c[i-1,j].a * k; // p * dp\dge
      ztemp.b := f[i].b * c[i-1,j].b * k; // q * dq\dge
      constante := constante + ztemp.a + ztemp.b;
    end;
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
  memo.lines.add('=== cancelled by the user. ===');
  btnExata.Enabled := true;
  btnGradiente.Enabled := true;
end;

end.
