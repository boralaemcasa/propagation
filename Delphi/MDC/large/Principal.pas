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

uses SNum;

procedure TFormPrincipal.btnOKClick(Sender: TObject);
var x, y, q, r, a, b: string;
begin
  x := Valida(editx.Text);
  y := Valida(edity.text);
  if x = '0' then exit;
  if y = '0' then exit;

  memo.clear;
  memox.clear;
  memoy.clear;
  if x[1] = '-' then
    x := oposto(x);
  if y[1] = '-' then
    y := oposto(y);
  if SNumCompare(y, x) > 0 then
  begin
    q := x;
    x := y;
    y := q;
  end;
  editx.Text := x;
  edity.text := y;

  repeat
    Divide(x, y, q, r);
    if (r <> '0') or (memo.lines.Count = 0) then
    begin
      if memox.lines.count = 0 then
      begin
        a := '1';
        b := oposto(q);
      end
      else if memox.lines.count = 1 then
      begin
        a := multiplica(oposto(a), q);
        b := soma(multiplica(oposto(b), q), '1');
      end
      else
      begin
        a := subtrai(memox.lines[memox.lines.count - 2], Multiplica(a, q));
        b := subtrai(memoy.lines[memoy.lines.count - 2], Multiplica(b, q));
      end;

      memox.Lines.Add(a);
      memoy.Lines.Add(b);
      if b[1] <> '-' then
        memo.lines.add(r + ' = ' + x + ' - ' + q + ' * ' + y + ' = ' +
          a + ' x + ' + b + ' y')
      else
        memo.lines.add(r + ' = ' + x + ' - ' + q + ' * ' + y + ' = ' +
          a + ' x - ' + oposto(b) + ' y');
    end;
    if (r = '1') or (r = '0') then
      break;
    x := y;
    y := r;
  until false;
end;

procedure TFormPrincipal.btnrandomClick(Sender: TObject);
var i: integer;
begin
  randomize;
  editx.text := inttostr(random(1000000));
  for i := 1 to 100 do
    editx.text := editx.text + inttostr(random(10));
  edity.text := inttostr(random(1000000));
  for i := 3 to 100 do
    edity.text := edity.text + inttostr(random(10));
  btnOK.Click;
end;

end.
