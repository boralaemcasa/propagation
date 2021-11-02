unit Derivar;

interface

function Parcial(sOrig, x: string; ConstText: string = ''; outside: boolean = true): string;

implementation

uses dialogs, sysutils, classes;

function Potencia(termo, x, ConstText: string): string;
var i, j: integer;
  LConst: TStringList;
  base, expoente: string;
begin
  j := pos(')^', termo) + 1;
  if j = 1 then
    j := length(termo) + 1;
  base := copy(termo, 1, j - 1);
  expoente := copy(termo, j + 1, length(termo) - j);

  try
    j := StrToInt(expoente);
  except
    result := 'ERROR: Only positive integer exponents allowed';
    exit;
  end;

  if j = 2 then
    expoente := '2 ' + base + ' '
  else if j <> 1 then
    expoente := IntToStr(j) + ' ' + base + '^' + IntToStr(j - 1) + ' '
  else
    expoente := '';

//dx u = u_x
  base := Parcial(copy(base, 2, length(base) - 2), x, ConstText, false);
  if (pos('+', base) > 0) or (pos('-', base) > 0) then
    base := '(' + base + ')';

  if base = '0' then
    result := '0'
  else
    result := expoente + base;
end;

function charcopy(s: string; index: integer): char;
begin
  s := copy(s, index, 1);
  if s = '' then
    result := #0
  else result := s[1];
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

function Produto(sOrig, x, ConstText: string): string;
var
  LFatores, LConst: TStringList;
  i, j, k: integer;
  c, s, s2: string;
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
  LConst.Text := ConstText;

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

  for i := 0 to LFatores.Count - 1 do
  begin
    s := s + c;
    for j := 0 to LFatores.Count - 1 do
      if i = j then
        if copy(LFatores[i], 1, 6) = '\frac{' then
          s := s + '(' + parcial(LFatores[i], x, ConstText, false) + ') '
        else if (pos(')^', LFatores[i]) > 0) and
          (pos(' ', copy(LFatores[i], pos(')^', LFatores[i]), length(LFatores[i]))
          ) = 0) then
          s := s + Potencia(LFatores[i], x, ConstText)
        else if charcopy(LFatores[i], 1) = '(' then
        begin
          s2 := parcial(copy(LFatores[i], 2, length(LFatores[i]) - 2), x, ConstText, false);
          if (pos('+', s2) > 0) or (pos('-', s2) > 0) then
            s2 := '(' + s2 + ')';
          s := s + s2 + ' ';
        end
        else
          s := s + parcial(LFatores[i], x, ConstText, false) + ' '
      else s := s + LFatores[j] + ' ';
    s := copy(s, 1, length(s) - 1) + ' + ';
  end;
  LFatores.free;
  LConst.Free;

  s := copy(s, 1, length(s) - 3);
  if pos(' + ', s) > 0 then
    s := '<' + s + '>';
  result := s;
end;

function Quociente(u, v, x, ConstText: string): string; // \frac{u_x}{v} - \frac{u v_x}{v^2}
var u_x, v_x, v2: string;
  base, expoente: string;
  j: integer;
  executar: boolean;
begin
  u_x := Parcial(u, x, ConstText, false);
  v_x := Parcial(v, x, ConstText, false);
  u := trim(u); // inserir espaços via StringReplace causou necessidade de trim
  if (pos(' +', u) > 0) or (pos('-', u) > 0) then
    u := '(' + u + ')';
  if (pos(' +', v_x) > 0) or (pos('-', v_x) > 0) then
    v_x := '(' + v_x + ')';
  v2 := v;
  executar := false;
  if (pos(' +', v2) > 0) or (pos('-', v2) > 0) then
    if pos(')^', v2) > 0 then
      executar := true
    else v2 := '(' + v2 + ')^2'
  else if pos('^', v2) > 0 then
    executar := true
  else v2 := v2 + '^2';

  if executar then
  begin
    j := pos(')^', v2) + 1;
    if j = 1 then
      j := pos('^', v2);
    base := copy(v2, 1, j - 1);
    expoente := copy(v2, j + 1, length(v2) - j);
    try
      j := StrToInt(expoente);
    except
      result := 'ERROR: Only positive integer exponents allowed';
      exit;
    end;
    v2 := base + '^' + IntToStr(j + 1);
    v_x := IntToStr(j) + ' ' + Parcial(base, x, ConstText, false); // dx u/w^n = u'/v - n u v'/w^(n+1)
  end;

  if u_x = '0' then
    result := ''
  else
    result := '\frac{' + u_x + '}{' + v + '}';

  if u = '1' then // 1 u = u
    u := '';

  //*** simplificar v_x com v2: \frac{I_3 - A_3}{w_y^5}

  if v_x <> '0' then
    result := result + ' - \frac{' + u + ' ' + v_x + '}{' + v2 + '}';
end;

function Underline(termo, x, ConstText: string): string;
var i, j: integer;
  LConst: TStringList;
  base, expoente: string;
begin
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
  Lconst.Text := ConstText;
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
    insert(x, base, i + 2)
  else begin
    i := pos('_', base);
    if i > 0 then
    begin
      insert('{' + x, base, i + 1);
      base := base + '}';
    end
    else base := base + '_' + x;
  end;

  result := expoente + base;
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

function Parcial(sOrig, x: string; ConstText: string = ''; outside: boolean = true): string;
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

  dx := '\partial_' + x + ' [';

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
        s := '-(' + Parcial(copy(s, 3, length(s) - 3), x, ConstText, false) + ')'
      else
        s := '-' + Parcial(copy(s, 2, length(s) - 1), x, ConstText, false);
    end
    else
      s := '-' + Parcial(copy(s, 2, length(s) - 1), x, ConstText, false);

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
        substring := Parcial(substring, x, ConstText, false);
        insert(substring, s, j - length(dx) + 1);
        i := j - length(dx) + 2 + length(substring);
        //*** insert(']', s, i - 1); \partial_x [ termo ]
      end
      else begin //underline
        delete(s, j + 1, i - j - 2);
        delete(s, j - length(dx) + 1, length(dx));
        substring := Underline(substring, x, ConstText);
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
      insert(Parcial(substring, x, ConstText, false), s, j - 2)
    else if copy(substring, 1, 6) = '\frac{' then
    begin // \frac{abcd} {efgh}
      delete(substring, 1, 6);
      k := ExtendedPos(substring);
      i := k + 3 + ExtendedPos(copy(substring, k + 4, length(substring) - k - 3));
      if i = length(substring) then
        insert(Quociente(copy(substring, 1, k - 1),
          copy(substring, k + 3, length(substring) - k - 3),
          x, ConstText), s, j - 2)
      else
        insert(Produto('\frac{' + substring, x, ConstText), s, j - 2);
    end
    else insert(Produto(substring, x, ConstText), s, j - 2);
  end
  else begin //underline
    delete(s, j + 1, i - j - 1);
    delete(s, j - length(dx) + 1, length(dx));
    substring := Underline(substring, x, ConstText);
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
{//*** verificados, mas não necessários
partial(2, x);
partial(C, x, C);
partial(C + 2, x, C);
partial( (C + 2)(C - 2), x, C);
partial(x^2, x);
partial( \frac{1}{2}, x);
\frac {0} {u}
\frac {u} {0}
\frac {u} {1}
w_y^0
w_y^ - 1

