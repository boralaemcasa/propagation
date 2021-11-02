program ap08ex03;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TMatriz = array[1..100, 1..100] of integer;

var f: TextFile;
    i, j, li, col, p, q, x: integer;
    A, B, C: TMatriz;
begin
  AssignFile(f, 'matrizes.txt');
  reset(f);

  read(f, li);
  read(f, col);
  for i := 1 to li do
    begin
      for j := 1 to col do
        read(f, A[i, j]);
      readln(f);
    end;

  read(f, p);
  read(f, q);
  for i := 1 to p do
    begin
      for j := 1 to q do
        read(f, B[i, j]);
      readln(f);
    end;

  closefile(f);

  if col <> p then
  begin
    write('Impossivel multiplicar');
    exit;
  end;

  for i := 1 to li do
    for j := 1 to q do
    begin
      c[i,j] := 0;
      for x := 1 to p do
        c[i,j] := c[i,j] + a[i, x] * b[x, j];
    end;

  for i := 1 to li do
  begin
    for j := 1 to q do
      write(c[i,j], ' ');
    writeln;
  end;

  readln;
end.
