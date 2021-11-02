unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses SNum;

function newton(n, p: integer): string;
var x, i, q: string;
begin
  if 2 * p > n then
    p := n - p;
  x := '1';
  i := inttostr(n);
  while SNumCompare(i, inttostr(n - p + 1)) >= 0 do
  begin
    x := multiplica(x, i);
    i := subtrai(i, '1');
  end;
  i := '2';
  while snumcompare(i, inttostr(p)) <= 0 do
  begin
    divide(x, i, q, result);
    x := q;
    i := soma(i, '1');
  end;
  result := x;
  while length(result) < 30 do
    result := ' ' + result;
end;

procedure TForm1.Button1Click(Sender: TObject);
var f: TextFile;
    n, p: integer;
begin
  assignFile(f, 'newton.txt');
  rewrite(f);
  for n := 0 to 100 do
  begin
    for p := 0 to n do
    begin
      write(f, newton(n, p));
      caption := inttostr(n) + ', ' + inttostr(p);
      application.processmessages;
    end;
    writeln(f);
  end;
  closefile(f);
  close;
end;

end.
