const dias: array[1..12] of byte = (31,0,31,30,31,30,31,31,30,31,30,31);

function bissexto(ano: integer): boolean;
begin
  bissexto := (ano mod 4 = 0)
end;

function DiasDoAno(a: integer): integer;
begin
  if bissexto(a)
    then DiasDoAno := 366
    else DiasDoAno := 365
end;

function DesdeJaneiro(d,m,a: integer): integer;
var i,soma: integer;
begin
  soma := 0;
  if bissexto(a) then dias[2] := 29 else dias[2] := 28;
  for i := 1 to (m-1) do
    soma := soma + dias[i];
  DesdeJaneiro := soma + d
end;

function AteDezembro(d,m,a: integer): integer;
var i,soma: integer;
begin
  if bissexto(a) then dias[2] := 29 else dias[2] := 28;
  soma := dias[m] - d;  {at‚ o fim do mˆs}
  for i := (m+1) to 12 do
    soma := soma + dias[i];
  AteDezembro := soma
end;

var dia1, mes1, ano1, total,
    dia2, mes2, ano2: integer;

BEGIN
  repeat
    read(dia1);
    if dia1 > 0 then
      begin
        readln(mes1, ano1, dia2, mes2, ano2);
        total := AteDezembro(dia1, mes1, ano1)
              + DesdeJaneiro(dia2, mes2, ano2);
        if ano1 <> ano2 then
          for ano1 := (ano1 + 1) to (ano2 - 1) do
            total := total + DiasDoAno(ano1)
        else total := total - DiasDoAno(ano1);
        writeln('Entre as datas h  ', total, ' dias.')
      end
  until dia1 <= 0
END.