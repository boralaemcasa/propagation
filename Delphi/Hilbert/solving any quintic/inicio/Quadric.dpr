program Quadric;
uses SysUtils, SNum in 'D:\mathematics\_my own\whole\SNum.pas';

function signed(x, y: string): string;
begin
  result := x;
  if FracCompare(x, '0') >= 0 then
    result := '+ ' + result
  else
    insert(' ', result, 2);

  if (x <> '0') and (y <> '1') then
    result := result + '/' + y;
end;

type TMatriz = array[1..4, 1..4] of string;

// Result := AM;

function Multiplicar(A: TMatriz; M: TMatriz): TMatriz;
var i, j, k: integer;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
    begin
      Result[i, j] := '0';
      for k := 1 to 4 do
        Result[i, j] := FracAdd(Result[i, j], FracMul(A[i, k], M[k, j]));
    end;
end;

var M, M2, M3, M4, M5, M6, M7, M8, L: TMatriz;
  f: textFile;
  i, j, k: integer;
  x, tn, t: string;
  cancelar: boolean;

begin
  cancelar := false;
  assignfile(f, 'd:\saida.txt');
  rewrite(f);
  M[1, 1] := '0';
  M[1, 2] := '1';
  M[1, 3] := '0';
  M[1, 4] := '0';

  M[2, 1] := '0';
  M[2, 2] := '0';
  M[2, 3] := '1';
  M[2, 4] := '0';

  M[3, 1] := '0';
  M[3, 2] := '0';
  M[3, 3] := '0';
  M[3, 4] := '1';

  M[4, 1] := '-1';
  M[4, 2] := '2';
  M[4, 3] := '-3';
  M[4, 4] := '2';      

  M2 := Multiplicar(M, M);
  M3 := Multiplicar(M2, M);
  M4 := Multiplicar(M3, M);
  M5 := Multiplicar(M4, M);
  M6 := Multiplicar(M5, M);
  M7 := Multiplicar(M6, M);
  M8 := Multiplicar(M7, M);

  for i := 1 to 4 do
    for j := 1 to 4 do
    begin
      write(f, 'f_', j);
      for k := 2 to i do
        write(f, '''');
      write(f, '(t) = ');
      if i = j then
        write(f, '1 ')
      else
        write(f, '0 ');

      write(f, signed(M[i, j], '1'), ' t ');
      x := '2';
      write(f, signed(M2[i, j], x), ' t² ');
      x := Multiplica(x, '3');
      write(f, signed(M3[i, j], x), ' t³ ');
      x := Multiplica(x, '4');
      write(f, signed(M4[i, j], x), ' t^4 ');
      x := Multiplica(x, '5');
      write(f, signed(M5[i, j], x), ' t^5 ');
      x := Multiplica(x, '6');
      write(f, signed(M6[i, j], x), ' t^6 ');
      x := Multiplica(x, '7');
      write(f, signed(M7[i, j], x), ' t^7 ');
      x := Multiplica(x, '8');
      writeln(f, signed(M8[i, j], x), ' t^8 + ...');
    end;   

  closefile(f);
end.

