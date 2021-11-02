unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    ed: TEdit;
    Memo1: TMemo;
    btn1: TButton;
    Memo2: TMemo;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum;

procedure TFormPrincipal.btn1Click(Sender: TObject);
var
  s, floor: string;
  x: integer;
begin
  s := ed.text;
  x := pos('.', s);
  if x > 0 then
  begin
    delete(s, x, 1);
    s := s + '/1';
    x := length(s) - x;
    for x := x downto 2 do
      s := s + '0';
    ed.Text := s;
  end;

  memo1.clear;
  s := FracValida(ed.Text);
  repeat
    floor := FracFloor(s);
    memo1.Lines.Add(floor);
    s := FracSub(s, floor);
    if s = '0' then
      break;
    s := FracDiv('1', s);
  until false;
end;

procedure TFormPrincipal.btn2Click(Sender: TObject);
var
  s: string;
  i, x: integer;
  frac: SFrac;
begin
  memo2.Clear;
  for i := 0 to memo1.lines.Count - 1 do
  begin
    s := memo1.Lines[i];
    for x := i - 1 downto 0 do
      s := FracAdd(FracDiv('1', s), memo1.Lines[x]);
    frac := Str2Frac(s);
    memo2.Lines.Add(s + ' = ' + DivideDizima(frac.n, frac.d, 20));
  end;
end;

end.
