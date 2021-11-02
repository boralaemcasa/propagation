program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var f: file of int64;
    p1, p2: int64;
    i: longint;
    eee: string;
    t: textfile;
begin
  assignfile(t, 'espelho.txt');
  rewrite(t);
  assignfile(f, 'primos 64.dat');
  reset(f);
  for i := filesize(f) - 1 downto 0 do
  begin
    seek(f, i);
    read(f, p2);
    seek(f, i - 1);
    read(f, p1);
    if p2 = p1 + 2 then
    begin
      writeln(p1);
      writeln(t, p1);
      readln(eee);
      if uppercase(eee) = 'EXIT' then
        exit;
    end;
  end;
  closefile(f);
  closefile(t);
end.
