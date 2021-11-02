unit Principal;

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
var
  f, g: TextFile;
  s, ke, kd, coefk: string;
  i, j: integer;
begin
  Button1.Enabled := false;
  filemode := 0;
  assignfile(f, 'v:\hilbert\hilbert13.txt');
  assignfile(g, 'v:\hilbert\producao.sql');
  reset(f);
  rewrite(g);
  repeat
    readln(f, s);
  until copy(s, 1, 12) = 'Repeat that ';
  repeat
    readln(f, s);
  until copy(s, 1, 7) = ' 6 -1 -';
  repeat
  i := 1;
  repeat
    inc(i);
  until s[i] <> ' ';
  repeat
    inc(i);
  until s[i] = ' ';
  j := i;
  repeat
    inc(j);
  until s[j] = ' ';
  ke := copy(s, 1, i - 1);
  kd := copy(s, i + 1, j - i - 1);
  coefk := copy(s, j + 1, length(s));
  s := 'insert into g014_solucao_edo values (' + ke + ',null,' + coefk + ',' + kd + ');';
  writeln(g, s);
  caption := ke;
  application.ProcessMessages;
  readln(f, s);
  until s = '';

  closefile(f);
  closefile(g);
  Button1.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  f, g: TextFile;
  s, ke, coefk: string;
  i: integer;
begin
  Button2.Enabled := false;
  filemode := 0;
  assignfile(f, 'v:\hilbert\hilbert13.txt');
  assignfile(g, 'v:\hilbert\mkprod.sql');
  reset(f);
  rewrite(g);
  repeat
    readln(f, s);
  until copy(s, 1, 11) = '[last line]';
  repeat
    readln(f, s);
  until s = ' 0 0';
  repeat
  i := 1;
  repeat
    inc(i);
  until s[i] <> ' ';
  repeat
    inc(i);
  until s[i] = ' ';
  ke := copy(s, 1, i - 1);
  coefk := copy(s, i + 1, length(s));
  s := 'insert into g014_mk values (' + ke + ',' + coefk + ');';
  writeln(g, s);
  caption := ke;
  application.ProcessMessages;
  readln(f, s);
  until s = '';

  closefile(f);
  closefile(g);
  Button2.Enabled := true;
end;

end.
