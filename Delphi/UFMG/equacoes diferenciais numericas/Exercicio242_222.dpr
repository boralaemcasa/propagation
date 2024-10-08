program Exercicio242_222;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function ff(x, y: double): double;
begin
  result := -y;
end;

var
  h, x_k, temp, error, errorAnt: double;
  y_k: array[-1..0] of double;
  k: integer;
  f, g: textFile;
begin
  assignfile(g, '242_222A.txt');
  rewrite(g);
  assignfile(f, '242_222B.txt');
  rewrite(f);
  writeln(f, 'h ; y(1) ; error ; error ratio');
  errorAnt := 1;
  h := 1/2;

  repeat
    h := h/2;
    k := 0;
    y_k[-1] := 1; // condi��o inicial
    y_k[0] := 1;
    writeln(g, 'x_k ; y_{k + 1} ; Error');

  //Heun = Runge-Kutta de ordem 2
    inc(k);
    x_k := 0 + h * k;
    y_k[0] := y_k[0] + h/2 * ( ff(x_k - h, y_k[0]) + ff(x_k, y_k[0] + h * ff(x_k - h, y_k[0])) );
    error := abs(exp(-x_k) - y_k[0]);
    writeln(g, x_k, ' ; ', y_k[0], ' ; ', error);

    repeat
      inc(k);
      x_k := 0 + h * k;
      temp := y_k[0];
      y_k[0] := y_k[0] + h/2 * (-3 * y_k[0] + y_k[-1]); // Adams-Bashforth 2.4.5; f = -y
      y_k[-1] := temp;
      error := abs(exp(-x_k) - y_k[0]);
      writeln(g, x_k, ' ; ', y_k[0], ' ; ', error);
    until x_k >= 1;

    writeln(f, h, ' ; ', y_k[0], ' ; ', error, ' ; ', error / errorAnt);
    errorAnt := error;
  until abs(h - 1/16) < 1e-4;

  closefile(f);
  closefile(g);
  write('O sistema gerou 2 arquivos.');
  readln;
end.
