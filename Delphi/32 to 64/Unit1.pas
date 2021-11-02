unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
var f: file of longword;
    g: file of int64;
    p: longword;
    p2: int64;
begin
  assignfile(f, 'J:\tenho offline\Delphi\Fatorador\primos novos.dat');
  reset(f);
  assignfile(g, 'J:\tenho offline\Delphi\Fatorador\primos 64.dat');
  rewrite(g);
  while not eof(f) do
  begin
    read(f, p);
    p2 := p;
    write(g, p2);
  end;
  closefile(f);
  closefile(g);
  showmessage('missão cumprida');
end;

type TInt40 = record
        quo: byte;
        resto: longword;
     end;

procedure TForm1.Button2Click(Sender: TObject);
var
  g: file of int64;
  i: int64;
  f: file of byte;
  x: byte;
begin
  assignfile(g, 'J:\tenho offline\Delphi\Fatorador\primos 64.dat');
  reset(g);
  assignfile(f, 'J:\tenho offline\Delphi\Fatorador\primos 40.dat');
  rewrite(f);

  while not eof(g) do
  begin
    read(g, i);
    x := i div $0100000000;
    write(f, x);  // byte 5
    i := i mod $0100000000;
    x := i div $01000000;
    write(f, x);  // byte 4
    i := i mod $01000000;
    x := i div $010000;
    write(f, x);  // byte 3
    i := i mod $010000;
    x := i div $0100;
    write(f, x);  // byte 2
    x := i mod $0100;
    write(f, x);  // byte 1
  end;

  closefile(f);
  closefile(g);
  showmessage('missão cumprida');
end;

end.
