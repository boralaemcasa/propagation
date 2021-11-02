program Exercicio25C;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//trapézio 2.5.33 y_k_1 = y_k + h ff( x_k_1, y_k_1 )
//sobre 2.5.25 y' = -100y + 100, y(0) = y_0
//erro calculado em relação a 2.5.26 y(x) = (y_0 - 1)exp(-100x) + 1

//y_k_1 = y_k + h [ - 100 * y_k_1 + 100 ]
//y_k_1 + 100 h y_k_1 = y_k + 100 h
//y_k_1 = (y_k + 100 h) / (1 + 100 h)

function ff(x, y: double): double;
begin
  Result := - 100 * y + 100;
end;

var
  h, y_k, x_k, error, errorAnt, inicial: double;
  k: integer;
  f, g: textFile;
begin
  write('Informe y_0: ');
  readln(inicial);

  assignfile(g, 'EX25CA.txt');
  rewrite(g);
  assignfile(f, 'EX25CB.txt');
  rewrite(f);

  writeln(f, 'y_0 = ', inicial);
  writeln(g, 'y_0 = ', inicial);

  writeln(f, 'h ; y(1) ; error ; error ratio');
  errorAnt := 1;
  h := 2;

  repeat
    h := h/2;
    k := 0;
    y_k := inicial;
    writeln(g, 'x_k ; y_{k + 1} ; Error');
    repeat
      inc(k);
      x_k := 0 + h * k;
      y_k := (y_k + 100 * h) / (1 + 100 * h);
      error := abs((inicial - 1) * exp(-100 * x_k) + 1 - y_k);
      writeln(g, x_k, ' ; ', y_k, ' ; ', error);
    until x_k >= 1;

    if abs(errorAnt - 0) < 1e-15 then
      writeln(f, h, ' ; ', y_k, ' ; ', error, ' ; division by zero')
    else
      writeln(f, h, ' ; ', y_k, ' ; ', error, ' ; ', error / errorAnt);
    errorAnt := error;
  until abs(h - 1/4096) < 1e-4;

  closefile(f);
  closefile(g);
  write('O sistema gerou 2 arquivos.');
  readln;
end.
