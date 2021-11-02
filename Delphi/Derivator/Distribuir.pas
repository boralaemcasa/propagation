unit Distribuir;

interface

function Distributiva(sOrig: string; outside: boolean = true): string;

implementation

uses dialogs, sysutils, classes;

procedure Salvar(s, filename: string);
var list: TStringList;
begin
  list := TStringList.Create;
  list.Text := s;
  list.SaveToFile(filename);
  list.Free;
end;

function ExtendedPos(s: string): integer;
var j, k: integer;
begin
  j := 0; // conta '(' abertos
  for k := 1 to length(s) do
  begin
    case s[k] of
      '{': inc(j);
      '}': dec(j);
    end;
    if j = -1 then
      break;
  end;
  result := k;
end;

function charcopy(s: string; index: integer): char;
begin
  s := copy(s, index, 1);
  if s = '' then
    result := #0
  else result := s[1];
end;

function Potencia(termo: string): string;
begin
  result := termo;
end;

function PrecisaParentese(termo: string): boolean;
var s: string;
    i, j, k: integer;
    duplo: boolean;
begin
  result := false;
  s := trim(termo);
  i := 1;

  if s[1] = '-' then
  begin
    result := true;
    exit;
  end;

  if s[i] in ['+', '-'] then
    inc(i);

  if copy(s, i, 6) = '\frac{' then
  begin
    i := i + 6 + ExtendedPos(copy(s, i + 7, length(s) - i - 6));
    i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
    inc(i,2);
  end
  else if s[i] = '(' then
  begin
    duplo := false;
    repeat
      j := 1; // conta '(' abertos
      for k := i + 1 to length(s) do
      begin
        case s[k] of
          '(': inc(j);
          ')': dec(j);
        end;
        if j = 0 then
          break;
      end;
      inc(k);
      if charcopy(s, k) = '^' then
        repeat
          inc(k)
        until not (charcopy(s, k) in ['0'..'9']);

      if charcopy(s, k) = #0 then
        break;
      if charcopy(s, k) = ' ' then
        inc(k);
      i := k;
      if charcopy(s, k) = '(' then
        duplo := true;
    until charcopy(s, k) <> '(';

    dec(k);
    if k = length(s) then
    begin
    end
    else begin
      result := true;
    end;
  end
  else begin
    repeat
      inc(i);
      if copy(s, i, 6) = '\frac{' then
      begin
        i := i + 6 + ExtendedPos(copy(s, i + 7, length(s) - i - 6));
        i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
        inc(i,2);
      end
      else if s[i] = '(' then
      begin
        j := 1; // conta '(' abertos
        for k := i + 1 to length(s) do
        begin
          case s[k] of
            '(': inc(j);
            ')': dec(j);
          end;
          if j = 0 then
            break;
        end;
        i := k;
      if charcopy(s, i) = '^' then
        repeat
          inc(i)
        until not (charcopy(s, i) in ['0'..'9']);
      end;
    until charcopy(s, i) in ['+', '-', #0];

    if charcopy(s, i) <> #0 then
      result := true;
  end;
end;

function QuebraParcelas(termo: string): string;
var s: string;
  i, j, k: integer;
  duplo: boolean;
begin
  s := trim(termo);

  i := 1;
  if s[i] in ['+', '-'] then
    inc(i);

  if copy(s, i, 6) = '\frac{' then
  begin
    i := i + 6 + ExtendedPos(copy(s, i + 7, length(s) - i - 6));
    i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
    inc(i,2);
  end
  else if s[i] = '(' then
  begin
    duplo := false;
    repeat
      j := 1; // conta '(' abertos
      for k := i + 1 to length(s) do
      begin
        case s[k] of
          '(': inc(j);
          ')': dec(j);
        end;
        if j = 0 then
          break;
      end;
      inc(k);
      if charcopy(s, k) = '^' then
      begin
        duplo := true;
        repeat
          inc(k)
        until not (charcopy(s, k) in ['0'..'9']);
      end;
      if charcopy(s, k) = #0 then
        break;
      if charcopy(s, k) = ' ' then
        inc(k);
      i := k;
      if charcopy(s, k) = '(' then
        duplo := true;
    until charcopy(s, k) <> '(';

    dec(k);
    if k = length(s) then
    begin
      if not duplo then
        s := QuebraParcelas(copy(s, 2, length(s) - 2))
    end
    else begin
      insert(#13#10, s, k + 1);
      s := copy(s,1,k+2) + QuebraParcelas(copy(s, k + 3, length(s) - k - 2));
    end;
  end
  else begin
    repeat
      inc(i);
      if copy(s, i, 6) = '\frac{' then
      begin
        i := i + 6 + ExtendedPos(copy(s, i + 7, length(s) - i - 6));
        i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
        inc(i,2);
      end
      else if s[i] = '(' then
      begin
        j := 1; // conta '(' abertos
        for k := i + 1 to length(s) do
        begin
          case s[k] of
            '(': inc(j);
            ')': dec(j);
          end;
          if j = 0 then
            break;
        end;
        i := k;
      if charcopy(s, i) = '^' then
        repeat
          inc(i)
        until not (charcopy(s, i) in ['0'..'9']);
      end;
    until charcopy(s, i) in ['+', '-', #0];

    if charcopy(s, i) <> #0 then
      s := copy(s, 1, i - 1) + #13#10 + QuebraParcelas(copy(s, i, length(s) - i + 1));
  end;
  result := s;
end;

function ShortSort(s: string): string;
var i, j: integer;
  ch: char;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[i] > s[j] then
      begin
        ch := s[j];
        s[j] := s[i];
        s[i] := ch;
      end;
  result := s;
end;

function Contido(sub: string; s: string): boolean;
var i, j: integer;
begin
  i := pos('_', sub);
  j := pos('_', s);
  result := false;
  if sub = s then
  begin
    result := true; // C = C
  end
  else if j > 0 then // A_x' = 0 =/=> A = 0 and A_{xy}' = 0 =/=> A = 0
  begin
    if i = 0 then
    begin
      if sub = copy(s, 1, j - 1) then // C'=0 ==> C_x = 0 and C_{xy} = 0
        result := true;
    end
    else
    begin
   //aqui i,j > 0
      if copy(sub, 1, i - 1) = copy(s, 1, j - 1) then
      begin
      //logo i = j
        delete(sub, 1, i);
        delete(s, 1, i);
        sub := StringReplace(sub, '{', '', [rfReplaceAll]);
        sub := ShortSort(StringReplace(sub, '}', '', [rfReplaceAll]));
        s := StringReplace(s, '{', '', [rfReplaceAll]);
        s := ShortSort(StringReplace(s, '}', '', [rfReplaceAll]));
        if pos(sub, s) > 0 then // A_x' = 0 ==> A_{xy}' = 0 ==> A_{wxyz}' = 0
          result := true;
      end;
    end;
  end;
end;

function semIndices(s: string): string;
var i, j: integer;
begin
// \Delta_x \delta_y ==> Dd
  repeat
    i := pos('\', s);
    if i = 0 then
      break;
    delete(s, i, 1);
    while not (charcopy(s, i + 1) in [' ', '\', '+', '-', #0]) do
      delete(s, i + 1, 1);
  until false;

  repeat
    i := pos('^', s); //w_y^2
    if i = 0 then
      break;
    delete(s, i, 1);
    while charcopy(s, i) in ['0'..'9'] do
      delete(s, i, 1);
  until false;

  repeat
    i := pos('_', s);
    if i = 0 then
      break;
    if s[i + 1] <> '{' then
      delete(s, i, 2)
    else begin
      j := pos('}', copy(s, i + 1, length(s)));
      delete(s, i, j + 1);
    end;
  until false;

  result := s;
end;

function conta(sub, s: string): integer;
var i: integer;
begin
  result := 0;
  repeat
    i := pos(sub, s);
    if i = 0 then
      break;
    inc(result);
    delete(s, i, length(sub));
  until false;
end;

function Produto(sOrig: string): string;
var
  LFatores, LConst: TStringList;
  Parcelas: array of TStringList;
  indices: array of integer;
  i, j, k: integer;
  c, s, s2: string;
  fim: boolean;
begin
  s := sOrig;
//uv = dx u v + u dx v
  LFatores := TStringList.Create;
  i := 1;
  while i <= length(s) do
  begin
    if copy(s, i, 6) = '\frac{' then
    begin
      //inc(i, 6);
      i := 6 + ExtendedPos(copy(s, 7, length(s) - 6));
      //inc(i, 3); // } {
      i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
      inc(i);
    end
    else if s[i] in [' ', '\'] then
      repeat
        inc(i);
      until charcopy(s, i) in [' ', '\', '(', #0]
    else if s[i] = '(' then
    begin
      j := 1; // conta '(' abertos
      for k := i + 1 to length(s) do
      begin
        case s[k] of
          '(': inc(j);
          ')': dec(j);
        end;
        if j = 0 then
          break;
      end;
      i := k + 1;
      if s[i] = '^' then
        repeat
          inc(i)
        until not (s[i] in ['0'..'9']);
    end
    else inc(i);

    if i <= length(s) then
      if s[i] = '_' then
        repeat
          inc(i);
        until charcopy(s, i) in [' ', '\', '(', #0];

    LFatores.Add(copy(s, 1, i - 1));
    delete(s, 1, i - 1);
    s := trim(s);
    i := 1;
  end;

  s := '';
  c := '';

  LConst := TStringList.Create;
  LConst.Text := '';

  //dx (abuv) = ab dx (uv)
  i := 0;
  while i < LFatores.Count do
  begin
    try
      strtoint(LFatores[i]); // a,b \in Z
      c := c + LFatores[i] + ' ';
      LFatores.Delete(i);
    except
      for j := 0 to LConst.Count - 1 do
        if Contido(LConst[j], LFatores[i]) then
        begin
          c := c + LFatores[i] + ' ';
          LFatores.Delete(i);
          dec(i); // versus inc
          break;
        end;

      inc(i);
    end;
  end;

  s := c;

  SetLength(Parcelas, LFatores.Count);
  SetLength(indices, LFatores.Count);

  if LFatores.Count = 1 then
  begin
    result := c + LFatores[0];
    exit;
  end;

  for i := 0 to LFatores.Count - 1 do
  begin
    Parcelas[i] := TStringList.Create;
    Parcelas[i].Text := QuebraParcelas(LFatores[i]);
    for j := 0 to Parcelas[i].Count - 1 do
    begin
      if charcopy(Parcelas[i][j], 1) = '+' then
        Parcelas[i][j] := trim(copy(Parcelas[i][j], 2, length(Parcelas[i][j]) - 1));

       if PrecisaParentese(Parcelas[i][j]) then
          Parcelas[i][j] := '(' + Parcelas[i][j] + ')';
    end;
    //showmessage(Parcelas[i].Text);
    indices[i] := 0;
  end;

  s := '';
  repeat
    s := s + ' + ' + c;
    for i := 0 to LFatores.Count - 1 do
      s := s + ' ' + Parcelas[i][indices[i]];

    fim := true;
    for i := 0 to LFatores.Count - 1 do
      if indices[i] < Parcelas[i].Count - 1 then
      begin
        j := i + 1;
        repeat
          dec(j);
        until (indices[j] < Parcelas[j].Count - 1) or (j = 0);

        if indices[j] < Parcelas[j].Count - 1 then
        begin
          inc(indices[j]);
          for k := j - 1 downto 0 do
            indices[k] := 0;
        end;

        fim := false;
        break;
      end;

    if fim then break;
  until false;

  for i := 0 to LFatores.Count - 1 do
    Parcelas[i].Free;

  LFatores.free;
  LConst.Free;

  delete(s, 1, 3);
  if pos(' + ', s) > 0 then
    s := '<' + s + '>';
  result := s;
end;

function Quociente(u, v: string): string; // \frac{u_x}{v} - \frac{u v_x}{v^2}
var u_x, v_x, v2: string;
  base, expoente: string;
  j: integer;
  executar: boolean;
begin
  result := '\frac{' + Distributiva(u, false) + '}{' + Distributiva(v, false) + '}';
end;

function Underline(termo: string): string;
var i, j: integer;
  LConst: TStringList;
  base, expoente: string;
begin
(*
  j := pos('^', termo);
  if j = 0 then
    j := length(termo) + 1;
  base := copy(termo, 1, j - 1);
  expoente := copy(termo, j + 1, length(termo) - j);
//dx c = 0
  try
    strtoint(base); // \in Z
    result := '0';
    exit;
  except
  end;

  LConst := TStringList.Create;
  Lconst.Text := '';
  for i := 0 to LConst.Count - 1 do
    if Contido(LConst[i], base) then
    begin
      result := '0';
      LConst.Free;
      exit;
    end;
  LConst.Free;

  if expoente <> '' then
  begin
    try
      j := StrToInt(expoente);
    except
      result := 'ERROR: Only positive integer exponents allowed';
      exit;
    end;
  end
  else j := 1;

  if j = 2 then
    expoente := '2 ' + base + ' '
  else if j <> 1 then
    expoente := IntToStr(j) + ' ' + base + '^' + IntToStr(j - 1) + ' '
  else
    expoente := '';

//dx u = u_x
  i := pos('_{', base);
  if i > 0 then
    insert('x', base, i + 2)
  else begin
    i := pos('_', base);
    if i > 0 then
    begin
      insert('{' + 'x', base, i + 1);
      base := base + '}';
    end
    else base := base + '_' + 'x';
  end;

  result := expoente + base;
*)
  result := termo;
end;

procedure ProcessaOutside(var s: string);
var i, j, k: integer;
begin
  s := StringReplace(s, '<', '(', [rfReplaceAll]);
  s := StringReplace(s, '>', ')', [rfReplaceAll]);
  j := 0; // conta '(' abertos
  for i := 1 to length(s) do
    case s[i] of
      '(': inc(j);
      ')': dec(j);
    end;

  for i := 1 to j do
    s := s + ')';

  repeat
    i := pos('+ (', s); //*** aqui eu poderia fazer - (a + b) = - a - b
    if i = 0 then
      break;

    j := 0; // conta '(' abertos
    for k := i + 2 to length(s) do
    begin
      case s[k] of
        '(': inc(j);
        ')': dec(j);
      end;
      if j = 0 then
        break;
    end;

    (* if charcopy(s, k + 1) <> '(' then
    begin
      delete(s, k, 1);       deu pau com \left( I_{3z} - A_{3z} \right) w_{xy}
      delete(s, i + 2, 1);
    end
    else *)delete(s, i + 1, 1); // find next
  until false;

  s := StringReplace(s, '+(', '+ (', [rfReplaceAll]);
end;

function Distributiva(sOrig: string; outside: boolean = true): string;
var
  i, j, k: integer;
  substring, dx, s: string;

begin
  s := sOrig;
  if outside then
  begin
    s := StringReplace(s, '\\', '', [rfReplaceAll]);
    s := StringReplace(s, #13#10, '', [rfReplaceAll]);
    s := StringReplace(s, #9, ' ', [rfReplaceAll]);
    s := StringReplace(s, '\cdot', '', [rfReplaceAll]);
    s := StringReplace(s, '[', '(', [rfReplaceAll]);
    s := StringReplace(s, ']', ')', [rfReplaceAll]);
    s := StringReplace(s, '\{', '(', [rfReplaceAll]);
    s := StringReplace(s, '\}', ')', [rfReplaceAll]);
  end;

  dx := '\partial_' + 'x' + ' [';

  if outside then
  begin
    s := StringReplace(s, '\left', '', [rfReplaceAll]);
    s := StringReplace(s, '\right', '', [rfReplaceAll]);
    s := StringReplace(s, '\biggl', '', [rfReplaceAll]);
    s := StringReplace(s, '\biggr', '', [rfReplaceAll]);
  end;

  //espaço antes do '+' requerido
  i := 1;
  while i <= length(s) do
    if (s[i] = '+') and (s[i - 1] <> ' ') then
    begin
      insert(' ', s, i);
      inc(i, 2)
    end
    else
      inc(i);

  //espaço antes do '-' requerido
  i := 1;
  while i <= length(s) do
    if (s[i] = '-') and (s[i - 1] <> ' ') then
    begin
      insert(' ', s, i);
      inc(i, 2)
    end
    else
      inc(i);

  //' }' proibido
  while pos(' }', s) > 0 do
    s := StringReplace(s, ' }', '}', [rfReplaceAll]);

  //'{ ' proibido
  while pos('{ ', s) > 0 do
    s := StringReplace(s, '{ ', '{', [rfReplaceAll]);

  //*** apenas 'a'..'z' permitido entre {}

  //espaço após o '}' requerido
  i := 1;
  while i < length(s) do
    if (s[i] = '}') and (s[i + 1] <> ' ') then
    begin
      insert(' ', s, i + 1);
      inc(i, 2)
    end
    else
      inc(i);

  //duplo espaço proibido
  while pos('  ', s) > 0 do
    s := StringReplace(s, '  ', ' ', [rfReplaceAll]);

  //espaços aa esquerda e aa direita proibidos
  s := trim(s);

  //chave e expoente
  s := StringReplace(s, '} ^', '}^', [rfReplaceAll]);

  // dx (- u) = - dx u
  if s[1] = '-' then
  begin
    if s[2] = ' ' then
      delete(s, 2, 1);
    if s[2] = '(' then
    begin
      if s[length(s) - 2] = ' ' then
        delete(s, length(s) - 2, 1);

      j := 1; // conta '(' abertos
      for k := 3 to length(s) do
      begin
        case s[k] of
          '(': inc(j);
          ')': dec(j);
        end;
        if j = 0 then
          break;
      end;

      if k = length(s) then
        s := '-(' + Distributiva(copy(s, 3, length(s) - 3), false) + ')'
      else
        s := '-' + Distributiva(copy(s, 2, length(s) - 1), false);
    end
    else
      s := '-' + Distributiva(copy(s, 2, length(s) - 1), false);

    if outside then
      ProcessaOutside(s);
    result := s;
    exit;
  end;

//distributiva
  s := dx + s;
  i := length(dx) + 1;
  while i <= length(s) do
  begin
    if copy(s, i, 6) = '\frac{' then
    begin
      i := i + 6 + ExtendedPos(copy(s, i + 7, length(s) - i - 6));
      //inc(i, 3); // } {
      i := i + 3 + ExtendedPos(copy(s, i + 4, length(s) - i - 3));
      inc(i, 2);
      continue; // vários frac () frac () frac
    end;

    if s[i] = '(' then
    begin
      j := 1; // conta '(' abertos
      for k := i + 1 to length(s) do
      begin
        case s[k] of
          '(': inc(j);
          ')': dec(j);
        end;
        if j = 0 then
          break;
      end;
      i := k + 1;
      if j <> 0 then
      begin
        result := 'ERROR: ) ausente';
        exit;
      end;
      continue; // vários () frac () frac ()
    end;

    if s[i] in ['+', '-'] then
    begin
      if s[i + 1] = ' ' then
        insert(dx, s, i + 2)
      else insert(' ' + dx, s, i + 1);

      j := i - 1; // j < i
      while s[j] <> '[' do
        dec(j);

      substring := copy(s, j + 1, i - j - 2);
      if length(semIndices(substring)) > 1 then
      begin
        delete(s, j + 1, i - j - 2);
        delete(s, j - length(dx) + 1, length(dx));
        substring := Distributiva(substring, false);
        insert(substring, s, j - length(dx) + 1);
        i := j - length(dx) + 2 + length(substring);
        //*** insert(']', s, i - 1); \partial_x [ termo ]
      end
      else begin //underline
        delete(s, j + 1, i - j - 2);
        delete(s, j - length(dx) + 1, length(dx));
        substring := Underline(substring);
        if substring = '0' then // dx c = 0
          delete(s, j - length(dx) - 2, 3) // ± 0
        else
          insert(substring, s, j - length(dx) + 1);
        i := j - length(dx) + 2 + length(substring);
      end;

      inc(i, length(dx) + 1);
    end;
    inc(i);
  end;

//última parcela
  j := i - 1;
  while s[j] <> '[' do
    dec(j);

  substring := copy(s, j + 1, i - j - 1);
  if length(semIndices(substring)) > 1 then
  begin
    delete(s, j + 1, i - j - 1);
    delete(s, j - length(dx) + 1, length(dx));

{
  //dx cu = c dx u
    repeat
      inc(k);
    until (k > length(substring)) or not (substring[k] in ['0'..'9']);

    if k > 1 then
    begin
      insert(copy(substring, 1, k - 1), s, j - 2);
      delete(substring, 1, k - 1);
    end;
}

    if conta(dx, s) > 1 then
      insert(Distributiva(substring, false), s, j - 2)
    else if copy(substring, 1, 6) = '\frac{' then
    begin // \frac{abcd} {efgh}
      delete(substring, 1, 6);
      k := ExtendedPos(substring);
      i := k + 3 + ExtendedPos(copy(substring, k + 4, length(substring) - k - 3));
      if i = length(substring) then
        insert(Quociente(copy(substring, 1, k - 1),
          copy(substring, k + 3, length(substring) - k - 3)
          ), s, j - 2)
      else
        insert(Produto('\frac{' + substring), s, j - 2);
    end
    else insert(Produto(substring), s, j - 2);
  end
  else begin //underline
    delete(s, j + 1, i - j - 1);
    delete(s, j - length(dx) + 1, length(dx));
    substring := Underline(substring);
    if substring = '0' then
      delete(s, j - length(dx) - 1, 1)
    else insert(substring, s, j - 2);
  end;

  s := StringReplace(s, '[', '(', [rfReplaceAll]);
  s := StringReplace(s, ']', ')', [rfReplaceAll]);

  if outside then
    ProcessaOutside(s);

  if charcopy(s, 1) = '(' then
  begin
    j := 0; // conta '(' abertos
    for k := 1 to length(s) do
    begin
      case s[k] of
        '(': inc(j);
        ')': dec(j);
      end;
      if j = 0 then
        break;
    end;

    delete(s, k, 1);
    delete(s, 1, 1);
  end;

  s := trim(s);
  if s = '' then
    s := '0';

  result := s;
end;

end.

