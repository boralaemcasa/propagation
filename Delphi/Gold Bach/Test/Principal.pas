unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    CheckBox1: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure TForm1.Button1Click(Sender: TObject);
var 
  p: longword; 
  f: file of longword;
  nextPerfect, counter, square, left: int64;
begin
  memo.clear;
  fileMode := 0;
  assignfile(f, '..\primos novos.dat');
  reset(f);
  p := 2;
  nextPerfect := 3;
  repeat
    counter := 0;
    square := nextPerfect * nextPerfect;
    repeat
      left := p * 13;
      if left > square then
        break;
      counter := counter + 1;
      memo.lines.add('13 * ' + inttostr(p));
      read(f, p);
    until false;
    memo.lines.add('Counter = ' + inttostr(counter));
    memo.lines.add(inttostr(square));
    if counter = 0 then
      showmessage('before ' + inttostr(square));
    nextPerfect := nextPerfect + 1;
    application.processmessages;
  until (square > 1024 * 1024) or checkbox1.checked;
  closefile(f);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  f: file of longword;
  p, counter: longword;
begin
  counter := 0;
  memo.clear;
  fileMode := 0;
  assignfile(f, '..\primos novos.dat');
  reset(f);
  repeat
    read(f, p);
    if p > 1000000 then
      break;
    inc(counter);
  until false;
  memo.lines.add(inttostr(counter));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  p, q, i, j: longword;
  f: file of longword;
  s: string;
begin
  memo.clear;
  fileMode := 0;
  assignfile(f, '..\primos novos.dat');
  reset(f);

  for i := 0 to 50 do
    for j := i + 1 to 50 do
    begin
      if checkbox1.checked then
      begin
        closefile(f);
        exit;
      end;

      seek(f, i);
      read(f, p);
      seek(f, j);
      read(f, q);
      s := inttostr(p) + ' * ' + inttostr(q) + ' = ' + inttostr(p * q);
      while length(s) < 30 do
        s := s + ' ';
      s := s + inttostr(p) + ' + ' + inttostr(q) + ' = ' + inttostr(p + q);
      memo.lines.add(s);
    end;

  closefile(f);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  f: file of longword;
  i, p1, p2, max, min, j: longword;
begin
  memo.clear;
  fileMode := 0;
  assignfile(f, '..\primos novos.dat');
  reset(f);
  i := 0;
  repeat
    seek(f, i);
    read(f, p1);
    min := i + 1;
    max := filesize(f);
    repeat
      j := (min + max) div 2;
      seek(f, j);
      read(f, p2);
      if p2 = 4 * p1 + 3 then
        break;

      if p2 < 4 * p1 + 3 then
        min := j + 1
      else
        max := j - 1;
    until min >= max;

    if p2 = 4 * p1 + 3 then
    begin
      memo.lines.add(inttostr(p1));
      application.ProcessMessages;
    end;

    inc(i);
  until eof(f) or CheckBox1.Checked;

  closefile(f);
end;

end.
