unit SNum253;

interface

uses StdCtrls;

   procedure ReadLine253(nomeArq: string; var resultado: string);
   procedure From10to253(var s: string);
   procedure From253to10(var s: string);
   procedure Validar10(var s: string);
   procedure Validar253(var s: string);
   procedure ZeroRTrim253(var s: string);

   procedure Soma253(var resultado: string; b: string);
   procedure Multiplica253(var resultado: string; b: string; converterB: boolean = true);

implementation

uses SysUtils, Forms, SNum;

procedure ReadLine253(nomeArq: string; var resultado: string);
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
    resultado := resultado + ch;
  end;
  closeFile(f);
end;

procedure Validar253(var s: string);
var i: integer;
begin
   i := 1;
   while i <= length(s) do
      begin
         if s[i] <= #252
            then inc(i)
            else delete(s, i, 1);
      end;

   if s = '' then s := #0;

   ZeroRTrim253(s);
end;

procedure ZeroRTrim253(var s: string);
begin
  while (copy(s, length(s), 1) = #0) and (length(s) > 1) do
    delete(s, length(s), 1);
end;

procedure Validar10(var s: string);
var i: integer;
begin
   i := 1;
   while i <= length(s) do
      begin
         if s[i] in ['0'..'9','-']
            then inc(i)
            else delete(s, i, 1);
      end;

   if s = '' then s := '0';

 //ZeroLTrim
   while (copy(s, 1, 1) = '0') and (length(s) > 1) do
     delete(s, 1, 1);
end;

{
procedure From10to253(var s: string);
var s253, q, r: string;
begin
  s253 := '';
  while SNum.SNumCompare(s, '253') >= 0 do
  begin
    SNum.Divide(s, '253', q, r);
    s253 := s253 + chr(StrToInt(r));
    s := q;
    application.MainForm.Caption := intToStr(length(s253));
    application.Title := application.MainForm.Caption;
    application.ProcessMessages;
  end;
  s253 := s253 + chr(StrToInt(s));
  s := s253;
end;

procedure From253to10(var s: string);
var s10, q, r: string;
begin
  s10 := '';
  while SNumCompare253(s, #10) >= 0 do
  begin
    Divide253(s, #10, q, r);
    s10 := char(byte(r[1]) + 48) + s10;
    s := q;
    application.MainForm.Caption := intToStr(length(s10));
    application.Title := application.MainForm.Caption;
    application.ProcessMessages;
  end;
  s10 := char(byte(s[1]) + 48) + s10;
  s := s10;
end;

procedure From253to10Decrescente(var s: string);
var resultado: string;
    i: integer;
begin
  i := length(s);
  Resultado := IntToStr(byte(s[i]));
  while i >= 1 do
  begin
    SNum.Multiplica(Resultado, '253');
    dec(i);
    SNum.Soma(Resultado, IntToStr(byte(s[i])));
    application.mainform.caption := inttostr(i) + ' / ' + inttostr(length(s));
    application.processmessages;
  end;
  s := resultado;
end;

procedure From250to10(var s: string);
var base, potencia10, subtotal, resultado, q, r: string;
    i: integer;
begin
  i := 1;
  base := '1';
  Resultado := '0';
  potencia10 := '1';
  while i <= length(s) do
  begin
    subtotal := StringReplace(potencia10, '1', inttostr(byte(s[i])), []);
    SNum.Divide(subtotal, base, q, r);
    SNum.Soma(Resultado, q);
  //next
    SNum.Multiplica(base, '4');
    potencia10 := potencia10 + '000';
    inc(i);
    application.mainform.caption := inttostr(i) + ' / ' + inttostr(length(s));
    application.processmessages;
  end;
  s := resultado;
end;
}

procedure From253to10(var s: string);
var base, subtotal, resultado: string;
    i: integer;
begin
  i := 1;
  base := '1';
  Resultado := '0';
  while i <= length(s) do
  begin
    subtotal := base;
    SNum.Multiplica(subtotal, IntToStr(byte(s[i])));
    SNum.Soma(Resultado, subtotal);
  //next
    SNum.Multiplica(base, '253');
    inc(i);
    application.mainform.caption := inttostr(i) + ' / ' + inttostr(length(s));
    application.processmessages;
  end;
  s := resultado;
end;

procedure From10to253(var s: string);
var base, subtotal, resultado: string;
    i: integer;
begin
  i := length(s);
  base := #1;
  Resultado := #0;
  while i >= 1 do
  begin
    subtotal := base;
    Multiplica253(subtotal, char(byte(s[i]) - 48), false); // não converter B evita recorrência
    Soma253(Resultado, subtotal);
  //next
    Multiplica253(base, #10, false); // não converter B evita recorrência
    dec(i);
  end;
  s := resultado;
end;

procedure Soma253(var resultado: string; b: string);
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
    a := a + #0;

//008765
//123400
  i := 1;
  while (i < x) and (b[i] = #0) do
    inc(i);

  Resultado := copy(a, 1, i - 1);
  delete(a, 1, i - 1);
  delete(b, 1, i - 1);

  carry := 0;
  for i := 1 to length(b) do
     begin
        x := byte(a[i]) + byte(b[i]) + carry;
        if x >= 253 then
           begin
              carry := 1;
              dec(x, 253);
           end
        else carry := 0;
        Resultado := Resultado + chr(x);
     end;
  if carry <> 0 then
     Resultado := Resultado + char(carry);
end;

procedure Multiplica253(var resultado: string; b: string; converterB: boolean = true);
var i, j, x, carry: integer;
    a, subtotal: string;
    multAlgarismo: array[2..252] of string;
begin
   a := resultado;
   if converterB then
     From10to253(b);

   for i := 2 to 252 do
   begin
     multAlgarismo[i] := '';
     carry := 0;

  // multiplicar i por cada algarismo de a
     if pos(chr(i), b) > 0 then
       for j := 1 to length(a) do
       begin
         x := byte(a[j]) * i + carry;
         carry := x div 253;
         x := x mod 253;
         multAlgarismo[i] := multAlgarismo[i] + chr(x);
       end;

	  if carry <> 0 then
        multAlgarismo[i] := multAlgarismo[i] + chr(carry);

   end;

   Resultado := #0;
   for i := 1 to length(b) do
     if b[i] <> #0 then
       begin
         subtotal := '';
      // zeros aa direita
         if i > 1 then
            for j := 1 to i - 1 do
               subtotal := subtotal + #0;

         if b[i] = #1
           then subtotal := subtotal + a
           else subtotal := subtotal + multAlgarismo[byte(b[i])];

      // o resultado é a soma dos subtotais
         soma253(Resultado, subtotal);
         begin
           application.title := 'multiplica ' + inttostr(length(resultado));
           application.mainform.Caption := application.title;
           application.processMessages;
         end;
       end;

   ZeroRTrim253(Resultado);
end;

end.
