unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Memo: TMemo;
    MemoY: TMemo;
    Panel1: TPanel;
    EditX: TEdit;
    EditY: TEdit;
    btnOK: TButton;
    MemoX: TMemo;
    btnrandom: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnrandomClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnOKClick(Sender: TObject);
var x, y, q, r, a, b: integer;
begin
  x := abs(strtoint(editx.Text));
  y := abs(strtoint(edity.text));
  if x = 0 then exit;
  if y = 0 then exit;

  memo.clear;
  memox.clear;
  memoy.clear;
  if y > x then
  begin
    q := x;
    x := y;
    y := q;
  end;
  editx.text := inttostr(x);
  edity.text := inttostr(y);

  repeat
    q := x div y;
    r := x mod y;
    if r <> 0 then
    begin
      if memox.lines.count = 0 then
      begin
        a := 1;
        b := -q;
      end
      else if memox.lines.count = 1 then
      begin
        a := -a * q;
        b := -b * q + 1;
      end
      else
      begin
        a := strtoint(memox.lines[memox.lines.count - 2]) - a * q;
        b := strtoint(memoy.lines[memoy.lines.count - 2]) - b * q;
      end;

      memox.Lines.Add(inttostr(a));
      memoy.Lines.Add(inttostr(b));
      if b > 0 then
        memo.lines.add(inttostr(r) + ' = ' + inttostr(x) + ' - ' + inttostr(q) + ' * ' + inttostr(y) + ' = ' +
          inttostr(a) + ' x + ' + inttostr(b) + ' y')
      else
        memo.lines.add(inttostr(r) + ' = ' + inttostr(x) + ' - ' + inttostr(q) + ' * ' + inttostr(y) + ' = ' +
          inttostr(a) + ' x - ' + inttostr(-b) + ' y')
    end;
    if (r = 1) or (r = 0) then
      break;
    x := y;
    y := r;
  until false;
end;

procedure TFormPrincipal.btnrandomClick(Sender: TObject);
begin
  randomize;
  editx.Text := inttostr(random(1000000)*random(1000000));
  edity.Text := inttostr(random(1000000)*random(1000000));
  btnOK.Click;
end;

end.
