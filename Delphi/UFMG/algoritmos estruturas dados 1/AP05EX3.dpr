program AP05EX3;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TVetor = array[1..900] of double;
  TMatriz = array[1..300, 1..3] of double;

procedure preencher(x: integer; vet: TVetor; var mat: TMatriz);
var i, li, col: integer;
begin
  li := 1;
  col := 1;
  for i := 1 to x do
  begin
    mat[li, col] := vet[i];
    inc(col);
    if col = 4 then
    begin
      col := 1;
      inc(li);
    end;
  end;
end;

var vet: TVetor;
    mat: TMatriz;
    i, x: integer;
begin
  write('Entre com um multiplo de 3: ');
  readln(x);
  if x mod 3 <> 0 then
    exit;
  for i := 1 to x do
  begin
    write('Entre com ');
    write(i);
    write(': ');
    readln(vet[i]);
  end;

  preencher(x, vet, mat);

  for i := 1 to x div 3 do
  begin
    write(i);
    write(': ');
    write(mat[i, 1]);
    write(' ; ');
    write(mat[i, 2]);
    write(' ; ');
    write(mat[i, 3]);
    writeln(' ;');
  end;

  readln;
end.
