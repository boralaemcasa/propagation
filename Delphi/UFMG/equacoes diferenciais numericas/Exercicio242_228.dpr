program Exercicio242_228;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function ff(x, y: double): double;
begin
  result := sqr(x) + sqr(y);
end;

var
  h, x_k, temp: double;
  y_k: array[-1..0] of double;
  k: integer;
  f, g: textFile;
begin
  assignfile(g, '242_228A.txt');
  rewrite(g);
  assignfile(f, '242_228B.txt');
  rewrite(f);
  writeln(f, 'h ; y(0.2)');
  h := 1/5;

  repeat
    h := h/2;
    k := 0;
    y_k[-1] := 1; // condição inicial
    y_k[0] := 1;
    writeln(g, 'k ; x_k ; y_{k + 1}');

  //Heun = Runge-Kutta de ordem 2
    inc(k);
    x_k := 0 + h * k;
    y_k[0] := y_k[0] + h/2 * ( ff(x_k, y_k[0]) + ff(x_k, y_k[0] + h * ff(x_k - h, y_k[0])) );
    writeln(g, k, ' ; ', x_k, ' ; ', y_k[0]);

    repeat
      inc(k);
      x_k := 0 + h * k;
      temp := y_k[0];
      y_k[0] := y_k[0] + h/2 * (3 * ff(x_k - h, y_k[0]) - ff(x_k - 2*h, y_k[-1])); // Adams-Bashforth 2.4.5
      y_k[-1] := temp;
      writeln(g, k, ' ; ', x_k, ' ; ', y_k[0]);
      if abs(x_k - 0.2) < 1e-4 then
        writeln(f, h, ' ; ', y_k[0]);
    until x_k >= 1;
  until abs(h - 1/160) < 1e-4;

  closefile(f);
  closefile(g);
  write('O sistema gerou 2 arquivos.');
  readln;
end.
