program ap07ex01;

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

var vet: TVetor;
    i, n: integer;
begin
  write('Entre com n: ');
  readln(n);

  for i := 1 to n do
    begin
      write('Entre com Vet ');
      writeln(i);
      write('Nome: ');
      readln(vet[i].nome);
      write('Idade: ');
      readln(vet[i].idade);
      write('Peso: ');
      readln(vet[i].peso);
      write('Altura: ');
      readln(vet[i].altura);
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
