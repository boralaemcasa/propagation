unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TForm1 = class(TForm)
    sg: TStringGrid;
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

function mdc(x,y: integer): integer;
var q, r: integer;
begin
  repeat
  q := x div y;
  r := x mod y;
  if r = 0 then
  break;
  x := y;
  y := r;
  until false;

  result := y;
end;

procedure TForm1.Button1Click(Sender: TObject);
var linha, x, y, a, b, c: integer;
begin
  linha := 1;
  sg.Cells[1,0] := 'a';
  sg.Cells[2,0] := 'b';
  sg.Cells[3,0] := 'c';
  sg.Cells[4,0] := 'x';
  sg.Cells[5,0] := 'y';
  for x := 1 to 10 do
    for y := 1 to 10 do
      if x > y then
      begin
        a := x * x - y * y;
        b := 2 * x * y;
        if a > b then
        begin
          c := b;
          b := a;
          a := c;
        end;
        c := x * x + y * y;
        if mdc(b,a) = 1 then
        begin
          sg.Cells[1,linha] := inttostr(a);
          sg.Cells[2,linha] := inttostr(b);
          sg.Cells[3,linha] := inttostr(c);
          sg.Cells[4,linha] := inttostr(x);
          sg.Cells[5,linha] := inttostr(y);
          inc(linha);
          sg.RowCount := linha;
        end;
      end;
end;

end.
