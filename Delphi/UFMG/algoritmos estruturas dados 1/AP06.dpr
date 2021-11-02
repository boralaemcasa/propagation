program AP06;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TVetor = array[1..900] of integer;
  TMatriz = array[1..300, 1..3] of integer;
  PVetor = ^TVetor;
  PMatriz = ^TMatriz;

var A, B: PMatriz;
    i, j, m, n: integer;
begin
  write('Entre com m: ');
  readln(m);
  write('Entre com n: ');
  readln(n);

  A := GetMemory(sizeof(TMatriz));
  B := GetMemory(sizeof(TMatriz));

  for i := 1 to m do
    for j := 1 to n do
    begin
      write('Entre com A ');
      write(i);
      write(' ,');
      write(j);
      write(' : ');
      readln(A^[i, j]);
    end;

  for i := 1 to m do
    for j := 1 to n do
    begin
      write('Entre com B ');
      write(i);
      write(' ,');
      write(j);
      write(' : ');
      readln(B^[i, j]);
      A^[i, j] := A^[i, j] + B^[i, j];
    end;

  for i := 1 to m do
    for j := 1 to n do
    begin
      write('C ');
      write(i);
      write(' ,');
      write(j);
      write(' : ');
      writeln(A[i, j]);
    end;

  FreeMemory(A);
  FreeMemory(B);

  readln;
end.
