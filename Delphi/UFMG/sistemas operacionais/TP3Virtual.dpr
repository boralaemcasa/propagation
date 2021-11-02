program TP3Virtual;
{$APPTYPE CONSOLE}
uses SysUtils;

type
  TRegistro = record
    address, fifo, LRU: longint;
    segunda, gravar: boolean;
  end;

var
  s: string;
  f: TextFile;
  g: array[0..100000000] of TRegistro;
  metodo: byte;
  pageMem, totalMem, lines, faults, dirtyFaults, max, remover, size: longint;
  d: double;
  reg: TRegistro;

function FifoLruRemover: longint;
var
  r: TRegistro;
  minimo, i: longint;
begin
//procure no tmp o Fifo minimo
  i := 0;
  result := 0;
  minimo := 2000000000;
  while i < size do
  begin
    r := g[i];
    if (metodo = 3) and (r.fifo < minimo) then
    begin
      result := i;
      minimo := r.fifo;
    end
    else if r.LRU < minimo then
    begin
      result := i;
      minimo := r.LRU;
    end;
    inc(i);
  end;
end;

function SecondRemover: longint;
var
  r: TRegistro;
  minimo1, minimo2, pos1, i: longint;
begin
//procure no tmp o Fifo minimo
  i := 0;
  pos1 := 0;
  minimo1 := 2000000000;
  minimo2 := 2000000000;
  while i < size do
  begin
    r := g[i];
    if (r.fifo < minimo1) and (not r.segunda) then
    begin
      pos1 := i;
      minimo1 := r.fifo;
    end
    else if (r.fifo < minimo2) and (r.segunda) then
    begin
      minimo2 := r.fifo;
    end;
    inc(i);
  end;

  if minimo2 < minimo1 then
  begin
    result := minimo2;
    exit;
  end;

  g[pos1].segunda := true;
  if minimo2 < 2000000000 then
  begin
    result := minimo2;
    exit;
  end;

  //chegou aqui, eu podia retornar minimo1.
  //todo mundo tem segunda chance. queremos o penultimo
  i := 0;
  minimo2 := 2000000000;
  while i < size do
  begin
    r := g[i];
    if (r.fifo < minimo2) and (not r.segunda) and (r.fifo > minimo1) then
      minimo2 := r.fifo;
    inc(i);
  end;

  result := minimo2;
end;

function LOADED: boolean;
var
  r: TRegistro;
  i: integer;
begin
//procure no tmp o registro atual e jogue em (reg, remover)
  i := 0;
  remover := 0;
  result := false;
  while i < size do
  begin
    r := g[i];
    if r.address = reg.address then
    begin
      result := true;
      reg.fifo := r.fifo; // codigo FIFO nao se altera, ja o codigo LRU se altera
      if not reg.gravar then // de 0
        if r.gravar then // para 1
          reg.gravar := true;
      break;
    end;
    inc(remover);
    inc(i);
  end;

  if not result then
    remover := -1;
end;

function FULL: boolean;
begin
  result := (size >= max);
//aponte para o registro a ser removido, caso ja nao esteja apontado
  if result and (remover < 0) then
    case metodo of
      1, 3: remover := FifoLruRemover;
      2: remover := SecondRemover;
      4: remover := random(size); // RANDOM
    end
  else
    remover := -1;
end;

function DIRTY: boolean;
var r: TRegistro;
begin
  r := g[remover];
  result := (r.gravar);
end;

procedure LOAD;
var i: integer;
begin
  if remover < 0 then
  begin
    i := size;
    inc(size)
  end
  else i := remover;
  g[i] := reg;
end;

begin
  size := 0;
  if paramcount <> 4 then
  begin
    write('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
    readln;
    exit;
  end;
  s := uppercase(paramstr(1));
  if s = 'LRU' then
    metodo := 1
  else if s = '2A' then
    metodo := 2
  else if s = 'FIFO' then
    metodo := 3
  else if s = 'RANDOM' then
    metodo := 4
  else
  begin
    writeln('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
    write('metodo in [LRU] [2A] [FIFO] [RANDOM]');
    readln; exit;
  end;
  s := paramstr(3);
  pageMem := StrToInt(s);
  d := ln(pageMem)/ln(2);
  if d <> round(d) then
  begin
    writeln('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
    write('page_mem - potencia de 2 requerida');
    readln; exit;
  end;
  s := paramstr(4);
  totalMem := StrToInt(s);
  d := ln(totalMem)/ln(2);
  if d <> round(d) then
  begin
    writeln('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
    write('total_mem - potencia de 2 requerida');
    readln; exit;
  end;

  filemode := fmOpenRead;
  assignfile(f, paramstr(2));
  try
    reset(f);
  except
    writeln('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
    write('Nao foi possivel abrir o arquivo ' + paramstr(2));
    readln; exit;
  end;
  max := totalMem div pageMem;
  lines := 0;
  faults := 0;
  dirtyFaults := 0;
  while not eof(f) do
  begin
    if lines mod 100000 = 0 then
    begin
      //writeln(lines);
      randomize;
    end;
    inc(lines);
    readln(f, s);
    if length(s) <> 10 then
    begin
      closefile(f);
      writeln('tp3virtual [metodo] [arquivo.log] [2^page_mem KB] [2^total_mem KB]');
      write('Erro na linha ', lines, ': dez caracteres esperados');
      readln; exit;
    end;

    s := lowercase(s);
    if s[8] in ['1'..'9'] then
      reg.address := byte(s[8]) - 48
    else if s[8] in ['a'..'f'] then
      reg.address := byte(s[8]) - 87 // 97 => 10
    else
      reg.address := 0;

    if s[7] in ['1'..'9'] then
      inc(reg.address, $10 * (byte(s[7]) - 48))
    else if s[7] in ['a'..'f'] then
      inc(reg.address, $10 * (byte(s[7]) - 87));

    if s[6] in ['1'..'9'] then
      inc(reg.address, $100 * (byte(s[6]) - 48))
    else if s[6] in ['a'..'f'] then
      inc(reg.address, $100 * (byte(s[6]) - 87));

    if s[5] in ['1'..'9'] then
      inc(reg.address, $1000 * (byte(s[5]) - 48))
    else if s[5] in ['a'..'f'] then
      inc(reg.address, $1000 * (byte(s[5]) - 87));

    if s[4] in ['1'..'9'] then
      inc(reg.address, $10000 * (byte(s[4]) - 48))
    else if s[4] in ['a'..'f'] then
      inc(reg.address, $10000 * (byte(s[4]) - 87));

    if s[3] in ['1'..'9'] then
      inc(reg.address, $100000 * (byte(s[3]) - 48))
    else if s[3] in ['a'..'f'] then
      inc(reg.address, $100000 * (byte(s[3]) - 87));

    if s[2] in ['1'..'9'] then
      inc(reg.address, $1000000 * (byte(s[2]) - 48))
    else if s[2] in ['a'..'f'] then
      inc(reg.address, $1000000 * (byte(s[2]) - 87));

    if s[1] in ['1'..'9'] then
      inc(reg.address, $10000000 * (byte(s[1]) - 48))
    else if s[1] in ['a'..'f'] then
      inc(reg.address, $10000000 * (byte(s[1]) - 87));

    reg.gravar := (s[10] = 'w');
    reg.fifo := lines;
    reg.LRU := lines;
    reg.segunda := false;
    if not LOADED then
    begin
      if FULL then
      begin
        inc(faults);
        if DIRTY then
          inc(dirtyFaults);
      end;
      LOAD;
    end;
  end;
  closefile(f);
  writeln('metodo = ' + paramstr(1));
  writeln('arquivo = ' + paramstr(2));
  writeln('page_mem = ' + paramstr(3) + ' KB');
  writeln('total_mem = ' + paramstr(4) + ' KB');
  writeln('numero total de acessos a memoria = ', lines);
  writeln('numero de page faults = ', faults);
  writeln('numero de paginas sujas escritas de volta no disco = ', dirtyFaults);
  writeln('[programa finalizado com sucesso]');
  writeln;
end.
