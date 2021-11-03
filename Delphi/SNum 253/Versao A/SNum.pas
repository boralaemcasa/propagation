unit SNum;

interface

uses StdCtrls;

const
   PRIMOS_SOURCE = 'D:\Vi\Matemática\EXEs\primos novos.dat';

var
   PRIMO_LIMITE: longword;

type
   SFrac = record
      n, d: string;
   end;

   function Valida(s: string): string;

// as funçoes abaixo já partem de q as strings sao válidas
   procedure Soma(var resultado: string; b: string);
   procedure Soma6(var a,b,c,d,e,f: string; var resultado: string);
   function  Subtrai(a,b: string): string;
   procedure Multiplica(var resultado: string; b: string);
   procedure Divide(a,b: string; var q,r: string);

   function  SNumCompare(a,b: string): shortint;
   function  Oposto(s: string): string;

   procedure ReadLine(nomeArq: string; var resultado: string);
   procedure WriteLine(nomeArq: string; var s: string);

// fraçoes
   function  Str2SFrac(a: string; b: string = ''): SFrac;
   procedure SFracReduz(var frac: SFrac);
   function  SFracDizima(frac: SFrac): string;

implementation

uses SysUtils, Forms;

procedure ReadLine(nomeArq: string; var resultado: string);
var f: file of char;
    ch: char;
begin
  Resultado := '';
  assignFile(f, nomeArq);
  fileMode := 0;
  reset(f);
  while not eof(f) do
  begin
    read(f, ch);
    if (ch = #13) or (ch = #10) then
      break;
    resultado := resultado + ch;
  end;
  closeFile(f);
end;

procedure WriteLine(nomeArq: string; var s: string);
var f: file of char;
    i: integer;
begin
  assignFile(f, nomeArq);
  rewrite(f);
  for i := 1 to length(s) do
    write(f, s[i]);
  closeFile(f);
end;

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

procedure Soma(var resultado: string; b: string);
var i, x: integer;
    carry: byte;
    a: string;
begin
  a := resultado;
  if length(a) > length(b) then // troca a, b
  begin
    Resultado := a;
    a := b;
    b := Resultado;
  end;

  x := length(b);
  while length(a) < x do
    a := '0' + a;

//008765
//123400
  i := x;
  while (i > 0) and (b[i] = '0') do
    dec(i);

  Resultado := copy(a, i + 1, x - i);
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
        if i mod 64 = 0 then
          Application.ProcessMessages;
        Resultado := char(x + 48) + Resultado;
     end;
  if carry <> 0 then
     Resultado := '1' + Resultado;
end;

procedure Soma6(var a,b,c,d,e,f: string; var resultado: string);
var i, x: integer;
    carry: byte;
begin
  x := length(f);
  while length(a) < x do
    a := '0' + a;
  if b <> '0' then
    while length(b) < x do
      b := '0' + b;
  if c <> '0' then
    while length(c) < x do
      c := '0' + c;
  if d <> '0' then
    while length(d) < x do
      d := '0' + d;
  if e <> '0' then
    while length(e) < x do
      e := '0' + e;

//008765
//123400
  Resultado := '';

  carry := 0;
  for i := x downto 1 do
     begin
        x := byte(a[i]) - 48 + byte(f[i]) - 48 + carry;
        if b <> '0' then
          inc(x, byte(b[i]) - 48);
        if c <> '0' then
          inc(x, byte(c[i]) - 48);
        if d <> '0' then
          inc(x, byte(d[i]) - 48);
        if e <> '0' then
          inc(x, byte(e[i]) - 48);
        carry := x div 10;
        x := x mod 10;
        if i mod 256 = 0 then
        begin
          application.title := inttostr(length(resultado));
          application.mainform.Caption := application.title;
          application.processMessages;
        end;

        Resultado := char(x + 48) + Resultado;
     end;
  if carry <> 0 then
     Resultado := char(carry + 48) + Resultado;
end;

function  Subtrai(a,b: string): string;
var i: integer;
    x, carry: shortint;
begin
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
begin
   Result := 0;
   if a = b then exit;

   if Result <> 0 then exit;

   while length(b) < length(a) do
      b := '0' + b;
   while length(a) < length(b) do
      a := '0' + a;

// positivos
   if a > b
      then Result := 1
      else Result := -1;
end;

procedure Multiplica(var resultado: string; b: string);
var i, j: integer;
    x, carry: byte;
    minus: boolean;
    a, subtotal: string;
    subtotais: array[1..6] of string;
    multAlgarismo: array[2..9] of string;
begin
   a := resultado;
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
     if pos(char(i + 48), b) > 0 then
       for j := length(a) downto 1 do
       begin
         x := (byte(a[j]) - 48) * i + carry;
         carry := x div 10;
         x := x mod 10;
         multAlgarismo[i] := char(x + 48) + multAlgarismo[i];
       end;

     if carry <> 0 then
        multAlgarismo[i] := char(carry + 48) + multAlgarismo[i];

     Application.ProcessMessages;
   end;

   Resultado := '0';
   if length(b) = 6 then
   begin
     for i := length(b) downto 1 do
       if b[i] <> '0' then
         begin
           subtotais[i] := '';
        // zeros aa direita
           if i < length(b) then
              for j := 1 to length(b) - i do
                 subtotais[i] := '0' + subtotais[i];

           if b[i] = '1'
             then subtotais[i] := a + subtotais[i]
             else subtotais[i] := multAlgarismo[(byte(b[i]) - 48)] + subtotais[i];
         end
       else subtotais[i] := '0';

  // o resultado é a soma dos subtotais
     soma6(subtotais[6], subtotais[5], subtotais[4], subtotais[3], subtotais[2], subtotais[1], Resultado);
   end
   else // tradicional
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
         soma(Resultado, subtotal);

         //application.title := 'multiplica ' + inttostr(length(resultado));
         //application.mainform.Caption := application.title;
         //application.processMessages;
       end;

   ZeroLTrim(Resultado);

   if minus then
      Resultado := '-' + Resultado;
end;

procedure Divide(a,b: string; var q,r: string);
var x: byte;
    index: integer;
begin
   if b = '0' then
      begin
         q := '0';
         r := '0';
         exit;
      end;

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
end;

function  Oposto(s: string): string;
begin
   if copy(s, 1, 1) = '-'
      then delete(s, 1, 1)
      else insert('-', s, 1);

   Result := s;
end;

function Str2SFrac(a: string; b: string = ''): SFrac;
begin
   if b = '' then b := '1';
   Result.n := a;
   Result.d := b;
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

begin
   PRIMO_LIMITE := 90000000;
end.
