program ap07ex02;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TRegistro = record
                nome: string[50];
                idade: integer;
                peso, altura: double;
              end;
  TVetor = array[1..900] of TRegistro;
  PVetor = ^TVetor;

function nova_pessoa: TRegistro;
var reg: TRegistro;
begin
  write('Nome: ');
  readln(reg.nome);
  write('Idade: ');
  readln(reg.idade);
  write('Peso: ');
  readln(reg.peso);
  write('Altura: ');
  readln(reg.altura);
  result := reg;
end;

var vet: TVetor;
    i, n: integer;
begin
  write('Entre com n: ');
  readln(n);

  for i := 1 to n do
    begin
      write('Entre com Vet ');
      writeln(i);
      vet[i] := nova_pessoa();
    end;

  for i := 1 to n do
    begin
      write('Vet ');
      writeln(i);
      write('Nome: ');
      writeln(vet[i].nome);
      write('Idade: ');
      writeln(vet[i].idade);
      write('Peso: ');
      writeln(vet[i].peso);
      write('Altura: ');
      writeln(vet[i].altura);
    end;

  readln;
end.
