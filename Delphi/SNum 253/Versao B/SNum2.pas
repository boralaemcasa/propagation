unit SNum2;

interface

const
   PRIMOS_SOURCE = 'primos novos.dat';

var
   PRIMO_LIMITE: longword;

type
   SFrac = record
      n, d: string;
   end;

   TArquivo = file of char;

   function Valida(s: string): string;

// as funçoes abaixo já partem de q as strings sao válidas
   function  Soma(a,b: string): string;
   function  Subtrai(a,b: string): string;
   function  Multiplica(a,b: string): string; overload;
   function  Multiplica(a,b, dir: string): string; overload;
   procedure Divide(a,b: string; var q,r: string);
   function  Potencia(a,b: string): string;

   function  SomaArq(var a, b: TArquivo): string;
   function  SubtraiArq(var a, b: TArquivo): string;
   function  SNumCompareArq(var a, b: TArquivo): shortint;
   procedure DivideArq(var a,b,q,r: TArquivo);
   procedure Gravar(var a: TArquivo; s: string);

   function  SNumCompare(a,b: string): shortint;
   function  Oposto(s: string): string;

   function  FatoresPrimos(x: string): string;

// fraçoes
   function  Str2SFrac(a: string; b: string = ''): SFrac;
   procedure SFracReduz(var frac: SFrac);
   function  SFracDizima(frac: SFrac): string;

   function  SFracAdd(a, b: SFrac): SFrac;
   function  SFracSub(a, b: SFrac): SFrac;
   function  SFracMul(a, b: SFrac): SFrac;
   function  SFracDiv(a, b: SFrac): SFrac;

implementation

uses SysUtils, Forms, Dialogs;

procedure ZeroLTrim(var s: string);
begin
  while (copy(s , 1, 1) = '0') and (length(s) > 1) do
    delete(s, 1, 1);
end;

procedure ZeroLTrimArq(var a: TArquivo);
var ch: char;
    i, j: integer;
begin
  seek(a, 0);
  repeat
    read(a, ch);
  until (ch <> '0') or eof(a);

  if eof(a) then
  begin
    Gravar(a, '0');
    exit;
  end;

  i := FilePos(a) - 1;
  if i > 0 then
  begin
    j := i;
    repeat
      Seek(a, j);
      read(a, ch);
      Seek(a, j - i);
      write(a, ch);
      inc(j);
    until j > FileSize(a) - 1;

    seek(a, FileSize(a) - i);
    truncate(a);
  end;
end;

function Valida(s: string): string;
var i: integer;
begin
   i := 1;
   if s = '' then s := '0';
   if s[1] = '-' then inc(i);
   while i <= length(s) do
      begin
         if s[i] in ['0'..'9']
            then inc(i)
            else delete(s, i, 1);
      end;

   Result := s;
   ZeroLTrim(Result);
end;

function  Soma(a,b: string): string;
var i, x: integer;
    carry: byte;
    minus: boolean;
begin
  minus := false;
  if copy(a, 1, 1) = '-' then
     begin
        delete(a, 1, 1);
        if copy(b, 1, 1) = '-' then
           begin
              delete(b, 1, 1);
           // -a + (-b) = -(a + b)
              minus := true;
           end
        else
           begin
           // -a + b = b - a
              Result := Subtrai(b, a);
              exit;
           end;
     end
  else if copy(b, 1, 1) = '-' then
     begin
        delete(b, 1, 1);
     // a + (-b) = a - b
        Result := Subtrai(a, b);
        exit;
     end;

  if length(a) > length(b) then // troca a, b
  begin
    Result := a;
    a := b;
    b := Result;
  end;

  x := length(b);
  while length(a) < x do
    a := '0' + a;

//008765
//123400
  i := x;
  while (i > 0) and (b[i] = '0') do
    dec(i);

  Result := copy(a, i + 1, x - i);
  delete(a, i + 1, x - i);
  delete(b, i + 1, x - i);

  carry := 0;
  for i := i downto 1 do
     begin
        x := byte(a[i]) - 48 + byte(b[i]) - 48 + carry;
        if x >= 10 then
           begin
              carry := 1;
              dec(x, 10);
           end
        else carry := 0;
        Result := char(x + 48) + Result;
     end;
  if carry <> 0 then
     Result := '1' + Result;
  if minus then
     Result := '-' + Result;
end;

function Ler(var a: TArquivo; posicao: integer): char;
begin
  seek(a, posicao);
  read(a, Result);
end;

function FileCopy(var a: TArquivo; index, count: integer): string;
var ch: char;
begin
  result := '';
  repeat
    Seek(a, index);
    read(a, ch);
    result := result + ch;
    inc(index);
    dec(count);
  until count = 0;
end;

function  SomaArq(var a, b: TArquivo): string;
var i, x, j: integer;
    carry: byte;
    minus: boolean;
    ch: char;
begin
  minus := false;
  seek(a, 0);
  read(a, ch);
  if ch = '-' then
     begin
        seek(a, 0);
        ch := '0';
        write(a, ch);
        seek(b, 0);
        read(b, ch);
        if ch = '-' then
           begin
              seek(b, 0);
              ch := '0';
              write(b, ch);
           // -a + (-b) = -(a + b)
              minus := true;
           end
        else
           begin
           // -a + b = b - a
              Result := SubtraiArq(b, a);
              exit;
           end;
     end
  else
  begin
     seek(b, 0);
     read(b, ch);
     if ch = '-' then
     begin
        seek(b, 0);
        ch := '0';
        write(b, ch);
     // a + (-b) = a - b
        Result := SubtraiArq(a, b);
        exit;
     end;
  end;

  if FileSize(a) > FileSize(b) then // troca a, b
    Result := SomaArq(b, a);

   i := FileSize(b) - FileSize(a);
   if i > 0 then
   begin
      j := FileSize(a) - 1;
      repeat
        Seek(a, j);
        read(a, ch);
        Seek(a, j + i);
        write(a, ch);
        dec(j);
      until j < 0;

      seek(a, 0);
      ch := '0';
      for i := 1 to i do
        write(a, ch);
   end;

//008765
//123400
  x := FileSize(b);
  i := x;
  while (i > 0) and (LER(b, i) = '0') do
    dec(i);

  Result := FileCopy(a, i + 1, x - i);
  seek(a, i + 1);
  truncate(a);
  seek(b, i + 1);
  truncate(b);

  carry := 0;
  for i := i downto 1 do
     begin
        x := byte(Ler(a, i)) - 48 + byte(Ler(b, i)) - 48 + carry;
        if x >= 10 then
           begin
              carry := 1;
              dec(x, 10);
           end
        else carry := 0;
        Result := char(x + 48) + Result;
     end;
  if carry <> 0 then
     Result := '1' + Result;
  if minus then
     Result := '-' + Result;
end;

function  Subtrai(a,b: string): string;
var i: integer;
    x, carry: shortint;
begin
   if copy(a, 1, 1) = '-' then
      begin
         delete(a, 1, 1);
         if copy(b, 1, 1) = '-' then
            begin
               delete(b, 1, 1);
            // -a - (-b) = b - a
               Result := Subtrai(b, a);
            end
         else
            begin
            // -a - b = -(a + b)
               Result := '-' + Soma(a, b);
            end;
         exit;
      end
   else if copy(b, 1, 1) = '-' then
      begin
         delete(b, 1, 1);
      // a - (-b) = a + b
         Result := Soma(a, b);
         exit;
      end
   else if SNumCompare(a, b) < 0 then
      begin
      // a < b => a - b = -(b - a)
         Result := '-' + Subtrai(b, a);
         exit;
      end;
// 923
// 199
   while length(b) < length(a) do
      b := '0' + b;
   Result := '';
   carry := 0;
   for i := length(a) downto 1 do
      begin
         x := byte(a[i]) - 48 - byte(b[i]) + 48 - carry;
         if x < 0 then
            begin
               carry := 1;
               inc(x, 10);
            end
         else carry := 0;
         Result := char(x + 48) + Result;
      end;

  ZeroLTrim(Result);
end;

function  SubtraiArq(var a, b: TArquivo): string;
var i, j: integer;
    x, carry: shortint;
    ch: char;
begin
   seek(a, 0);
   read(a, ch);
   if ch = '-' then
      begin
         seek(a, 0);
         ch := '0';
         write(a, ch);

         seek(b, 0);
         read(b, ch);
         if ch = '-' then
            begin
               seek(b, 0);
               ch := '0';
               write(b, ch);
            // -a - (-b) = b - a
               Result := SubtraiArq(b, a);
            end
         else
            begin
            // -a - b = -(a + b)
               Result := '-' + SomaArq(a, b);
            end;
         exit;
      end
   else if Ler(b, 0) = '-' then
      begin
         seek(b, 0);
         ch := '0';
         write(b, ch);
      // a - (-b) = a + b
         Result := SomaArq(a, b);
         exit;
      end
   else if SNumCompareArq(a, b) < 0 then
      begin
      // a < b => a - b = -(b - a)
         Result := '-' + SubtraiArq(b, a);
         exit;
      end;
// 923
// 199

   i := FileSize(a) - FileSize(b);
   if i > 0 then
   begin
      j := FileSize(b) - 1;
      repeat
        Seek(b, j);
        read(b, ch);
        Seek(b, j + i);
        write(b, ch);
        dec(j);
      until j < 0;

      seek(b, 0);
      ch := '0';
      for i := 1 to i do
        write(b, ch);
   end;

   Result := '';
   carry := 0;
   for i := FileSize(a) - 1 downto 0 do
      begin
         x := byte(Ler(a, i)) - 48 - byte(Ler(b, i)) + 48 - carry;
         if x < 0 then
            begin
               carry := 1;
               inc(x, 10);
            end
         else carry := 0;
         Result := char(x + 48) + Result;
      end;

  ZeroLTrim(Result);
end;

function  SNumCompare(a,b: string): shortint;
var minus: boolean;
begin
   Result := 0;
   if a = b then exit;
   minus := false;
   if copy(a, 1, 1) = '-' then
      if copy(b, 1, 1) = '-'
         then minus := true
         else Result := -1
   else if copy(b, 1, 1) = '-' then
      Result := -1;

   if Result <> 0 then exit;

   if minus then
      begin
         delete(a, 1, 1);
         delete(b, 1, 1);
      end;

   while length(b) < length(a) do
      b := '0' + b;
   while length(a) < length(b) do
      a := '0' + a;

// positivos
   if a > b
      then Result := 1
      else Result := -1;

// negativos inverte
   if minus then Result := - Result;
end;

function  SNumCompareArq(var a, b: TArquivo): shortint;
var minus: boolean;
    ch: char;
    i,j: integer;
begin
   Result := 0;
   i := 0;
   seek(b, 0);
   while i <= FileSize(b) - 1 do
   begin
     read(b, ch);
     if Ler(a, i) <> ch then
       break;
   end;
   if (i = FileSize(b)) and (Ler(a, i - 1) = ch) then exit;
   minus := false;
   if Ler(a, 0) = '-' then
   begin
      seek(b, 0);
      read(b, ch);
      if ch = '-'
         then minus := true
         else Result := -1
   end
   else
   begin
      seek(b, 0);
      read(b, ch);
      if ch = '-' then
        Result := -1;
   end;

   if Result <> 0 then exit;

   if minus then
      begin
        ch := '0';
        seek(a, 0);
        write(a, ch);
        seek(b, 0);
        write(b, ch);
      end;

   i := FileSize(a) - FileSize(b);
   if i > 0 then
   begin
      j := FileSize(b) - 1;
      repeat
        Seek(b, j);
        read(b, ch);
        Seek(b, j + i);
        write(b, ch);
        dec(j);
      until j < 0;

      seek(b, 0);
      ch := '0';
      for i := 1 to i do
        write(b, ch);
   end;

   i := FileSize(b) - FileSize(a);
   if i > 0 then
   begin
      j := FileSize(a) - 1;
      repeat
        Seek(a, j);
        read(a, ch);
        Seek(a, j + i);
        write(a, ch);
        dec(j);
      until j < 0;

      seek(a, 0);
      ch := '0';
      for i := 1 to i do
        write(a, ch);
   end;
   
// positivos
   i := 0;
   while Ler(a, i) = Ler(b, i) do
     inc(i);

   if Ler(a, i) > Ler(b, i)
      then Result := 1
      else Result := -1;

// negativos inverte
   if minus then Result := - Result;

   ZeroLTrimArq(a);
   ZeroLTrimArq(b);
end;

function  Multiplica(a,b: string): string; overload;
var i, j, LengthA, LengthB: integer;
    x, carry: byte;
    minus: boolean;
    subtotal, alfa: string;
    multAlgarismo: array[2..9] of string;
begin
   minus := (copy(a, 1, 1) = '-');
   if minus then delete(a, 1, 1);
   if copy(b, 1, 1) = '-' then
      begin
         delete(b, 1, 1);
         minus := not minus;
      end;

   for i := 2 to 9 do
   begin
     multAlgarismo[i] := '';
     carry := 0;

  // multiplicar i por cada algarismo de a
     for j := length(a) downto 1 do
        begin
           x := (byte(a[j]) - 48) * i + carry;
           carry := x div 10;
           x := x mod 10;
           multAlgarismo[i] := char(x + 48) + multAlgarismo[i];
        end;

     if carry <> 0 then
        multAlgarismo[i] := char(carry + 48) + multAlgarismo[i];
  	 application.mainForm.caption := inttostr(i);
	   application.processmessages;
   end;

   alfa := '- ' + inttostr(length(a)) + ' + ';
   LengthA := length(a);
   LengthB := length(b);

   Result := '0';
   for i := length(b) downto 1 do
     if b[i] <> '0' then
       begin
         subtotal := '';
      // zeros aa direita
         if i < length(b) then
            for j := 1 to length(b) - i do
               subtotal := '0' + subtotal;

         if b[i] = '1'
           then subtotal := a + subtotal
           else subtotal := multAlgarismo[(byte(b[i]) - 48)] + subtotal;

      // o resultado é a soma dos subtotais
         Result := soma(Result, subtotal);
         j := length(subtotal);
         Application.MainForm.caption := alfa + inttostr(j) + ' = ' + intToStr(- lengthA + j) + ' >> ' + FloatToStr((j - lengthA) * 100 / lengthB);
         application.processMessages;
       end;

   ZeroLTrim(Result);

   if minus then
      Result := '-' + Result;
end;

procedure Gravar(var a: TArquivo; s: string);
var i: integer;
begin
  rewrite(a);
  for i := 1 to length(s) do
    write(a, s[i]);
  Truncate(a);
end;

function  Multiplica(a,b, dir: string): string; overload;
var i, j: integer;
    x, carry: byte;
    minus: boolean;
    subtotal: string;
    multAlgarismo: array[2..9] of string;
    f: TextFile;
    t: TDateTime;
begin
  minus := (copy(a, 1, 1) = '-');
  if minus then delete(a, 1, 1);
  if copy(b, 1, 1) = '-' then
     begin
        delete(b, 1, 1);
        minus := not minus;
     end;

  if FileExists(dir + 'calcula.ini') then
  begin
    AssignFile(f, dir + 'calcula.ini');
    Reset(f);

    for i := 2 to 9 do
    begin
      readln(f);
      readln(f, multAlgarismo[i]);
    end;

    readln(f);
    readln(f, i);
    readln(f);
    readln(f, result);
    CloseFile(f);
  end
  else begin
    for i := 2 to 9 do
    begin
      multAlgarismo[i] := '';
      carry := 0;

   // multiplicar i por cada algarismo de a
      for j := length(a) downto 1 do
         begin
            x := (byte(a[j]) - 48) * i + carry;
            carry := x div 10;
            x := x mod 10;
            multAlgarismo[i] := char(x + 48) + multAlgarismo[i];
         end;

      if carry <> 0 then
         multAlgarismo[i] := char(carry + 48) + multAlgarismo[i];
    end;

    i := length(b) + 1;
    Result := '0';
  end;

  for i := i - 1 downto 1 do
    if b[i] <> '0' then
      begin
        t := Time; // vamos ver qto tempo leva

        subtotal := '';
     // zeros aa direita
        if i < length(b) then
           for j := 1 to length(b) - i do
              subtotal := '0' + subtotal;

        if b[i] = '1'
          then subtotal := a + subtotal
          else subtotal := multAlgarismo[(byte(b[i]) - 48)] + subtotal;

     // o resultado é a soma dos subtotais
        Result := soma(Result, subtotal);

        Application.title := inttostr(i) + ' - ' + TimeToStr(time - t);
        Application.MainForm.Caption := Application.Title;
        Application.ProcessMessages;

        if i mod 5 = 0 then // auto save
        begin
          AssignFile(f, dir + 'calcula_AutoSave.ini');
          rewrite(f);
          for j := 2 to 9 do
          begin
            writeln(f, '[' + inttostr(j) + ']');
            writeln(f, multAlgarismo[j]);
          end;

          writeln(f, '[i]');
          writeln(f, i);
          writeln(f, '[Result]');
          ZeroLTrim(Result);
          writeln(f, Result);
          CloseFile(f);
        end;

        if FileExists(dir + 'fechar.txt') then
        begin
          AssignFile(f, dir + 'calcula.ini');
          rewrite(f);
          for j := 2 to 9 do
          begin
            writeln(f, '[' + inttostr(j) + ']');
            writeln(f, multAlgarismo[j]);
          end;

          writeln(f, '[i]');
          writeln(f, i);
          writeln(f, '[Result]');
          ZeroLTrim(Result);
          writeln(f, Result);
          CloseFile(f);
          Application.Terminate;
          Result := 'HALT';
          exit;
        end;
      end;

  ZeroLTrim(Result);

  if minus then
    Result := '-' + Result;

  DeleteFile(dir + 'calcula.ini');
end;

procedure Divide(a,b: string; var q,r: string);
var minusa, minusb: boolean;
    x: byte;
    index, contador: integer;
begin
   if b = '0' then
      begin
         q := '0';
         r := '0';
         exit;
      end;

   minusa := (copy(a, 1, 1) = '-');
   minusb := (copy(b, 1, 1) = '-');
   if minusa then delete(a, 1, 1);
   if minusb then delete(b, 1, 1);

   contador := 0;
   q := '';
   index := length(b);
   r := copy(a, 1, index);
   repeat
      x := 0;
      while SNumCompare(r, b) >= 0 do
         begin
           inc(x);
           r := Subtrai(r, b);
           Application.ProcessMessages;
         end;
      q := q + char(x + 48);

      inc(contador);
      if contador mod 256 = 0 then
      begin
        Application.MainForm.Caption := {'Divisor = ' + b + '; r = ' + r + } 'Len(q) = ' + inttostr(contador);
        Application.Title := application.mainForm.Caption;
      end;
      Application.ProcessMessages;

      if index >= length(a) then break;

   // "baixar" o próximo
      inc(index);
      if r = '0' then r := ''; // zero de resto nao vai virar zero aa esq
      r := r + a[index];
   until false;

   ZeroLTrim(q);

//  7 /  4 = ( 1, 3)     a < 0, r > 0:  incrementar o módulo do quociente
// -7 /  4 = (-2, 1)                   complementar o resto
//  7 / -4 = (-1, 3)     exatamente um negativo: sinal '-' no quociente
// -7 / -4 = ( 2, 1)
   if minusa and (r <> '0') then
      begin
         q := Soma(q, '1');
         r := Subtrai(b, r);
      end;
   if minusa xor minusb then
      q := '-' + q;
end;

procedure DivideArq(var a,b,q,r: TArquivo);
var minusa, minusb: boolean;
    x: byte;
    index, contador: integer;
    ch: char;
    hum: TArquivo;
    s: string;
begin
   if FileSize(b) = 1 then
   begin
     read(b, ch);
     if ch = '0' then
      begin
         write(q, ch);
         write(r, ch);
         truncate(r);
         exit;
      end;
     seek(b, 0);
   end;

   read(a, ch);
   minusa := (ch = '-');
   read(b, ch);
   minusb := (ch = '-');
   seek(a, 0);
   seek(b, 0);
   ch := '0';
   if minusa then write(a, ch);
   if minusb then write(b, ch);

   contador := 0;
   index := FileSize(b);
   for x := 0 to index - 1 do
   begin
     read(a, ch);
     write(r, ch);
   end;
   repeat
      x := 0;
      while SNumCompareArq(r, b) >= 0 do
         begin
           inc(x);
           Gravar(r, SubtraiArq(r, b));
           Application.ProcessMessages;
         end;
      //showmessage(inttostr(contador) + ' ; ' + inttostr(filesize(r)));
      seek(q, filesize(q));
      ch := char(x + 48);
      write(q, ch);

      inc(contador);
      if contador mod 256 = 0 then
      begin
        Application.MainForm.Caption := {'Divisor = ' + b + '; r = ' + r + } 'Len(q) = ' + inttostr(contador);
        Application.Title := application.mainForm.Caption;
      end;
      Application.ProcessMessages;

      if index >= FileSize(a) - 1 then break;

   // "baixar" o próximo
      inc(index);
      if (FileSize(r) = 1) and (Ler(r, 0) = '0') then Gravar(r, ''); // zero de resto nao vai virar zero aa esq
      ch := Ler(a, index);
      Seek(r, FileSize(r));
      write(r, ch);
   until false;

   ZeroLTrimArq(q);

//  7 /  4 = ( 1, 3)     a < 0, r > 0:  incrementar o módulo do quociente
// -7 /  4 = (-2, 1)                   complementar o resto
//  7 / -4 = (-1, 3)     exatamente um negativo: sinal '-' no quociente
// -7 / -4 = ( 2, 1)
   if minusa and ((FileSize(r) <> 1) or (Ler(r, 0) <> '0')) then
      begin
         AssignFile(hum, '1.tmp');
         Gravar(hum, '1');
         Gravar(q, SomaArq(q, hum));
         CloseFile(hum);
         Gravar(r, SubtraiArq(b, r));
      end;
   if minusa xor minusb then
   begin
      x := FileSize(q) - 1;
      repeat
        Seek(q, x);
        read(q, ch);
        write(q, ch);
        dec(x);
      until x = 0;

      seek(q, 0);
      ch := '-';
      write(q, ch);
   end;
end;

function  Oposto(s: string): string;
begin
   if copy(s, 1, 1) = '-'
      then delete(s, 1, 1)
      else insert('-', s, 1);

   Result := s;
end;

function Potencia(a,b: string): string;
begin
  if SNumCompare(b, '0') <= 0 then
    Result := '1'
  else begin
    Result := a;
    while b <> '1' do
    begin
      Result := Multiplica(result, a);
      b := Subtrai(b, '1');
    end
  end;
end;

function Str2SFrac(a: string; b: string = ''): SFrac;
begin
   if b = '' then b := '1';
   Result.n := a;
   Result.d := b;
end;

function SFracAdd(a, b: SFrac): SFrac;
//var c: SFrac;
//    mdc, q1, q2, r: string;
begin
{
// reduzir a fraçao com os 2 denominadores => c
   c.n := a.d;
   c.d := b.d;
   SFracReduz(c);
   Divide(b.d, c.d, mdc, r);
   Divide(Multiplica(a.n, b.d), mdc, q1, r);
   Divide(Multiplica(a.d, b.n), mdc, q2, r);
   Result.n := Soma(q1, q2);
   Divide(Multiplica(a.d, b.d), mdc, q1, r);
   Result.d := q1;
   SFracReduz(Result);
}
   Result.n := Soma(Multiplica(a.n, b.d), Multiplica(a.d, b.n));
   Result.d := Multiplica(a.d, b.d);
   SFracReduz(Result);
end;

function SFracSub(a, b: SFrac): SFrac;
begin
   b.n := Oposto(b.n);
   Result := SFracAdd(a, b);
{
   Result.n := Subtrai(Multiplica(a.n, b.d), Multiplica(a.d, b.n));
   Result.d := Multiplica(a.d, b.d);
   SFracReduz(Result);
}
end;

function SFracMul(a, b: SFrac): SFrac;
//var aux: string;
begin
{
   aux := b.d;
   b.d := a.d;
   a.d := aux;
   SFracReduz(a);
   SFracReduz(b);
   Result.n := Multiplica(a.n, b.n);
   Result.d := Multiplica(a.d, b.d);
}
   Result.n := Multiplica(a.n, b.n);
   Result.d := Multiplica(a.d, b.d);
   SFracReduz(Result);
end;

function SFracDiv(a, b: SFrac): SFrac;
var aux: string;
begin
   aux := b.n;
   b.n := b.d;
   b.d := aux;
   Result := SFracMul(a, b);
end;

procedure SFracReduz(var frac: SFrac);
var f: file of longword;
    p: longword;
    ps, x, y, q1, q2, r: string;
    minusn, minusd,
    divx, divy: boolean;
begin
   FileMode := 0; // read only 
   AssignFile(f, PRIMOS_SOURCE);
   reset(f);

   minusn := (copy(frac.n, 1, 1) = '-');
   minusd := (copy(frac.d, 1, 1) = '-');
   if minusn then delete(frac.n, 1, 1);
   if minusd then delete(frac.d, 1, 1);
   if frac.n = '0' then frac.d := '1';

   x := frac.n;
   y := frac.d;
   p := 2;
   ps := '2';
   repeat
      Divide(x, ps, q1, r);
      divx := r = '0';
      Divide(y, ps, q2, r);
      divy := r = '0';

      if divx then x := q1;
      if divy then y := q2;
      if divx and divy then
         begin
            Divide(frac.n, ps, frac.n, r);
            Divide(frac.d, ps, frac.d, r);
         end;

      if not divx and not divy then
         begin
            read(f, p);
            ps := IntToStr(p);
         end;

      if (SNumCompare(x, ps) > 0) and (SNumCompare(x, IntToStr(p * p)) < 0) then
         ps := x
      else if (SNumCompare(y, ps) > 0) and (SNumCompare(y, IntToStr(p * p)) < 0) then
         ps := y;
   until (x = '1') or (y = '1') or eof(f) or (p > PRIMO_LIMITE);

   if (minusn xor minusd) and (frac.n <> '0') then
      frac.n := '-' + frac.n;

   CloseFile(f);
end;

function SFracDizima(frac: SFrac): string;
var d,           // dividendo
    alg,         // algarismo quociente
    restos: string;
    i, posicao: integer;
begin
   Divide(frac.n, frac.d, result, d);
   result := result + ',';
   restos := '.'; // é preciso ser entre pontos pq senao pega pedaço (4 de 14 p.ex.)
   posicao := 0; // só p/ nao dar warning

// achar o resto que se repete
{  exemplo:
       1/7 = (0,1)
      10/7 = 1,3
      30/7 = 4,2
      20/7 = 2,6
      60/7 = 8,4
      40/7 = 5,5
      50/7 = 7,1
      logo 1/7 = 0,(142857)
}
   if d <> '0' then
      repeat
         restos := restos + d + '.';      //.1.3.2.6.4.5.
         d := d + '0';
         Divide(d, frac.d, alg, d);
         result := result + alg;            //142857
         posicao := pos('.' + d + '.', restos);
      until (posicao > 0) or (d = '0');

   if d <> '0' then
      begin
      // contar os '.' da posiçao em diante (nro de algs da dízima)
         delete(restos, 1, posicao);
         posicao := 0;
         for i := 1 to length(restos) do
            if restos[i] = '.' then
               inc(posicao);

         insert('(', result, length(result) - posicao + 1);
         result := result + ')';
      end;
end;

function FatoresPrimos(x: string): string;
var fatorado, ps, q, r: string;
    f: file of longword;
    p: longword;
    expo: integer;
{
var x, ps, q, r, fatorado: string;
    p, p2: int64;
    n, counter, expo: integer;
}
begin
   if SNumCompare(x, '2') < 0 then
      begin
         Result := x;
         exit;
      end;

   fatorado := '';
   AssignFile(f, PRIMOS_SOURCE);
   reset(f);

   p := 2;
   ps := IntToStr(p);
   expo := 1;

   repeat
      Divide(x, ps, q, r);
      if (r = '0') and (x <> '0') then
         begin
            if pos(ps + ' * ', fatorado) > 0 then
               begin
                  inc(expo);
                  if q = '1' then
                     begin
                        fatorado := copy(fatorado, 1, length(fatorado) - 3);
                        fatorado := fatorado + ' ^ ' + IntToStr(expo) + ' * ';
                     end
               end
            else if expo = 1 then
               fatorado := fatorado + ps + ' * '
            else
               begin
                  fatorado := copy(fatorado, 1, length(fatorado) - 3);
                  fatorado := fatorado + ' ^ ' + IntToStr(expo) + ' * ' + ps + ' * ';
                  expo := 1;
               end;

            x := q;
         end
      else
      // próximo primo
         if eof(f) or (p > PRIMO_LIMITE) then
            ps := x
         else
            begin
               read(f, p);
               ps := inttostr(p);
            end;

      if (SNumCompare(x, ps) > 0) and (SNumCompare(x, Multiplica(ps, ps)) < 0) then
         ps := x;
   until x = '1';

   CloseFile(f);

   Result := copy(fatorado, 1, length(fatorado) - 3);
end;

begin
   PRIMO_LIMITE := 90000000;
end.
