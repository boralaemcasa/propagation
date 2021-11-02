unit SNum;

interface

const
   PRIMOS_SOURCE = 'primos novos.dat';

var
   PRIMO_LIMITE: longword;

type
   SFrac = record
      n, d: string;
   end;

   function Valida(s: string): string;

// as funçoes abaixo já partem de q as strings sao válidas
   function  Soma(a,b: string): string;
   function  Subtrai(a,b: string): string;
   function  Multiplica(a,b: string): string; overload;
   function  Multiplica(a,b, dir: string): string; overload;
   procedure Divide(a,b: string; var q,r: string);
   function  Potencia(a,b: string): string;

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

uses SysUtils, Forms;

procedure ZeroLTrim(var s: string);
begin
  while (copy(s, 1, 1) = '0') and (length(s) > 1) do
    delete(s, 1, 1);
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

function  Multiplica(a,b: string): string; overload;
var i, j: integer;
    x, carry: byte;
    minus: boolean;
    subtotal: string;
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
   end;

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
       end;

   ZeroLTrim(Result);

   if minus then
      Result := '-' + Result;
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
    index: integer;
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

   q := '';
   index := length(b);
   r := copy(a, 1, index);
   repeat
      x := 0;
      while SNumCompare(r, b) >= 0 do
         begin
            inc(x);
            r := Subtrai(r, b);
         end;
      q := q + char(x + 48);
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
