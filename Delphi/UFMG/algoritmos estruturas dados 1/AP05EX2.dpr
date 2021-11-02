program AP05EX2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure imprimir(vet: array of integer);
var i: integer;
begin
  for i := 0 to 9 do
  begin
    write(i);
    write(': ');
    write(vet[i]);
    write(' ; @ = ');
    writeln(integer(@vet[i]));
  end;
end;

procedure somaAnterior(n: integer; vet: array of integer);
var i: integer;
begin
  for i := 1 to n - 1 do
    vet[i] := vet[i] + vet[i - 1];
  imprimir(vet);
end;

var vet: array[0..9] of integer;
    i: integer;
begin
  for i := 0 to 9 do
  begin
    write('Entre com ');
    write(i);
    write(': ');
    readln(vet[i]);
  end;

  imprimir(vet);
  somaAnterior(10, vet);

  readln;
end.
