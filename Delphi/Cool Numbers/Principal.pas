unit Principal;

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

function fatorial(n: integer): double;
var i: integer;
begin
  result := 1;
  for i := 2 to n do
    result := result * i;
end;

function newton(n, p: integer): double;
begin
  result := fatorial(n) / fatorial(p) / fatorial(n-p);
end;

procedure TForm1.Button1Click(Sender: TObject);
var x, termo, soma, alpha0, alpha1, M, beta0, beta1, beta2, gama0, gama1, gama2, gama3, gama4, gama5: double;
    k, n, j, sinal: integer;
begin
  x := ln(2);
  termo := x * x / 2;
  k := 0;
  soma := termo;
  repeat
    inc(k);
    termo := termo * x * x * x * 0.1 / (3 * k * (3 * k + 1) * (3 * k + 2));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  memo.lines.add('gamma = ' + floattostr(soma));

  termo := x;
  k := 0;
  soma := termo;
  repeat
    inc(k);
    termo := termo * x * x * x * 0.1 / ((3 * k - 1) * (3 * k) * (3 * k + 1));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  memo.lines.add('beta = ' + floattostr(soma));

  termo := 1;
  k := 0;
  soma := termo;
  repeat
    inc(k);
    termo := termo * x * x * x * 0.1 / ((3 * k - 2) * (3 * k - 1) * (3 * k));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  memo.lines.add('alpha = ' + floattostr(soma));

  soma := 0;
  n := 0;
  repeat
    for j := 0 to n + 1 do
      if odd(j) then
      begin
        if odd(1 - j)
          then sinal := -1
          else sinal := 1;

        k := (j - 1) div 2;

        termo := newton(n + 1, j) * sinal / (n + 1) * exp(-k * ln(10));
        soma := soma + termo;
      end;
    inc(n);
  until abs(termo) < 1e-13;

  alpha1 := soma;
  memo.lines.add('');
  memo.lines.add('alpha_1 = ' + floattostr(soma));

  soma := 0;
  n := 0;
  repeat
    for j := 0 to n + 1 do
      if not odd(j) then
      begin
        if odd(1 - j)
          then sinal := -1
          else sinal := 1;

        k := j div 2;

        termo := newton(n + 1, j) * sinal / (n + 1) * exp(-k * ln(10));
        soma := soma + termo;
      end;
    inc(n);
  until abs(termo) < 1e-13;

  alpha0 := soma;
  memo.lines.add('alpha_0 = ' + floattostr(soma));

  termo := alpha0;
  soma := termo;
  k := 0;
  repeat
    inc(k);
    termo := termo * alpha0 * alpha0 * alpha0 * 0.1 / ((3 * k - 1) * (3 * k) * (3 * k + 1));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  beta1 := soma;
  memo.lines.add('beta_1 = ' + floattostr(soma));

  termo := alpha0 * alpha0 /2;
  soma := termo;
  k := 0;
  repeat
    inc(k);
    termo := termo * alpha0 * alpha0 * alpha0 * 0.1 / ((3 * k) * (3 * k + 1) * (3 * k + 2));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  beta2 := soma;
  memo.lines.add('beta_2 = ' + floattostr(soma));

  termo := 1;
  soma := termo;
  k := 0;
  repeat
    inc(k);
    termo := termo * alpha0 * alpha0 * alpha0 * 0.1 / ((3 * k - 2) * (3 * k - 1) * (3 * k));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  beta0 := soma;
  memo.lines.add('beta_0 = ' + floattostr(soma));

  termo := 1;
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x - 5) * (6 * x - 4) * (6 * x - 3) * (6 * x - 2) * (6 * x - 1) * (6 * x));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  gama0 := soma;
  memo.lines.add('gamma_0 = ' + floattostr(soma));

  termo := 0.0001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 / (5.0 * 4.0 * 3.0 * 2.0);
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x) * (6 * x + 1) * (6 * x + 2) * (6 * x + 3) * (6 * x + 4) * (6 * x + 5));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  gama1 := soma;
  memo.lines.add('gamma_1 = ' + floattostr(soma));

  termo := 0.001 * alpha1 * alpha1 * alpha1 * alpha1 / (4.0 * 3.0 * 2.0);
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x - 1) * (6 * x) * (6 * x + 1) * (6 * x + 2) * (6 * x + 3) * (6 * x + 4));
    soma := soma + termo;
    //showmessage('x = ' + floattostr(x) + #13#10'M = ' + floattostr(M) + #13#10'termo = ' + floattostr(termo) + #13#10'soma = ' + floattostr(soma));
  until abs(termo) < 1e-12;

  gama2 := soma;
  memo.lines.add('gamma_2 = ' + floattostr(soma));

  termo := 0.01 * alpha1 * alpha1 * alpha1 / (3.0 * 2.0);
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x - 2) * (6 * x - 1) * (6 * x) * (6 * x + 1) * (6 * x + 2) * (6 * x + 3));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  gama3 := soma;
  memo.lines.add('gamma_3 = ' + floattostr(soma));

  termo := 0.1 * alpha1 * alpha1 / 2.0;
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x - 3) * (6 * x - 2) * (6 * x - 1) * (6 * x) * (6 * x + 1) * (6 * x + 2));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  gama4 := soma;
  memo.lines.add('gamma_4 = ' + floattostr(soma));

  termo := alpha1;
  M :=  0.00001 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1 * alpha1;
  soma := termo;
  x := 0;
  repeat
    x := x + 1;
    termo := termo * M / ((6 * x - 4) * (6 * x - 3) * (6 * x - 2) * (6 * x - 1) * (6 * x) * (6 * x + 1));
    soma := soma + termo;
  until abs(termo) < 1e-12;

  gama5 := soma;
  memo.lines.add('gamma_5 = ' + floattostr(soma));

  soma := beta0 * gama0 + 0.1 * beta2 * gama2 + 0.1 * beta1 * gama4;
  memo.lines.add('');
  memo.lines.add('zeta_0 = ' + floattostr(soma));

  soma := beta0 * gama1 + 0.1 * beta2 * gama3 + 0.1 * beta1 * gama5;
  memo.lines.add('zeta_1 = ' + floattostr(soma));

  soma := beta0 * gama2 + beta1 * gama0 + 0.1 * beta2 * gama4;
  memo.lines.add('zeta_2 = ' + floattostr(soma));

  soma := beta0 * gama3 + beta1 * gama1 + 0.1 * beta2 * gama5;
  memo.lines.add('zeta_3 = ' + floattostr(soma));

  soma := beta0 * gama4 + beta1 * gama2 + beta2 * gama0;
  memo.lines.add('zeta_4 = ' + floattostr(soma));

  soma := beta0 * gama5 + beta1 * gama3 + beta2 * gama1;
  memo.lines.add('zeta_5 = ' + floattostr(soma));

end;

end.
