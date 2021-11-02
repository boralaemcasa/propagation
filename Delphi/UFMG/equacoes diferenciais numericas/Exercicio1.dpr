program Exercicio1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  h, y_k, x_k, error, errorAnt: double;
  k: integer;
  f, g: textFile;
begin
  assignfile(g, 'EX1A.txt');
  rewrite(g);
  assignfile(f, 'EX1B.txt');
  rewrite(f);
  writeln(f, 'h ; y(1) ; error ; error ratio');
  errorAnt := 1;
  h := 2;

  repeat
    h := h/2;
    k := 0;
    y_k := 1;
    writeln(g, 'x_k ; y_{k + 1} ; Error');
    repeat
      inc(k);
      x_k := 0 + h * k;
      y_k := y_k + h * y_k;
      error := abs(exp(x_k) - y_k);
      writeln(g, x_k, ' ; ', y_k, ' ; ', error);
    until x_k >= 1;

    writeln(f, h, ' ; ', y_k, ' ; ', error, ' ; ', error / errorAnt);
    errorAnt := error;
  until abs(h - 1/4096) < 1e-4;

  closefile(f);
  closefile(g);
  write('O sistema gerou 2 arquivos.');
  readln;
end.
