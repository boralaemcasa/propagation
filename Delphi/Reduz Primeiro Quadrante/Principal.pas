unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    Edit1: TEdit;
    Memo: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
  private
  public
    procedure processar(xx: integer);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.Button1Click(Sender: TObject);
begin
  processar(strtoint(edit1.Text));
end;

procedure TFormPrincipal.Processar(xx: integer);
var
  minus_sin, minus_cos: boolean;
  x: integer;
  s: string;
begin
  minus_sin := false;
  minus_cos := false;
  x := xx mod 360;
  if x < 0 then
    x := x + 360;
  if x >= 270 then
  begin
    minus_sin := true;
    x := 360 - x;
  end
  else if x >= 180 then
  begin
    minus_sin := true;
    minus_cos := true;
    x := x - 180;
  end
  else if x > 90 then
  begin
    minus_cos := true;
    x := 180 - x;
  end;

  s := '\cos ' + inttostr(xx) + '^\circ &= ';

  if minus_cos then
    s := s + ' - ';

  if x > 45 then
    s := s + '\sin ' + inttostr(90 - x)
  else
    s := s + '\cos ' + inttostr(x);
  memo.Lines.Add(s + '^\circ \\'); 
end;

procedure TFormPrincipal.MemoDblClick(Sender: TObject);
var i: integer;
begin
  for i := 1 to 120 do
     processar(3 * i);
end;

end.
