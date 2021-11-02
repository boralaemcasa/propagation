unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TMatriz = array[1..5, 1..5] of double;
  TVetor = array[1..5] of double;

  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    btnSchmidt: TButton;
    btnRefletores: TButton;
    btnPotencia: TButton;
    btnSVD: TButton;
    Memo: TMemo;
    sg: TStringGrid;
    combo: TComboBox;
    procedure btnSchmidtClick(Sender: TObject);
    procedure btnRefletoresClick(Sender: TObject);
    procedure btnPotenciaClick(Sender: TObject);
    procedure btnSVDClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function PowerMethod(A: TMatriz; n: integer): TMatriz;
  public
    lambda: TVetor;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

function floatyToStr(x: double): string; overload;
begin
  if x < 1E9 then
    x := round(x * 1E9) / 1E9;
  result := floattostr(x);
end;

function floatytoStr(V: TVetor; n: integer): string; overload;
var i: integer;
begin
  result := '';
  for i := 1 to n - 1 do
    result := result + floatyToStr(v[i]) + ' ; ';
  result := result + floatyToStr(v[n]);
end;

function MatrixMult(A, B: TMatriz; n: integer): TMatriz;
var i, j, k: integer;
begin
  for i := 1 to n do
    for j := 1 to n do
      result[i, j] := 0;

  for i := 1 to n do
    for j := 1 to n do
      for k := 1 to n do
        result[i, j] := result[i, j] + A[i, k] * B[k, j];
end;

function MatrixTimesVec(A: TMatriz; B: TVetor; n: integer): TVetor;
var i, k: integer;
begin
  for i := 1 to n do
    result[i] := 0;

  for i := 1 to n do
    for k := 1 to n do
      result[i] := result[i] + A[i, k] * B[k];
end;

function coluna(M: TMatriz; j: integer): TVetor;
var i: integer;
begin
  for i := 1 to 5 do
    result[i] := M[i, j];
end;

function norma(V: TVetor; n: integer): double;
var a, b, c, d, e: double;
begin
  a := v[1];
  b := v[2];
  c := v[3];
  d := v[4];
  e := v[5];

  if n = 2 then
    result := sqrt(a * a + b * b)
  else if n = 3 then
    result := sqrt(a * a + b * b + c * c)
  else if n = 4 then
    result := sqrt(a * a + b * b + c * c + d * d)
  else
    result := sqrt(a * a + b * b + c * c + d * d + e * e);
end;

function produtoInterno(V, W: TVetor; n: integer): double;
var a, b, c, d, e,
  a2, b2, c2, d2, e2: double;
begin
  a := v[1]; a2 := w[1];
  b := v[2]; b2 := w[2];
  c := v[3]; c2 := w[3];
  d := v[4]; d2 := w[4];
  e := v[5]; e2 := w[5];

  if n = 2 then
    result := a * a2 + b * b2
  else if n = 3 then
    result := a * a2 + b * b2 + c * c2
  else if n = 4 then
    result := a * a2 + b * b2 + c * c2 + d * d2
  else
    result := a * a2 + b * b2 + c * c2 + d * d2 + e * e2;
end;

function transposta(A: TMatriz; n: integer): TMatriz;
var i, j: integer;
begin
  for i := 1 to n do
    for j := 1 to n do
      result[i, j] := A[j, i];
end;

function sgn(x: double): double;
begin
  if x = 0 then
    result := 0
  else
    result := x / abs(x);
end;

function det22(a, b, c, d: double): double;
begin
  result := a * d - b * c;
end;

// a d g a d
// b e h b e
// c f i c f

function det33(a, b, c, d, e, f, g, h, i: double): double;
begin
  result := a * e * i + d * h * c + g * b * f
    - d * b * i - a * h * f - g * e * c;
end;

// a e i m
// b f j n
// c g k o
// d h l p

function det44(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p: double): double;
begin
  result := +a * det33(f, g, h, j, k, l, n, o, p)
    - e * det33(b, c, d, j, k, l, n, o, p)
    + i * det33(b, c, d, f, g, h, n, o, p)
    - m * det33(b, c, d, f, g, h, j, k, l);
end;

// a f k p u
// b g l q v
// c h m r w
// d i n s x
// e j o t y

function det55(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y: double): double;
begin
  result := +a * det44(g, h, i, j, l, m, n, o, q, r, s, t, v, w, x, y)
    - f * det44(b, c, d, e, l, m, n, o, q, r, s, t, v, w, x, y)
    + k * det44(b, c, d, e, g, h, i, j, q, r, s, t, v, w, x, y)
    - p * det44(b, c, d, e, g, h, i, j, l, m, n, o, v, w, x, y)
    + u * det44(b, c, d, e, g, h, i, j, l, m, n, o, q, r, s, t);
end;

function SomaVetor(V, W: TVetor): TVetor;
var i: integer;
begin
  for i := 1 to 5 do
    result[i] := v[i] + w[i];
end;

function KVetor(k: double; V: TVetor): TVetor;
var i: integer;
begin
  for i := 1 to 5 do
    result[i] := k * v[i];
end;

procedure TFormPrincipal.btnSchmidtClick(Sender: TObject);
var V, Q, R: TMatriz;
  i, j: integer;
  s: string;
begin
  V[1, 1] := 1;
  V[2, 1] := 2;
  V[3, 1] := 3;
  V[4, 1] := 4;
  V[5, 1] := 5;
  V[2, 2] := 6;
  V[3, 2] := 7;
  V[4, 2] := 8;
  V[5, 2] := 9;
  V[3, 3] := 10;
  V[4, 3] := 11;
  V[5, 3] := 12;
  V[4, 4] := 13;
  V[5, 4] := 14;
  V[5, 5] := 15;
  for i := 1 to 5 do
    for j := i + 1 to 5 do
      V[i, j] := V[j, i];
{
  for i := 2 to 5 do
    for j := 7 - i to 5 do
      V[i,j] := 0;
}
  s := 'V'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(V[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  for i := 1 to 5 do
    for j := i + 1 to 5 do
      R[j, i] := 0;

  R[1, 1] := norma(Coluna(V, 1), 5);
  for i := 1 to 5 do
    Q[i, 1] := V[i, 1] / R[1, 1];

  R[1, 2] := ProdutoInterno(coluna(v, 2),
    coluna(q, 1), 5);

  for i := 1 to 5 do
    Q[i, 2] := V[i, 2] - R[1, 2] * Q[i, 1];

  R[2, 2] := norma(Coluna(q, 2), 5);
  for i := 1 to 5 do
    Q[i, 2] := Q[i, 2] / R[2, 2];

  for i := 1 to 2 do
    R[i, 3] := ProdutoInterno(coluna(v, 3),
      coluna(q, i), 5);

  for i := 1 to 5 do
    Q[i, 3] := V[i, 3] - R[1, 3] * Q[i, 1] - R[2, 3] * Q[i, 2];

  R[3, 3] := norma(Coluna(q, 3), 5);
  for i := 1 to 5 do
    Q[i, 3] := Q[i, 3] / R[3, 3];

  for i := 1 to 3 do
    R[i, 4] := ProdutoInterno(coluna(v, 4),
      coluna(q, i), 5);

  for i := 1 to 5 do
    Q[i, 4] := V[i, 4] - R[1, 4] * Q[i, 1] - R[2, 4] * Q[i, 2] - R[3, 4] * Q[i, 3];

  R[4, 4] := norma(Coluna(q, 4), 5);
  for i := 1 to 5 do
    Q[i, 4] := Q[i, 4] / R[4, 4];

  for i := 1 to 4 do
    R[i, 5] := ProdutoInterno(coluna(v, 5),
      coluna(q, i), 5);

  for i := 1 to 5 do
    Q[i, 5] := V[i, 5] - R[1, 5] * Q[i, 1] - R[2, 5] * Q[i, 2] - R[3, 5] * Q[i, 3] - R[4, 5] * Q[i, 4];

  R[5, 5] := norma(Coluna(q, 5), 5);
  for i := 1 to 5 do
    Q[i, 5] := Q[i, 5] / R[5, 5];

  s := s + #13#10 + 'Q'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(Q[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  s := s + #13#10 + 'R'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(R[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  V := MatrixMult(Q, R, 5);

  s := s + #13#10 + 'QR'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(V[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  Q := MatrixMult(Q, Transposta(Q, 5), 5);

  s := s + #13#10 + 'Q Q^T'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(Q[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);
end;

procedure TFormPrincipal.btnRefletoresClick(Sender: TObject);
var A, Q1, Q2, Q3, Q4, R, q: TMatriz;
  i, j: integer;
  s: string;
  tau, gamma: double;
  u, w: TVetor;
begin
  A[1, 1] := 1;
  A[2, 1] := 2;
  A[3, 1] := 3;
  A[4, 1] := 4;
  A[5, 1] := 5;
  A[2, 2] := 6;
  A[3, 2] := 7;
  A[4, 2] := 8;
  A[5, 2] := 9;
  A[3, 3] := 10;
  A[4, 3] := 11;
  A[5, 3] := 12;
  A[4, 4] := 13;
  A[5, 4] := 14;
  A[5, 5] := 15;
  for i := 1 to 5 do
    for j := i + 1 to 5 do
      A[i, j] := A[j, i];

  s := 'A'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(A[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  tau := norma(Coluna(A, 1), 5) * sgn(A[1, 1]);
  u[1] := A[1, 1] + tau;
  for i := 2 to 5 do
    u[i] := A[i, 1] / u[1];
  u[1] := 1;

  gamma := 2 / produtoInterno(u,
    u, 5);

  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      Q1[i, j] := -gamma * u[i] * u[j];

    Q1[i, i] := Q1[i, i] + 1;
  end;

  R := MatrixMult(Q1, A, 5);

  w := coluna(R, 2);
  w[1] := 0;
  tau := norma(w, 5) * sgn(R[2, 2]);
  u[2] := R[2, 2] + tau;
  for i := 3 to 5 do
    u[i] := R[i, 2] / u[2];
  u[2] := 1;
  u[1] := 0;

  gamma := 2 / produtoInterno(u,
    u, 5);

  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      Q2[i, j] := -gamma * u[i] * u[j];

    Q2[i, i] := Q2[i, i] + 1;
  end;

  R := MatrixMult(Q2, Q1, 5);
  R := MatrixMult(R, A, 5);

  w := coluna(R, 3);
  w[1] := 0;
  w[2] := 0;
  tau := norma(w, 5) * sgn(R[3, 3]);
  u[3] := R[3, 3] + tau;
  for i := 4 to 5 do
    u[i] := R[i, 3] / u[3];
  u[3] := 1;
  u[2] := 0;
  u[1] := 0;

  gamma := 2 / produtoInterno(u,
    u, 5);

  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      Q3[i, j] := -gamma * u[i] * u[j];

    Q3[i, i] := Q3[i, i] + 1;
  end;

  R := MatrixMult(Q3, Q2, 5);
  R := MatrixMult(R, Q1, 5);
  R := MatrixMult(R, A, 5);

  w := coluna(R, 4);
  w[1] := 0;
  w[2] := 0;
  w[3] := 0;
  tau := norma(w, 5) * sgn(R[4, 4]);
  u[4] := R[4, 4] + tau;
  u[5] := R[5, 4] / u[4];
  u[4] := 1;
  u[3] := 0;
  u[2] := 0;
  u[1] := 0;

  gamma := 2 / produtoInterno(u,
    u, 5);

  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      Q4[i, j] := -gamma * u[i] * u[j];

    Q4[i, i] := Q4[i, i] + 1;
  end;

  Q := MatrixMult(Q1, Q2, 5);
  Q := MatrixMult(Q, Q3, 5);
  Q := MatrixMult(Q, Q4, 5);

  s := s + #13#10 + 'Q = Q1 Q2 Q3 Q4'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(Q[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  R := MatrixMult(Q4, Q3, 5);
  R := MatrixMult(R, Q2, 5);
  R := MatrixMult(R, Q1, 5);
  R := MatrixMult(R, A, 5);

  s := s + #13#10 + 'R = Q^T A = Q4 Q3 Q2 Q1 A'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(R[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  R := MatrixMult(Q, R, 5);

  s := s + #13#10 + 'QR'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(R[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);

  Q := MatrixMult(Q, Transposta(Q, 5), 5);

  s := s + #13#10 + 'Q Q^T'#13#10#13#10;
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      s := s + floatyToStr(Q[i, j]) + ' ';
    s := s + #13#10;
  end;

  showmessage(s);
end;

const erro = 1E-9;

function TFormPrincipal.PowerMethod(A: TMatriz; n: integer): TMatriz;
var q, qlinha, v1, v2, v3, v4, v5, w: TVetor;
  x, xant: double;
  s: string;
  i, j, k: integer;
begin
  for i := n + 1 to 5 do
    for j := n + 1 to 5 do
      A[i, j] := 0;

  s := 'A'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(A[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  for k := 1 to n do
  begin
    q[1] := random;
    q[2] := random;
    q[3] := random;
    q[4] := random;
    q[5] := random;

    for i := n + 1 to 5 do
      q[i] := 0;

    if k = 2 then
    begin
      x := produtointerno(q, v1, n) / sqr(norma(v1, n));
      q := SomaVetor(q, KVetor(-x, v1));
    end;
    if k = 3 then
      if n = 3 then
      begin
        q[1] := det22(v1[2], v2[2], v1[3], v2[3]);
        q[2] := -det22(v1[1], v2[1], v1[3], v2[3]);
        q[3] := det22(v1[1], v2[1], v1[2], v2[2]);
        //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
        //q := KVetor(x, w);
      end
      else if n = 4 then
      begin
        v3[1] := random;
        v3[2] := random;
        x := det22(v1[3], v2[3], v1[4], v2[4]);
        v3[3] := det22(-v1[1] * v3[1] - v1[2] * v3[2], -v2[1] * v3[1] - v2[2] * v3[2], v1[4], v2[4]) / x;
        v3[4] := det22(v1[3], v2[3], -v1[1] * v3[1] - v1[2] * v3[2], -v2[1] * v3[1] - v2[2] * v3[2]) / x;
        x := norma(v3, n);
        v3 := KVetor(1 / x, v3);

        v4[1] := det33(v1[2], v2[2], v3[2], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
        v4[2] := -det33(v1[1], v2[1], v3[1], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
        v4[3] := det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[4], v2[4], v3[4]);
        v4[4] := -det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[3], v2[3], v3[3]);
        x := norma(v4, n);
        v4 := KVetor(1 / x, v4);

        x := det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1);

        q := SomaVetor(KVetor(det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1
          ) / x, v3), KVetor(det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n)
          ) / x, v4));
      end
      else
      begin
        v3[1] := random;
        v3[2] := random;
        v3[3] := random;
        x := det22(v1[4], v2[4], v1[5], v2[5]);
        v3[4] := det22(-v1[1] * v3[1] - v1[2] * v3[2] - v1[3] * v3[3], -v2[1] * v3[1] - v2[2] * v3[2] - v2[3] * v3[3], v1[5], v2[5]) / x;
        v3[5] := det22(v1[4], v2[4], -v1[1] * v3[1] - v1[2] * v3[2] - v1[3] * v3[3], -v2[1] * v3[1] - v2[2] * v3[2] - v2[3] * v3[3]) / x;
        x := norma(v3, n);
        v3 := KVetor(1 / x, v3);

        v4[1] := random;
        v4[2] := random;
        x := det33(v1[3], v2[3], v3[3],
          v1[4], v2[4], v3[4],
          v1[5], v2[5], v3[5]);
        v4[3] := det33(-v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2],
          v1[4], v2[4], v3[4],
          v1[5], v2[5], v3[5]) / x;
        v4[4] := det33(v1[3], v2[3], v3[3],
          -v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2],
          v1[5], v2[5], v3[5]) / x;
        v4[5] := det33(v1[3], v2[3], v3[3],
          v1[4], v2[4], v3[4],
          -v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2]) / x;
        x := norma(v4, n);
        v4 := KVetor(1 / x, v4);

        v5[1] := det44(v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[2] := -det44(v1[1], v2[1], v3[1], v4[1], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[3] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[4] := -det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[5], v2[5], v3[5], v4[5]);
        v5[5] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4]);
        x := norma(v5, n);
        v5 := KVetor(1 / x, v5);

        x := det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
          produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1);

        q := SomaVetor(SomaVetor(
          KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
          produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
          ) / x, v3),
          KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
          produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
          ) / x, v4)),
          KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n)
          ) / x, v5));
      end;
    if k = 4 then
      if n = 4 then
      begin
        q[1] := det33(v1[2], v2[2], v3[2], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
        q[2] := -det33(v1[1], v2[1], v3[1], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
        q[3] := det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[4], v2[4], v3[4]);
        q[4] := -det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[3], v2[3], v3[3]);
      //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
      //q := KVetor(x, w);
      end
      else
      begin
        v4[1] := random;
        v4[2] := random;
        x := det33(v1[3], v2[3], v3[3],
          v1[4], v2[4], v3[4],
          v1[5], v2[5], v3[5]);
        v4[3] := det33(-v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2],
          v1[4], v2[4], v3[4],
          v1[5], v2[5], v3[5]) / x;
        v4[4] := det33(v1[3], v2[3], v3[3],
          -v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2],
          v1[5], v2[5], v3[5]) / x;
        v4[5] := det33(v1[3], v2[3], v3[3],
          v1[4], v2[4], v3[4],
          -v1[1] * v4[1] - v1[2] * v4[2], -v2[1] * v4[1] - v2[2] * v4[2], -v3[1] * v4[1] - v3[2] * v4[2], ) / x;
        x := norma(v4, n);
        v4 := KVetor(1 / x, v4);

        v5[1] := det44(v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[2] := -det44(v1[1], v2[1], v3[1], v4[1], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[3] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        v5[4] := -det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[5], v2[5], v3[5], v4[5]);
        v5[5] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4]);
        x := norma(v5, n);
        v5 := KVetor(1 / x, v5);

        x := det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
          produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1);

        q := SomaVetor(KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
          produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
          ) / x, v4), KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
          produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
          produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
          produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
          produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n)
          ) / x, v5));
      end;
    if k = 5 then
    begin
      q[1] := det44(v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
      q[2] := -det44(v1[1], v2[1], v3[1], v4[1], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
      q[3] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
      q[4] := -det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[5], v2[5], v3[5], v4[5]);
      q[5] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4]);
      //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
      //q := KVetor(x, w);
    end;

    if k >= 2 then
    begin
      for i := n + 1 to 5 do
        q[i] := 0;

      x := norma(q, n);
      if q[1] < 0 then x := -x;

      q := KVetor(1 / x, q);
    end;

    xant := q[n];
    repeat
      q := MatrixTimesVec(A, q, n);

      if k = 2 then
      begin
        x := produtointerno(q, v1, n) / sqr(norma(v1, n));
        q := SomaVetor(q, KVetor(-x, v1));
      end;
      if k = 3 then
        if n = 3 then
        begin
          q[1] := det22(v1[2], v2[2], v1[3], v2[3]);
          q[2] := -det22(v1[1], v2[1], v1[3], v2[3]);
          q[3] := det22(v1[1], v2[1], v1[2], v2[2]);
        //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
        //q := KVetor(x, w);
        end
        else if n = 4 then
        begin
          x := det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1);

          q := SomaVetor(KVetor(det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1
            ) / x, v3), KVetor(det44(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n)
            ) / x, v4));
        end
        else
        begin
          x := det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
            produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1);

          q := SomaVetor(SomaVetor(
            KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
            produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
            ) / x, v3),
            KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
            produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
            ) / x, v4)),
            KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n)
            ) / x, v5));
        end;
      if k = 4 then
        if n = 4 then
        begin
          q[1] := det33(v1[2], v2[2], v3[2], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
          q[2] := -det33(v1[1], v2[1], v3[1], v1[3], v2[3], v3[3], v1[4], v2[4], v3[4]);
          q[3] := det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[4], v2[4], v3[4]);
          q[4] := -det33(v1[1], v2[1], v3[1], v1[2], v2[2], v3[2], v1[3], v2[3], v3[3]);
      //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
      //q := KVetor(x, w);
        end
        else
        begin
          x := det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
            produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1);

          q := SomaVetor(KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n),
            produtointerno(v1, v5, n), produtointerno(v2, v5, n), produtointerno(v3, v5, n), produtointerno(v4, v5, n), 1
            ) / x, v4), KVetor(det55(1, produtointerno(v1, v2, n), produtointerno(v1, v3, n), produtointerno(v1, v4, n), produtointerno(v1, v5, n),
            produtointerno(v1, v2, n), 1, produtointerno(v2, v3, n), produtointerno(v2, v4, n), produtointerno(v2, v5, n),
            produtointerno(v1, v3, n), produtointerno(v2, v3, n), 1, produtointerno(v3, v4, n), produtointerno(v3, v5, n),
            produtointerno(v1, v4, n), produtointerno(v2, v4, n), produtointerno(v3, v4, n), 1, produtointerno(v4, v5, n),
            produtointerno(v1, q, n), produtointerno(v2, q, n), produtointerno(v3, q, n), produtointerno(v4, q, n), produtointerno(v5, q, n)
            ) / x, v5));
        end;
      if k = 5 then
      begin
        q[1] := det44(v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        q[2] := -det44(v1[1], v2[1], v3[1], v4[1], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        q[3] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[4], v2[4], v3[4], v4[4], v1[5], v2[5], v3[5], v4[5]);
        q[4] := -det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[5], v2[5], v3[5], v4[5]);
        q[5] := det44(v1[1], v2[1], v3[1], v4[1], v1[2], v2[2], v3[2], v4[2], v1[3], v2[3], v3[3], v4[3], v1[4], v2[4], v3[4], v4[4]);
      //x := produtointerno(q, v1, n) / produtointerno(w, v1, n);
      //q := KVetor(x, w);
      end;

      for i := n + 1 to 5 do
        q[i] := 0;

      x := norma(q, n);
      if q[1] < 0 then x := -x;

      q := KVetor(1 / x, q);

      x := q[n];
      if abs(x - xant) < erro then
        break;
      xant := x;
    until false;

    qlinha := MatrixTimesVec(A, q, n);
    x := produtointerno(q, qlinha, n) / sqr(norma(q, n));
    lambda[k] := x;
    x := 1;

    if k = 1 then
    begin
      v1 := q;

      for i := n + 1 to 5 do
        v1[i] := 0;
    end
    else if k >= 2 then
    begin
      q[1] := 1;
// a' d g                          a' e i m      a' f  k  p  u
// b e' h   ou  a'x + cy = 0  ou   b f' j n  ou  b  g' l  q  v
// c f i'       b     d'           c g k' o      c  h  m' r  w
//                                 d h l p'      d  i  n  s' x
//                                               e  j  o  t  y'
      if n = 2 then
        q[2] := (-A[1, 1] + lambda[k]) * q[1] / A[1, 2]
      else if n = 3 then
      begin
        x := det22(A[2, 2] - lambda[k],
          A[3, 2],
          A[2, 3],
          A[3, 3] - lambda[k]);
        q[2] := det22(-A[2, 1] * q[1],
          -A[3, 1] * q[1],
          A[2, 3],
          A[3, 3] - lambda[k]) / x;
        q[3] := det22(A[2, 2] - lambda[k],
          A[3, 2],
          -A[2, 1] * q[1],
          -A[3, 1] * q[1]) / x;

      end
      else if n = 4 then
      begin
        x := det33(A[2, 2] - lambda[k], A[3, 2], A[4, 2],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k]);
        q[2] := det33(-A[2, 1], -A[3, 1], -A[4, 1],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k]) / x;
        q[3] := det33(A[2, 2] - lambda[k], A[3, 2], A[4, 2],
          -A[2, 1], -A[3, 1], -A[4, 1],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k]) / x;
        q[4] := det33(A[2, 2] - lambda[k], A[3, 2], A[4, 2],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3],
          -A[2, 1], -A[3, 1], -A[4, 1]) / x;
      end
      else
      begin
        x := det44(A[2, 2] - lambda[k], A[3, 2], A[4, 2], A[5, 2],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3], A[5, 3],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k], A[5, 4],
          A[2, 5], A[3, 5], A[4, 5], A[5, 5] - lambda[k]);
        q[2] := det44(-A[2, 1], -A[3, 1], -A[4, 1], -A[5, 1],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3], A[5, 3],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k], A[5, 4],
          A[2, 5], A[3, 5], A[4, 5], A[5, 5] - lambda[k]) / x;
        q[3] := det44(A[2, 2] - lambda[k], A[3, 2], A[4, 2], A[5, 2],
          -A[2, 1], -A[3, 1], -A[4, 1], -A[5, 1],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k], A[5, 4],
          A[2, 5], A[3, 5], A[4, 5], A[5, 5] - lambda[k]) / x;
        q[4] := det44(A[2, 2] - lambda[k], A[3, 2], A[4, 2], A[5, 2],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3], A[5, 3],
          -A[2, 1], -A[3, 1], -A[4, 1], -A[5, 1],
          A[2, 5], A[3, 5], A[4, 5], A[5, 5] - lambda[k]) / x;
        q[5] := det44(A[2, 2] - lambda[k], A[3, 2], A[4, 2], A[5, 2],
          A[2, 3], A[3, 3] - lambda[k], A[4, 3], A[5, 3],
          A[2, 4], A[3, 4], A[4, 4] - lambda[k], A[5, 4],
          -A[2, 1], -A[3, 1], -A[4, 1], -A[5, 1]) / x;
      end;

      x := norma(q, n);
      if q[1] < 0 then x := -x;
    end;

    if k = 2 then
    begin
      v2 := KVetor(1 / x, q);
      for i := n + 1 to 5 do
        v2[i] := 0;
    end
    else if k = 3 then
    begin
      v3 := KVetor(1 / x, q);
      for i := n + 1 to 5 do
        v3[i] := 0;
    end
    else if k = 4 then
    begin
      v4 := KVetor(1 / x, q);
      for i := n + 1 to 5 do
        v4[i] := 0;
    end
    else
    begin
      v5 := KVetor(1 / x, q);
      for i := n + 1 to 5 do
        v5[i] := 0;
    end;

    if k = 1 then
      memo.Lines.add(floatyToStr(v1, n) + #13#10'lambda 1 = ' + floatyToStr(lambda[1]))
    else if k = 2 then
      memo.Lines.add(floatyToStr(v2, n) + #13#10'lambda 2 = ' + floatyToStr(lambda[2]))
    else if k = 3 then
      memo.Lines.add(floatyToStr(v3, n) + #13#10'lambda 3 = ' + floatyToStr(lambda[3]))
    else if k = 4 then
      memo.Lines.add(floatyToStr(v4, n) + #13#10'lambda 4 = ' + floatyToStr(lambda[4]))
    else
      memo.Lines.add(floatyToStr(v5, n) + #13#10'lambda 5 = ' + floatyToStr(lambda[5]))
  end;

  w := MatrixTimesVec(a, v1, n);
  memo.lines.add('');
  for i := 1 to n do
    memo.lines.add(floatyToStr(w[i]) + ' = ' + floatyToStr(lambda[1] * v1[i]));

  w := MatrixTimesVec(a, v2, n);
  memo.lines.add('');
  for i := 1 to n do
    memo.lines.add(floatyToStr(w[i]) + ' = ' + floatyToStr(lambda[2] * v2[i]));

  if n >= 3 then
  begin
    w := MatrixTimesVec(a, v3, n);
    memo.lines.add('');
    for i := 1 to n do
      memo.lines.add(floatyToStr(w[i]) + ' = ' + floatyToStr(lambda[3] * v3[i]));
  end;

  if n >= 4 then
  begin
    w := MatrixTimesVec(a, v4, n);
    memo.lines.add('');
    for i := 1 to n do
      memo.lines.add(floatyToStr(w[i]) + ' = ' + floatyToStr(lambda[4] * v4[i]));
  end;

  if n >= 5 then
  begin
    w := MatrixTimesVec(a, v5, n);
    memo.lines.add('');
    for i := 1 to n do
      memo.lines.add(floatyToStr(w[i]) + ' = ' + floatyToStr(lambda[5] * v5[i]));
  end;

  for i := 1 to 5 do
    for j := 1 to 5 do
      result[i, j] := 0;

  for i := 1 to 5 do
    Result[i, 1] := v1[i];
  for i := 1 to 5 do
    Result[i, 2] := v2[i];
  for i := 1 to 5 do
    Result[i, 3] := v3[i];
  for i := 1 to 5 do
    Result[i, 4] := v4[i];
  for i := 1 to 5 do
    Result[i, 5] := v5[i];
end;

procedure TFormPrincipal.btnPotenciaClick(Sender: TObject);
var
  i, j, n: integer;
  A, P, D, R: TMatriz;
begin
  memo.clear;
  for i := 1 to 5 do
    for j := 1 to 5 do
    begin
      D[i, j] := 0;
      P[i, j] := 0;
      R[i, j] := 0;
      A[i, j] := 0;
    end;
{
  D[1,1] := 2;
  D[2,2] := -5;
  D[3,3] := 3;

  P[2,2] := cos(pi/6);
  P[2,3] := sin(pi/6);
  P[3,2] := sin(pi/6);
  P[3,3] := -cos(pi/6);
  P[1,1] := 1;

  A := matrixmult(matrixmult(transposta(P), D), P);

  R[1,1] := cos(pi/6);
  R[1,3] := sin(pi/6);
  R[3,1] := sin(pi/6);
  R[3,3] := -cos(pi/6);
  R[2,2] := 1;

  A := matrixmult(matrixmult(transposta(R), A), R);
}

  n := strtoint(combo.Text);

  for i := 1 to n do
    for j := 1 to n do
      A[i, j] := strtofloat(sg.cells[j - 1, i - 1]);

  PowerMethod(A, n);
end;

procedure TFormPrincipal.btnSVDClick(Sender: TObject);
var
  i, j, n: integer;
  A, P, D, R, T: TMatriz;
  s: string;
  vec: TVetor;
begin
  WindowState := wsMaximized;
  memo.clear;

  for i := 1 to 5 do
    for j := 1 to 5 do
    begin
      D[i, j] := 0;
      P[i, j] := 0;
      R[i, j] := 0;
      A[i, j] := 0;
      T[i, j] := 0;
    end;
  D[1, 1] := 3;
  D[2, 2] := 5;
  D[3, 3] := 2;
  D[4, 4] := 1;

  P[2, 2] := cos(pi / 6);
  P[2, 3] := sin(pi / 6);
  P[3, 2] := sin(pi / 6);
  P[3, 3] := -cos(pi / 6);
  P[1, 1] := 1;
  P[4, 4] := 1;

  T[3, 3] := cos(pi / 6);
  T[3, 4] := sin(pi / 6);
  T[4, 3] := sin(pi / 6);
  T[4, 4] := -cos(pi / 6);
  T[1, 1] := 1;
  T[2, 2] := 1;

  A := matrixmult(matrixmult(transposta(P, 4), D, 4), P, 4);

  R[1, 1] := cos(pi / 6);
  R[1, 3] := sin(pi / 6);
  R[3, 1] := sin(pi / 6);
  R[3, 3] := -cos(pi / 6);
  R[2, 2] := 1;
  R[4, 4] := 1;

  D := matrixmult(matrixMult(P, R, 4), T, 4);

  s := 'PR'#13#10#13#10;
  for i := 1 to 4 do
  begin
    for j := 1 to 4 do
      s := s + floatyToStr(D[i, j]) + ' ';
    s := s + #13#10;
  end;

  //memo.lines.add(s);

  A := matrixmult(matrixmult(transposta(R, 4), A, 4), R, 4);
  A := matrixmult(matrixmult(transposta(T, 4), A, 4), T, 4);

  n := strtoint(combo.Text);

  for i := 1 to n do
    for j := 1 to n do
      A[i, j] := strtofloat(sg.cells[j - 1, i - 1]);

  s := 'AAAAAA'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(A[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  memo.lines.add('A A^T');
  P := PowerMethod(matrixmult(a, transposta(a, n), n), n);

  for i := 1 to 5 do
    for j := 1 to 5 do
      D[i, j] := 0;

  vec := Coluna(P, 1);
  vec := MatrixTimesVec(Transposta(A, 5), vec, 5);
  for i := 1 to 5 do
    R[i, 1] := 1 / sqrt(lambda[1]) * vec[i];

  vec := Coluna(P, 2);
  vec := MatrixTimesVec(Transposta(A, 5), vec, 5);
  for i := 1 to 5 do
    R[i, 2] := 1 / sqrt(lambda[2]) * vec[i];

  if n > 2 then
  begin
    vec := Coluna(P, 3);
    vec := MatrixTimesVec(Transposta(A, 5), vec, 5);
    for i := 1 to 5 do
      R[i, 3] := 1 / sqrt(lambda[3]) * vec[i];
  end;

  if n > 3 then
  begin
    vec := Coluna(P, 4);
    vec := MatrixTimesVec(Transposta(A, 5), vec, 5);
    for i := 1 to 5 do
      R[i, 4] := 1 / sqrt(lambda[4]) * vec[i];
  end;

  if n > 4 then
  begin
    vec := Coluna(P, 5);
    vec := MatrixTimesVec(Transposta(A, 5), vec, 5);
    for i := 1 to 5 do
      R[i, 5] := 1 / sqrt(lambda[5]) * vec[i];
  end;

  for i := 1 to 5 do
    D[i, i] := sqrt(abs(lambda[i]));

  A := MatrixMult(MatrixMult(P, D, 5), Transposta(R, 5), 5);

  s := 'U'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(P[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  s := 'Sigma'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(D[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  s := 'V'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(R[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  R := matrixmult(transposta(R, n), R, n);

  s := 'V^T V'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(R[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);

  s := 'A'#13#10#13#10;
  for i := 1 to n do
  begin
    for j := 1 to n do
      s := s + floatyToStr(A[i, j]) + ' ';
    s := s + #13#10;
  end;

  memo.lines.add(s);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var f: textfile; i, j: integer; s: string;
begin
  filemode := 0;
  AssignFile(f, 's.ini');
  reset(f);
  for i := 0 to 4 do
    for j := 0 to 4 do
    begin
      readln(f, s);
      sg.cells[i, j] := s;
    end;

  closefile(f);
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var f: textfile; i, j: integer;
begin
  AssignFile(f, 's.ini');
  rewrite(f);
  for i := 0 to 4 do
    for j := 0 to 4 do
      writeln(f, sg.cells[i, j]);

  closefile(f);
end;

end.

