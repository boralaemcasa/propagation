program Quintic;
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

type TMatriz = array[1..5, 1..5] of string;

// Result := AM;

function Multiplicar(A: TMatriz; M: TMatriz): TMatriz;
var i, j, k: integer;
begin
  for i := 1 to 5 do
    for j := 1 to 5 do
    begin
      Result[i, j] := '0';
      for k := 1 to 5 do
        Result[i, j] := FracAdd(Result[i, j], FracMul(A[i, k], M[k, j]));
    end;
end;

var M, Mn: TMatriz;
  f: textFile;
  i, j: integer;
  fatorial, x, tn, t: string;
  L: array[1..5] of string;
  cancelar: boolean;
  sf: SFrac;

begin
  cancelar := false;
  assignfile(f, 'd:\saida.txt');
  rewrite(f);
  M[1, 1] := '0';
  M[1, 2] := '1';
  M[1, 3] := '0';
  M[1, 4] := '0';
  M[1, 5] := '0';
  M[2, 1] := '0';
  M[2, 2] := '0';
  M[2, 3] := '1';
  M[2, 4] := '0';
  M[2, 5] := '0';
  M[3, 1] := '0';
  M[3, 2] := '0';
  M[3, 3] := '0';
  M[3, 4] := '1';
  M[3, 5] := '0';
  M[4, 1] := '0';
  M[4, 2] := '0';
  M[4, 3] := '0';
  M[4, 4] := '0';
  M[4, 5] := '1';
  M[5, 1] := '1';
  M[5, 2] := '1';
  M[5, 3] := '0';
  M[5, 4] := '0';
  M[5, 5] := '0';

  t := '1';

  for i := 1 to 5 do
  begin
    x := '2';
    fatorial := '2';
    Mn := M;
    tn := t;
    write(f, 'f_', i, '(t) = ');
    if i = 1 then
      L[i] := '1'
    else
      L[i] := '0';

    write(f, L[i] + ' ');

    write(f, signed(M[1, i], '1'), ' t ');
    L[i] := FracAdd(L[i], FracMul(FracDiv(M[1, i], '1'), tn));

    for j := 2 to 20 do
    begin
      Mn := Multiplicar(Mn, M);
      tn := FracMul(tn, t);
      write(f, signed(Mn[1, i], fatorial), ' t^', x, ' ');
      L[i] := FracAdd(L[i], FracMul(FracDiv(Mn[1, i], fatorial), tn));
      x := Soma(x, '1');
      fatorial := Multiplica(fatorial, x);
    end;

    writeln(f);
  end;

  for i := 1 to 5 do
  begin
    sf := Str2Frac(L[i]);
    L[i] := DivideDizima(sf.n, sf.d, 30);
    writeln(f, 'L_', i, ' = ', L[i]);
  end;

  closefile(f);
end.

