unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button4: TButton;
    Button5: TButton;
    Tree: TTreeView;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TreeDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    A, A2: array[0..1658880] of word; // conjuntos, [0] é contador
  end;

var
  Form1: TForm1;
  f: file of word;

implementation

{$R *.DFM}

uses snum;

function espacos(convert: word; len: byte): string;
begin
   result := inttostr(convert);
   while length(result) < len do
      result := ' ' + result;
end;

function M(n: integer): word;
begin
   seek(f, n);
   read(f, Result);
end;

procedure Grava(n: word);
begin
   Seek(f, FileSize(f));
   write(f, n);
end;

procedure TForm1.Button1Click(Sender: TObject);
var f: file of longword;
    p, p_ant, max: longword;
begin
   Button1.Enabled := false;
   AssignFile(f, PRIMOS_SOURCE);
   reset(f);

   p_ant := 2;
   max := 0;
   while not eof(f) do
      begin
         read(f, p);
         if p - p_ant > max then
            begin
               max := p - p_ant;
               Memo.Lines.Add(IntToStr(p) + ' - ' + IntToStr(p_ant) + ' = ' + IntToStr(max));
            end;
         p_ant := p;
      end;

   CloseFile(f);

   Button1.Enabled := true;
   Button1.Caption := 'Concluido';
end;

procedure TForm1.Button2Click(Sender: TObject);
var n, n_ant, previsao,
    aux, i, ini, min_linhas: integer;

begin
   Memo.Clear;
   Application.ProcessMessages;
   ini := strtoint(edit1.text);
   min_linhas := strtoint(edit2.text);

   AssignFile(f, 'd:\tmp');
   rewrite(f);

   previsao := 0;
   // do 5, eliminar M(3) =>  ok 2,4, 2,4, 2    6x
   // do 7,          M(5) =>   8 linhas        30
   // do 11,         M(7) =>  48 linhas       210
   // do 13,        M(11) => 480 linhas      2310
   //    17                 5760            30030
   //    19
   n := INI;
   repeat
      n_ant := n;
      repeat
         inc(n, 2);
         aux := 1;
         for i := 3 to INI - 1 do
            if n mod i = 0 then
               begin
                  aux := 0;
                  break;
               end;
      until aux > 0;
      Grava(n - n_ant);
      if n - n_ant = previsao then break;

   // prever
      aux := FileSize(f);
      if (aux < MIN_LINHAS * 2) or odd(aux) then continue;
      aux := aux div 2;

      previsao := 1;
      for i := 0 to aux - 1 do
         if M(i) <> M(aux + i) then
            begin
               previsao := 0;
               break;
            end;

      if previsao > 0 then
         previsao := M(0);
   until false;

   n := INI;
   aux := FileSize(f);
   for i := 0 to aux - 1 do
      begin
         if (i = 0) or (i = aux div 2) or (i = aux - 1) then
            Memo.Lines.Add(inttostr(n));
         n := n + M(i);
      end;

   Memo.Lines.Add('delta1 = ' + IntToStr(StrToInt(Memo.Lines[1]) - StrToInt(Memo.Lines[0])));
   Memo.Lines.Add('delta2 = ' + IntToStr(StrToInt(Memo.Lines[2]) - StrToInt(Memo.Lines[1])));
   Memo.Lines.Add(inttostr((aux - 1) div 2) + ' linhas');
   for i := 0 to (aux - 1) div 2 - 1 do
      Memo.lines.add(inttostr(M(i)));
   Memo.SetFocus;
   CloseFile(f);
end;

function is_prime(x: word): boolean;
var i: word;
begin
   for i := 2 to x do
      if x < i * i then
         break
      else if x mod i = 0 then
         begin
            Result := false;
            exit;
         end;

   Result := true;
end;

procedure TForm1.Button4Click(Sender: TObject);
var b, n0, n1, n2, n3, n4: byte;
    x: word;
begin
   for n4 := 0 to 10 do
      for n3 := 0 to 6 do
         for n2 := 0 to 4 do
            for n1 := 0 to 2 do
               for n0 := 0 to 1 do
                  begin
                     x := 2 + n0 + 2*n1 + 2*3*n2 + 2*3*5*n3 + 2*3*5*7*n4;
                     if is_prime(x) then
                        begin
                           b := n4;
                           if b > 9
                              then inc(b, 55)
                              else inc(b, 48);
                           Memo.Lines.Add(Format('%s%d%d%d%d = %d', [char(b), n3, n2, n1, n0, x]));
                        end;
                  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var b,        // 2*3*5*7 *...
    i,        // contador 1 .. A[0]
    x,        // contador 0 .. min(A) - 1
    c,        // "único", 0 .. min(A) - 1
    j,        // auxiliar
    line:     // linha onde escrever
       word;
    s: string;
    level: byte;
    list: TStringList;
    limite: integer;

function a_min: word;
var i: word;
begin
   Result := A[1];
   for i := 2 to A[0] do
      if A[i] < Result then
         Result := A[i];
end;

const TREE_FILE = 'c:\tmp.tmp';

begin
   limite := strtoint(edit1.text);
   list := TStringList.Create;
   A[0] := 1; A[1] := 2; // A := {2}
   b := 1;
   list.Add('2...');
   level := 0;
   repeat
      inc(level);
   {
      Afirmaçao:
         para todo a pertenc A, existe único c, 0 <= c < min(A) tal que
         a + bc = q * min(A), ou, (a + bc) mod min(A) = 0

      Construçao:
         A2 := {a + bx: a pertenc A, 0 <= x < min(A), x <> c
   }
      A2[0] := 0;
      for i := 1 to A[0] do
         for x := 0 to a_min - 1 do
            begin
               if x = 0 then
                  begin
                     for j := 0 to list.Count - 1 do
                        if (copy(list[j], length(list[j])-2, 3) = '...') then
                           if level = 1 then
                              break
                           else if (list[j][level] <> #9) and (list[j][level - 1] = #9) then
                              break;
                     s := list[j];
                     Delete(s, length(s) - 2, 3);
                     list[j] := s;
                     line := j + 1;
                  end;

               for c := 0 to a_min - 1 do
                  if (A[i] + b * c) mod a_min = 0 then
                     break; // c relativo a A[i] encontrado

               if x <> c then
                  begin
                     inc(A2[0]);
                     A2[A2[0]] := A[i] + b * x;
                     s := Format('%d + %d * %d = %d = %s...', [A[i], b, x, A[i] + b * x, FatoresPrimos(IntToStr(A[i] + b * x))]);
                     //*s := Format('%d + %d * %d = %d...', [A[i], b, x, A[i] + b * x]);
                  end
               //else s := Format('%d + %d * %d = %d = %d * %d => Cancela %d + %dx', [A[i], b, x, A[i] + b * x, a_min, (A[i] + b * c) div a_min, A[i] + b * c, b * a_min]);
               else s := Format('%s + %d * %s = %d = %d * %d          => Cancela', [espacos(A[i], 3), b, espacos(x, 2), A[i] + b * x, a_min, (A[i] + b * c) div a_min, A[i] + b * c, b * a_min]);

               for j := 1 to level do
                  s := #9 + s;
               list.Insert(line, s);
               inc(line);
            end;

      b := b * a_min;
      A := A2;
   (*
      Afirmaçoes:
         min(A) é primo.
         para todo a pertenc A, para todo x >= 0,
            para todo d pertenc D(a + bx) - {1}, d >= min(A).
   *)
   until a_min > limite;

   list.SaveToFile(TREE_FILE);
//   Tree.LoadFromFile(TREE_FILE);

   Memo.Clear;
   Memo.Lines.Add('ORIGENS');
   for j := 0 to list.Count - 1 do
      if (list[j][level] <> #9) and (list[j][level - 1] = #9) and
            (pos('Cancela', list[j]) = 0) then
         Memo.Lines.Add(copy(list[j], level, length(list[j])));

   Memo.Lines.Add('');
   Memo.Lines.Add('CANCELADOS');
   inc(level);
   for j := 0 to list.Count - 1 do
      if (list[j][level] <> #9) and (list[j][level - 1] = #9) and
            (pos('Cancela', list[j]) > 0) then
         Memo.Lines.Add(copy(list[j], level, length(list[j])));

   Memo.Lines.Add('');
   Memo.Lines.Add('NAO PRIMOS');
   for j := 0 to list.Count - 1 do
      if (list[j][level] <> #9) and (list[j][level - 1] = #9) then
         begin
            s := list[j];
            while not (s[length(s)] in ['=','*','^']) do
               delete(s, length(s), 1);
            if s[length(s)] <> '=' then
               Memo.Lines.Add(copy(list[j], level, length(list[j]) - level - 2));
         end;

   list.free;
end;

procedure TForm1.Button6Click(Sender: TObject);
var f: file of longword;
    p, plido: longword;
    i: word;
    b: 2..26+10;
    s: string;

function caracter(x: word): string;
begin
   if x < 10 then
      Result := char(x + 48)
   else if x < 10 + 26 then
      Result := char(x + 55)
   else
      Result := '[' + IntToStr(x) + ']';
end;

begin
   Memo.Clear;
   AssignFile(f, PRIMOS_SOURCE);
   reset(f);
   p := 2;
   plido := 2;
   b := StrToInt(Edit1.Text);
   for i := 1 to StrToInt(Edit2.Text) do
      begin
         s := '';
         while p >= b do
            begin
               s := caracter(p mod b) + s;
               p := p div b;
            end;
         if p > 0 then
            s := caracter(p) + s;

         while length(s) < 10 do
            s := ' ' + s;
         Memo.Lines.Add(s + ' = ' + IntToStr(plido));

         read(f, p);
         plido := p;
      end;
end;

procedure TForm1.TreeDblClick(Sender: TObject);
begin
   tree.top := memo.top;
   tree.height := 505;
end;

procedure TForm1.FormCreate(Sender: TObject);
var f: file of longword;
    p, i: longword;
begin
   Button1.Enabled := false;
   AssignFile(f, PRIMOS_SOURCE);
   reset(f);
   for i := 1 to 50 do
      begin
         read(f, p);
         memo.lines.add(espacos(i, 2) + espacos(p, 5));
      end;

   closefile(f);
end;

end.
