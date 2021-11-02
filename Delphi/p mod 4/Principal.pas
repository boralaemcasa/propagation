unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function inteiroToStr(x: longword): string;
var i: integer;
begin
  result := inttostr(x);
  i := length(result) - 2;
  while i >= 2 do
  begin
    insert('.', result, i);
    dec(i, 3);
  end;
end;

function five(s: string): string;
begin
  result := s;
  while length(result) < 5 do
    result := ' ' + result;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  f: file of longword;
  p: longword;
  t1, t2, t3: TextFile;
begin
  assignFile(t1, 'primos1Mod6.txt');
  assignFile(t3, 'primos5Mod6.txt');
  assignFile(t2, 'primosMod6.txt');

  rewrite(t1);
  rewrite(t2);
  rewrite(t3);

  fileMode := 0;
  assignfile(f, 'J:\tenho offline\Delphi\Fatorador\primos novos.dat');
  reset(f);
  while not eof(f) do
  begin
    read(f, p);
    if p mod 6 = 1 then
    begin
      writeln(t1, p);
      writeln(t2, p, ' = 1');
    end
    else
    begin
      writeln(t3, p);
      writeln(t2, p, ' = 5');
    end;
    if filepos(f) mod 10000 = 0 then
    begin
      caption := inteirotostr(p);
      Application.ProcessMessages;
    end;
  end;

  closefile(f);
  closefile(t1);
  closefile(t2);
  closefile(t3);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  f: file of longword;
  p: longword;
  t0, t1, t7, t11, t13, t17, t19, t23, t29: TextFile;
begin
  assignFile(t1,  'primos01Mod30.txt');
  assignFile(t7,  'primos07Mod30.txt');
  assignFile(t11, 'primos11Mod30.txt');
  assignFile(t13, 'primos13Mod30.txt');
  assignFile(t17, 'primos17Mod30.txt');
  assignFile(t19, 'primos19Mod30.txt');
  assignFile(t23, 'primos23Mod30.txt');
  assignFile(t29, 'primos29Mod30.txt');
  assignFile(t0,  'primosMod30.txt');

  rewrite(t1);
  rewrite(t7);
  rewrite(t11);
  rewrite(t13);
  rewrite(t17);
  rewrite(t19);
  rewrite(t23);
  rewrite(t29);
  rewrite(t0);

  fileMode := 0;
  assignfile(f, 'J:\tenho offline\Delphi\Fatorador\primos novos.dat');
  reset(f);
  while not eof(f) do
  begin
    read(f, p);
    case p mod 30 of
       1: writeln(t1, p);
       7: writeln(t7, p);
      11: writeln(t11, p);
      13: writeln(t13, p);
      17: writeln(t17, p);
      19: writeln(t19, p);
      23: writeln(t23, p);
      29: writeln(t29, p);
    end;

    writeln(t0, p, ' = ', p mod 30);

    if filepos(f) mod 10000 = 0 then
    begin
      caption := inteirotostr(p);
      Application.ProcessMessages;
    end;
  end;

  closefile(t1);
  closefile(t7);
  closefile(t11);
  closefile(t13);
  closefile(t17);
  closefile(t19);
  closefile(t23);
  closefile(t29);
  closefile(t0);
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
var
  i: integer;
  s1, s2, s3, s4, s5, s6, s7, s8: string;
  t1, t7, t11, t13, t17, t19, t23, t29: TextFile;
begin
  filemode := 0;
  assignFile(t1,  'gemeos01Mod30.txt');
  assignFile(t7,  'gemeos07Mod30.txt');
  assignFile(t11, 'gemeos11Mod30.txt');
  assignFile(t13, 'gemeos13Mod30.txt');
  assignFile(t17, 'gemeos17Mod30.txt');
  assignFile(t19, 'gemeos19Mod30.txt');
  assignFile(t23, 'gemeos23Mod30.txt');
  assignFile(t29, 'gemeos29Mod30.txt');

  reset(t1);
  reset(t7);
  reset(t11);
  reset(t13);
  reset(t17);
  reset(t19);
  reset(t23);
  reset(t29);

  memo.clear;

  for i := 1 to 5000 do
  begin
    readln(t1, s1);
    readln(t7, s2);
    readln(t11, s3);
    readln(t13, s4);
    readln(t17, s5);
    readln(t19, s6);
    readln(t23, s7);
    readln(t29, s8);

    memo.lines.add(five(s1) + ' ' + five(s2) + ' ' + five(s3) + ' ' + five(s4) + ' '
                 + five(s5) + ' ' + five(s6) + ' ' + five(s7) + ' ' + five(s8));
  end;

  closefile(t1);
  closefile(t7);
  closefile(t11);
  closefile(t13);
  closefile(t17);
  closefile(t19);
  closefile(t23);
  closefile(t29);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: integer;
  s1, s2: string;
  t1, t5: TextFile;
begin
  filemode := 0;
  assignFile(t1,  'primos1Mod6.txt');
  assignFile(t5,  'primos5Mod6.txt');

  reset(t1);
  reset(t5);

  memo.clear;
  readln(t5, s2); // 3 sobrando lá, caiu no else

  for i := 1 to 5000 do
  begin
    readln(t1, s1);
    readln(t5, s2);

    memo.lines.add(five(s1) + ' ' + five(s2));
  end;

  closefile(t1);
  closefile(t5);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: integer;
  t: TextFile;
  s: string;
begin
  filemode := 0;
  assignFile(t,  'primosMod30.txt');
  reset(t);

  memo.clear;

  for i := 1 to 5000 do
  begin
    readln(t, s);
    memo.lines.add(s);
  end;

  closefile(t);
end;

end.
