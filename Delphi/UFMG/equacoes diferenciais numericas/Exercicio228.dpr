program Exercicio228;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function ff(x, y: double): double;
begin
  result := sqr(x) + sqr(y);
end;

var
  h, y_k, x_k: double;
  k: integer;
  f, g: textFile;
begin
  assignfile(g, 'EX228A.txt');
  rewrite(g);
  assignfile(f, 'EX228B.txt');
  rewrite(f);
  writeln(f, 'h ; y(0.2)');

  writeln(f, 'Euler');
  writeln(g, 'Euler');

  h := 1/5;

  repeat
    h := h/2;
    k := 0;
    y_k := 1;
    writeln(g, 'k ; x_k ; y_{k + 1}');
    repeat
      inc(k);
      x_k := 0 + h * k;
      y_k := y_k + h * (sqr(x_k) + sqr(y_k));
      writeln(g, k, ' ; ', x_k, ' ; ', y_k);
      if abs(x_k - 0.2) < 1e-4 then
        writeln(f, h, ' ; ', y_k);
    until x_k >= 1;
  until abs(h - 1/160) < 1e-4;

  writeln(f);
  writeln(g);
  writeln(f, 'Heun');
  writeln(g, 'Heun');

  h := 1/5;

  repeat
    h := h/2;
    k := 0;
    y_k := 1;
    writeln(g, 'k ; x_k ; y_{k + 1}');
    repeat
      inc(k);
      x_k := 0 + h * k;
      y_k := y_k + h/2 * ( ff(x_k - h, y_k) + ff(x_k, y_k + h * ff(x_k - h, y_k)) );
      writeln(g, k, ' ; ', x_k, ' ; ', y_k);
      if abs(x_k - 0.2) < 1e-3 then
        writeln(f, h, ' ; ', y_k);
    until x_k >= 1;
  until abs(h - 1/80) < 1e-4; // floating point overflow em 1/160

  closefile(f);
  closefile(g);
  write('O sistema gerou 2 arquivos.');
  readln;
end.
