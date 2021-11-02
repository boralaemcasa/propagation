program AP05EX1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function maiores(n: integer; vet: array of integer; x: integer): integer;
var i, contador: integer;
begin
  contador := 0;
  for i := 0 to n - 1 do
    if vet[i] > x then
      inc(contador);
  result := contador;
end;

var vet: array[0..9] of integer;
    i, x: integer;
begin
  for i := 0 to 9 do
  begin
    write('Entre com ');
    write(i);
    write(': ');
    readln(vet[i]);
  end;
  write('x: ');
  readln(x);
  write(maiores(10, vet, x));
  write(' maiores que ');
  write(x);
  readln;
end.
