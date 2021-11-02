program ap09;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function mdc(a, b: integer): integer;
var q, r: integer;
begin
  if a < b then
  begin
    result := mdc(b, a);
    exit;
  end;

  q := a div b;
  r := a mod b;

  if r = 0 then
  begin
    result := b;
    exit;
  end;

  result := mdc(b, r);
end;

function fib(n: integer): integer;
begin
  if (n = 0) or (n = 1) then
  begin
    result := n;
    exit;
  end;

  result := fib(n - 1) + fib(n - 2);
end;

type TPonto = record
                x,y: double;
              end;
              
type TRetangulo = record
                    inferiorEsquerdo: TPonto;
                    altura, largura: double;
                  end;

function estaDentro(r: TRetangulo; p: TPonto): boolean;
begin
  if
  (r.inferiorEsquerdo.x <= p.x)
  and
  (p.x <= r.inferiorEsquerdo.x + r.largura)
  and
  (r.inferiorEsquerdo.y - r.altura <= p.y)
  and
  (p.y <= r.inferiorEsquerdo.y)
  then
  result := true
  else
  result := false;
end;

var i, nota, maiorNota: integer;
    r: TRetangulo;
    p: TPonto;
    f: TextFile;
    s, nome, maiorNome: string[50];

begin
  writeln(mdc(530, 1230));
  for i := 0 to 10 do
    writeln(fib(i));

  r.inferiorEsquerdo.x := 100;
  r.inferiorEsquerdo.y := 200;
  r.largura := 60;
  r.altura := 200;
  p.x := 155;
  p.y := 15;
  if estaDentro(r, p) then
    writeln('sim')
  else
    writeln('nao');

  AssignFile(f, 'notas.txt');
  reset(f);

  maiorNota := -1;

  while not eof(f) do
  begin
    readln(f, s);
    i := pos(',', s);
    nome := copy(s, 1, i - 1);
    nota := StrToInt(copy(s, i + 1, length(s) - i));
    if nota > maiorNota then
    begin
      maiorNota := nota;
      maiorNome := nome;
    end;
  end;

  closefile(f);

  write(maiorNome);
  write(',');
  write(maiorNota);

  readln;
end.
